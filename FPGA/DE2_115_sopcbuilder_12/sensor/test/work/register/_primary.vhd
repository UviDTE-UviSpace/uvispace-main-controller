library verilog;
use verilog.vl_types.all;
entity \register\ is
    generic(
        N               : integer := 8
    );
    port(
        d               : in     vl_logic_vector;
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        q               : out    vl_logic_vector
    );
end \register\;
