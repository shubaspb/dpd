//*************************************************************************************
//Название проекта : 
//Название файла : dds_signal_generator.v
//Назначение : Генератор АМ, ФМ, ЧМ сигнала прямым цифровым синтезом частот
//Автор : Шубин Д.А.
//Дата создания : 12.11.2013
//Синтаксис : IEEE 1364-2001 (Verilog HDL 2001)
//Комментарии :
//Прямой цифровой синтезатор частот формирует комплексный сигнал 
//в соответствии с законом изменения 
//   - частоты (frequency)
//   - фазы (phase)
//   - амплитуды (amplitude)
//*************************************************************************************
//Состояние модуля : [*] проведена проверка синтаксиса (quartus 13.0, modelsim)
// [*] синтезируется без серьезных предупреждений (quartus 13.0)
// [*] проведена функциональное моделирование (modelsim)
// [ ] проведено временное моделирование (modelsim)
// [ ] проведено тестирование в логическом анализаторе
// [ ] проведено тестирование в целевой системе
//*************************************************************************************
//Ревизия : 1.0.0
//*************************************************************************************
`timescale 1ns / 10ps


module dds_signal_generator
   #(parameter WIDTH_NCO = 16,                  // width NCO output
			   WIDTH_PHASE = 32,                // width phase accumulator
			   WIDHT_ADDR_ROM = 10,             // width address table sinus
			   INIT_ROM_FILE = "sin_nco.dat")   // initialisation file for tale sinus (0:pi/2)
   (input clk, 
    input reset_b, 
    input [WIDTH_PHASE-1:0]    frequency,  // frequency = frequency[Hz]*A_F; A_F = 2^WIDTH_PHASE/Fs;
	input [WIDTH_PHASE-1:0]    phase,      // phase = phase[radians]*2^WIDTH_PHASE/(2*pi);
	input [WIDTH_NCO-1:0]      amplitude,   
	input  ena_output,
	input  start,             
    output [WIDTH_NCO-1:0]     real_sig,
    output [WIDTH_NCO-1:0]     imag_sig,
    output [67:0] tst);

	
	
	
 	reg start_reg;
	always @(posedge clk, negedge reset_b) begin :form_start_strobe
		if (~reset_b)
			start_reg <= 1'b0;
		else
			start_reg <= start;
	end
	wire start_strobe = (~start_reg)&start;
	


////////////////// Phase accumulator ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------- Phase accumulator -------------------------------------------------------
reg [WIDTH_PHASE-1:0] cnt_phase;
reg [WIDTH_PHASE-1:0] cnt_phase_sin;
reg [WIDTH_PHASE-1:0] cnt_phase_cos;

always @(posedge clk, negedge reset_b)  begin : phase_counter
    if (~reset_b)
	    cnt_phase <= {(WIDTH_PHASE){1'b0}};	       	
    else begin
	    if (start_strobe)
		    cnt_phase <= {(WIDTH_PHASE){1'b0}};	  
		else
			cnt_phase <= cnt_phase + frequency;	 
	end	   
end
	
reg [WIDTH_PHASE-1:0] phase_reg;
always @(posedge clk, negedge reset_b)  begin : phase_delay
   if (~reset_b)
	   phase_reg <= {(WIDTH_PHASE){1'b0}};	       	
   else
       phase_reg <= phase;	       
end

reg [WIDTH_PHASE-1:0] cnt_phase_sin_reg;
reg [WIDTH_PHASE-1:0] cnt_phase_cos_reg;
always @(posedge clk, negedge reset_b)  begin : latch_phase
    if (~reset_b) begin
	    cnt_phase_sin_reg <= {(WIDTH_PHASE){1'b0}};		
        cnt_phase_cos_reg <= {(WIDTH_PHASE){1'b0}};	       	
    end else begin
        cnt_phase_sin_reg <= cnt_phase + phase_reg;	
        cnt_phase_cos_reg <= cnt_phase + phase_reg;	// addition pi/2 for cosinus      
	end		
end

always @(posedge clk, negedge reset_b)  begin : latch_phase_2
    if (~reset_b) begin
	    cnt_phase_sin <= {(WIDTH_PHASE){1'b0}};		
        cnt_phase_cos <= {(WIDTH_PHASE){1'b0}};	       	
    end else begin
        cnt_phase_sin <= cnt_phase_sin_reg;	
        cnt_phase_cos <= cnt_phase_cos_reg + 2**(WIDTH_PHASE-2);	// addition pi/2 for cosinus      
	end		
end




// -------- rounding phase sinus ------------------------------------------------
wire [WIDHT_ADDR_ROM+1:0] cnt_phase_sin_round;
assign cnt_phase_sin_round = cnt_phase_sin[WIDTH_PHASE-1:WIDTH_PHASE-WIDHT_ADDR_ROM-2] + ({ {(WIDHT_ADDR_ROM+1){1'b0}},  {cnt_phase_sin[WIDTH_PHASE-WIDHT_ADDR_ROM-3]} });

// -------- rounding phase cosinus ------------------------------------------------
wire [WIDHT_ADDR_ROM+1:0] cnt_phase_cos_round;
assign cnt_phase_cos_round = cnt_phase_cos[WIDTH_PHASE-1:WIDTH_PHASE-WIDHT_ADDR_ROM-2] + ({ {(WIDHT_ADDR_ROM+1){1'b0}},  {cnt_phase_cos[WIDTH_PHASE-WIDHT_ADDR_ROM-3]} });


// -------- Generate addr and sign of number -----------------------------------
reg [WIDHT_ADDR_ROM-1:0] addr_rom_sin;
reg [WIDHT_ADDR_ROM-1:0] addr_rom_cos;
reg sign_sin_reg;
reg sign_cos_reg;
reg sign_sin;
reg sign_cos;

always @(posedge clk, negedge reset_b) begin : gen_addr_and_sign
   if (~reset_b) begin
      addr_rom_sin <= {(WIDHT_ADDR_ROM){1'b0}};	
	  addr_rom_cos <= {(WIDHT_ADDR_ROM){1'b0}};	
	  sign_sin_reg <= 1'b0;
	  sign_cos_reg <= 1'b0; 
      sign_sin <= 1'b0;
	  sign_cos <= 1'b0; 	
   end else begin
      addr_rom_sin <= cnt_phase_sin_round[WIDHT_ADDR_ROM-1:0] ^ {(WIDHT_ADDR_ROM){cnt_phase_sin_round[WIDHT_ADDR_ROM]}}; //  00 - [0:pi/2] 
	  addr_rom_cos <= cnt_phase_cos_round[WIDHT_ADDR_ROM-1:0] ^ {(WIDHT_ADDR_ROM){cnt_phase_cos_round[WIDHT_ADDR_ROM]}}; //  01 - [pi/2:pi]  
	  sign_sin_reg <= cnt_phase_sin_round[WIDHT_ADDR_ROM+1];                                                             //  10 - [pi:3*pi/2]
	  sign_cos_reg <= cnt_phase_cos_round[WIDHT_ADDR_ROM+1]; 	                                                         //  11 - [3*pi/2:2*pi]
	  sign_sin <= sign_sin_reg;    // delay by one clock cycle equal delay for read rom
	  sign_cos <= sign_cos_reg; 
   end       
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


// ========== Sinus table ==================================
// phase of sinus = addr_rom_sin/2^WIDHT_ADDR_ROM*(pi/2)
reg [WIDTH_NCO-2:0] rom_sin [0:2**WIDHT_ADDR_ROM-1];
reg [WIDTH_NCO-2:0] out_rom_sin;

initial begin 
   $readmemb(INIT_ROM_FILE, rom_sin); // Initial ROM
end

// Read ROM 
always @ (posedge clk, negedge reset_b) begin : read_rom_sin
   if (~reset_b)
      out_rom_sin <= {(WIDTH_NCO-1){1'b0}};
   else
      out_rom_sin = rom_sin[addr_rom_sin];	
end
// ==========================================================


// ========== Cosinus table =================================
// phase of cosinus = addr_rom_cos/2^WIDHT_ADDR_ROM*(pi/2)
reg [WIDTH_NCO-2:0] rom_cos [0:2**WIDHT_ADDR_ROM-1];
reg [WIDTH_NCO-2:0] out_rom_cos;

initial begin 
   $readmemb(INIT_ROM_FILE, rom_cos); // Initial ROM
end

// Read ROM 
always @ (posedge clk, negedge reset_b) begin : read_rom_cos
   if (~reset_b)
      out_rom_cos <= {(WIDTH_NCO-1){1'b0}};
   else
      out_rom_cos = rom_cos[addr_rom_cos];
end
// ==========================================================


// ===== Convert number to two's complement representation ===========================
// --------- convert sinus -----------------------------------------------------------
reg [WIDTH_NCO-1:0] real_out;
reg [WIDTH_NCO-1:0] imag_out;

wire [WIDTH_NCO-2:0] xor_rom_sin;
wire [WIDTH_NCO-1:0] mod_rom_sin;

assign xor_rom_sin = out_rom_sin^{(WIDTH_NCO-1){sign_sin}};	 // convert modul from rom                               
assign mod_rom_sin = {{sign_sin}, {xor_rom_sin}};	         // calculate number

// Represent of two's complement code
always @(posedge clk, negedge reset_b) begin : conv_two_compl_code_sin
   if (~reset_b)
      imag_out <= 0;
   else begin
      if (sign_sin==0)
		 imag_out <= mod_rom_sin;
	  else
		 imag_out <= mod_rom_sin + ({ {(WIDTH_NCO-1){1'b0}},  {(1){1'b1}} });
   end
end

// ---------- convert cosinus ---------------------------------------------------------
wire [WIDTH_NCO-2:0] xor_rom_cos;
wire [WIDTH_NCO-1:0] mod_rom_cos;

assign xor_rom_cos = out_rom_cos^{(WIDTH_NCO-1){sign_cos}};	 // convert modul from rom                               
assign mod_rom_cos = {{sign_cos}, {xor_rom_cos}};	         // calculate number

// Represent of two's complement code
always @(posedge clk, negedge reset_b) begin : conv_two_compl_code_cos
   if (~reset_b)
      real_out <= {(WIDTH_NCO){1'b0}};
   else begin
      if (sign_cos==0)
		 real_out <= mod_rom_cos;
	  else
		 real_out <= mod_rom_cos + ({ {(WIDTH_NCO-1){1'b0}},  {(1){1'b1}} });
   end
end
// ======================================================================================


reg [WIDTH_NCO-1:0] amplitude_reg1;
reg [WIDTH_NCO-1:0] amplitude_reg2;
reg [WIDTH_NCO-1:0] amplitude_reg3;
reg [WIDTH_NCO-1:0] amplitude_reg4;
reg [WIDTH_NCO-1:0] amplitude_reg5;
reg [WIDTH_NCO-1:0] amplitude_reg6;

reg [3:0] ena_delay;
reg ena_output_reg;
always @(posedge clk, negedge reset_b) begin : delay_enable_output
	if (~reset_b) begin
		amplitude_reg1 <= {(WIDTH_NCO){1'b0}};
		amplitude_reg2 <= {(WIDTH_NCO){1'b0}};
		amplitude_reg3 <= {(WIDTH_NCO){1'b0}};
		amplitude_reg4 <= {(WIDTH_NCO){1'b0}};
		amplitude_reg5 <= {(WIDTH_NCO){1'b0}};
		amplitude_reg6 <= {(WIDTH_NCO){1'b0}};
	end else begin
		amplitude_reg1 <= amplitude;
		amplitude_reg2 <= amplitude_reg1;
		amplitude_reg3 <= amplitude_reg2;
		amplitude_reg4 <= amplitude_reg3;
		amplitude_reg5 <= amplitude_reg4;
		amplitude_reg6 <= amplitude_reg5;
   end
end




//////////////// Multiplier by amplitude ///////////////////
    reg signed [WIDTH_NCO*2-1:0] real_sig_all;
    reg signed [WIDTH_NCO*2-1:0] imag_sig_all;
	always @(posedge clk, negedge reset_b)
		if (!reset_b) begin
			real_sig_all <= {(WIDTH_NCO*2){1'b0}};
			imag_sig_all <= {(WIDTH_NCO*2){1'b0}};
		end else begin
			real_sig_all <= $signed(real_out)*$signed(amplitude_reg6);
			imag_sig_all <= $signed(imag_out)*$signed(amplitude_reg6);
		end
	assign real_sig	= real_sig_all[WIDTH_NCO*2-2:WIDTH_NCO-1];
	assign imag_sig	= imag_sig_all[WIDTH_NCO*2-2:WIDTH_NCO-1];
		
/////////////////////////////////////////////////////////////

assign tst = {
    clk, 
	reset_b, 
	start_strobe,
	1'd0,
	real_sig[15:0],
	imag_sig[15:0],
	cnt_phase_sin[31:0]
};

endmodule




/*	////////////////////// PATTERN GENERATOR ///////////////////////////////////////////////////////
	localparam LENGTH_PATTERN = 1000;
	localparam WIDTH_ADDR_PATTERN = 10;
	
	///////////// Modulation functions tables 
	reg [WIDTH_PHASE-1:0] rom_frequency [0:LENGTH_PATTERN-1]; 
	initial begin 
	$readmemb(FREQ_INIT_FILE, rom_frequency);  
	end

	reg [WIDTH_PHASE-1:0] rom_phase [0:LENGTH_PATTERN-1]; 
	initial begin 
	$readmemb(PHASE_INIT_FILE, rom_phase);  
	end

	reg [WIDTH_NCO-1:0] rom_amplitude [0:LENGTH_PATTERN-1]; 
	initial begin 
	$readmemb(AMPL_INIT_FILE, rom_amplitude);  
	end


	/////////////// signal counter 
	reg [31:0] cnt_sig;
	reg ena_sig;
	wire [31:0] per_sig = PERIOD_SIGNAL;
	wire end_period_signal = (cnt_sig==per_sig-1)&(~&per_sig);

	always @(posedge clk, negedge reset_b) begin : counter_sig
		if (!reset_b) begin
			cnt_sig <= 32'd0;
			ena_sig <= 1'b0;
		end else begin
			if ( start_strobe || end_period_signal ) begin
				cnt_sig <= 32'd0;
				ena_sig <= 1'b1;
			end else begin
				cnt_sig <= cnt_sig + 32'd1; 
				if (cnt_sig==LENGTH_SIGNAL-1)
					ena_sig <= 1'b0;
				else
					ena_sig <= ena_sig;
			end
		end
	end

	/////////////// Read tables
	wire [WIDTH_ADDR_PATTERN-1:0] addr_pattern = cnt_sig[WIDTH_ADDR_PATTERN-1:0];
    reg [WIDTH_PHASE-1:0] frequency;
	reg [WIDTH_PHASE-1:0] phase;
	reg [WIDTH_NCO-1:0]   amplitude;

	always @(posedge clk, negedge reset_b) begin : read_modulation_tables
		if (!reset_b) begin
			frequency <= {(WIDTH_PHASE){1'b0}};
			phase     <= {(WIDTH_PHASE){1'b0}};
			amplitude <= {(WIDTH_NCO){1'b0}};
		end else begin
			if (ena_sig) begin
				frequency <= rom_frequency [addr_pattern];
				phase     <= rom_phase     [addr_pattern];
				amplitude <= rom_amplitude [addr_pattern];
			end else begin
				frequency <= {(WIDTH_PHASE){1'b0}};
				phase     <= {(WIDTH_PHASE){1'b0}};
				amplitude <= {(WIDTH_NCO){1'b0}};
			end
		end
	end
	
	/////////////// start delay 
	reg start_reg1;
	reg start_reg2;
	always @(posedge clk, negedge reset_b) begin : delay_start
		if (!reset_b) begin
			start_reg1 <= 1'b0;
	        start_reg2 <= 1'b0;
		end else begin
			start_reg1 <= start_strobe;
	        start_reg2 <= start_reg1;
		end
	end
//////////////////////////////////////////////////////////////////////////////////////////////////////// */
	
	
	
	
	
















