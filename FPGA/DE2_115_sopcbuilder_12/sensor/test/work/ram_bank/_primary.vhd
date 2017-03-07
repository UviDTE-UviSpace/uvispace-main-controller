library verilog;
use verilog.vl_types.all;
entity ram_bank is
    generic(
        WORD_SIZE       : integer := 16;
        ADDRESS_SIZE    : integer := 7;
        FILENAME        : string  := "memory.bin"
    );
    port(
        clock           : in     vl_logic;
        enable          : in     vl_logic;
        address_write   : in     vl_logic_vector;
        write           : in     vl_logic;
        data_in         : in     vl_logic_vector;
        address_read    : in     vl_logic_vector;
        read            : in     vl_logic;
        data_out        : out    vl_logic_vector
    );
end ram_bank;
