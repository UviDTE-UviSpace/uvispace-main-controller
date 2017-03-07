library verilog;
use verilog.vl_types.all;
entity fifo_tb is
    generic(
        N               : integer := 1;
        WIDTH           : integer := 8;
        HEIGHT          : integer := 8
    );
end fifo_tb;
