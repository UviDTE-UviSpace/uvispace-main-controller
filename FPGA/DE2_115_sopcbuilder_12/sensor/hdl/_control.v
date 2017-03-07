///
/// Control unit
/// ------------
///
/// This module implement the control unit of image processing algorithm.
///
module control (
        input clock,
        input reset_n,
        // Control inputs
        input in_write_image_done,
        input in_coordinates_done,
        input in_detection_done,
        input in_read_image_done,
        // Control outputs
        output out_write_image_en,
        output out_coordinates_en,
        output out_detection_en,
        output out_read_image_en,
        output out_process_done
	);
	
	reg [4:0] mode;
	reg write_image;
	reg coordinates;
    reg detection;
	reg read_image;
	reg done;
    
    always @(posedge clock)
    begin
        if (reset_n) begin
            case (mode)
                0: begin
                    coordinates <= 1'b1;
                    if (in_coordinates_done) mode <= 1;
                end
                1: begin
                    coordinates <= 1'b0;
                    mode <= 2;
                end
                2: begin
			        detection <= 1'b1;
                    if (in_detection_done) mode <= 3;
                end           
                3: begin
				    detection <= 1'b0;
                    mode <= 4;
                end
                4: begin // loop mode
                    done <= 1'b1;
                    //mode <= 0;
                end
            endcase
		end
		else begin
		    mode <= 0;
            done <= 1'b0;
            write_image <= 1'b0;
            coordinates <= 1'b0;
            detection <= 1'b0; 
            read_image <= 1'b0;
        end
	end
	
    assign out_write_image_en = write_image;
    assign out_coordinates_en = coordinates;
    assign out_detection_en = detection;
    assign out_read_image_en = read_image;
    assign out_process_done = (reset_n) ? done : 1'b1;
    
endmodule 