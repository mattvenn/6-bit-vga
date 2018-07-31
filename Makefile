PROJ = 6bitvga
PIN_DEF = icestick.pcf
DEVICE = hx1k

SRC = top.v VgaSyncGen.v numbers.v image.v fontROM.v bcd.v

all: $(PROJ).bin

%.blif: $(SRC)
	yosys -p "synth_ice40 -top top -blif $@" $^

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

prog: $(PROJ).bin
	iceprog $<

sudo-prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo iceprog $<

debug-vga:
	iverilog -o test vga_tb.v VgaSyncGen.v bcd.v
	vvp test -fst
	gtkwave test.vcd gtk.gtkw

debug-numbers:
	iverilog -o numbers numbers.v fontROM.v image.v numbers_tb.v
	vvp numbers -fst
	gtkwave test.vcd gtk-numbers.gtkw

debug-bcd:
	iverilog -o bcd bcd.v bcd_tb.v
	vvp bcd -fst
	gtkwave test.vcd gtk-bcd.gtkw

clean:
	rm -f $(PROJ).blif $(PROJ).asc $(PROJ).rpt $(PROJ).bin

.SECONDARY:
.PHONY: all prog clean
