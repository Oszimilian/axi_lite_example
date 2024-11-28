library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

use work.axi_lite_intf.all;

entity t_axi_lite is
end entity;

architecture tbench of t_axi_lite is

    signal clk, rst_n               : std_logic := '0';
    signal simstop                  : boolean   := false;

    signal axi_intf_o_s               : axi_lite_output_intf_t;
    signal axi_intf_i_s               : axi_lite_input_intf_t;
  
begin

    -- Clock generation
    clk_p : process
    begin
        clk <= '0';
        wait for 10 ns; 
        clk <= '1'; 
        wait for 10 ns;
        if simstop then
        wait;
        end if;
    end process clk_p;

    -- Reset generation
    rst_p : process
    begin
        rst_n <= '0';
        wait for 20 ns;
        rst_n <= '1';
        wait;
    end process rst_p;

    simstop_p : process
    begin
        wait for 10 us;
        simstop <= true;
        wait;
    end process simstop_p;

    hps_engine_i0 : entity work.hps_engine
        port map(
            clk                 => clk,
            rst_n               => rst_n,

            axi_awaddr          => axi_intf_o_s.axi_awaddr,
            axi_awvalid         => axi_intf_o_s.axi_awvalid,
            axi_awready         => axi_intf_i_s.axi_awready,

            axi_wdata           => axi_intf_o_s.axi_wdata,
            axi_wvalid          => axi_intf_o_s.axi_wvalid,
            axi_wready          => axi_intf_i_s.axi_wready,

            axi_bresp           => axi_intf_i_s.axi_bresp,
            axi_bvalid          => axi_intf_i_s.axi_bvalid,
            axi_bready          => axi_intf_o_s.axi_bready,

            axi_araddr          => axi_intf_o_s.axi_araddr,
            axi_arvalid         => axi_intf_o_s.axi_arvalid,
            axi_arready         => axi_intf_i_s.axi_arready,

            axi_rdata           => axi_intf_i_s.axi_rdata,
            axi_rresp           => axi_intf_i_s.axi_rresp,
            axi_rvalid          => axi_intf_i_s.axi_rvalid,
            axi_rready          => axi_intf_o_s.axi_rready          
        );

    axi_lite_slave_i0 : entity work.axi_lite_slave
        port map(
            clk                 => clk,
            rst_n               => rst_n,
            
            axi_intf_o          => axi_intf_i_s,
            axi_intf_i          => axi_intf_o_s
        );
    
end tbench ; -- tbench