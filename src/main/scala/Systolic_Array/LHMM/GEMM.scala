package Systolic_Array.LHMM

import spinal.core._
import spinal.core.internals.Operator
import spinal.lib._
import xip.{xil_SimpleDualBram}
import utils.ForLoopCounter
import utils.SubstractLoopCounter

case class configGemm(){
  val WH_WIDTH = 13
  val W_WIDTH = 16
  val SA_COL =8
  val dataWidthIn = 64
  val dataWidthOut = 64
}

object GEMM_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {
  val IDLE, INIT, WRITE, READ, CHECK,END,ENDOTHER,ENDOUT= newElement//CHECK等待状态,

}

object RW_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {
  val IDLE, WRITE= newElement//CHECK,

}

case class RW_Fsm(start:Bool)extends Area{
  val currentState = Reg(RW_ENUM()) init RW_ENUM.IDLE //RegInit(GEMM_ENUM.IDLE)
  val nextState = RW_ENUM()
  currentState:= nextState

  val writeEnd = Bool()
  switch(currentState){
    is(RW_ENUM.WRITE) {
      when(writeEnd) {
        nextState := RW_ENUM.IDLE
      } otherwise {
        nextState := RW_ENUM.WRITE
      }
    }


    is(RW_ENUM.IDLE) {
      when(start) {
        nextState := RW_ENUM.WRITE
      } otherwise {
        nextState := RW_ENUM.IDLE
      }
    }

  }



}



case class GEMM_Fsm(start:Bool)extends Area{
  val currentState = Reg(GEMM_ENUM()) init GEMM_ENUM.IDLE//RegInit(GEMM_ENUM.IDLE)
  val nextState = GEMM_ENUM()
  currentState:= nextState
  val initEnd = Bool()
  val readFinish = Bool()
  val writeEnd = Bool()
  val judge = Bool()//读完没写完
  val otherWrite= Bool()//那边写完
  val dataEnd = Bool()
  val end = Bool()

  switch(currentState){
    is(GEMM_ENUM.IDLE){
      when(start){
        nextState:=GEMM_ENUM.INIT
      }otherwise{
        nextState:=GEMM_ENUM.IDLE
      }
    }

    is(GEMM_ENUM.INIT){
      when(initEnd){
        nextState:=GEMM_ENUM.WRITE
      }otherwise{
        nextState:=GEMM_ENUM.INIT
      }
    }

    is(GEMM_ENUM.WRITE){
      when(writeEnd) {
        nextState := GEMM_ENUM.READ
      } otherwise {
        nextState := GEMM_ENUM.WRITE
      }
    }

    is(GEMM_ENUM.READ){
     when(dataEnd){
        nextState := GEMM_ENUM.END
      }elsewhen(judge) {
        nextState := GEMM_ENUM.CHECK
      }otherwise {
        nextState := GEMM_ENUM.READ
      }

    }

    is(GEMM_ENUM.CHECK){
      when(otherWrite) { //那边写完
        nextState := GEMM_ENUM.READ
      }elsewhen(dataEnd){
        nextState := GEMM_ENUM.ENDOTHER
      } otherwise {
        nextState := GEMM_ENUM.CHECK
      }
    }




    is(GEMM_ENUM.ENDOTHER){
      when(end) {
        nextState := GEMM_ENUM.ENDOUT
      } otherwise {
        nextState := GEMM_ENUM.ENDOTHER
      }
    }


    is(GEMM_ENUM.END){
      when(end) {
        nextState := GEMM_ENUM.ENDOUT
      } otherwise {
        nextState := GEMM_ENUM.END
      }

    }
    is(GEMM_ENUM.ENDOUT) {
      when(readFinish) {
        nextState := GEMM_ENUM.IDLE
      } otherwise {
        nextState := GEMM_ENUM.ENDOUT
      }

    }



  }

}
class GemmCache extends Component {
  val config = new configGemm()

  val io = new Bundle{
    val sData =  slave Stream UInt(config.dataWidthIn bits)
    val WIDTH = in UInt(config.WH_WIDTH bits)
    val HIGHT = in UInt(config.WH_WIDTH bits)
    val WEIGHTCOL  = in UInt(12 bits) //权重矩阵列数

    val start = in Bool()  //START信号，开始加载
    val validOut = out Vec(Bool(),8)
    val LayerEnd = out Bool ()  //结束信号
    val bvalid = out Bool ()
    val mData = out UInt(config.dataWidthOut bits)
  }
  noIoPrefix()
  io.mData:=0


  val Switch=Reg(Bool()) init(False)//这地方的初始化得是1
  val valid =  Vec(Bool(),8) //数据有效
  val fsm =  GEMM_Fsm(io.start)
  val rwfsm = new RW_Fsm((Switch.fall()||Switch.rise())&&fsm.currentState=/=GEMM_ENUM.IDLE&&fsm.currentState=/=GEMM_ENUM.ENDOUT)

  val initCount = ForLoopCounter(fsm.currentState === GEMM_ENUM.INIT, 3, 5)
  val colCnt = ForLoopCounter(io.sData.fire, config.W_WIDTH, io.WIDTH - 1)
  val rAddrCnt = ForLoopCounter(fsm.currentState === GEMM_ENUM.READ||fsm.currentState===GEMM_ENUM.END||fsm.currentState===GEMM_ENUM.ENDOUT||fsm.currentState===GEMM_ENUM.ENDOTHER, config.WH_WIDTH, io.WIDTH - 1)
  val totalCnt = ForLoopCounter(rAddrCnt.valid, 12, io.WEIGHTCOL / 8 - 1) //记录权重矩阵出了几次
  val finish = Bool()
  val OneColCnt = ForLoopCounter(io.sData.fire, config.W_WIDTH, io.WIDTH / 8 - 1) //一列完成
  val rowCnt = ForLoopCounter(OneColCnt.valid, config.W_WIDTH, io.HIGHT - 1) //行计数器
  val hangCnt = SubstractLoopCounter(colCnt.valid,config.WH_WIDTH,io.HIGHT,config.SA_COL)//还剩几行
  when(io.start) {
    hangCnt.reset
  }

