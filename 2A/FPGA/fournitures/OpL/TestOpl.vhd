--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:20:18 03/25/2022
-- Design Name:   
-- Module Name:   /home/isijelma/2A/s8/FPGA/projet/ModuleOPL2/TestOpl.vhd
-- Project Name:  ModuleOPL2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MasterOpl
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TestOpl is
  end TestOpl;


architecture behavior of TestOpl is

    component MasterOpl
        port ( rst : in std_logic;
         clk : in std_logic;
         en : in std_logic;
         v1 : in std_logic_vector (7 downto 0);
         v2 : in std_logic_vector(7 downto 0);
         miso : in std_logic;
         ss   : out std_logic;
         sclk : out std_logic;
         mosi : out std_logic;
         val_nand : out std_logic_vector (7 downto 0);
         val_xor : out std_logic_vector (7 downto 0);
         val_nor : out std_logic_vector (7 downto 0);
         busy : out std_logic);
    end component;
    
    
    component SlaveOpl
        port(
            sclk : in  std_logic;
            mosi : in  std_logic;
            miso : out std_logic;
            ss   : in  std_logic);
    end component;
    
    
  --Inputs
  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal en : std_logic := '0';
  signal v1 : std_logic_vector(7 downto 0) := (others => '0');
  signal v2 : std_logic_vector(7 downto 0) := (others => '0');
  signal miso : std_logic := '0';
  
  --Outputs
  signal ss : std_logic;
  signal sclk : std_logic;
  signal mosi : std_logic;
  signal busy : std_logic;
  signal val_nand : std_logic_vector(7 downto 0) := (others => '0');
  signal val_xor : std_logic_vector(7 downto 0) := (others => '0');    
  signal val_nor : std_logic_vector(7 downto 0) := (others => '0');
  -- Clock period definitions
  constant clk_period : time := 10 ns;
  
begin
    
    m : MasterOpl
    port map ( rst => rst,
             clk => clk,
             en => en,
             v1 => v1,
             v2 => v2,
             miso => miso,
             ss => ss,
             sclk => sclk,
             mosi => mosi,
             val_nand => val_nand,
				 val_xor => val_xor,
             val_nor => val_nor,
             busy => busy  
           );

    
    uut : SlaveOpl
    port map ( sclk => sclk,
             mosi => mosi,
             miso => miso,
             ss => ss  
           );
           
    clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;


  -- Stimulus process
  stim_proc: process
  begin                
    -- hold reset state for 100 ns.
    wait for 100 ns;  
    rst <= '1';

    wait for clk_period*10;
    
    -- insert stimulus here
    en <= '0';
    -- Les 2 octets opérandes
    v1 <= "00000111";
    v2 <= "10000110";
    
    wait for clk_period*10;  
    
    en <= '1';
    wait for clk_period*3;
    en <= '0';
    wait until busy = '0';
    
   
	 
    v1 <= "11100011";
    v2 <= "00110011";
    
    wait for clk_period*10; 
    en <= '1';
    wait for clk_period*3;
    en <= '0';
    wait until busy = '0';
	 
	 
	  v1 <= "11111010";
    v2 <= "11111011";
    
    wait for clk_period*10; 
    en <= '1';
    wait for clk_period*3;
    en <= '0';
    wait until busy = '0';
	 
	 
	 
	 v1 <= "10111110";
    v2 <= "11011011";
    
    wait for clk_period*10; 
    en <= '1';
    wait for clk_period*3;
    en <= '0';
    wait until busy = '0';
	 
	 
	 
	 
	 
	 
	 
    
    
    wait;
  end process;
END;  
    