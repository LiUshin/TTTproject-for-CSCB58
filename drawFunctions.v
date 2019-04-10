// Part 2 skeleton

module project_v0
	(
		clck,						//	On Board 50 MHz
		// Your inputs and outputs here
        startx,
        starty,
        color,
        plot,
        resetn,
		selector,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input	clck;				//	50 MHz
    input plot;
	 input resetn;
	input   [7:0] startx;
    input   [6:0] starty;
	input   [2:0] color;
	input  [2:0] selector;


	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
		
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
   //wire pl;
	wire [7:0] x;
	wire [6:0] y;
	//wire [2:0] color;
// square4x4 draw(
  // .clk(CLOCK50),
   //.x_coords(SW[7:0]),
	//.y_coords(SW[6:0]),
   //.input_colour(SW[9:7]),
   //.finalX(x),
   //.finalY(y),
   //.output_colour(color),
	//.plot(pl)
  //);


  muxDrawer myDrawer(
        .selector(selector),
        .startx(startx),
        .starty(starty),
        .clock(clck),
        .enable(plot),
        .FinalX(x),
        .FinalY(y)
  )


//   positions myc(
//      .enable(plot),
//        .clk(clck),
//        .count(count),
//        .inY(starty),
//        .inX(startx),
//        .outX(x),
//        .outY(y)
//	);    
//	bcounter cot(
//
//		.ck(clck),
//		.bv(count)
//	);

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(clck),
			.colour(color),
			.x(x),
			.y(y),
			.plot(plot),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "finalbackgroundnew.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	// datapath d0(...);

    // Instansiate FSM control
    // control c0(...);

    
endmodule
module bcounter(ck,bv);
  input ck;
  output reg [5:0] bv=6'b0;
  always@(posedge ck)
  begin: clock
    if(bv==6'b111111)
      bv <= 0;
    else
      bv <= bv+1'b1;
  end
endmodule

module bcounter10b(ck, bv);
  input ck;
  output reg [9:0] bv=9'b0;
  always@(posedge ck)
  begin: clock
    if(bv==10'b1111111111)
      bv <= 0;
    else
      bv <= bv+1'b1;
  end
endmodule



module positions(
    input clk,
    input enable,// Part 2 skeleton
	input [6:0] inY,
    input [7:0] inX,
    input [5:0]  count,
    output reg  [7:0] outX,
	output reg  [6:0] outY
    );
	always@(count)
    begin: state_table 
      if (enable)
	  begin	   
	    outX <= inX + count[2:0];
		outY <= inY + count[5:3];
	  end
    end 
endmodule


module positionsFrame32(
    input clk,
    input enable,// Part 2 skeleton
	input [6:0] inY,
    input [7:0] inX,
    input [9:0] count,
    output reg  [7:0] outX,
	output reg  [6:0] outY
    
    );
	always@(count)
    begin: state_table 
      if (enable)
	  begin
        if(count[9:5]==5'b00000 || count[9:5]==5'b11111)
        begin 
	      outX <= inX + count[4:0];
		  outY <= inY + count[9:5];
        end
        else if(count[4:0]==5'b00000||count[4:0]==5'b11111)
        begin
          outX <= inX + count[4:0];
		  outY <= inY + count[9:5];
        end         
	  end
    end 
endmodule

module positionsCross(
    input clk,
    input enable,// Part 2 skeleton
	input [6:0] inY,
    input [7:0] inX,
	 input [7:0] inX2,
    input [9:0] count,
    output reg  [7:0] outX,
	output reg  [6:0] outY   
    );
	 


module muxDrawer(
  input [2:0] selector,
  input [7:0] startx,
  input [6:0] starty,
  input clock;
  input enable;
  output reg [7:0] FinalX,
  output reg [7:0] FinalY
);


    wire [7:0] chessX;
    wire [6:0] chessY;
	wire [5:0] chessCount;
    wire [7:0] winnerX;
    wire [6:0] winnerY;
	wire [5:0] winnerCount;



   positionsFrame32 myc(
        .enable(enable),
        .clk(clock),
        .count(chessCount),
        .inY(starty),
        .inX(startx),
        .outX(chessX),
        .outY(chessY)
	); 

	bcounter10b cot(

		.ck(clock),
		.bv(chessCount)
	);
   positions myc(
        .enable(enable),
        .clk(clock),
        .count(winnerCount),
        .inY(starty),
        .inX(startx),
        .outX(winnerX),
        .outY(winnerY)
	); 

	bcounter cot(

		.ck(clock),
		.bv(winnerCount)
	);




    always(*)
        begin
        case(selector[2:0])
        3'b000: begin
		           FinalX = chessX;
				   FinalY = chessY;
			    end
		3'b001: begin
		           FinalX = winnerX;
				   FinalY = winnerY;
			    end
		default:begin
		           FinalX = winnerX;
				   FinalY = winnerY;
			    end



        end

endmodule



