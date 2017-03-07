library verilog;
use verilog.vl_types.all;
entity register5 is
    generic(
        N               : integer := 8;
        K               : integer := 5
    );
    port(
        clock           : in     vl_logic;
        enable          : in     vl_logic;
        d               : in     vl_logic_vector;
        q0              : out    vl_logic_vector;
        q1              : out    vl_logic_vector;
        q2              : out    vl_logic_vector;
        q3              : out    vl_logic_vector;
        q4              : out    vl_logic_vector
    );
end register5;
