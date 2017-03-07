library verilog;
use verilog.vl_types.all;
entity fifo3x3 is
    generic(
        N               : integer := 3;
        MEMORY_SIZE     : integer := 4096;
        ADDRESS_SIZE    : integer := 12;
        K               : integer := 3
    );
    port(
        clock           : in     vl_logic;
        reset_n         : in     vl_logic;
        width           : in     vl_logic_vector(15 downto 0);
        read            : in     vl_logic;
        pi              : in     vl_logic_vector;
        po00            : out    vl_logic_vector;
        po01            : out    vl_logic_vector;
        po02            : out    vl_logic_vector;
        po10            : out    vl_logic_vector;
        po11            : out    vl_logic_vector;
        po12            : out    vl_logic_vector;
        po20            : out    vl_logic_vector;
        po21            : out    vl_logic_vector;
        po22            : out    vl_logic_vector;
        valid           : out    vl_logic
    );
end fifo3x3;
