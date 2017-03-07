library verilog;
use verilog.vl_types.all;
entity corners is
    port(
        clock           : in     vl_logic;
        reset_n         : in     vl_logic;
        width           : in     vl_logic_vector(15 downto 0);
        height          : in     vl_logic_vector(15 downto 0);
        in_write        : in     vl_logic;
        in_pixel        : in     vl_logic;
        out_left1_x     : out    vl_logic_vector(15 downto 0);
        out_left1_y     : out    vl_logic_vector(15 downto 0);
        out_left2_x     : out    vl_logic_vector(15 downto 0);
        out_left2_y     : out    vl_logic_vector(15 downto 0);
        out_top1_x      : out    vl_logic_vector(15 downto 0);
        out_top1_y      : out    vl_logic_vector(15 downto 0);
        out_top2_x      : out    vl_logic_vector(15 downto 0);
        out_top2_y      : out    vl_logic_vector(15 downto 0);
        out_right1_x    : out    vl_logic_vector(15 downto 0);
        out_right1_y    : out    vl_logic_vector(15 downto 0);
        out_right2_x    : out    vl_logic_vector(15 downto 0);
        out_right2_y    : out    vl_logic_vector(15 downto 0);
        out_bottom1_x   : out    vl_logic_vector(15 downto 0);
        out_bottom1_y   : out    vl_logic_vector(15 downto 0);
        out_bottom2_x   : out    vl_logic_vector(15 downto 0);
        out_bottom2_y   : out    vl_logic_vector(15 downto 0)
    );
end corners;
