.PHONY: all
all:
	verilator -Wall --trace -cc ../../../sv/soc/irq/pimc.sv --exe tb_pimc.cpp
	make -C obj_dir/ -f Vpimc.mk Vpimc
	./obj_dir/Vpimc
