// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : Img2Col_Top
// Git hash  : a653350aa150c74719ae18f588ed205272e9bf60

`timescale 1ns/1ps

module Img2Col_Top (
  input               start,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  output     [63:0]   mData,
  input               mReady,
  output              mValid,
  input               Fifo_Clear,
  output              mLast,
  input      [4:0]    Stride,
  input      [4:0]    Kernel_Size,
  input      [15:0]   Window_Size,
  input      [15:0]   InFeature_Size,
  input      [15:0]   InFeature_Channel,
  input      [15:0]   OutFeature_Channel,
  input      [15:0]   OutFeature_Size,
  input      [15:0]   OutCol_Count_Times,
  input      [15:0]   InCol_Count_Times,
  input      [15:0]   OutRow_Count_Times,
  input      [15:0]   OutFeature_Channel_Count_Times,
  input      [12:0]   Sliding_Size,
  output              Test_Signal,
  input      [15:0]   Test_Generate_Period,
  output              Test_End,
  output              Raddr_Valid,
  output              LayerEnd,
  output              SA_Row_Cnt_Valid,
  input               clk,
  input               reset
);
  localparam IMG2COL_ENUM_IDLE = 7'd1;
  localparam IMG2COL_ENUM_INIT = 7'd2;
  localparam IMG2COL_ENUM_INIT_ADDR = 7'd4;
  localparam IMG2COL_ENUM_DATA_CACHE = 7'd8;
  localparam IMG2COL_ENUM_WAIT_COMPUTE = 7'd16;
  localparam IMG2COL_ENUM_UPDATE_ADDR = 7'd32;
  localparam IMG2COL_ENUM_START_COMPUTE = 7'd64;

  reg                 AddrFifo_io_push_valid;
  reg                 AddrFifo_io_pop_ready;
  wire                AddrFifo_io_flush;
  reg                 RaddrFifo0_io_push_valid;
  reg        [15:0]   RaddrFifo0_io_push_payload;
  reg                 RaddrFifo0_io_pop_ready;
  wire                RaddrFifo0_io_flush;
  wire                Img2Col_SubModule_start;
  wire                Img2Col_SubModule_NewAddrIn_valid;
  wire       [13:0]   DGB_addra;
  wire       [13:0]   DGB_addrb;
  wire                AddrFifo_io_push_ready;
  wire                AddrFifo_io_pop_valid;
  wire       [15:0]   AddrFifo_io_pop_payload;
  wire       [5:0]    AddrFifo_io_occupancy;
  wire       [5:0]    AddrFifo_io_availability;
  wire                RaddrFifo0_io_push_ready;
  wire                RaddrFifo0_io_pop_valid;
  wire       [15:0]   RaddrFifo0_io_pop_payload;
  wire       [5:0]    RaddrFifo0_io_occupancy;
  wire       [5:0]    RaddrFifo0_io_availability;
  wire                Img2Col_SubModule_NewAddrIn_ready;
  wire                Img2Col_SubModule_SA_Idle;
  wire       [15:0]   Img2Col_SubModule_Raddr;
  wire                Img2Col_SubModule_Raddr_Valid;
  wire                Img2Col_SubModule_SA_End;
  wire                Img2Col_SubModule_AddrReceived;
  wire                Img2Col_SubModule_SA_Row_Cnt_Valid;
  wire       [63:0]   DGB_doutb;
  wire       [4:0]    _zz_Addr_Init_Cnt_valid;
  wire       [4:0]    _zz_Addr_Init_Cnt_valid_1;
  wire       [15:0]   _zz_In_Col_Cnt_valid;
  wire       [4:0]    _zz_Row_Cache_Cnt_valid;
  wire       [15:0]   _zz_In_Row_Cnt_valid;
  wire       [15:0]   _zz_when_Data_Generate_V2_l217;
  wire       [4:0]    _zz_when_Data_Generate_V2_l217_1;
  wire       [15:0]   _zz_Out_Row_Cnt_valid;
  wire       [15:0]   _zz_Test_Valid;
  reg                 start_regNext;
  wire                when_Data_Generate_V2_l59;
  reg        [6:0]    Fsm_currentState;
  reg        [6:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Addr_Inited;
  wire                Fsm_Data_Cached;
  wire                Fsm_Addr_Updated;
  wire                Fsm_SA_Ready;
  wire                Fsm_Cache_End;
  wire                Fsm_Layer_End;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l39;
  reg        [4:0]    Addr_Init_Cnt_count;
  wire                Addr_Init_Cnt_valid;
  reg        [15:0]   WaddrOffset;
  wire                when_Data_Generate_V2_l170;
  wire                when_Data_Generate_V2_l175;
  wire                AddrFifo_io_pop_fire;
  wire                when_Data_Generate_V2_l179;
  wire                when_Data_Generate_V2_l183;
  reg        [15:0]   Raddr_Initialization;
  wire                when_Data_Generate_V2_l193;
  wire                when_Data_Generate_V2_l197;
  reg        [4:0]    Cache_Row_Num;
  reg        [4:0]    Raddr_Updata_Cnt_Num;
  wire                sData_fire;
  reg        [15:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  reg        [4:0]    Row_Cache_Cnt_count;
  wire                Row_Cache_Cnt_valid;
  reg        [15:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  wire                when_Data_Generate_V2_l217;
  reg                 CacheEnd_Flag;
  wire                when_Data_Generate_V2_l228;
  wire                Img2ColOutput_Module_Ready_Receive_Addr;
  wire                when_Data_Generate_V2_l245;
  wire                RaddrFifo0_io_pop_fire;
  reg        [15:0]   Out_Row_Cnt_count;
  wire                Out_Row_Cnt_valid;
  wire       [15:0]   Waddr;
  wire                sData_fire_1;
  reg                 Img2Col_SubModule_Raddr_Valid_regNext;
  reg                 Out_Row_Cnt_valid_regNext;
  reg        [15:0]   Out_Row_Cnt_count_regNext;
  wire                Test_Valid;
  reg                 Test_Valid_regNext;
  `ifndef SYNTHESIS
  reg [103:0] Fsm_currentState_string;
  reg [103:0] Fsm_nextState_string;
  `endif


  assign _zz_Addr_Init_Cnt_valid = (_zz_Addr_Init_Cnt_valid_1 - 5'h01);
  assign _zz_Addr_Init_Cnt_valid_1 = (Kernel_Size + Stride);
  assign _zz_In_Col_Cnt_valid = (InCol_Count_Times - 16'h0001);
  assign _zz_Row_Cache_Cnt_valid = (Cache_Row_Num - 5'h01);
  assign _zz_In_Row_Cnt_valid = (InFeature_Size - 16'h0001);
  assign _zz_when_Data_Generate_V2_l217_1 = (Kernel_Size - 5'h01);
  assign _zz_when_Data_Generate_V2_l217 = {11'd0, _zz_when_Data_Generate_V2_l217_1};
  assign _zz_Out_Row_Cnt_valid = (OutRow_Count_Times - 16'h0001);
  assign _zz_Test_Valid = (Test_Generate_Period - 16'h0001);
  WaddrOffset_Fifo AddrFifo (
    .io_push_valid   (AddrFifo_io_push_valid       ), //i
    .io_push_ready   (AddrFifo_io_push_ready       ), //o
    .io_push_payload (WaddrOffset[15:0]            ), //i
    .io_pop_valid    (AddrFifo_io_pop_valid        ), //o
    .io_pop_ready    (AddrFifo_io_pop_ready        ), //i
    .io_pop_payload  (AddrFifo_io_pop_payload[15:0]), //o
    .io_flush        (AddrFifo_io_flush            ), //i
    .io_occupancy    (AddrFifo_io_occupancy[5:0]   ), //o
    .io_availability (AddrFifo_io_availability[5:0]), //o
    .clk             (clk                          ), //i
    .reset           (reset                        )  //i
  );
  WaddrOffset_Fifo RaddrFifo0 (
    .io_push_valid   (RaddrFifo0_io_push_valid        ), //i
    .io_push_ready   (RaddrFifo0_io_push_ready        ), //o
    .io_push_payload (RaddrFifo0_io_push_payload[15:0]), //i
    .io_pop_valid    (RaddrFifo0_io_pop_valid         ), //o
    .io_pop_ready    (RaddrFifo0_io_pop_ready         ), //i
    .io_pop_payload  (RaddrFifo0_io_pop_payload[15:0] ), //o
    .io_flush        (RaddrFifo0_io_flush             ), //i
    .io_occupancy    (RaddrFifo0_io_occupancy[5:0]    ), //o
    .io_availability (RaddrFifo0_io_availability[5:0] ), //o
    .clk             (clk                             ), //i
    .reset           (reset                           )  //i
  );
  Img2Col_OutPut Img2Col_SubModule (
    .start                          (Img2Col_SubModule_start             ), //i
    .NewAddrIn_valid                (Img2Col_SubModule_NewAddrIn_valid   ), //i
    .NewAddrIn_ready                (Img2Col_SubModule_NewAddrIn_ready   ), //o
    .NewAddrIn_payload              (RaddrFifo0_io_pop_payload[15:0]     ), //i
    .SA_Idle                        (Img2Col_SubModule_SA_Idle           ), //o
    .Raddr                          (Img2Col_SubModule_Raddr[15:0]       ), //o
    .Raddr_Valid                    (Img2Col_SubModule_Raddr_Valid       ), //o
    .SA_End                         (Img2Col_SubModule_SA_End            ), //o
    .Stride                         (Stride[4:0]                         ), //i
    .Kernel_Size                    (Kernel_Size[4:0]                    ), //i
    .Window_Size                    (Window_Size[15:0]                   ), //i
    .InFeature_Size                 (InFeature_Size[15:0]                ), //i
    .InFeature_Channel              (InFeature_Channel[15:0]             ), //i
    .OutFeature_Channel             (OutFeature_Channel[15:0]            ), //i
    .OutFeature_Size                (OutFeature_Size[15:0]               ), //i
    .OutCol_Count_Times             (OutCol_Count_Times[15:0]            ), //i
    .InCol_Count_Times              (InCol_Count_Times[15:0]             ), //i
    .OutFeature_Channel_Count_Times (OutFeature_Channel_Count_Times[15:0]), //i
    .Sliding_Size                   (Sliding_Size[12:0]                  ), //i
    .mReady                         (mReady                              ), //i
    .Fifo_Clear                     (Fifo_Clear                          ), //i
    .AddrReceived                   (Img2Col_SubModule_AddrReceived      ), //o
    .LayerEnd                       (Fsm_Layer_End                       ), //i
    .SA_Row_Cnt_Valid               (Img2Col_SubModule_SA_Row_Cnt_Valid  ), //o
    .clk                            (clk                                 ), //i
    .reset                          (reset                               )  //i
  );
  DataGen_Bram DGB (
    .clka  (clk                ), //i
    .addra (DGB_addra[13:0]    ), //i
    .dina  (sData_payload[63:0]), //i
    .ena   (sData_fire_1       ), //i
    .wea   (1'b1               ), //i
    .addrb (DGB_addrb[13:0]    ), //i
    .doutb (DGB_doutb[63:0]    ), //o
    .clkb  (clk                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      IMG2COL_ENUM_IDLE : Fsm_currentState_string = "IDLE         ";
      IMG2COL_ENUM_INIT : Fsm_currentState_string = "INIT         ";
      IMG2COL_ENUM_INIT_ADDR : Fsm_currentState_string = "INIT_ADDR    ";
      IMG2COL_ENUM_DATA_CACHE : Fsm_currentState_string = "DATA_CACHE   ";
      IMG2COL_ENUM_WAIT_COMPUTE : Fsm_currentState_string = "WAIT_COMPUTE ";
      IMG2COL_ENUM_UPDATE_ADDR : Fsm_currentState_string = "UPDATE_ADDR  ";
      IMG2COL_ENUM_START_COMPUTE : Fsm_currentState_string = "START_COMPUTE";
      default : Fsm_currentState_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      IMG2COL_ENUM_IDLE : Fsm_nextState_string = "IDLE         ";
      IMG2COL_ENUM_INIT : Fsm_nextState_string = "INIT         ";
      IMG2COL_ENUM_INIT_ADDR : Fsm_nextState_string = "INIT_ADDR    ";
      IMG2COL_ENUM_DATA_CACHE : Fsm_nextState_string = "DATA_CACHE   ";
      IMG2COL_ENUM_WAIT_COMPUTE : Fsm_nextState_string = "WAIT_COMPUTE ";
      IMG2COL_ENUM_UPDATE_ADDR : Fsm_nextState_string = "UPDATE_ADDR  ";
      IMG2COL_ENUM_START_COMPUTE : Fsm_nextState_string = "START_COMPUTE";
      default : Fsm_nextState_string = "?????????????";
    endcase
  end
  `endif

  assign when_Data_Generate_V2_l59 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & IMG2COL_ENUM_IDLE) == IMG2COL_ENUM_IDLE) : begin
        if(when_Data_Generate_V2_l59) begin
          Fsm_nextState = IMG2COL_ENUM_INIT;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_INIT) == IMG2COL_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = IMG2COL_ENUM_INIT_ADDR;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_INIT_ADDR) == IMG2COL_ENUM_INIT_ADDR) : begin
        if(Fsm_Addr_Inited) begin
          Fsm_nextState = IMG2COL_ENUM_DATA_CACHE;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_INIT_ADDR;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_DATA_CACHE) == IMG2COL_ENUM_DATA_CACHE) : begin
        if(Fsm_Data_Cached) begin
          Fsm_nextState = IMG2COL_ENUM_WAIT_COMPUTE;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_DATA_CACHE;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_WAIT_COMPUTE) == IMG2COL_ENUM_WAIT_COMPUTE) : begin
        if(Fsm_Layer_End) begin
          Fsm_nextState = IMG2COL_ENUM_IDLE;
        end else begin
          if(Fsm_SA_Ready) begin
            Fsm_nextState = IMG2COL_ENUM_UPDATE_ADDR;
          end else begin
            Fsm_nextState = IMG2COL_ENUM_WAIT_COMPUTE;
          end
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_UPDATE_ADDR) == IMG2COL_ENUM_UPDATE_ADDR) : begin
        if(Fsm_Addr_Updated) begin
          Fsm_nextState = IMG2COL_ENUM_START_COMPUTE;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_UPDATE_ADDR;
        end
      end
      default : begin
        if(Fsm_Layer_End) begin
          Fsm_nextState = IMG2COL_ENUM_IDLE;
        end else begin
          if(Fsm_Cache_End) begin
            Fsm_nextState = IMG2COL_ENUM_WAIT_COMPUTE;
          end else begin
            Fsm_nextState = IMG2COL_ENUM_DATA_CACHE;
          end
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & IMG2COL_ENUM_INIT) != 7'b0000000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign when_WaCounter_l39 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign Addr_Init_Cnt_valid = ((Addr_Init_Cnt_count == _zz_Addr_Init_Cnt_valid) && when_WaCounter_l39);
  assign Fsm_Addr_Inited = Addr_Init_Cnt_valid;
  always @(*) begin
    AddrFifo_io_push_valid = 1'b0;
    if(when_Data_Generate_V2_l170) begin
      AddrFifo_io_push_valid = 1'b1;
    end
    if(In_Col_Cnt_valid) begin
      AddrFifo_io_push_valid = 1'b1;
    end
  end

  always @(*) begin
    AddrFifo_io_pop_ready = 1'b0;
    if(when_Data_Generate_V2_l183) begin
      AddrFifo_io_pop_ready = 1'b1;
    end
    if(In_Col_Cnt_valid) begin
      AddrFifo_io_pop_ready = 1'b1;
    end
  end

  assign when_Data_Generate_V2_l170 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign when_Data_Generate_V2_l175 = ((Fsm_currentState & IMG2COL_ENUM_INIT) != 7'b0000000);
  assign AddrFifo_io_pop_fire = (AddrFifo_io_pop_valid && AddrFifo_io_pop_ready);
  assign when_Data_Generate_V2_l179 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign when_Data_Generate_V2_l183 = (((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000) && ((Fsm_nextState & IMG2COL_ENUM_DATA_CACHE) != 7'b0000000));
  always @(*) begin
    RaddrFifo0_io_push_valid = 1'b0;
    if(when_Data_Generate_V2_l193) begin
      RaddrFifo0_io_push_valid = 1'b1;
    end
    if(when_Data_Generate_V2_l245) begin
      RaddrFifo0_io_push_valid = RaddrFifo0_io_pop_fire;
    end
  end

  always @(*) begin
    RaddrFifo0_io_pop_ready = 1'b0;
    if(when_Data_Generate_V2_l245) begin
      RaddrFifo0_io_pop_ready = Img2ColOutput_Module_Ready_Receive_Addr;
    end
  end

  always @(*) begin
    RaddrFifo0_io_push_payload = RaddrFifo0_io_pop_payload;
    if(when_Data_Generate_V2_l193) begin
      RaddrFifo0_io_push_payload = Raddr_Initialization;
    end
    if(when_Data_Generate_V2_l245) begin
      RaddrFifo0_io_push_payload = RaddrFifo0_io_pop_payload;
    end
  end

  assign when_Data_Generate_V2_l193 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign when_Data_Generate_V2_l197 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign sData_fire = (sData_valid && sData_ready);
  assign In_Col_Cnt_valid = ((In_Col_Cnt_count == _zz_In_Col_Cnt_valid) && sData_fire);
  assign Row_Cache_Cnt_valid = ((Row_Cache_Cnt_count == _zz_Row_Cache_Cnt_valid) && In_Col_Cnt_valid);
  assign In_Row_Cnt_valid = ((In_Row_Cnt_count == _zz_In_Row_Cnt_valid) && In_Col_Cnt_valid);
  assign when_Data_Generate_V2_l217 = (_zz_when_Data_Generate_V2_l217 < In_Row_Cnt_count);
  always @(*) begin
    if(when_Data_Generate_V2_l217) begin
      Cache_Row_Num = Stride;
    end else begin
      Cache_Row_Num = Kernel_Size;
    end
  end

  always @(*) begin
    if(when_Data_Generate_V2_l217) begin
      Raddr_Updata_Cnt_Num = Stride;
    end else begin
      Raddr_Updata_Cnt_Num = Kernel_Size;
    end
  end

  assign Fsm_Data_Cached = Row_Cache_Cnt_valid;
  assign when_Data_Generate_V2_l228 = ((Fsm_currentState & IMG2COL_ENUM_IDLE) != 7'b0000000);
  assign Fsm_Cache_End = CacheEnd_Flag;
  assign sData_ready = ((Fsm_currentState & IMG2COL_ENUM_DATA_CACHE) != 7'b0000000);
  assign when_Data_Generate_V2_l245 = ((Fsm_currentState & IMG2COL_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign RaddrFifo0_io_pop_fire = (RaddrFifo0_io_pop_valid && RaddrFifo0_io_pop_ready);
  assign Img2Col_SubModule_start = ((Fsm_currentState & IMG2COL_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign Fsm_SA_Ready = Img2Col_SubModule_SA_Idle;
  assign Img2ColOutput_Module_Ready_Receive_Addr = Img2Col_SubModule_NewAddrIn_ready;
  assign Img2Col_SubModule_NewAddrIn_valid = ((Fsm_currentState & IMG2COL_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign SA_Row_Cnt_Valid = Img2Col_SubModule_SA_Row_Cnt_Valid;
  assign LayerEnd = Fsm_Layer_End;
  assign Fsm_Addr_Updated = Img2Col_SubModule_AddrReceived;
  assign Out_Row_Cnt_valid = ((Out_Row_Cnt_count == _zz_Out_Row_Cnt_valid) && Img2Col_SubModule_SA_End);
  assign Fsm_Layer_End = Out_Row_Cnt_valid;
  assign Waddr = (WaddrOffset + In_Col_Cnt_count);
  assign DGB_addra = Waddr[13:0];
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign DGB_addrb = Img2Col_SubModule_Raddr[13:0];
  assign mData = DGB_doutb;
  assign mValid = Img2Col_SubModule_Raddr_Valid_regNext;
  assign mLast = Out_Row_Cnt_valid_regNext;
  assign Test_Valid = (_zz_Test_Valid == Out_Row_Cnt_count_regNext);
  assign Test_Signal = Test_Valid;
  assign Test_End = ((! Test_Valid) && Test_Valid_regNext);
  assign AddrFifo_io_flush = ((Fsm_nextState & IMG2COL_ENUM_IDLE) != 7'b0000000);
  assign RaddrFifo0_io_flush = ((Fsm_nextState & IMG2COL_ENUM_IDLE) != 7'b0000000);
  assign Raddr_Valid = Img2Col_SubModule_Raddr_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Img2Col_SubModule_Raddr_Valid_regNext <= Img2Col_SubModule_Raddr_Valid;
    Out_Row_Cnt_valid_regNext <= Out_Row_Cnt_valid;
    Out_Row_Cnt_count_regNext <= Out_Row_Cnt_count;
    Test_Valid_regNext <= Test_Valid;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= IMG2COL_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Addr_Init_Cnt_count <= 5'h0;
      WaddrOffset <= 16'h0;
      Raddr_Initialization <= 16'h0;
      In_Col_Cnt_count <= 16'h0;
      Row_Cache_Cnt_count <= 5'h0;
      In_Row_Cnt_count <= 16'h0;
      CacheEnd_Flag <= 1'b0;
      Out_Row_Cnt_count <= 16'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l39) begin
        if(Addr_Init_Cnt_valid) begin
          Addr_Init_Cnt_count <= 5'h0;
        end else begin
          Addr_Init_Cnt_count <= (Addr_Init_Cnt_count + 5'h01);
        end
      end
      if(when_Data_Generate_V2_l175) begin
        WaddrOffset <= 16'h0;
      end else begin
        if(AddrFifo_io_pop_fire) begin
          WaddrOffset <= AddrFifo_io_pop_payload;
        end else begin
          if(when_Data_Generate_V2_l179) begin
            WaddrOffset <= (WaddrOffset + InCol_Count_Times);
          end
        end
      end
      if(when_Data_Generate_V2_l197) begin
        Raddr_Initialization <= (Raddr_Initialization + InCol_Count_Times);
      end else begin
        Raddr_Initialization <= 16'h0;
      end
      if(sData_fire) begin
        if(In_Col_Cnt_valid) begin
          In_Col_Cnt_count <= 16'h0;
        end else begin
          In_Col_Cnt_count <= (In_Col_Cnt_count + 16'h0001);
        end
      end
      if(In_Col_Cnt_valid) begin
        if(Row_Cache_Cnt_valid) begin
          Row_Cache_Cnt_count <= 5'h0;
        end else begin
          Row_Cache_Cnt_count <= (Row_Cache_Cnt_count + 5'h01);
        end
      end
      if(In_Col_Cnt_valid) begin
        if(In_Row_Cnt_valid) begin
          In_Row_Cnt_count <= 16'h0;
        end else begin
          In_Row_Cnt_count <= (In_Row_Cnt_count + 16'h0001);
        end
      end
      if(In_Row_Cnt_valid) begin
        CacheEnd_Flag <= 1'b1;
      end else begin
        if(when_Data_Generate_V2_l228) begin
          CacheEnd_Flag <= 1'b0;
        end
      end
      if(Img2Col_SubModule_SA_End) begin
        if(Out_Row_Cnt_valid) begin
          Out_Row_Cnt_count <= 16'h0;
        end else begin
          Out_Row_Cnt_count <= (Out_Row_Cnt_count + 16'h0001);
        end
      end
    end
  end


endmodule

module Img2Col_OutPut (
  input               start,
  input               NewAddrIn_valid,
  output              NewAddrIn_ready,
  input      [15:0]   NewAddrIn_payload,
  output              SA_Idle,
  output     [15:0]   Raddr,
  output              Raddr_Valid,
  output              SA_End,
  input      [4:0]    Stride,
  input      [4:0]    Kernel_Size,
  input      [15:0]   Window_Size,
  input      [15:0]   InFeature_Size,
  input      [15:0]   InFeature_Channel,
  input      [15:0]   OutFeature_Channel,
  input      [15:0]   OutFeature_Size,
  input      [15:0]   OutCol_Count_Times,
  input      [15:0]   InCol_Count_Times,
  input      [15:0]   OutFeature_Channel_Count_Times,
  input      [12:0]   Sliding_Size,
  input               mReady,
  input               Fifo_Clear,
  output reg          AddrReceived,
  input               LayerEnd,
  output              SA_Row_Cnt_Valid,
  input               clk,
  input               reset
);
  localparam IMG2COL_OUTPUT_ENUM_IDLE = 7'd1;
  localparam IMG2COL_OUTPUT_ENUM_INIT = 7'd2;
  localparam IMG2COL_OUTPUT_ENUM_INIT_ADDR = 7'd4;
  localparam IMG2COL_OUTPUT_ENUM_SA_COMPUTE = 7'd8;
  localparam IMG2COL_OUTPUT_ENUM_UPDATE_ADDR = 7'd16;
  localparam IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY = 7'd32;
  localparam IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR = 7'd64;

  reg                 RaddrFifo1_io_push_valid;
  reg        [15:0]   RaddrFifo1_io_push_payload;
  reg                 RaddrFifo1_io_pop_ready;
  wire                RaddrFifo1_io_flush;
  wire                RaddrFifo1_io_push_ready;
  wire                RaddrFifo1_io_pop_valid;
  wire       [15:0]   RaddrFifo1_io_pop_payload;
  wire       [5:0]    RaddrFifo1_io_occupancy;
  wire       [5:0]    RaddrFifo1_io_availability;
  wire       [4:0]    _zz_Raddr_Init_Cnt_valid;
  wire       [4:0]    _zz_Raddr_Update_Cnt_valid;
  wire       [12:0]   _zz_In_Channel_Process_Cnt_valid;
  wire       [12:0]   _zz_In_Channel_Process_Cnt_valid_1;
  wire       [15:0]   _zz_Window_Col_Cnt_valid;
  wire       [4:0]    _zz_Window_Col_Cnt_valid_1;
  wire       [15:0]   _zz_Window_Row_Cnt_valid;
  wire       [4:0]    _zz_Window_Row_Cnt_valid_1;
  wire       [15:0]   _zz_Out_Channel_Cnt_valid;
  wire       [15:0]   _zz_Out_Col_Cnt_valid;
  wire       [15:0]   _zz_when_Data_Generate_V2_l498;
  wire       [15:0]   _zz_when_Data_Generate_V2_l498_1;
  wire       [15:0]   _zz_WindowSize_Cnt_valid;
  wire       [15:0]   _zz_WindowSize_Cnt_valid_1;
  wire       [31:0]   _zz_Kernel_Base_Addr;
  wire       [15:0]   _zz_Kernel_Base_Addr_1;
  wire       [31:0]   _zz_Kernel_Addr;
  wire       [15:0]   _zz_Kernel_Addr_1;
  wire       [31:0]   _zz_Kernel_Addr_2;
  wire       [31:0]   _zz_Kernel_Addr_3;
  wire       [31:0]   _zz_Kernel_Addr_4;
  wire       [31:0]   _zz_Raddr;
  wire       [31:0]   _zz_Raddr_1;
  reg                 start_regNext;
  wire                when_Data_Generate_V2_l344;
  reg        [6:0]    Fsm_currentState;
  reg        [6:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Addr_Inited;
  wire                Fsm_SA_Computed;
  wire                Fsm_Addr_Updated;
  wire                Fsm_LayerEnd;
  wire                Fsm_NextReady;
  wire                Fsm_Fifo_Clear;
  wire                when_Data_Generate_V2_l376;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  reg        [15:0]   Row_Base_Addr;
  wire                RaddrFifo1_io_pop_fire;
  wire                RaddrFifo1_io_push_fire;
  wire                when_WaCounter_l39;
  reg        [4:0]    Raddr_Init_Cnt_count;
  wire                Raddr_Init_Cnt_valid;
  wire                RaddrFifo1_io_push_fire_1;
  wire                when_WaCounter_l39_1;
  reg        [4:0]    Raddr_Update_Cnt_count;
  wire                Raddr_Update_Cnt_valid;
  wire                when_Data_Generate_V2_l463;
  wire                when_WaCounter_l39_2;
  reg        [2:0]    SA_Row_Cnt_count;
  reg                 SA_Row_Cnt_valid_1;
  reg        [12:0]   In_Channel_Process_Cnt_count;
  wire                In_Channel_Process_Cnt_valid;
  reg        [15:0]   Window_Col_Cnt_count;
  wire                Window_Col_Cnt_valid;
  reg        [15:0]   Window_Row_Cnt_count;
  wire                Window_Row_Cnt_valid;
  reg        [15:0]   Out_Channel_Cnt_count;
  wire                Out_Channel_Cnt_valid;
  reg        [15:0]   Out_Col_Cnt_count;
  wire                Out_Col_Cnt_valid;
  reg        [15:0]   OutFeature_Col_Lefted;
  wire                when_Data_Generate_V2_l495;
  wire                when_Data_Generate_V2_l498;
  reg        [12:0]   WindowSize_Cnt_count;
  wire                WindowSize_Cnt_valid;
  reg        [31:0]   Kernel_Addr;
  reg        [31:0]   Kernel_Base_Addr;
  wire                when_Data_Generate_V2_l523;
  wire                when_Data_Generate_V2_l533;
  wire                RaddrFifo1_io_push_fire_2;
  wire                when_Data_Generate_V2_l537;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif


  assign _zz_Raddr_Init_Cnt_valid = (Kernel_Size - 5'h01);
  assign _zz_Raddr_Update_Cnt_valid = (Stride - 5'h01);
  assign _zz_In_Channel_Process_Cnt_valid = (_zz_In_Channel_Process_Cnt_valid_1 - 13'h0001);
  assign _zz_In_Channel_Process_Cnt_valid_1 = (InFeature_Channel >>> 3);
  assign _zz_Window_Col_Cnt_valid_1 = (Kernel_Size - 5'h01);
  assign _zz_Window_Col_Cnt_valid = {11'd0, _zz_Window_Col_Cnt_valid_1};
  assign _zz_Window_Row_Cnt_valid_1 = (Kernel_Size - 5'h01);
  assign _zz_Window_Row_Cnt_valid = {11'd0, _zz_Window_Row_Cnt_valid_1};
  assign _zz_Out_Channel_Cnt_valid = (OutFeature_Channel_Count_Times - 16'h0001);
  assign _zz_Out_Col_Cnt_valid = (OutCol_Count_Times - 16'h0001);
  assign _zz_when_Data_Generate_V2_l498 = {13'd0, SA_Row_Cnt_count};
  assign _zz_when_Data_Generate_V2_l498_1 = (OutFeature_Col_Lefted - 16'h0001);
  assign _zz_WindowSize_Cnt_valid = {3'd0, WindowSize_Cnt_count};
  assign _zz_WindowSize_Cnt_valid_1 = (Window_Size - 16'h0001);
  assign _zz_Kernel_Base_Addr_1 = ({3'd0,Sliding_Size} <<< 3);
  assign _zz_Kernel_Base_Addr = {16'd0, _zz_Kernel_Base_Addr_1};
  assign _zz_Kernel_Addr_1 = ({3'd0,Sliding_Size} <<< 3);
  assign _zz_Kernel_Addr = {16'd0, _zz_Kernel_Addr_1};
  assign _zz_Kernel_Addr_2 = (Kernel_Base_Addr + _zz_Kernel_Addr_3);
  assign _zz_Kernel_Addr_3 = {19'd0, WindowSize_Cnt_count};
  assign _zz_Kernel_Addr_4 = {19'd0, Sliding_Size};
  assign _zz_Raddr = (Kernel_Addr + _zz_Raddr_1);
  assign _zz_Raddr_1 = {16'd0, Row_Base_Addr};
  WaddrOffset_Fifo RaddrFifo1 (
    .io_push_valid   (RaddrFifo1_io_push_valid        ), //i
    .io_push_ready   (RaddrFifo1_io_push_ready        ), //o
    .io_push_payload (RaddrFifo1_io_push_payload[15:0]), //i
    .io_pop_valid    (RaddrFifo1_io_pop_valid         ), //o
    .io_pop_ready    (RaddrFifo1_io_pop_ready         ), //i
    .io_pop_payload  (RaddrFifo1_io_pop_payload[15:0] ), //o
    .io_flush        (RaddrFifo1_io_flush             ), //i
    .io_occupancy    (RaddrFifo1_io_occupancy[5:0]    ), //o
    .io_availability (RaddrFifo1_io_availability[5:0] ), //o
    .clk             (clk                             ), //i
    .reset           (reset                           )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      IMG2COL_OUTPUT_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      IMG2COL_OUTPUT_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      IMG2COL_OUTPUT_ENUM_INIT_ADDR : Fsm_currentState_string = "INIT_ADDR      ";
      IMG2COL_OUTPUT_ENUM_SA_COMPUTE : Fsm_currentState_string = "SA_COMPUTE     ";
      IMG2COL_OUTPUT_ENUM_UPDATE_ADDR : Fsm_currentState_string = "UPDATE_ADDR    ";
      IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY : Fsm_currentState_string = "WAIT_NEXT_READY";
      IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR : Fsm_currentState_string = "WAIT_FIFO_CLEAR";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      IMG2COL_OUTPUT_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      IMG2COL_OUTPUT_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      IMG2COL_OUTPUT_ENUM_INIT_ADDR : Fsm_nextState_string = "INIT_ADDR      ";
      IMG2COL_OUTPUT_ENUM_SA_COMPUTE : Fsm_nextState_string = "SA_COMPUTE     ";
      IMG2COL_OUTPUT_ENUM_UPDATE_ADDR : Fsm_nextState_string = "UPDATE_ADDR    ";
      IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY : Fsm_nextState_string = "WAIT_NEXT_READY";
      IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR : Fsm_nextState_string = "WAIT_FIFO_CLEAR";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_Data_Generate_V2_l344 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_IDLE) == IMG2COL_OUTPUT_ENUM_IDLE) : begin
        if(when_Data_Generate_V2_l344) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_INIT) == IMG2COL_OUTPUT_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT_ADDR;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_INIT_ADDR) == IMG2COL_OUTPUT_ENUM_INIT_ADDR) : begin
        if(Fsm_Addr_Inited) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT_ADDR;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) == IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) : begin
        if(Fsm_NextReady) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_SA_COMPUTE;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) == IMG2COL_OUTPUT_ENUM_SA_COMPUTE) : begin
        if(Fsm_LayerEnd) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_IDLE;
        end else begin
          if(Fsm_SA_Computed) begin
            Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR;
          end else begin
            if(when_Data_Generate_V2_l376) begin
              Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
            end else begin
              Fsm_nextState = IMG2COL_OUTPUT_ENUM_SA_COMPUTE;
            end
          end
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR) == IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR) : begin
        if(Fsm_Fifo_Clear) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_UPDATE_ADDR;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR;
        end
      end
      default : begin
        if(Fsm_Addr_Updated) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_UPDATE_ADDR;
        end
      end
    endcase
  end

  assign when_Data_Generate_V2_l376 = (! Fsm_NextReady);
  assign when_WaCounter_l19 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT) != 7'b0000000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Fifo_Clear = Fifo_Clear;
  assign NewAddrIn_ready = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000) || ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000));
  always @(*) begin
    RaddrFifo1_io_push_valid = 1'b0;
    if(when_Data_Generate_V2_l533) begin
      RaddrFifo1_io_push_valid = NewAddrIn_valid;
    end else begin
      if(when_Data_Generate_V2_l537) begin
        RaddrFifo1_io_push_valid = NewAddrIn_valid;
      end else begin
        RaddrFifo1_io_push_valid = Window_Col_Cnt_valid;
      end
    end
  end

  always @(*) begin
    RaddrFifo1_io_pop_ready = 1'b0;
    if(when_Data_Generate_V2_l463) begin
      RaddrFifo1_io_pop_ready = 1'b1;
    end
    if(!when_Data_Generate_V2_l533) begin
      if(when_Data_Generate_V2_l537) begin
        RaddrFifo1_io_pop_ready = RaddrFifo1_io_push_fire_2;
      end
    end
    if(Window_Col_Cnt_valid) begin
      RaddrFifo1_io_pop_ready = 1'b1;
    end
  end

  assign RaddrFifo1_io_pop_fire = (RaddrFifo1_io_pop_valid && RaddrFifo1_io_pop_ready);
  assign RaddrFifo1_io_push_fire = (RaddrFifo1_io_push_valid && RaddrFifo1_io_push_ready);
  assign when_WaCounter_l39 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000) && RaddrFifo1_io_push_fire);
  assign Raddr_Init_Cnt_valid = ((Raddr_Init_Cnt_count == _zz_Raddr_Init_Cnt_valid) && when_WaCounter_l39);
  assign Fsm_Addr_Inited = Raddr_Init_Cnt_valid;
  assign RaddrFifo1_io_push_fire_1 = (RaddrFifo1_io_push_valid && RaddrFifo1_io_push_ready);
  assign when_WaCounter_l39_1 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000) && RaddrFifo1_io_push_fire_1);
  assign Raddr_Update_Cnt_valid = ((Raddr_Update_Cnt_count == _zz_Raddr_Update_Cnt_valid) && when_WaCounter_l39_1);
  assign Fsm_Addr_Updated = Raddr_Update_Cnt_valid;
  assign Fsm_NextReady = mReady;
  always @(*) begin
    AddrReceived = 1'b0;
    if(when_Data_Generate_V2_l463) begin
      AddrReceived = 1'b1;
    end
  end

  assign when_Data_Generate_V2_l463 = ((((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000) && ((Fsm_nextState & IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) != 7'b0000000)) || (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000) && ((Fsm_nextState & IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) != 7'b0000000)));
  assign when_WaCounter_l39_2 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000) && mReady);
  always @(*) begin
    SA_Row_Cnt_valid_1 = ((SA_Row_Cnt_count == 3'b111) && when_WaCounter_l39_2);
    if(when_Data_Generate_V2_l498) begin
      SA_Row_Cnt_valid_1 = 1'b1;
    end
  end

  assign SA_Row_Cnt_Valid = SA_Row_Cnt_valid_1;
  assign In_Channel_Process_Cnt_valid = ((In_Channel_Process_Cnt_count == _zz_In_Channel_Process_Cnt_valid) && SA_Row_Cnt_valid_1);
  assign Window_Col_Cnt_valid = ((Window_Col_Cnt_count == _zz_Window_Col_Cnt_valid) && In_Channel_Process_Cnt_valid);
  assign Window_Row_Cnt_valid = ((Window_Row_Cnt_count == _zz_Window_Row_Cnt_valid) && Window_Col_Cnt_valid);
  assign Out_Channel_Cnt_valid = ((Out_Channel_Cnt_count == _zz_Out_Channel_Cnt_valid) && Window_Row_Cnt_valid);
  assign Out_Col_Cnt_valid = ((Out_Col_Cnt_count == _zz_Out_Col_Cnt_valid) && Out_Channel_Cnt_valid);
  assign SA_End = Out_Col_Cnt_valid;
  assign when_Data_Generate_V2_l495 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT) != 7'b0000000);
  assign when_Data_Generate_V2_l498 = (((_zz_when_Data_Generate_V2_l498 == _zz_when_Data_Generate_V2_l498_1) && mReady) && ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000));
  assign WindowSize_Cnt_valid = ((_zz_WindowSize_Cnt_valid == _zz_WindowSize_Cnt_valid_1) && SA_Row_Cnt_valid_1);
  assign when_Data_Generate_V2_l523 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000) && mReady);
  assign Raddr = _zz_Raddr[15:0];
  assign Fsm_SA_Computed = Out_Col_Cnt_valid;
  assign SA_Idle = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_IDLE) != 7'b0000000) || ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000));
  assign when_Data_Generate_V2_l533 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000);
  always @(*) begin
    if(when_Data_Generate_V2_l533) begin
      RaddrFifo1_io_push_payload = NewAddrIn_payload;
    end else begin
      if(when_Data_Generate_V2_l537) begin
        RaddrFifo1_io_push_payload = NewAddrIn_payload;
      end else begin
        RaddrFifo1_io_push_payload = Row_Base_Addr;
      end
    end
  end

  assign RaddrFifo1_io_push_fire_2 = (RaddrFifo1_io_push_valid && RaddrFifo1_io_push_ready);
  assign when_Data_Generate_V2_l537 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign Raddr_Valid = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000) && mReady);
  assign Fsm_LayerEnd = LayerEnd;
  assign RaddrFifo1_io_flush = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_IDLE) != 7'b0000000);
  always @(posedge clk) begin
    start_regNext <= start;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= IMG2COL_OUTPUT_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Row_Base_Addr <= 16'h0;
      Raddr_Init_Cnt_count <= 5'h0;
      Raddr_Update_Cnt_count <= 5'h0;
      SA_Row_Cnt_count <= 3'b000;
      In_Channel_Process_Cnt_count <= 13'h0;
      Window_Col_Cnt_count <= 16'h0;
      Window_Row_Cnt_count <= 16'h0;
      Out_Channel_Cnt_count <= 16'h0;
      Out_Col_Cnt_count <= 16'h0;
      OutFeature_Col_Lefted <= 16'h0;
      WindowSize_Cnt_count <= 13'h0;
      Kernel_Addr <= 32'h0;
      Kernel_Base_Addr <= 32'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(RaddrFifo1_io_pop_fire) begin
        Row_Base_Addr <= RaddrFifo1_io_pop_payload;
      end
      if(when_WaCounter_l39) begin
        if(Raddr_Init_Cnt_valid) begin
          Raddr_Init_Cnt_count <= 5'h0;
        end else begin
          Raddr_Init_Cnt_count <= (Raddr_Init_Cnt_count + 5'h01);
        end
      end
      if(when_WaCounter_l39_1) begin
        if(Raddr_Update_Cnt_valid) begin
          Raddr_Update_Cnt_count <= 5'h0;
        end else begin
          Raddr_Update_Cnt_count <= (Raddr_Update_Cnt_count + 5'h01);
        end
      end
      if(when_WaCounter_l39_2) begin
        if(SA_Row_Cnt_valid_1) begin
          SA_Row_Cnt_count <= 3'b000;
        end else begin
          SA_Row_Cnt_count <= (SA_Row_Cnt_count + 3'b001);
        end
      end
      if(SA_Row_Cnt_valid_1) begin
        if(In_Channel_Process_Cnt_valid) begin
          In_Channel_Process_Cnt_count <= 13'h0;
        end else begin
          In_Channel_Process_Cnt_count <= (In_Channel_Process_Cnt_count + 13'h0001);
        end
      end
      if(In_Channel_Process_Cnt_valid) begin
        if(Window_Col_Cnt_valid) begin
          Window_Col_Cnt_count <= 16'h0;
        end else begin
          Window_Col_Cnt_count <= (Window_Col_Cnt_count + 16'h0001);
        end
      end
      if(Window_Col_Cnt_valid) begin
        if(Window_Row_Cnt_valid) begin
          Window_Row_Cnt_count <= 16'h0;
        end else begin
          Window_Row_Cnt_count <= (Window_Row_Cnt_count + 16'h0001);
        end
      end
      if(Window_Row_Cnt_valid) begin
        if(Out_Channel_Cnt_valid) begin
          Out_Channel_Cnt_count <= 16'h0;
        end else begin
          Out_Channel_Cnt_count <= (Out_Channel_Cnt_count + 16'h0001);
        end
      end
      if(Out_Channel_Cnt_valid) begin
        if(Out_Col_Cnt_valid) begin
          Out_Col_Cnt_count <= 16'h0;
        end else begin
          Out_Col_Cnt_count <= (Out_Col_Cnt_count + 16'h0001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        OutFeature_Col_Lefted <= OutFeature_Size;
      end else begin
        if(Out_Channel_Cnt_valid) begin
          OutFeature_Col_Lefted <= (OutFeature_Col_Lefted - 16'h0008);
        end else begin
          if(when_Data_Generate_V2_l495) begin
            OutFeature_Col_Lefted <= OutFeature_Size;
          end
        end
      end
      if(when_Data_Generate_V2_l498) begin
        SA_Row_Cnt_count <= 3'b000;
      end
      if(SA_Row_Cnt_valid_1) begin
        if(WindowSize_Cnt_valid) begin
          WindowSize_Cnt_count <= 13'h0;
        end else begin
          WindowSize_Cnt_count <= (WindowSize_Cnt_count + 13'h0001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        Kernel_Base_Addr <= 32'h0;
      end else begin
        if(Out_Channel_Cnt_valid) begin
          Kernel_Base_Addr <= (Kernel_Base_Addr + _zz_Kernel_Base_Addr);
        end
      end
      if(Out_Col_Cnt_valid) begin
        Kernel_Addr <= 32'h0;
      end else begin
        if(Out_Channel_Cnt_valid) begin
          Kernel_Addr <= (Kernel_Base_Addr + _zz_Kernel_Addr);
        end else begin
          if(Window_Row_Cnt_valid) begin
            Kernel_Addr <= Kernel_Base_Addr;
          end else begin
            if(WindowSize_Cnt_valid) begin
              Kernel_Addr <= Kernel_Base_Addr;
            end else begin
              if(SA_Row_Cnt_valid_1) begin
                Kernel_Addr <= (_zz_Kernel_Addr_2 + 32'h00000001);
              end else begin
                if(when_Data_Generate_V2_l523) begin
                  Kernel_Addr <= (Kernel_Addr + _zz_Kernel_Addr_4);
                end
              end
            end
          end
        end
      end
    end
  end


endmodule

//WaddrOffset_Fifo replaced by WaddrOffset_Fifo

//WaddrOffset_Fifo replaced by WaddrOffset_Fifo

module WaddrOffset_Fifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [15:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [15:0]   io_pop_payload,
  input               io_flush,
  output reg [5:0]    io_occupancy,
  output reg [5:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [15:0]   _zz_logic_ram_port0;
  wire       [5:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [5:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [15:0]   _zz_logic_ram_port_1;
  wire       [5:0]    _zz_io_occupancy;
  wire       [5:0]    _zz_io_availability;
  wire       [5:0]    _zz_io_availability_1;
  wire       [5:0]    _zz_io_availability_2;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1021;
  wire       [5:0]    logic_ptrDif;
  reg [15:0] logic_ram [0:32];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {5'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {5'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_occupancy = (6'h21 + logic_ptrDif);
  assign _zz_io_availability = (6'h21 + _zz_io_availability_1);
  assign _zz_io_availability_1 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_availability_2 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h20);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    if(logic_pushPtr_willOverflow) begin
      logic_pushPtr_valueNext = 6'h0;
    end else begin
      logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    end
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 6'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h20);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    if(logic_popPtr_willOverflow) begin
      logic_popPtr_valueNext = 6'h0;
    end else begin
      logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    end
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1021 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  always @(*) begin
    if(logic_ptrMatch) begin
      io_occupancy = (logic_risingOccupancy ? 6'h21 : 6'h0);
    end else begin
      io_occupancy = ((logic_popPtr_value < logic_pushPtr_value) ? logic_ptrDif : _zz_io_occupancy);
    end
  end

  always @(*) begin
    if(logic_ptrMatch) begin
      io_availability = (logic_risingOccupancy ? 6'h0 : 6'h21);
    end else begin
      io_availability = ((logic_popPtr_value < logic_pushPtr_value) ? _zz_io_availability : _zz_io_availability_2);
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1021) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule
