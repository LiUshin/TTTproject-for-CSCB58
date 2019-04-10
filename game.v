//Sw[7:0] data_in

//KEY[0] synchronous reset when pressed
//KEY[1] go signal

//LEDR displays result
//HEX0 & HEX1 also displays result

module top(SW, KEY, CLOCK_50, LEDR, HEX0, HEX1, LEDG,VGA_CLK,VGA_HS, VGA_VS,
		VGA_BLANK_N,
		VGA_SYNC_N,
		VGA_R,
		VGA_G,
		VGA_B );
    input [9:0] SW;
    input [3:0] KEY;
    input CLOCK_50;
    output [17:0] LEDR;
    output [6:0] HEX0;
	 output [6:0] HEX1;
	 output [6:0] LEDG;
	 
	 
	 
	 
	 
	 
	 	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   

    wire resetn;
    wire go;
    wire [3:0] winner;
	 wire [3:0] state;
	 wire player_A, player_B, tie, win, occupied;



    //wire [7:0] data_result;
    assign go = ~KEY[0];
    assign resetn = SW[9];

/////////
   wire [1:0] whose_turn;
   wire [6:0] starty;
	wire [7:0] startx;
   wire [2:0] color;
   wire plot;
   wire [2:0] selector;
	
	//// fsmdraw
	wire clear;
	wire signal;
	
	
	
project_v0 draw(
      .clck(CLOCK_50),
      .startx(startx),
      .starty(starty),
      .color(color),
      .selector(selector),
      .plot(1'b1),
      .resetn(KEY[3]),
      .VGA_CLK(VGA_CLK),   						
		  .VGA_HS(VGA_HS),						
		  .VGA_VS(VGA_VS),
		  .VGA_BLANK_N(VGA_BLANK_N),		
		  .VGA_SYNC_N(VGA_SYNC_N),	
	    .VGA_R(VGA_R),   			
		  .VGA_G(VGA_G),	 		
		  .VGA_B(VGA_B)  

    );
	 
	 
	 
	 
	 
	 
	drawMachine DM(
    .clk(CLOCK_50),
    .pulse(signal),
    .resetn(resetn),
    .ledr(LEDR[17:0]),
    .winner(winner),
    .tie(LEDG[2]),
    .whose_turn(whose_turn),
    .startx(startx),
    .starty(starty),
    .color(color),
    .selector(selector)
    );
	 
counterLiupi yupi(
    .clk(CLOCK_50),
    .signal(signal)
);
//muxPoint newM(
//      .position(SW[3:0]),
//      .leftX(startx),
//      .leftY(starty)
//    );

//    curcolor coloredit(
//      .who(whose_turn),
//      .color(color) 
//    );

//    shortpulse mypulse(
//      .clk(CLOCK_50),
//      .ledr(17'b0),
//      .occupied(LEDG[4]),
//      .plot(LEDG[5]),
//		.enable(LEDG[6])
//    );



//plotcontrol drawcontrl(
//    .clk(CLOCK_50),
//    .resetn(resetn),
//    .go(go),
//    .occupied(occupied),
//    .signal(signal),
//    .plot(LEDG[5]),
//    .Clear_b(clear)
//    );
//counterLiu cont(
//    .clk(CLOCK_50),
//    .clear(clear),
//    .signal(signal)
//);











/////
    

    game mygame(
        .clk(CLOCK_50),
        .resetn(resetn),
        .go(go),
        .data_in(SW[3:0]),
        .A1(LEDR[17:16]),
        .B1(LEDR[15:14]),
        .C1(LEDR[13:12]),
        .A2(LEDR[11:10]),
        .B2(LEDR[9:8]),
        .C2(LEDR[7:6]),
        .A3(LEDR[5:4]),
        .B3(LEDR[3:2]),
        .C3(LEDR[1:0] ),
        .winner(winner),
		  .player_A(LEDG[0]),
		  .player_B(LEDG[1]),
		  .tie(LEDG[2]),
		  .win(LEDG[3]),
		  .occupied(LEDG[4]),
		  .state(state),
		  .whose_turn(whose_turn)

    );



    


    hex_decoder H0(
        .hex_digit(winner), 
        .segments(HEX0)
        );
		  
   hex_decoder H1(
        .hex_digit(state), 
        .segments(HEX1)
        );
        

endmodule

module game(
    input clk,
    input resetn,
    input go,
    input [3:0] data_in,
    output wire [1:0] A1, A2, A3, B1, B2, B3, C1, C2, C3,
    output wire [3:0] winner,
	 output wire player_A, player_B,
	 output wire [3:0] state,
	 output wire tie, win, occupied,
	 output wire [1:0] whose_turn
    );





    control C0(
        .clk(clk),
        .resetn(resetn),
        .go(go),
        .occupied(occupied),
        .tie(tie),
        .win(win),
        .player_A(player_A),
        .player_B(player_B),
		  .current_state(state),
		  .whose_turn(whose_turn)
    );

    isoccupied helper1(
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .C1(C1),
        .C2(C2),
        .C3(C3),
        .position(data_in),
        .occupied(occupied)
    );

    
    istie helper2(
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .C1(C1),
        .C2(C2),
        .C3(C3),
        .tie(tie)
    );

    iswin helper3(
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .C1(C1),
        .C2(C2),
        .C3(C3),
        .win(win),
        .player(winner)

    );
  

    position_registers D0(
        .clock(clk),
        .reset(resetn),
        .occupied(occupied),
        .player_A(player_A),
        .player_B(player_B),
        .positionCol(data_in[1:0]),
        .positionRow(data_in[3:2]),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .C1(C1),
        .C2(C2),
        .C3(C3)
    );
                
endmodule        
                

module control(
    input clk,
    input resetn,
    input go,
    input occupied,
    input tie,
    input win,

    output reg  player_A, player_B,
	 output reg  [3:0] current_state,
	 output reg [1:0] whose_turn

    );

    reg [3:0]  next_state; 
    
    localparam  WAIT_A     = 4'b0000,
                PLAYER_A   = 4'b0001,
                WAIT_B     = 4'b0010,
                PLAYER_B   = 4'b0011,
                END        = 4'b0100;

    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                WAIT_A: begin 
                            if (tie == 1'b1 || win == 1'b1)
                            next_state <= END;
									 else if (go == 1'b1)
                            next_state <= PLAYER_A; // go to next state when input go signal
                            else
                            next_state <= WAIT_A;                
                        end
                PLAYER_A: begin
                            if (occupied == 1'b0)
                                next_state <=  WAIT_B;
                            else
                                next_state <=  WAIT_A;
                        end
                WAIT_B: begin 
                            if (tie == 1'b1 || win == 1'b1)
                            next_state <= END;
                            else if (go == 1'b1)
                            next_state <= PLAYER_B; // go to next state when input go signal
                            else
                            next_state <= WAIT_B;                
                        end
                PLAYER_B: begin
                            if (occupied == 1'b0)
                                next_state <=  WAIT_A;
                            else
                                next_state <=  WAIT_B;
                        end
                END: next_state <= END; // Loop in current state until reset
                default:     next_state = WAIT_A;
        endcase
    end // state_table
   

    always @(posedge clk)
    begin: state_FFs
        if(resetn)
            current_state <=  WAIT_A; // Should set reset state to state A
        else
            current_state <= next_state;
    end // state_FFS


    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        player_A = 1'b0;
        player_B = 1'b0;
		  whose_turn = 2'b00;

        case (current_state)
		      WAIT_A: begin
                whose_turn = 2'b01;
                end
            WAIT_B:begin
                whose_turn = 2'b11;
                end
            PLAYER_A: begin
				    whose_turn = 2'b01;
                player_A = 1'b1;
                end
            PLAYER_B: begin
				    whose_turn = 2'b11;
                player_B = 1'b1;
                end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   

endmodule


module istie(
    input [1:0] A1, A2, A3, B1, B2, B3, C1, C2, C3,
    output reg tie
    );
  always@(*)
  begin
   if ((A1 == 2'b11 || A1 == 2'b01)
     &&(A2 == 2'b11 || A2 == 2'b01)
     &&(A3 == 2'b11 || A3 == 2'b01)
     &&(B1 == 2'b11 || B1 == 2'b01)
     &&(B2 == 2'b11 || B2 == 2'b01)
     &&(B3 == 2'b11 || B3 == 2'b01)
     &&(C1 == 2'b11 || C1 == 2'b01)
     &&(C2 == 2'b11 || C2 == 2'b01)
     &&(C3 == 2'b11 || C3 == 2'b01))
    tie <= 1'b1;
    else
    tie <= 1'b0;
    end

endmodule

module iswin(
    input [1:0] A1, A2, A3, B1, B2, B3, C1, C2, C3,
    output reg win,
    output reg [3:0] player
    );
  always@(*)
  begin
   if ((A1 == 2'b11 && A2 == 2'b11 && A3 == 2'b11)
     ||(B1 == 2'b11 && B2 == 2'b11 && B3 == 2'b11)
     ||(C1 == 2'b11 && C2 == 2'b11 && C3 == 2'b11)
     ||(A1 == 2'b11 && B1 == 2'b11 && C1 == 2'b11)
     ||(A2 == 2'b11 && B2 == 2'b11 && C2 == 2'b11)
     ||(A3 == 2'b11 && B3 == 2'b11 && C3 == 2'b11)
     ||(A1 == 2'b11 && B2 == 2'b11 && C3 == 2'b11)
     ||(A3 == 2'b11 && B2 == 2'b11 && C1 == 2'b11)) begin
    win <= 1'b1;
    player <= 4'b1011;
    end



    else if ((A1 == 2'b01 && A2 == 2'b01 && A3 == 2'b01)
     ||(B1 == 2'b01 && B2 == 2'b01 && B3 == 2'b01)
     ||(C1 == 2'b01 && C2 == 2'b01 && C3 == 2'b01)
     ||(A1 == 2'b01 && B1 == 2'b01 && C1 == 2'b01)
     ||(A2 == 2'b01 && B2 == 2'b01 && C2 == 2'b01)
     ||(A3 == 2'b01 && B3 == 2'b01 && C3 == 2'b01)
     ||(A1 == 2'b01 && B2 == 2'b01 && C3 == 2'b01)
     ||(A3 == 2'b01 && B2 == 2'b01 && C1 == 2'b01)) begin
    win <= 1'b1;
    player <= 4'b1010;
    end
    else begin
    win <= 1'b0;
    player <= 4'b0000;
    end
  end
endmodule

module isoccupied(input [1:0] A1, A2, A3, B1, B2, B3, C1, C2, C3, input [3:0] position, output reg occupied);
  always@(*)
  begin
    if ((position == 4'b0000 && A1 != 2'b0)
    || (position == 4'b0001 && B1 != 2'b0)
    || (position == 4'b0010 && C1 != 2'b0)
    || (position == 4'b0100 && A2 != 2'b0)
    || (position == 4'b0101 && B2 != 2'b0)
    || (position == 4'b0110 && C2 != 2'b0)
    || (position == 4'b1000 && A3 != 2'b0)
    || (position == 4'b1001 && B3 != 2'b0)
    || (position == 4'b1010 && C3 != 2'b0))
    occupied <= 1'b1;
    else
    occupied <= 1'b0;
  end

endmodule


module position_registers(
      input clock, // clock of the game 
      input reset, // reset the game 
      input occupied, // disable writing when an illegal move is detected
      input player_A,
      input player_B,
      input [1:0] positionCol,
      input [1:0] positionRow,
      output reg[1:0] A1,A2,A3,B1,B2,B3,C1,C2,C3// positions stored
      );
 // Position 1 
 always @(posedge clock or posedge reset)
 begin
  if(reset) 
   A1 <= 2'b00;
  else begin
   if(occupied==1'b1)
    A1 <= A1;// keep previous position
   else if(positionCol==2'b00 && positionRow==2'b0)
   begin
     if(player_A==1'b1)
       A1 <= 2'b01; // store computer data 
     else if (player_B==1'b1)
       A1 <= 2'b11;// store player data 
     else 
       A1 <= A1;// keep previous position
   end
   else
     A1 <= A1;
  end 
 end 

 // Position 2 
 always @(posedge clock or posedge reset)
 begin
  if(reset) 
   A2 <= 2'b00;
  else begin
   if(occupied==1'b1)
    A2 <= A2;// keep previous position
   else if(positionCol==2'b00 && positionRow==2'b01)
   begin
     if(player_A==1'b1)
       A2 <= 2'b01; // store computer data 
     else if (player_B==1'b1)
       A2 <= 2'b11;// store player data 
     else 
       A2 <= A2;// keep previous position
   end
   else
     A2 <= A2;
  end 
 end 
// Position 3 
 always @(posedge clock or posedge reset)
 begin
  if(reset) 
   A3 <= 2'b00;
  else begin
   if(occupied==1'b1)
    A3 <= A3;// keep previous position
   else if(positionCol==2'b00 && positionRow==2'b10)
   begin
     if(player_A==1'b1)
       A3 <= 2'b01; // store computer data 
     else if (player_B==1'b1)
       A3 <= 2'b11;// store player data 
     else 
       A3 <= A3;// keep previous position
   end
   else
     A3 <= A3;
  end 
 end 
 // Position 4 
 always @(posedge clock or posedge reset)
 begin
  if(reset) 
   B1 <= 2'b00;
  else begin
   if(occupied==1'b1)
    B1 <= B1;// keep previous position
   else if(positionCol==2'b01 && positionRow==2'b00)
   begin
     if(player_A==1'b1)
       B1 <= 2'b01; // store computer data 
     else if (player_B==1'b1)
       B1 <= 2'b11;// store player data 
     else 
       B1 <= B1;// keep previous position
   end
   else
     B1 <= B1;
  end 
 end 
 // Position 5 
  always @(posedge clock or posedge reset)
 begin
  if(reset) 
   B2 <= 2'b00;
  else begin
   if(occupied==1'b1)
    B2 <= B2;// keep previous position
   else if(positionCol==2'b01 && positionRow==2'b01)
   begin
     if(player_A==1'b1)
       B2 <= 2'b01; // store computer data 
     else if (player_B==1'b1)
       B2 <= 2'b11;// store player data 
     else 
       B2 <= B2;// keep previous position
   end
   else
     B2 <= B2;
  end 
 end 
 // Position 6 
 always @(posedge clock or posedge reset)
 begin
  if(reset) 
   B3 <= 2'b00;
  else begin
   if(occupied==1'b1)
    B3 <= B3;// keep previous position
   else if(positionCol==2'b01 && positionRow==2'b10)
   begin
     if(player_A==1'b1)
       B3 <= 2'b01; // store computer data 
     else if (player_B==1'b1)
       B3 <= 2'b11;// store player data 
     else 
       B3 <= B3;// keep previous position
   end
   else
     B3 <= B3;
  end 
 end 
 // Position 7 
  always @(posedge clock or posedge reset)
 begin
  if(reset) 
   C1 <= 2'b00;
  else begin
   if(occupied==1'b1)
    C1 <= C1;// keep previous position
   else if(positionCol==2'b10 && positionRow==2'b00)
   begin
     if(player_A==1'b1)
       C1 <= 2'b01; // store computer data 
     else if (player_B==1'b1)
       C1 <= 2'b11;// store player data 
     else 
       C1 <= C1;// keep previous position
   end
   else
     C1 <= C1;
  end 
 end 
 // Position 8 
   always @(posedge clock or posedge reset)
 begin
  if(reset) 
   C2 <= 2'b00;
  else begin
   if(occupied==1'b1)
    C2 <= C2;// keep previous position
   else if(positionCol==2'b10 && positionRow==2'b01)
   begin
     if(player_A==1'b1)
       C2 <= 2'b01; // store computer data 
     else if (player_B==1'b1)
       C2 <= 2'b11;// store player data 
     else 
       C2 <= C2;// keep previous position
   end
   else
     C2 <= C2;
  end 
 end 
 // Position 9 
    always @(posedge clock or posedge reset)
 begin
  if(reset) 
   C3 <= 2'b00;
  else begin
   if(occupied==1'b1)
    C3 <= C3;// keep previous position
   else if(positionCol==2'b10 && positionRow==2'b10)
   begin
     if(player_A==1'b1)
       C3 <= 2'b01; // store computer data 
     else if (player_B==1'b1)
       C3 <= 2'b11;// store player data 
     else 
       C3 <= C3;// keep previous position
   end
   else
     C3 <= C3;
  end 
 end 
endmodule 


module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule




/////
//integer ms_count = 0;
//reg sec_pulse;
//always @(posedge clk)
  //begin
    //sec_pulse <= 0;
    //if (ms_pulse)
      //if (ms_count == 999)
        //begin
          //ms_count <= 0;
          //sec_pulse <= 1;
        //end
      //else
        //ms_count <= ms_count+1;
 // end

///////////

module counterLiu2(
    input clk,
    input enable,
    output reg [16:0] count
);
always @(posedge clk) // triggered every time clock rises
begin
if (enable == 1'b0) 
  count <= 0;
else if (count == 6'd100000) 
  count <= 0; 
else if (enable == 1'b1) 
  count <= count + 1'b1;
end
endmodule
 



module shortpulse
(
  input clk,
  input [17:0] ledr,
  input occupied,
  output reg plot=1'b0,
  output reg enable=1'b0
);


 wire [16:0] count=17'b0;


counterLiu2 mycount(
  .clk(clk),
  .enable(enable),
  .count(count)
);

  always @(ledr)
  begin

      enable <= 1'b1;

  end
  //always @(count)
  //begin
  //  if (count==6'd100000)
  //  begin
  //     plot <= 0;
  //     enable <=0;
  //  end
  //  else
  //    plot <= 1; 
  //end
  always @(clk)
  begin
    if (count==6'd100000)
    begin
       plot <= 0;
       enable <=0;
    end
    else if(enable == 1)
      plot <= 1; 
  end
endmodule

module curcolor(
  input [1:0] who,
  output [2:0] color
);
  assign color[2:0]=(who==2'b01) ? 3'b100 : 3'b001;

endmodule




module muxPoint(  
  input [3:0] position, 
  output reg [6:0] frameX, frameY, leftX, leftY, rightX, rightY);

    always @(*) 
    begin
    frameX = 7'b000_0000;
    frameY = 7'b000_0000;
    leftX = 7'b000_0000;
    leftY = 7'b000_0000;
    rightX = 7'b000_0000;
    rightY = 7'b000_0000;


        case (position[3:0]) 
            4'b0000: begin //A1
                     frameX = 7'b000_0000; //0
                     frameY = 7'b000_0000; //0
                     leftX = 7'b000_0100; //4
                     leftY = 7'b000_0100; //4
                     rightX = 7'b010_0100; //36
                     rightY = 7'b000_0100; //4
            end
            4'b0100: begin //A2
                     frameX = 7'b000_0000; //0
                     frameY = 7'b010_1000; //40
                     leftX = 7'b000_0100; //4
                     leftY = 7'b010_1100; //44
                     rightX = 7'b010_0100; //36
                     rightY = 7'b010_1100; //44
            end
            4'b1000: begin //A3
                     frameX = 7'b000_0000; //0
                     frameY = 7'b101_0000; //80
                     leftX = 7'b000_0100; //4
                     leftY = 7'b101_0100; //84
                     rightX = 7'b010_0100; //36
                     rightY = 7'b101_0100; //84
            end
            4'b0001: begin //B1
                     frameX = 7'b010_1000; //40
                     frameY = 7'b000_0000; //0
                     leftX = 7'b010_1100; //44
                     leftY = 7'b000_0100; //4
                     rightX = 7'b100_1100; //76
                     rightY = 7'b000_0100; //4
            end
            4'b0101: begin //B2
                     frameX = 7'b010_1000; //40
                     frameY = 7'b010_1000; //40
                     leftX = 7'b010_1100; //44
                     leftY = 7'b010_1100; //44
                     rightX = 7'b100_1100; //76
                     rightY = 7'b010_1100; //44
            end
            4'b1001:  begin //B3
                     frameX = 7'b010_1000; //40
                     frameY = 7'b101_0000; //80
                     leftX = 7'b010_1100; //44
                     leftY = 7'b101_0100; //84
                     rightX = 7'b100_1100; //76
                     rightY = 7'b101_0100; //84
            end
            4'b0010: begin //C1
                     frameX = 7'b101_0000; //80
                     frameY = 7'b000_0000; //0
                     leftX = 7'b101_0100; //84
                     leftY = 7'b000_0100; //4
                     rightX = 7'b111_0100; //116
                     rightY = 7'b000_0100; //4
            end

            4'b0110: begin //C2
                     frameX = 7'b101_0000; //80
                     frameY = 7'b010_1000; //40
                     leftX = 7'b101_0100; //84
                     leftY = 7'b010_1100; //44
                     rightX = 7'b111_0100; //116
                     rightY = 7'b010_1100; //44
            end

            4'b1010:  begin //C3
                     frameX = 7'b101_0000; //80
                     frameY = 7'b101_0000; //80
                     leftX = 7'b101_0100; //84
                     leftY = 7'b101_0100; //84
                     rightX = 7'b111_0100; //116
                     rightY = 7'b101_0100; //84
            end
        endcase
    end

endmodule 

