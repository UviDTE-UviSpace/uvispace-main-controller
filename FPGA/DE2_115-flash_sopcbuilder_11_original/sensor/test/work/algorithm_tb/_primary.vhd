library verilog;
use verilog.vl_types.all;
entity algorithm_tb is
    generic(
        N               : integer := 8;
        WIDTH           : integer := 80;
        HEIGHT          : integer := 60
    );
end algorithm_tb;
