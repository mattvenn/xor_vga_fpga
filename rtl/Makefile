SHELL := /bin/bash # Use bash syntax
SEED = 10
PROJECT = xor

DEVICE = up5k
PIN_DEF = icebreaker.pcf
PACKAGE = sg48

# target freq for vga panel
FREQ = 31.5

all: $(PROJECT).bin

BUILD_DIR = ./
SOURCES = VgaSyncGen.v top.v xor.v

# $@ The file name of the target of the rule.rule
# $< first pre requisite
# $^ names of all preerquisites

CFLAGS = -O3 -Iobj_dir -I/usr/share/verilator/include

LDFLAGS = -lSDL2 -lSDL2_image

# rules for building the json
%.json: $(SOURCES) $(LISTINGS)
	yosys -l yosys.log -DSYNTH -p 'synth_ice40 -top top -json $(PROJECT).json' $(SOURCES)

%.asc: %.json $(ICEBREAKER_PIN_DEF) 
	nextpnr-ice40 -l nextpnr.log --seed $(SEED) --freq $(FREQ) --package $(PACKAGE) --$(DEVICE) --asc $@ --pcf $(PIN_DEF) --json $<

gui: $(PROJECT).json $(ICEBREAKER_PIN_DEF) 
	nextpnr-ice40 --gui -l nextpnr.log --seed $(SEED) --freq $(FREQ) --package $(PACKAGE) --$(DEVICE) --asc $(PROJECT).asc --pcf $(PIN_DEF) --json $(PROJECT).json

# bin, for programming
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.asc
	icepack $< $@

prog: $(PROJECT).bin
	iceprog $<

debug:
	iverilog -o test.out  $(SOURCES) top_tb.v -DDEBUG
	vvp test.out -fst
	gtkwave test.vcd test.gtkw

obj_dir/Vxor.h : $(SOURCES) $(LISTINGS) ../sim/fb_verilator.cpp
	verilator --cc xor.v --exe ../sim/fb_verilator.cpp -CFLAGS "$(CFLAGS)" -LDFLAGS "$(LDFLAGS)"

verilator: obj_dir/Vxor.h
	cd obj_dir && make -f Vxor.mk

clean:
	rm -f ${PROJECT}.json ${PROJECT}.asc ${PROJECT}.bin *log $(LISTINGS)
	rm -rf obj_dir

#secondary needed or make will remove useful intermediate files
.SECONDARY:
.PHONY: all clean
