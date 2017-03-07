library verilog;
use verilog.vl_types.all;
entity connected is
    generic(
        LABEL_SIZE      : integer := 7;
        WORD_SIZE       : integer := 16
    );
    port(
        clock           : in     vl_logic;
        reset_n         : in     vl_logic;
        width           : in     vl_logic_vector(15 downto 0);
        height          : in     vl_logic_vector(15 downto 0);
        in_write        : in     vl_logic;
        in_pixel        : in     vl_logic;
        out_write       : out    vl_logic;
        out_pixel       : out    vl_logic_vector;
        out1_size       : out    vl_logic_vector(15 downto 0);
        out1_left1      : out    vl_logic_vector(31 downto 0);
        out1_top1       : out    vl_logic_vector(31 downto 0);
        out1_right1     : out    vl_logic_vector(31 downto 0);
        out1_bottom1    : out    vl_logic_vector(31 downto 0);
        out_done        : out    vl_logic
    );
end connected;
