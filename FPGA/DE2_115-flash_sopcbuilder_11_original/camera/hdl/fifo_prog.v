///
/// Programmable FIFO memory
/// ------------------------
///
/// The memory size of this FIFO is programmable through a register value.
///
/// .. figure:: fifo_prog.png
///
///    Programmable FIFO block
/// 
/// Proporciona los datos en la misma secuencia de entrada, pero retardados
/// un cierto valor indicado por el tama�o (size) de la FIFO, mientras que
/// el tama�o de la memoria viene establecido por el par�metro MEMORY_SIZE.
///
/// Para ello, cuando su funcionamiento se encuentra desinhibido (ena) graba
/// un dato a cada flanco de reloj (clk).
///
/// Los par�metros MEMORY_WIDTH y MEMORY_SIZE establecen el ancho de dato y 
/// el tama�o f�sico de la memoria que ser� utilizada por la FIFO.
/// 
module fifo_prog #(
        parameter MEMORY_WIDTH = 12,
        parameter MEMORY_SIZE = 4096,
        parameter ADDRESS_SIZE = 12,
        parameter ADDRESS_SIZE1 = 11,
        parameter ADDRESS_SIZE2 = 10,
        parameter WORD_SIZE = MEMORY_WIDTH,
        parameter N = MEMORY_WIDTH 
    ) (
        input clk,
        input reset_n,
        input enable,
        input [N-1:0] data_in,
        input [15:0] size,
        output [N-1:0] data_out
    );
    
    reg [15:0] write_pointer;
    reg [15:0] read_pointer;
    
    always @(posedge clk)
    begin
        if (reset_n) begin
            if (enable) begin
                if (write_pointer < size - 1) begin
                    write_pointer[15:0] <= write_pointer[15:0] + 16'd1;
                end
                else begin
                    write_pointer[15:0] <= 16'd0; 
                end
                if (read_pointer < size - 1) begin
                    read_pointer[15:0] <= read_pointer[15:0] + 16'd1;
                end
                else begin
                    read_pointer[15:0] <= 16'd0;
                end
            end
        end
        else begin
            write_pointer[15:0] <= 16'd0;
            read_pointer[15:0] <= 16'd1;
        end
    end
        
    // RAM memory
    wire [N-1:0] data1;
    fifo_ram #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE1)
    ) mem1 (
        .clock(clk),
        .enable(enable),
        .address_write(write_pointer[ADDRESS_SIZE1-1:0]),
        .write(enable & !write_pointer[ADDRESS_SIZE-1]),
        .data_in(data_in[WORD_SIZE-1:0]),
        .address_read(read_pointer[ADDRESS_SIZE1-1:0]),
        .read(enable & !read_pointer[ADDRESS_SIZE-1]),
        .data_out(data1[WORD_SIZE-1:0])
    );
    wire [N-1:0] data2;
    fifo_ram #(
        .WORD_SIZE(WORD_SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE2)
    ) mem2 (
        .clock(clk),
        .enable(enable),
        .address_write(write_pointer[ADDRESS_SIZE2-1:0]),
        .write(enable & write_pointer[ADDRESS_SIZE-1]),
        .data_in(data_in[WORD_SIZE-1:0]),
        .address_read(read_pointer[ADDRESS_SIZE2-1:0]),
        .read(enable & read_pointer[ADDRESS_SIZE-1]),
        .data_out(data2[WORD_SIZE-1:0])
    );
    assign data_out[WORD_SIZE-1:0] = read_pointer[ADDRESS_SIZE-1] ? data2[WORD_SIZE-1:0] : data1[WORD_SIZE-1:0];
   
endmodule
//
// Bloque de memoria RAM con lectura y escritura en el mismo ciclo
//
module fifo_ram #(
        parameter WORD_SIZE = 12,
        parameter ADDRESS_SIZE = 12,
        parameter FILENAME = "memory.bin"
    ) ( 
        input clock,
        input enable, 
        input [ADDRESS_SIZE-1:0] address_write,
        input write,
        input [WORD_SIZE-1:0] data_in,
        input [ADDRESS_SIZE-1:0] address_read,
        input read,
        output [WORD_SIZE-1:0] data_out
    );
    
    reg [WORD_SIZE-1:0] data [0:(1<<ADDRESS_SIZE)-1];
    //initial $readmemb (FILENAME, data);
    
    reg [WORD_SIZE-1:0] _data_out;
    always @(posedge clock) begin
        if (enable) begin
            if (read) begin
                _data_out = data[address_read];
            end
            if (write) begin
                data[address_write] = data_in;
            end
        end
    end
    assign data_out = _data_out;
    
endmodule
