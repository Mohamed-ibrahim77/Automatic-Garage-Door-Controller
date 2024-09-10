module Automatic_Garage_Door_Controller_Moore (

	input  wire UP_Max, 
	input  wire DN_Max,
	input  wire Activate,
	input  wire CLK, RST,	

	output wire UP_M,
	output wire DN_M	
	);

	localparam  [2:0]    IDLE = 2'b00,
                     	 MV_UP_STATE = 2'b01,
                     	 MV_DN_STATE = 2'b10;

	reg    [2:0]     current_state,
                     next_state ; 	

    // state transition 		
	always @(posedge CLK or negedge RST) begin
  		if(!RST) begin
     		current_state <= IDLE ;
   		end
  		else begin
     		current_state <= next_state ;
   		end
 	end	

 	// next_state logic
	always @(*) begin
	  case(current_state)
		  IDLE           : begin
				              if(!Activate)
							   	next_state = IDLE ;
				              else if (UP_Max && !DN_Max) begin
				               	next_state = MV_DN_STATE ;
				              end
				              else if (!UP_Max && DN_Max) begin
				               	next_state = MV_UP_STATE ;
				              end
				              else begin
				              	next_state = IDLE ;
				              end			  
				           end

		  MV_DN_STATE    : begin
				              if(DN_Max)
							   	next_state = IDLE ;
							  else begin
							  	next_state = MV_DN_STATE ;
							  end
				              		   
		            	   end

		  MV_UP_STATE   : begin
				              if(UP_Max)
							   	next_state = IDLE ;
							  else 
				               	next_state = MV_UP_STATE ;
		            	 end
		
		  default :   	next_state = IDLE ;		 
		  
	  endcase
	end	

	// output logic
	always @(*) begin
	  	case(current_state)
			  IDLE     : begin
			              	UP_M = 1'b0;
			              	DN_M = 1'b0;	  
			             end
		
			  MV_DN_STATE : begin
				              	UP_M = 1'b0;
				              	DN_M = 1'b1;
				            end	
		
			  MV_UP_STATE : begin
			              		UP_M = 1'b1;
				              	DN_M = 1'b0;	   
			                end
		
			  default  : begin
			              	UP_M = 1'b0;
			              	DN_M = 1'b0;
			             end			  
	    endcase
	 end	
			 	 
endmodule