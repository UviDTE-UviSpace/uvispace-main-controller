library verilog;
use verilog.vl_types.all;
entity fifo5x5 is
    generic(
        N               : integer := 3;
        MEMORY_SIZE     : integer := 4096;
        ADDRESS_SIZE    : integer := 12;
        K               : integer := 5
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
        po03            : out    vl_logic_vector;
        po04            : out    vl_logic_vector;
        po10            : out    vl_logic_vector;
        po11            : out    vl_logic_vector;
        po12            : out    vl_logic_vector;
        po13            : out    vl_logic_vector;
        po14            : out    vl_logic_vector;
        po20            : out    vl_logic_vector;
        po21            : out    vl_logic_vector;
        po22            : out    vl_logic_vector;
        po23            : out    vl_logic_vector;
        po24            : out    vl_logic_vector;
        po30            : out    vl_logic_vector;
        po31            : out    vl_logic_vector;
        po32            : out    vl_logic_vector;
        po33            : out    vl_logic_vector;
        po34            : out    vl_logic_vector;
        po40            : out    vl_logic_vector;
        po41            : out    vl_logic_vector;
        po42            : out    vl_logic_vector;
        po43            : out    vl_logic_vector;
        po44            : out    vl_logic_vector;
        valid           : out    vl_logic
    );
end fifo5x5;
