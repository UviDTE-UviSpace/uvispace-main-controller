library verilog;
use verilog.vl_types.all;
entity RGB2BIN is
    port(
        clock           : in     vl_logic;
        reset_n         : in     vl_logic;
        in_red          : in     vl_logic_vector(11 downto 0);
        in_green        : in     vl_logic_vector(11 downto 0);
        in_blue         : in     vl_logic_vector(11 downto 0);
        in_valid        : in     vl_logic;
        in_red_threshold_min: in     vl_logic_vector(31 downto 0);
        in_red_threshold_max: in     vl_logic_vector(31 downto 0);
        in_green_threshold_min: in     vl_logic_vector(31 downto 0);
        in_green_threshold_max: in     vl_logic_vector(31 downto 0);
        in_blue_threshold_min: in     vl_logic_vector(31 downto 0);
        in_blue_threshold_max: in     vl_logic_vector(31 downto 0);
        out_red_threshold: out    vl_logic;
        out_green_threshold: out    vl_logic;
        out_blue_threshold: out    vl_logic;
        out_gray_threshold: out    vl_logic;
        out_valid_threshold: out    vl_logic
    );
end RGB2BIN;
