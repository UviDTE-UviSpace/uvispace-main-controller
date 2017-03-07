# Etapas de simualción con Modelsim:
# 1. Se crea la librería de trabajo (vlib)
# 2. Se compilan los archivos de diseño (vlog)
# 3. Se compilan los bancos de pruebas (vlog)
# 4. Se corre la simulación (vsim)

# vsim -do "add wave /*; run -all" work.test

VERILOGEX = .v # verilog file extension
 
# dirs
SOURCEDIRS += ../hdl
SOURCEDIRS += ../test
SIMDIR = work

# testbench path TESTBENCH is passed from the command line
TESTBENCHNAME = $(subst ${VERILOGEX},,${TEST})

# compilation
VERILOG_CMD = vlog
VHDL_CMD = vcom

# simulation
SIM_CMD = vsim
 
all: compile run 

lib :  
	vlib $(SIMDIR)

compile : lib
	@echo "Compiling verilog files."
	for dir in $(SOURCEDIRS); do \
	    $(VERILOG_CMD) -work $(SIMDIR) $$dir/*$(VERILOGEX); \
    done

run :
	$(SIM_CMD) -c -do "run -all; exit;" $(SIMDIR).$(TESTBENCHNAME)
