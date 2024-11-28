# Variablen
OLO_BASE_SRC_DIR := extern/src/base  # Verzeichnis für die Basis-VHDL-Dateien
PROJECT_NAME := t_axi_lite

# Manuelle Auflistung der VHDL-Dateien ohne Zeilenfortsetzung
SRC_FILES = \
    extern/src/base/vhdl/olo_base_pkg_array.vhd \
    extern/src/base/vhdl/olo_base_pkg_math.vhd \
    extern/src/base/vhdl/olo_base_pkg_logic.vhd \
    extern/src/base/vhdl/olo_base_cc_bits.vhd \
    extern/src/base/vhdl/olo_base_cc_reset.vhd \
    extern/src/base/vhdl/olo_base_cc_n2xn.vhd \
    extern/src/base/vhdl/olo_base_arb_prio.vhd \
    extern/src/base/vhdl/olo_base_arb_rr.vhd \
	extern/src/base/vhdl/olo_base_cc_pulse.vhd \
    extern/src/base/vhdl/olo_base_cc_simple.vhd \
    extern/src/base/vhdl/olo_base_ram_sdp.vhd \
    extern/src/base/vhdl/olo_base_delay_cfg.vhd \
    extern/src/base/vhdl/olo_base_decode_firstbit.vhd \
    extern/src/base/vhdl/olo_base_ram_tdp.vhd \
    extern/src/base/vhdl/olo_base_strobe_gen.vhd \
    extern/src/base/vhdl/olo_base_wconv_n2xn.vhd \
    extern/src/base/vhdl/olo_base_fifo_async.vhd \
    extern/src/base/vhdl/olo_base_delay.vhd \
    extern/src/base/vhdl/olo_base_prbs.vhd \
    extern/src/base/vhdl/olo_base_tdm_mux.vhd \
    extern/src/base/vhdl/olo_base_cc_handshake.vhd \
    extern/src/base/vhdl/olo_base_fifo_sync.vhd \
    extern/src/base/vhdl/olo_base_flowctrl_handler.vhd \
    extern/src/base/vhdl/olo_base_dyn_sft.vhd \
    extern/src/base/vhdl/olo_base_strobe_div.vhd \
    extern/src/base/vhdl/olo_base_ram_sp.vhd \
    extern/src/base/vhdl/olo_base_cam.vhd \
    extern/src/base/vhdl/olo_base_cc_status.vhd \
    extern/src/base/vhdl/olo_base_reset_gen.vhd \
    extern/src/base/vhdl/olo_base_wconv_xn2n.vhd \
    extern/src/base/vhdl/olo_base_fifo_packet.vhd \
    extern/src/base/vhdl/olo_base_pl_stage.vhd \
    extern/src/base/vhdl/olo_base_cc_xn2n.vhd \
	extern/src/axi/vhdl/olo_axi_pkg_protocol.vhd \
	extern/src/axi/vhdl/olo_axi_master_simple.vhd \
	extern/src/axi/vhdl/olo_axi_pl_stage.vhd \
	extern/src/axi/vhdl/olo_axi_master_full.vhd \
	extern/src/axi/vhdl/olo_axi_lite_slave.vhd \
	axi_lite_intf.vhd \
	axi_lite_slave.vhd \
	hps_engine.vhd \
	t_axi_lite.vhd \


# Ziel: Analyse der Basis VHDL-Dateien
ghdlinit: analyze

# Ziel: VHDL-Dateien mit GHDL analysieren
analyze:
	@echo "Analysiere Basis VHDL-Dateien..."
	@for file in $(SRC_FILES); do \
		echo "Analysiere $$file..."; \
		ghdl -a "$$file"; \
	done

# Elaborate step
elaborate: analyze
	@echo "Elaboriere das Design..."
	ghdl -e $(PROJECT_NAME)

# Run simulation
run: elaborate
	@echo "Starte Simulation..."
	ghdl -r $(PROJECT_NAME) --wave=output.ghw

# Combine all in one target: sim
sim: run
	@echo "Simulation erfolgreich abgeschlossen!"

# Ziel: Bereinigen
clean:
	@echo "Bereinige GHDL-Artefakte..."
	@rm -f *.o *.cf *.ghw *.vcd