  when(totalCnt.valid && fsm.currentState===GEMM_ENUM.ENDOUT) {
    finish := True
  } otherwise {
    finish := False
  }


  fsm.initEnd:=initCount.valid
  fsm.writeEnd:=colCnt.valid||rowCnt.valid
  fsm.judge:=totalCnt.valid&&rwfsm.currentState===RW_ENUM.WRITE
  fsm.dataEnd := rowCnt.valid
  rwfsm.writeEnd := colCnt.valid||rowCnt.valid
  fsm.end:= totalCnt.valid&&(fsm.currentState===GEMM_ENUM.END || fsm.currentState===GEMM_ENUM.ENDOTHER)
  fsm.readFinish := finish //totalCnt.valid&&rwfsm.currentState===RW_ENUM.IDLE//suoyou都读空
  fsm.otherWrite := colCnt.valid
  io.LayerEnd := RegNext(finish)

  val writeend = fsm.currentState === GEMM_ENUM.WRITE && fsm.nextState === GEMM_ENUM.READ
  when(Delay(writeend, 1)) {
    Switch := !Switch
  } elsewhen (Delay(totalCnt.valid && rwfsm.currentState === RW_ENUM.IDLE, 1)) {
    Switch := !Switch
  } elsewhen (Delay(colCnt.valid && fsm.currentState === GEMM_ENUM.CHECK, 1)) {
    Switch := !Switch
  }
//  when(Delay(finish, 1)) {
//    Switch := !Switch
//  }


  val Write_Row_Base_Addr = Reg(UInt(10 bits)) init (0) //写权重的基地址，一列一列存

  val InData_Switch = Reg(UInt(8 bits)) init (1) //这地方的初始化得是1
  when(io.sData.fire) {
    Write_Row_Base_Addr := Write_Row_Base_Addr + 1
  }

  when(OneColCnt.valid) {
    InData_Switch := InData_Switch.rotateLeft(1) //循环左移1位
    Write_Row_Base_Addr := 0
  }

  when(rowCnt.valid){
    InData_Switch := 1
    colCnt.clear
  }


  val mdata_temp = UInt(config.dataWidthOut bits)
  val Weight_Cache = Array.tabulate(config.SA_COL) {
    i =>
      def gen() = {
        //4096*64bit是一个Bram资源，32K
        val buffer1 = new xil_SimpleDualBram(config.dataWidthIn, 800, 8, "A_Bram", true)
        val buffer2 = new xil_SimpleDualBram(config.dataWidthIn, 800, 8, "B_Bram", true)
        buffer1.io.addra := 0
        buffer1.io.dina := 0
        buffer1.io.ena := False
        buffer1.io.wea := True
        buffer2.io.addrb := 0
        buffer2.io.addra := 0
        buffer2.io.dina := 0
        buffer2.io.ena := False
        buffer2.io.wea := True
        buffer1.io.addrb := 0

        when(Switch === False) {
          buffer1.io.addra := Write_Row_Base_Addr //colCnt.count
          buffer1.io.dina := io.sData.payload
          buffer1.io.ena := InData_Switch(i downto i).asBool && io.sData.fire
          buffer1.io.wea := True
          buffer2.io.addrb := rAddrCnt.count
          mdata_temp((i + 1) * 8 - 1 downto i * 8) := buffer2.io.doutb
        } otherwise {
          buffer2.io.addra := Write_Row_Base_Addr //colCnt.count
          buffer2.io.dina := io.sData.payload
          buffer2.io.ena := InData_Switch(i downto i).asBool && io.sData.fire
          buffer2.io.wea := True
          buffer1.io.addrb := rAddrCnt.count
          //data := buffer1.io.doutb
          //    for (i <- 0 to 7) {
          mdata_temp((i + 1) * 8 - 1 downto i * 8) := buffer1.io.doutb
          //    }
        }


      }

      gen()
  }
  for (k <- 0 to 7) {
    io.mData((k + 1) * 8 - 1 downto k * 8) := Delay(mdata_temp((k + 1) * 8 - 1 downto k * 8), k)
  }

  when(fsm.currentState===GEMM_ENUM.END || fsm.currentState===GEMM_ENUM.ENDOUT){
    io.sData.ready := False
  }elsewhen(fsm.currentState === GEMM_ENUM.WRITE || rwfsm.currentState === RW_ENUM.WRITE) {
    io.sData.ready := True
  } otherwise {
    io.sData.ready := False
  }




  valid := Vec(False, 8)
  when(RegNext(fsm.currentState === GEMM_ENUM.READ||fsm.currentState === GEMM_ENUM.END)){
    valid := Vec(True, 8)
  }
  when(RegNext(fsm.currentState === GEMM_ENUM.ENDOUT)) {
    for (i <- 0 to 7) {
      when(hangCnt.count > i) {
        valid(i) := True
      } otherwise {
        valid(i) := False
      }

    }
  }


  for (i <- 0 to 7) {
    io.validOut(i) := Delay(valid(i), i)
  }




  when(fsm.currentState === GEMM_ENUM.READ||fsm.currentState === GEMM_ENUM.END||fsm.currentState === GEMM_ENUM.ENDOUT) {
    io.bvalid := True
  } otherwise {
    io.bvalid := False
  }


}
object GemmCacheV1 extends App{
  val verilog_path="./Simulation/gemm"
  SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new GemmCache)
}