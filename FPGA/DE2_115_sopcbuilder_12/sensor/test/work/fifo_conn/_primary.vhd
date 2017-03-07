library verilog;
use verilog.vl_types.all;
entity fifo_conn is
    generic(
        N               : integer := 8;
        MEMORY_SIZE     : integer := 4096;
        ADDRESS_SIZE    : integer := 12
    );
    port(
        clock           : in     vl_logic;
        reset_n         : in     vl_logic;
        width           : in     vl_logic_vector(15 downto 0);
        write           : in     vl_logic;
        pi11            : in     vl_logic_vector;
        po00            : out    vl_logic_vector;
        po01            : out    vl_logic_vector;
        po02            : out    vl_logic_vector;
        po10            : out    vl_logic_vector;
        valid           : out    vl_logic
    );
end fifo_conn;
