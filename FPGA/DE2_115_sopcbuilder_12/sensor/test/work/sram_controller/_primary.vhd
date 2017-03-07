library verilog;
use verilog.vl_types.all;
entity sram_controller is
    port(
        clock           : in     vl_logic;
        reset_n         : in     vl_logic;
        image_size      : in     vl_logic_vector(22 downto 0);
        image_start_addr: in     vl_logic_vector(12 downto 0);
        write_image_en  : in     vl_logic;
        write_image     : in     vl_logic;
        write_image_data: in     vl_logic_vector(1 downto 0);
        write_image_done: out    vl_logic;
        read_image_en   : in     vl_logic;
        read_image      : out    vl_logic;
        read_image_data : out    vl_logic_vector(1 downto 0);
        read_image_done : out    vl_logic;
        sram_clock      : out    vl_logic;
        sram_write      : out    vl_logic;
        sram_write_data : out    vl_logic_vector(31 downto 0);
        sram_write_addr : out    vl_logic_vector(12 downto 0);
        sram_read_data  : in     vl_logic_vector(31 downto 0);
        sram_read_addr  : out    vl_logic_vector(12 downto 0)
    );
end sram_controller;
