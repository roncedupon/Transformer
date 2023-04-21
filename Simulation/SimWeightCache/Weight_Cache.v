// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : Weight_Cache
// Git hash  : 1108b61adcf947182a291b8b7d6ee841ff80883d

`timescale 1ns/1ps

module Weight_Cache (
  input               start,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  input      [15:0]   Matrix_Row,
  input      [15:0]   Matrix_Col,
  output reg [63:0]   mData,
  input               Raddr_Valid,
  output              Weight_Cached,
  input               LayerEnd,
  output     [7:0]    MatrixCol_Switch,
  input               clk,
  input               reset
);
  localparam WEIGHT_CACHE_STATUS_IDLE = 4'd1;
  localparam WEIGHT_CACHE_STATUS_INIT = 4'd2;
  localparam WEIGHT_CACHE_STATUS_CACHE_WEIGHT = 4'd4;
  localparam WEIGHT_CACHE_STATUS_SA_COMPUTE = 4'd8;

  wire       [13:0]   xil_SimpleDualBram_addra;
  wire       [7:0]    xil_SimpleDualBram_dina;
  wire       [13:0]   xil_SimpleDualBram_addrb;
  wire       [13:0]   xil_SimpleDualBram_1_addra;
  wire       [7:0]    xil_SimpleDualBram_1_dina;
  wire       [13:0]   xil_SimpleDualBram_1_addrb;
  wire       [13:0]   xil_SimpleDualBram_2_addra;
  wire       [7:0]    xil_SimpleDualBram_2_dina;
  wire       [13:0]   xil_SimpleDualBram_2_addrb;
  wire       [13:0]   xil_SimpleDualBram_3_addra;
  wire       [7:0]    xil_SimpleDualBram_3_dina;
  wire       [13:0]   xil_SimpleDualBram_3_addrb;
  wire       [13:0]   xil_SimpleDualBram_4_addra;
  wire       [7:0]    xil_SimpleDualBram_4_dina;
  wire       [13:0]   xil_SimpleDualBram_4_addrb;
  wire       [13:0]   xil_SimpleDualBram_5_addra;
  wire       [7:0]    xil_SimpleDualBram_5_dina;
  wire       [13:0]   xil_SimpleDualBram_5_addrb;
  wire       [13:0]   xil_SimpleDualBram_6_addra;
  wire       [7:0]    xil_SimpleDualBram_6_dina;
  wire       [13:0]   xil_SimpleDualBram_6_addrb;
  wire       [13:0]   xil_SimpleDualBram_7_addra;
  wire       [7:0]    xil_SimpleDualBram_7_dina;
  wire       [13:0]   xil_SimpleDualBram_7_addrb;
  wire       [7:0]    xil_SimpleDualBram_doutb;
  wire       [7:0]    xil_SimpleDualBram_1_doutb;
  wire       [7:0]    xil_SimpleDualBram_2_doutb;
  wire       [7:0]    xil_SimpleDualBram_3_doutb;
  wire       [7:0]    xil_SimpleDualBram_4_doutb;
  wire       [7:0]    xil_SimpleDualBram_5_doutb;
  wire       [7:0]    xil_SimpleDualBram_6_doutb;
  wire       [7:0]    xil_SimpleDualBram_7_doutb;
  wire       [15:0]   _zz_In_Row_Cnt_valid;
  wire       [15:0]   _zz_In_Col_Cnt_valid;
  wire       [15:0]   _zz_In_Col_Cnt_count_1;
  wire       [15:0]   _zz_OutRow_Cnt_valid;
  wire       [15:0]   _zz_OutCol_Cnt_valid;
  wire       [15:0]   _zz_OutCol_Cnt_count_1;
  wire       [15:0]   _zz_addra;
  wire       [15:0]   _zz_addrb;
  wire       [15:0]   _zz_addra_1;
  wire       [15:0]   _zz_addrb_1;
  wire       [15:0]   _zz_addra_2;
  wire       [15:0]   _zz_addrb_2;
  wire       [15:0]   _zz_addra_3;
  wire       [15:0]   _zz_addrb_3;
  wire       [15:0]   _zz_addra_4;
  wire       [15:0]   _zz_addrb_4;
  wire       [15:0]   _zz_addra_5;
  wire       [15:0]   _zz_addrb_5;
  wire       [15:0]   _zz_addra_6;
  wire       [15:0]   _zz_addrb_6;
  wire       [15:0]   _zz_addra_7;
  wire       [15:0]   _zz_addrb_7;
  reg                 start_regNext;
  wire                when_Weight_CacheV2_l29;
  reg        [3:0]    Fsm_currentState;
  reg        [3:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Weight_All_Cached;
  wire                Fsm_SA_Computed;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                sData_fire;
  reg        [15:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  wire       [3:0]    _zz_In_Col_Cnt_count;
  reg        [15:0]   In_Col_Cnt_count;
  reg                 In_Col_Cnt_valid;
  wire                when_Weight_CacheV2_l96;
  reg        [15:0]   Read_Row_Base_Addr;
  reg        [15:0]   Write_Row_Base_Addr;
  wire                when_WaCounter_l39;
  reg        [15:0]   OutRow_Cnt_count;
  wire                OutRow_Cnt_valid;
  wire       [3:0]    _zz_OutCol_Cnt_count;
  reg        [15:0]   OutCol_Cnt_count;
  reg                 OutCol_Cnt_valid;
  wire                when_Weight_CacheV2_l107;
  wire                when_Weight_CacheV2_l116;
  wire                sData_fire_1;
  wire                sData_fire_2;
  wire                sData_fire_3;
  wire                sData_fire_4;
  wire                sData_fire_5;
  wire                sData_fire_6;
  wire                sData_fire_7;
  wire                sData_fire_8;
  reg        [7:0]    MatrixCol_Switch_1;
  reg        [7:0]    MatrixCol_Switch_1_regNext;
  `ifndef SYNTHESIS
  reg [95:0] Fsm_currentState_string;
  reg [95:0] Fsm_nextState_string;
  `endif


  assign _zz_In_Row_Cnt_valid = (Matrix_Row - 16'h0001);
  assign _zz_In_Col_Cnt_valid = {12'd0, _zz_In_Col_Cnt_count};
  assign _zz_In_Col_Cnt_count_1 = {12'd0, _zz_In_Col_Cnt_count};
  assign _zz_OutRow_Cnt_valid = (Matrix_Row - 16'h0001);
  assign _zz_OutCol_Cnt_valid = {12'd0, _zz_OutCol_Cnt_count};
  assign _zz_OutCol_Cnt_count_1 = {12'd0, _zz_OutCol_Cnt_count};
  assign _zz_addra = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb = (OutRow_Cnt_count + Read_Row_Base_Addr);
  assign _zz_addra_1 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_1 = (OutRow_Cnt_count + Read_Row_Base_Addr);
  assign _zz_addra_2 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_2 = (OutRow_Cnt_count + Read_Row_Base_Addr);
  assign _zz_addra_3 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_3 = (OutRow_Cnt_count + Read_Row_Base_Addr);
  assign _zz_addra_4 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_4 = (OutRow_Cnt_count + Read_Row_Base_Addr);
  assign _zz_addra_5 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_5 = (OutRow_Cnt_count + Read_Row_Base_Addr);
  assign _zz_addra_6 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_6 = (OutRow_Cnt_count + Read_Row_Base_Addr);
  assign _zz_addra_7 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_7 = (OutRow_Cnt_count + Read_Row_Base_Addr);
  Weight_Bram xil_SimpleDualBram (
    .clka  (clk                           ), //i
    .addra (xil_SimpleDualBram_addra[13:0]), //i
    .dina  (xil_SimpleDualBram_dina[7:0]  ), //i
    .ena   (sData_fire_1                  ), //i
    .wea   (1'b1                          ), //i
    .addrb (xil_SimpleDualBram_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_doutb[7:0] ), //o
    .clkb  (clk                           )  //i
  );
  Weight_Bram xil_SimpleDualBram_1 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_1_addra[13:0]), //i
    .dina  (xil_SimpleDualBram_1_dina[7:0]  ), //i
    .ena   (sData_fire_2                    ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_1_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_1_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_2 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_2_addra[13:0]), //i
    .dina  (xil_SimpleDualBram_2_dina[7:0]  ), //i
    .ena   (sData_fire_3                    ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_2_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_2_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_3 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_3_addra[13:0]), //i
    .dina  (xil_SimpleDualBram_3_dina[7:0]  ), //i
    .ena   (sData_fire_4                    ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_3_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_3_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_4 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_4_addra[13:0]), //i
    .dina  (xil_SimpleDualBram_4_dina[7:0]  ), //i
    .ena   (sData_fire_5                    ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_4_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_4_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_5 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_5_addra[13:0]), //i
    .dina  (xil_SimpleDualBram_5_dina[7:0]  ), //i
    .ena   (sData_fire_6                    ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_5_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_5_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_6 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_6_addra[13:0]), //i
    .dina  (xil_SimpleDualBram_6_dina[7:0]  ), //i
    .ena   (sData_fire_7                    ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_6_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_6_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_7 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_7_addra[13:0]), //i
    .dina  (xil_SimpleDualBram_7_dina[7:0]  ), //i
    .ena   (sData_fire_8                    ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_7_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_7_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      WEIGHT_CACHE_STATUS_IDLE : Fsm_currentState_string = "IDLE        ";
      WEIGHT_CACHE_STATUS_INIT : Fsm_currentState_string = "INIT        ";
      WEIGHT_CACHE_STATUS_CACHE_WEIGHT : Fsm_currentState_string = "CACHE_WEIGHT";
      WEIGHT_CACHE_STATUS_SA_COMPUTE : Fsm_currentState_string = "SA_COMPUTE  ";
      default : Fsm_currentState_string = "????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      WEIGHT_CACHE_STATUS_IDLE : Fsm_nextState_string = "IDLE        ";
      WEIGHT_CACHE_STATUS_INIT : Fsm_nextState_string = "INIT        ";
      WEIGHT_CACHE_STATUS_CACHE_WEIGHT : Fsm_nextState_string = "CACHE_WEIGHT";
      WEIGHT_CACHE_STATUS_SA_COMPUTE : Fsm_nextState_string = "SA_COMPUTE  ";
      default : Fsm_nextState_string = "????????????";
    endcase
  end
  `endif

  assign when_Weight_CacheV2_l29 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & WEIGHT_CACHE_STATUS_IDLE) == WEIGHT_CACHE_STATUS_IDLE) : begin
        if(when_Weight_CacheV2_l29) begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_INIT;
        end else begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_IDLE;
        end
      end
      (((Fsm_currentState) & WEIGHT_CACHE_STATUS_INIT) == WEIGHT_CACHE_STATUS_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_CACHE_WEIGHT;
        end else begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_INIT;
        end
      end
      (((Fsm_currentState) & WEIGHT_CACHE_STATUS_CACHE_WEIGHT) == WEIGHT_CACHE_STATUS_CACHE_WEIGHT) : begin
        if(Fsm_Weight_All_Cached) begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_SA_COMPUTE;
        end else begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_CACHE_WEIGHT;
        end
      end
      default : begin
        if(Fsm_SA_Computed) begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_IDLE;
        end else begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_SA_COMPUTE;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign sData_fire = (sData_valid && sData_ready);
  assign In_Row_Cnt_valid = ((In_Row_Cnt_count == _zz_In_Row_Cnt_valid) && sData_fire);
  assign _zz_In_Col_Cnt_count = 4'b1000;
  always @(*) begin
    In_Col_Cnt_valid = ((In_Col_Cnt_count <= _zz_In_Col_Cnt_valid) && In_Row_Cnt_valid);
    if(when_Weight_CacheV2_l96) begin
      In_Col_Cnt_valid = 1'b0;
    end
  end

  assign when_Weight_CacheV2_l96 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign when_WaCounter_l39 = (Raddr_Valid && ((Fsm_currentState & WEIGHT_CACHE_STATUS_SA_COMPUTE) != 4'b0000));
  assign OutRow_Cnt_valid = ((OutRow_Cnt_count == _zz_OutRow_Cnt_valid) && when_WaCounter_l39);
  assign _zz_OutCol_Cnt_count = 4'b1000;
  always @(*) begin
    OutCol_Cnt_valid = ((OutCol_Cnt_count <= _zz_OutCol_Cnt_valid) && OutRow_Cnt_valid);
    if(when_Weight_CacheV2_l107) begin
      OutCol_Cnt_valid = 1'b0;
    end
  end

  assign when_Weight_CacheV2_l107 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign when_Weight_CacheV2_l116 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign Fsm_Weight_All_Cached = In_Col_Cnt_valid;
  assign Weight_Cached = In_Col_Cnt_valid;
  assign xil_SimpleDualBram_addra = _zz_addra[13:0];
  assign xil_SimpleDualBram_addrb = _zz_addrb[13:0];
  assign xil_SimpleDualBram_dina = sData_payload[7 : 0];
  assign sData_fire_1 = (sData_valid && sData_ready);
  always @(*) begin
    mData[7 : 0] = xil_SimpleDualBram_doutb;
    mData[15 : 8] = xil_SimpleDualBram_1_doutb;
    mData[23 : 16] = xil_SimpleDualBram_2_doutb;
    mData[31 : 24] = xil_SimpleDualBram_3_doutb;
    mData[39 : 32] = xil_SimpleDualBram_4_doutb;
    mData[47 : 40] = xil_SimpleDualBram_5_doutb;
    mData[55 : 48] = xil_SimpleDualBram_6_doutb;
    mData[63 : 56] = xil_SimpleDualBram_7_doutb;
  end

  assign xil_SimpleDualBram_1_addra = _zz_addra_1[13:0];
  assign xil_SimpleDualBram_1_addrb = _zz_addrb_1[13:0];
  assign xil_SimpleDualBram_1_dina = sData_payload[15 : 8];
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_2_addra = _zz_addra_2[13:0];
  assign xil_SimpleDualBram_2_addrb = _zz_addrb_2[13:0];
  assign xil_SimpleDualBram_2_dina = sData_payload[23 : 16];
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_3_addra = _zz_addra_3[13:0];
  assign xil_SimpleDualBram_3_addrb = _zz_addrb_3[13:0];
  assign xil_SimpleDualBram_3_dina = sData_payload[31 : 24];
  assign sData_fire_4 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_4_addra = _zz_addra_4[13:0];
  assign xil_SimpleDualBram_4_addrb = _zz_addrb_4[13:0];
  assign xil_SimpleDualBram_4_dina = sData_payload[39 : 32];
  assign sData_fire_5 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_5_addra = _zz_addra_5[13:0];
  assign xil_SimpleDualBram_5_addrb = _zz_addrb_5[13:0];
  assign xil_SimpleDualBram_5_dina = sData_payload[47 : 40];
  assign sData_fire_6 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_6_addra = _zz_addra_6[13:0];
  assign xil_SimpleDualBram_6_addrb = _zz_addrb_6[13:0];
  assign xil_SimpleDualBram_6_dina = sData_payload[55 : 48];
  assign sData_fire_7 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_7_addra = _zz_addra_7[13:0];
  assign xil_SimpleDualBram_7_addrb = _zz_addrb_7[13:0];
  assign xil_SimpleDualBram_7_dina = sData_payload[63 : 56];
  assign sData_fire_8 = (sData_valid && sData_ready);
  assign sData_ready = ((Fsm_currentState & WEIGHT_CACHE_STATUS_CACHE_WEIGHT) != 4'b0000);
  assign Fsm_SA_Computed = LayerEnd;
  always @(*) begin
    case(OutCol_Cnt_count)
      16'h0001 : begin
        MatrixCol_Switch_1[0 : 0] = 1'b1;
        MatrixCol_Switch_1[7 : 1] = 7'h0;
      end
      16'h0002 : begin
        MatrixCol_Switch_1[1 : 0] = 2'b11;
        MatrixCol_Switch_1[7 : 2] = 6'h0;
      end
      16'h0003 : begin
        MatrixCol_Switch_1[2 : 0] = 3'b111;
        MatrixCol_Switch_1[7 : 3] = 5'h0;
      end
      16'h0004 : begin
        MatrixCol_Switch_1[3 : 0] = 4'b1111;
        MatrixCol_Switch_1[7 : 4] = 4'b0000;
      end
      16'h0005 : begin
        MatrixCol_Switch_1[4 : 0] = 5'h1f;
        MatrixCol_Switch_1[7 : 5] = 3'b000;
      end
      16'h0006 : begin
        MatrixCol_Switch_1[5 : 0] = 6'h3f;
        MatrixCol_Switch_1[7 : 6] = 2'b00;
      end
      16'h0007 : begin
        MatrixCol_Switch_1[6 : 0] = 7'h7f;
        MatrixCol_Switch_1[7 : 7] = 1'b0;
      end
      default : begin
        MatrixCol_Switch_1 = 8'hff;
      end
    endcase
  end

  assign MatrixCol_Switch = MatrixCol_Switch_1_regNext;
  always @(posedge clk) begin
    start_regNext <= start;
    MatrixCol_Switch_1_regNext <= MatrixCol_Switch_1;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= WEIGHT_CACHE_STATUS_IDLE;
      Init_Count_count <= 3'b000;
      In_Row_Cnt_count <= 16'h0;
      In_Col_Cnt_count <= Matrix_Col;
      Read_Row_Base_Addr <= 16'h0;
      Write_Row_Base_Addr <= 16'h0;
      OutRow_Cnt_count <= 16'h0;
      OutCol_Cnt_count <= Matrix_Col;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(sData_fire) begin
        if(In_Row_Cnt_valid) begin
          In_Row_Cnt_count <= 16'h0;
        end else begin
          In_Row_Cnt_count <= (In_Row_Cnt_count + 16'h0001);
        end
      end
      if(In_Row_Cnt_valid) begin
        if(In_Col_Cnt_valid) begin
          In_Col_Cnt_count <= Matrix_Col;
        end else begin
          In_Col_Cnt_count <= (In_Col_Cnt_count - _zz_In_Col_Cnt_count_1);
        end
      end
      if(when_Weight_CacheV2_l96) begin
        In_Col_Cnt_count <= Matrix_Col;
      end
      if(when_WaCounter_l39) begin
        if(OutRow_Cnt_valid) begin
          OutRow_Cnt_count <= 16'h0;
        end else begin
          OutRow_Cnt_count <= (OutRow_Cnt_count + 16'h0001);
        end
      end
      if(OutRow_Cnt_valid) begin
        if(OutCol_Cnt_valid) begin
          OutCol_Cnt_count <= Matrix_Col;
        end else begin
          OutCol_Cnt_count <= (OutCol_Cnt_count - _zz_OutCol_Cnt_count_1);
        end
      end
      if(when_Weight_CacheV2_l107) begin
        OutCol_Cnt_count <= Matrix_Col;
      end
      if(OutCol_Cnt_valid) begin
        Read_Row_Base_Addr <= 16'h0;
      end else begin
        if(OutRow_Cnt_valid) begin
          Read_Row_Base_Addr <= (Read_Row_Base_Addr + Matrix_Row);
        end
      end
      if(when_Weight_CacheV2_l116) begin
        Write_Row_Base_Addr <= 16'h0;
      end else begin
        if(In_Row_Cnt_valid) begin
          Write_Row_Base_Addr <= (Write_Row_Base_Addr + Matrix_Row);
        end
      end
    end
  end


endmodule
