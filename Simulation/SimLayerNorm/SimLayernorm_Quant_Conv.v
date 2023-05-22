`timescale 1ns / 1ps

module Sim_Layernorm_Quant;
parameter Mem_Depth =412000;
parameter Mem_Width=8*8;//txt����λ��
parameter Total_Input_Times=412000;//����2224*224*64bit���ݺ�mValid��Ҫ����

parameter Mem2_Depth=300*300*4;//�ڶ���Mem������
parameter Mem2_Width=64;

  reg clk;
  reg rst;

  wire mReady;
  reg mValid;
  wire mReady2;
  reg mValid2;

  reg sReady;
  wire sValid;
  wire sLast;//��ȡsLast�źţ��ڶ���������
  wire Start_Again_En;
  assign Start_Again_En=1;//��Ҫ�����ٴ�����
  reg start;
  reg start2;
  wire [63:0]sData;

  reg [31:0]Total_Cnt;//����ģ��Mvalid��Sready
  reg [63:0]Out_Total_Cnt;//������ݼ���������������������ݵ�
  reg[63:0]Input_Total_Cnt;//��������������������
  reg [63:0]Input_Total_Cnt2;
  reg [31:0]mem_addr;
  reg [31:0]mem_addr2;  
  
  reg	[Mem_Width-1:0]	mem	[0:Mem_Depth-1];
  
  reg [Mem2_Width-1:0]mem2[0:Mem2_Depth-1];
  wire Write_Txt_En;
  wire Write_Txt_End;    
  reg [1:0]InSwitch; 
//  ����txt����=====================================================
//E:\\Transformer\\Sim_Transformer\\SimData_Output\\DataGenerate.txt
//  integer file_out;
//  initial
//  begin

//      file_out = $fopen("C:\\Users\\25073\\Desktop\\compare\\VivadoOutput.txt","w+");//�ǵ���\\�ֿ�
//      if (!file_out) begin
//          $display("can't open file");
//          $finish;
//      end
//  end 

//  always @ (posedge clk) begin  
//        if(Write_Txt_End)begin
//           $fclose(file_out);  //�ر�д�ļ�
//        end
//        else if(sValid&&Write_Txt_En) begin
//          $fdisplay(file_out, "%h", sData);//������д��TXT�ļ��У������Զ�����
//        end 
//  end
//  ==========================================
  initial
  begin

//    $readmemh("E:\\Transformer\\Transformer_Arithmatic\\Transformer_Main\\TXT\\WeightPicture.txt",mem);//_Modified
//    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\K33\\S1_320_320\\WeightPicture.txt",mem);
    $readmemh("E:\\Transformer\\Sim_File\\SimQuant\\WeightPicture.txt",mem);//_Modified
    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\K1616\\S16\\WeightData.txt",mem2);//��8bitΪScale����8bitΪBias
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
  always#5 clk=~clk;//100Mʱ��


  //ȫ�ּ����������ڿ���Mvalid��Sready
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
  //������ݼ�����===============================================
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
  //�������룬û����ʱ��ֱ�Ӵ�reg�ж�����=========================
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
  //���������ݼ�����================================================
  always@(posedge clk)
  begin
    if(rst||start)//����λ��ڶ������������������Ҫ��λ
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
  //mValid��sReadyģ��============================================
  always@(posedge clk)
  begin
    if(rst)
    begin
      mValid<=0;
      sReady<=0;
    end
    else if(Total_Cnt<64&&Input_Total_Cnt<Total_Input_Times)
    begin
      mValid<=1'b1;
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
    else if(sLast&&Start_Again_En)//sLast�����һ��������������ٴ�����
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
  if(rst||start)//����λ��ڶ������������������Ҫ��λ
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
.Control_Switch_Conv(1'b1),
.Control_Matrix2Img(0),
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
.Img2Col_Stride                        (2),
.Img2Col_Kernel_Size                   (3),
.Img2Col_Window_Size                   (12),
.Img2Col_InFeature_Size                (322),
.Img2Col_InFeature_Channel             (32),
.Img2Col_OutFeature_Channel            (64),
.Img2Col_OutFeature_Size               (160),
.Img2Col_Sliding_Size                  (8),
.Img2Col_OutCol_Count_Times            (20),
.Img2Col_InCol_Count_Times             (1288),
.Img2Col_OutRow_Count_Times            (160),
.Img2Col_OutFeature_Channel_Count_Times(8),
.Img2Col_WeightMatrix_Row                    (288),
//======================================
.clk(clk),
.reset(rst)
);




endmodule