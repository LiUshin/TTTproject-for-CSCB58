module drawMachine(
    input clk,
    input pulse,
    input resetn,
    input [17:0] ledr,
    input [6:0] ledg,
    input [3:0] winner,
    input tie,
    input [1:0] whose_turn,
    output reg [7:0] startx,
    output reg [6:0] starty,
    output reg [2:0] color,
    output reg [2:0] selector
    );

    reg [3:0]  next_state; 
	reg [3:0]  current_state;
 
    localparam  DrawA1    = 4'b0000,
                DrawB1  = 4'b0001,
                DrawC1    = 4'b0010,
                DrawA2    = 4'b0011,
                DrawB2    = 4'b0100,
                DrawC2    = 4'b0101,
                DrawA3    = 4'b0110,
                DrawB3    = 4'b0111,
                DrawC3    = 4'b1000,
                DrawWinner    = 4'b1001,
                DrawWhoseTurn    = 4'b1010,
                DrawTie    = 4'b1011,
                DrawTie2  = 4'b1110;


    // Next state logic aka our state table
    always@(posedge pulse)
    begin: state_table 
            case (current_state)
                DrawA1: begin 
                   next_state <= DrawB1;
                end
                DrawB1: begin 
                   next_state <= DrawC1;
                end
                DrawC1: begin 
                   next_state <= DrawA2;
                end 
                DrawA2: begin 
                   next_state <= DrawB2;
                end 
                DrawB2: begin 
                   next_state <= DrawC2;
                end 
                DrawC2: begin 
                   next_state <= DrawA3;
                end 
                DrawA3: begin 
                   next_state <= DrawB3;
                end 
                DrawB3: begin 
                   next_state <= DrawC3;
                end 
                DrawC3: begin 
                   next_state <= DrawWinner;
                end 
                DrawWinner: begin 
                   next_state <= DrawWhoseTurn;
                end 
                DrawWhoseTurn: begin 
                   next_state <= DrawTie;
                end 
                DrawTie: begin 
                   next_state <= DrawTie2;
                end
                DrawTie2: begin 
                   next_state <= DrawA1;
                end                  

                default:     next_state = DrawA1;
        endcase
    end // state_table
   

    always @(posedge clk)
    begin: state_FFs
        if(resetn)
            current_state <=  DrawA1; // Should set reset state to state A
        else
            current_state <= next_state;
    end // state_FFS


    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        startx =0;
        starty =0;
        color=0;
        selector = 3'b000;
        case (current_state)
                DrawA1: begin 
                    startx=8'b0000_0100;
                    starty=7'b000_0100;
                    selector = 3'b000;
                    if (ledr[17:16]==2'b01)
                        color <= 3'b010;
                    else if (ledr[17:16]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end
                DrawB1: begin 
                    startx=8'b0010_1100;
                    starty=7'b000_0100;
                    selector = 3'b000;
                    if (ledr[15:14]==2'b01)
                        color <= 3'b010;
                    else if (ledr[15:14]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end
                DrawC1: begin 
                   startx=8'b0101_0100;
                    starty=7'b000_0100;
                    selector = 3'b000;
                    if (ledr[13:12]==2'b01)
                        color <= 3'b010;
                    else if (ledr[13:12]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end 
                DrawA2: begin 
                   startx=8'b0000_0100;
                    starty=7'b010_1100;
                    selector = 3'b000;
                    if (ledr[11:10]==2'b01)
                        color <= 3'b010;
                    else if (ledr[11:10]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end 
                DrawB2: begin 
                   startx=8'b0010_1100;
                    starty=7'b010_1100;
                    selector = 3'b000;
                    if (ledr[9:8]==2'b01)
                        color <= 3'b010;
                    else if (ledr[9:8]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end 
                DrawC2: begin 
                   startx=8'b0101_0100;
                    starty=7'b010_1100;
                    selector = 3'b000;
                    if (ledr[7:6]==2'b01)
                        color <= 3'b010;
                    else if (ledr[7:6]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end 
                DrawA3: begin 
                   startx=8'b0000_0100;
                    starty=7'b101_0100;
                    selector = 3'b000;
                    if (ledr[5:4]==2'b01)
                        color <= 3'b010;
                    else if (ledr[5:4]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end 
                DrawB3: begin 
                   startx=8'b0010_1100;
                    starty=7'b101_0100;
                    selector = 3'b000;
                    if (ledr[3:2]==2'b01)
                        color <= 3'b010;
                    else if (ledr[3:2]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end 
                DrawC3: begin 
                   startx=8'b0101_0100;
                    starty=7'b101_0100;
                    selector = 3'b000;
                    if (ledr[1:0]==2'b01)
                        color <= 3'b010;
                    else if (ledr[1:0]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end 
                DrawWinner: begin 
                   startx=8'b1001_0001;
                    starty=7'b100_0110;//70
                    selector=3'b001;
                    if (winner[3:0]==4'b1011)
                        color <= 3'b010;
                    else if (winner[3:0]==4'b1010)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end 
                DrawWhoseTurn: begin 
                   startx=8'b1001_0001;//145
                    starty=7'b110_0100;//100
                    selector = 3'b001;
                    if (whose_turn[1:0]==2'b01)
                        color <= 3'b010;
                    else if (whose_turn[1:0]==2'b11)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end 
                DrawTie: begin 
                   startx=8'b1001_0001;
                    starty=7'b101_1010;//90
                    selector = 3'b011;
                    if (tie==1'b1)
                        color <= 3'b010;
                    else 
                        color <= 3'b111;
                end
                DrawTie2: begin 
                   startx=8'b1001_0001;
                    starty=7'b101_0000;//80
                    selector = 3'b100;
                    if (tie==1'b1)
                        color <= 3'b001;
                    else 
                        color <= 3'b111;
                end              

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   

endmodule





module counterLiupi(
    input clk,
    output reg [16:0] count=0,
    output reg signal
);
  always @(posedge clk) // triggered every time clock rises
  begin
    signal = 0;
    if (count == 6'd10000) 
      begin
        count <= 0; 
        signal <= 1'b1;
      end
    else
      count <= count + 1'b1;
   end
endmodule