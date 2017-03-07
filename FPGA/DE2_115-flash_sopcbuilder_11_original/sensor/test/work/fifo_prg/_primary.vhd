library verilog;
use verilog.vl_types.all;
entity fifo_prg is
    generic(
        MEMORY_WIDTH    : integer := 3;
        MEMORY_SIZE     : integer := 4096;
        ADDRESS_SIZE    : integer := 12
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        enable          : in     vl_logic;
        data_in         : in     vl_logic_vector;
        size            : in     vl_logic_vector(15 downto 0);
        data_out        : out    vl_logic_vector
    );
end fifo_prg;
