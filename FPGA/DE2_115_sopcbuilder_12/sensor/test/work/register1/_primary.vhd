library verilog;
use verilog.vl_types.all;
entity register1 is
    generic(
        N               : integer := 8
    );
    port(
        clock           : in     vl_logic;
        enable          : in     vl_logic;
        d               : in     vl_logic_vector;
        q               : out    vl_logic_vector
    );
end register1;
