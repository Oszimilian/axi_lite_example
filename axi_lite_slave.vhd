library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.axi_lite_intf.all;

entity axi_lite_slave is 
    port(
        clk               : in   std_logic;
        rst_n             : in   std_logic;

        axi_intf_o		  : out axi_lite_input_intf_t;
        axi_intf_i		  : in 	axi_lite_output_intf_t
    );
end entity axi_lite_slave;

architecture rtl of axi_lite_slave is

    -- AXI-Interface
	signal axi_input_s			: axi_lite_input_intf_t;
	signal axi_ouput_s			: axi_lite_output_intf_t;

	-- USER-AXI-Interface
	signal rb_addr 				: std_logic_vector(20 downto 0);
	signal rb_wr				: std_logic;
	signal rb_byte_ena 			: std_logic_vector(3 downto 0);
	signal rb_wr_data 			: std_logic_vector(31 downto 0);
	signal rd_rd 				: std_logic;
	signal rb_rd_data 			: std_logic_vector(31 downto 0);
	signal rb_rd_valid 			: std_logic;

    -- Reset
    signal rst_h                : std_logic;

    -- Registers
    signal a_reg_s              : std_logic_vector(31 downto 0);
    signal b_reg_s              : std_logic_vector(31 downto 0);

begin

    -- AXI Mapping
    axi_intf_o                  <= axi_input_s;
	axi_ouput_s                 <= axi_intf_i;

    -- Reset
    rst_h                       <= not rst_n;

	-- AXI LITE INTERFACE
	slave_i0 : entity work.olo_axi_lite_slave
		generic map(
			AxiAddrWidth_g			=> 21,
			AxiDataWidth_g			=> 32,
			ReadTimeoutClks_g		=> 100
		)

		port map(
			Clk						=>	clk,
			Rst						=>  rst_h,
			
			S_AxiLite_ArAddr		=> axi_ouput_s.axi_araddr,
			S_AxiLite_ArValid		=> axi_ouput_s.axi_arvalid,
			S_AxiLite_ArReady		=> axi_input_s.axi_arready,
			
			S_AxiLite_AwAddr		=> axi_ouput_s.axi_awaddr,
			S_AxiLite_AwValid		=> axi_ouput_s.axi_awvalid,
			S_AxiLite_AwReady		=> axi_input_s.axi_awready,
			
			S_AxiLite_WData			=> axi_ouput_s.axi_wdata,
			S_AxiLite_WStrb			=> axi_ouput_s.axi_wstrb,
			S_AxiLite_WValid		=> axi_ouput_s.axi_wvalid,
			S_AxiLite_WReady		=> axi_input_s.axi_wready,
			
			S_AxiLite_BResp			=> axi_input_s.axi_bresp,
			S_AxiLite_BValid		=> axi_input_s.axi_bvalid,
			S_AxiLite_BReady		=> axi_ouput_s.axi_bready,
			
			S_AxiLite_RData			=> axi_input_s.axi_rdata,
			S_AxiLite_RValid		=> axi_input_s.axi_rvalid,
			S_AxiLite_RReady		=> axi_ouput_s.axi_rready,
			
			Rb_Addr					=> rb_addr,
			Rb_Wr					=> rb_wr,
			Rb_ByteEna				=> rb_byte_ena,
			Rb_WrData				=> rb_wr_data,
			Rb_Rd					=> rd_rd,
			Rb_RdData				=> rb_rd_data,
			Rb_RdValid				=> rb_rd_valid
		);

    -- Reaction Process
    p_rb : process(clk)
    begin
        if rising_edge(clk) then
        
            -- *** Write ***
            if rb_wr = '1' then
                case rb_addr is 
                    when "000000000000000000000" => 
                        a_reg_s             <= rb_wr_data;
                    when "000000000000000000100" =>
                        b_reg_s             <= rb_wr_data;
                    when others => null;
                end case;
            end if;
            
            -- *** Read ***
            rb_rd_valid <= '0'; -- Defuault value   
            if rd_rd = '1' then
                case rb_addr is
                    when "000000000000000000000" => 
                        rb_rd_data              <= a_reg_s;
                        rb_rd_valid             <= '1';
                    when "000000000000000000100" =>
                        rb_rd_data              <= b_reg_s;
                        rb_rd_valid             <= '1';

                    when others => null; -- Fail by timeout for illegal addreses
                end case;
            end if;
    
            -- Reset and other logic omitted
        end if;
    end process;



end rtl ; -- rtl