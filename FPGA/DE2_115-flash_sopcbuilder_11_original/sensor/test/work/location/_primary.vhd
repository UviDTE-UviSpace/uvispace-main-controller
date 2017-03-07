library verilog;
use verilog.vl_types.all;
entity location is
    port(
        clock           : in     vl_logic;
        reset_n         : in     vl_logic;
        width           : in     vl_logic_vector(15 downto 0);
        height          : in     vl_logic_vector(15 downto 0);
        in_write        : in     vl_logic;
        in_pixel        : in     vl_logic_vector(2 downto 0);
        out_write       : out    vl_logic;
        out_pixel       : out    vl_logic_vector(2 downto 0);
        out_red_left1   : out    vl_logic_vector(31 downto 0);
        out_red_top1    : out    vl_logic_vector(31 downto 0);
        out_red_right1  : out    vl_logic_vector(31 downto 0);
        out_red_bottom1 : out    vl_logic_vector(31 downto 0);
        out_red_left2   : out    vl_logic_vector(31 downto 0);
        out_red_top2    : out    vl_logic_vector(31 downto 0);
        out_red_right2  : out    vl_logic_vector(31 downto 0);
        out_red_bottom2 : out    vl_logic_vector(31 downto 0);
        out_green_left1 : out    vl_logic_vector(31 downto 0);
        out_green_top1  : out    vl_logic_vector(31 downto 0);
        out_green_right1: out    vl_logic_vector(31 downto 0);
        out_green_bottom1: out    vl_logic_vector(31 downto 0);
        out_green_left2 : out    vl_logic_vector(31 downto 0);
        out_green_top2  : out    vl_logic_vector(31 downto 0);
        out_green_right2: out    vl_logic_vector(31 downto 0);
        out_green_bottom2: out    vl_logic_vector(31 downto 0);
        out_blue_left1  : out    vl_logic_vector(31 downto 0);
        out_blue_top1   : out    vl_logic_vector(31 downto 0);
        out_blue_right1 : out    vl_logic_vector(31 downto 0);
        out_blue_bottom1: out    vl_logic_vector(31 downto 0);
        out_blue_left2  : out    vl_logic_vector(31 downto 0);
        out_blue_top2   : out    vl_logic_vector(31 downto 0);
        out_blue_right2 : out    vl_logic_vector(31 downto 0);
        out_blue_bottom2: out    vl_logic_vector(31 downto 0)
    );
end location;
