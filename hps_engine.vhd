library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity hps_engine is 
    port (
        clk            : in std_logic;
        rst_n          : in std_logic;

        axi_awaddr     : out std_logic_vector(20 downto 0)                          := (others => '0');
        axi_awvalid    : out std_logic                                              := '0';
        axi_awready    : in std_logic                                               := '0';
      
        axi_wdata      : out std_logic_vector(31 downto 0)                          := (others => '0');
        axi_wvalid     : out std_logic                                              := '0';
        axi_wready     : in std_logic                                               := '0';
      
        axi_bresp      : in std_logic_vector(1 downto 0)                            := (others => '0');
        axi_bvalid     : in std_logic                                               := '0';
        axi_bready     : out std_logic                                              := '0';
      
        axi_araddr     : out std_logic_vector(20 downto 0)                          := (others => '0');
        axi_arvalid    : out std_logic                                              := '0';
        axi_arready    : in std_logic                                               := '0';
      
        axi_rdata      : in std_logic_vector(31 downto 0)                           := (others => '0');
        axi_rresp      : in std_logic_vector(1 downto 0)                            := (others => '0');
        axi_rvalid     : in std_logic                                               := '0';
        axi_rready     : out std_logic                                              := '0'
    );
end entity;

architecture tbench of hps_engine is
    type can_frame_addresses_t is array (0 to 1) of std_logic_vector(20 downto 0);
    type axi_data_t is array(0 to 1) of std_logic_vector(31 downto 0);

    signal can_frame_addresses : can_frame_addresses_t := (
        0 => "000000000000000000000", 
        1 => "000000000000000000100"
    );

    signal can_data : axi_data_t :=(
        0 => x"DEADBEEF",
        1 => x"DEADAFFE"
    );
begin


  hps_engine_p: process
  begin
    wait for 150 ns;

        for i in 0 to 1 loop
            -- Write
            axi_awaddr <= can_frame_addresses(i);
            axi_awvalid <= '1';
            wait until clk = '1' and clk'event;
            wait until axi_awready = '1';
            axi_awvalid <= '0';
        
            axi_wdata <= can_data(i);
            axi_wvalid <= '1';
            wait until clk = '1' and clk'event;
            wait until axi_wready = '1';
        
        
            axi_bready <= '1';
            wait until axi_bvalid = '1';
            wait until clk = '1' and clk'event;
            axi_bready <= '0';
            axi_wvalid <= '0';

            -- Read
            axi_araddr <= can_frame_addresses(i);
            axi_arvalid <= '1';
            wait until clk = '1' and clk'event;
            wait until axi_arready = '1';
            wait until clk = '1' and clk'event;
            axi_arvalid <= '0';

            axi_rready <= '1';
            wait until axi_rvalid = '1';

            wait until clk = '1' and clk'event;
            axi_rready <= '0';


            wait for 50 ns;
        end loop;


    wait;
  end process hps_engine_p;

end tbench ; -- tbench