library verilog;
use verilog.vl_types.all;
entity erosion5x5 is
    generic(
        N               : integer := 1;
        k00             : integer := 1;
        k01             : integer := 1;
        k02             : integer := 1;
        k03             : integer := 1;
        k04             : integer := 1;
        k10             : integer := 1;
        k11             : integer := 1;
        k12             : integer := 1;
        k13             : integer := 1;
        k14             : integer := 1;
        k20             : integer := 1;
        k21             : integer := 1;
        k22             : integer := 1;
        k23             : integer := 1;
        k24             : integer := 1;
        k30             : integer := 1;
        k31             : integer := 1;
        k32             : integer := 1;
        k33             : integer := 1;
        k34             : integer := 1;
        k40             : integer := 1;
        k41             : integer := 1;
        k42             : integer := 1;
        k43             : integer := 1;
        k44             : integer := 1
    );
    port(
        clock           : in     vl_logic;
        reset_n         : in     vl_logic;
        width           : in     vl_logic_vector(15 downto 0);
        in_write        : in     vl_logic;
        in_pixel        : in     vl_logic_vector;
        out_read        : out    vl_logic;
        out_pixel       : out    vl_logic_vector
    );
end erosion5x5;
