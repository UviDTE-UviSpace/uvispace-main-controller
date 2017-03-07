library verilog;
use verilog.vl_types.all;
entity ram_banks is
    generic(
        WORD_SIZE       : integer := 16;
        ADDRESS_SIZE    : integer := 8
    );
    port(
        clock           : in     vl_logic;
        enable          : in     vl_logic;
        address_write   : in     vl_logic_vector;
        write           : in     vl_logic;
        write_left_x    : in     vl_logic_vector;
        write_left_y    : in     vl_logic_vector;
        write_top_x     : in     vl_logic_vector;
        write_top_y     : in     vl_logic_vector;
        write_right_x   : in     vl_logic_vector;
        write_right_y   : in     vl_logic_vector;
        write_bottom_x  : in     vl_logic_vector;
        write_bottom_y  : in     vl_logic_vector;
        address_read    : in     vl_logic_vector;
        read            : in     vl_logic;
        read_left_x     : out    vl_logic_vector;
        read_left_y     : out    vl_logic_vector;
        read_top_x      : out    vl_logic_vector;
        read_top_y      : out    vl_logic_vector;
        read_right_x    : out    vl_logic_vector;
        read_right_y    : out    vl_logic_vector;
        read_bottom_x   : out    vl_logic_vector;
        read_bottom_y   : out    vl_logic_vector
    );
end ram_banks;
