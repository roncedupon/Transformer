`timescale 1ns / 1ps

module Sim_Quant;
parameter Mem_Depth =18376;
parameter Mem_Width=8*8;//txt数据位宽
parameter Total_Input_Times=102;//发完2224*224*64bit数据后mValid需要拉低

parameter Mem2_Depth=300*300*4;//第二个Mem的配置
parameter Mem2_Width=64;

  reg clk;
  reg rst;

  wire mReady;
  reg mValid;
  wire mReady2;
  reg mValid2;

  reg sReady;
  wire sValid;
  wire sLast;//获取sLast信号，第二次启动。
  wire Start_Again_En;
  assign Start_Again_En=1;//需要仿真再次启动
  reg start;
  reg start2;
  wire [63:0]sData;

  reg [31:0]Total_Cnt;//用来模拟Mvalid和Sready
  reg [63:0]Out_Total_Cnt;//输出数据计数器，用来计数输出数据的
  reg[63:0]Input_Total_Cnt;//用来计算输入数据数量
  reg [63:0]Input_Total_Cnt2;
  reg [31:0]mem_addr;
  reg [31:0]mem_addr2;  
  
  reg	[Mem_Width-1:0]	mem	[0:Mem_Depth-1];
  
  reg [Mem2_Width-1:0]mem2[0:Mem2_Depth-1];
  wire Write_Txt_En;
  wire Write_Txt_End;    
  reg [1:0]InSwitch; 
//  导出txt数据=====================================================
//E:\\Transformer\\Sim_Transformer\\SimData_Output\\DataGenerate.txt
//  integer file_out;
//  initial
//  begin

//      file_out = $fopen("C:\\Users\\25073\\Desktop\\compare\\VivadoOutput.txt","w+");//记得用\\分开
//      if (!file_out) begin
//          $display("can't open file");
//          $finish;
//      end
//  end 

//  always @ (posedge clk) begin  
//        if(Write_Txt_End)begin
//           $fclose(file_out);  //关闭写文件
//        end
//        else if(sValid&&Write_Txt_En) begin
//          $fdisplay(file_out, "%h", sData);//将数据写到TXT文件中，并且自动换行
//        end 
//  end
//  ==========================================
  initial
  begin

//    $readmemh("E:\\Transformer\\Transformer_Arithmatic\\Transformer_Main\\TXT\\WeightPicture.txt",mem);//_Modified
    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\K33\\S1_320_320\\WeightPicture.txt",mem);
//    $readmemh("E:\\Transformer\\Sim_File\\SimGemm\\AB.txt",mem);//_Modified
    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\K1616\\S16\\WeightData.txt",mem2);//高8bit为Scale，低8bit为Bias
    clk=0;
    start=0;
    rst=1;
    InSwitch=1;
    mValid=0;
    mem_addr=0;
    mem_addr2=0;
    #20000
     rst=0;
     start=1;
     start2=1;
    #200
     start=0;
     start2=0;
     #20000
     InSwitch=0;
  end
  always#5 clk=~clk;//100M时钟


  //全局计数器，用于控制Mvalid和Sready
  always@(posedge clk)
  begin
    if(rst)
    begin
      Total_Cnt<=0;
    end
    else if(Total_Cnt<512)
    begin
      Total_Cnt<=Total_Cnt+1'b1;
    end
    else
      Total_Cnt<=0;
  end
  //输出数据计数器===============================================
  always@(posedge clk)
  begin
    if(rst)
    begin
      Out_Total_Cnt<=0;
    end
    else if(sReady&&sValid)
    begin
      Out_Total_Cnt<=Out_Total_Cnt+1'b1;
    end
    else if(sLast)
      Out_Total_Cnt<=0;
    else
      Out_Total_Cnt<=Out_Total_Cnt;
  end
  //数据输入，没有延时，直接从reg中读出来=========================
  always@(posedge clk)
  begin
    if(rst)
    begin
      mem_addr<=0;
    end
    else if(start)
    begin//
      mem_addr<=0;
    end
    else if(mValid&&mReady)
      mem_addr<=mem_addr+1'b1;
    else
      mem_addr<=mem_addr;
  end
  //总输入数据计数器================================================
  always@(posedge clk)
  begin
    if(rst||start)//若复位或第二次启动，这个计数器要归位
    begin
      Input_Total_Cnt<=0;
    end
    else if(mReady&&mValid)
    begin
      Input_Total_Cnt<=Input_Total_Cnt+1'b1;
    end
    else
      Input_Total_Cnt<=Input_Total_Cnt;
  end
  //mValid和sReady模拟============================================
  always@(posedge clk)
  begin
    if(rst)
    begin
      mValid<=0;
      sReady<=0;
    end
    else if(Total_Cnt<2&&Input_Total_Cnt<Total_Input_Times)
    begin
      mValid<=1'b0;
      sReady<=1;
    end
    else
    begin
      mValid<=1;
      sReady<=1;
    end
  end
  always@(posedge clk)
  begin
    if(rst)
    begin
      start<=0;
    end
    else if(sLast&&Start_Again_En)//sLast即最后一个输出，结束后再次启动
      start<=1;
    else start<=0;
  end
//================================================================================
  always@(posedge clk)
begin
  if(rst)
  begin
    mem_addr2<=0;
  end
  else if(start)
  begin//
    mem_addr2<=0;
  end
  else if(mValid2&&mReady2)
    mem_addr2<=mem_addr2+1'b1;
  else
    mem_addr2<=mem_addr2;
end


always@(posedge clk)
begin
  if(rst||start)//若复位或第二次启动，这个计数器要归位
  begin
    Input_Total_Cnt2<=0;
  end
  else if(mReady2&&mValid2)
  begin
    Input_Total_Cnt2<=Input_Total_Cnt2+1'b1;
  end
  else
    Input_Total_Cnt2<=Input_Total_Cnt2;
end
always@(posedge clk)
  begin
    if(rst)
    begin
      mValid2<=0;
    end
    else if(Total_Cnt<64&&Input_Total_Cnt2<Total_Input_Times)
    begin
      mValid2<=1'b1;
    end
    else
    begin
      mValid2<=1;
    end
  end

Conv ConvUnit(
.Control_start(start),

//.Control_Matrix2Img(0),
//.Control_Inswitch(0),
//.s_axis_s2mm_tkeep(),
//.s_axis_s2mm_tlast(),
.s_axis_s2mm_tready(mReady),
.s_axis_s2mm_tvalid(mValid),
.s_axis_s2mm_tdata(mem[mem_addr]),
//.m_axis_mm2s_tdata(),
//.m_axis_mm2s_tkeep(),
//.m_axis_mm2s_tlast(),
//.m_axis_mm2s_tready(1'b1),
//.m_axis_mm2s_tvalid(),

//======================================
//.Control_Switch_Conv(1'b1),
//.Img2Col_Stride                        (16),
//.Img2Col_Kernel_Size                   (16),
//.Img2Col_Window_Size                   (16),
//.Img2Col_InFeature_Size                (224),
//.Img2Col_InFeature_Channel             (8),
//.Img2Col_OutFeature_Channel            (16),
//.Img2Col_OutFeature_Size               (14),
//.Img2Col_Sliding_Size                  (16),
//.Img2Col_OutCol_Count_Times            (2),
//.Img2Col_InCol_Count_Times             (224),
//.Img2Col_OutRow_Count_Times            (14),
//.Img2Col_OutFeature_Channel_Count_Times(2),
//.Img2Col_WeightMatrix_Row(2048), 
//.Img2Col_OutMatrix_Col(16),    
//.Img2Col_OutMatrix_Row(196),    
//===================================================================
.Control_Switch_Conv(1'b0),
.Img2Col_OutFeature_Channel                 (16),
.Img2Col_WeightMatrix_Row                   (16),
.Img2Col_OutMatrix_Col                      (16),
.Img2Col_OutMatrix_Row                      (23),

.GemmInstru_WIDTH                           (16),
.GemmInstru_HEIGHT                          (23),

.m_axis_mm2s_tready(1'b1),
.m_axis_mm2s_tlast(sLast),
.clk(clk),
.reset(rst)


);




endmodule
