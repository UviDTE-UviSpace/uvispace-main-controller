library verilog;
use verilog.vl_types.all;
entity convolution3_tb is
    generic(
        N               : integer := 8;
        WIDTH           : integer := 32;
        HEIGHT          : integer := 32;
        stages          : integer := 1
    );
end convolution3_tb;
