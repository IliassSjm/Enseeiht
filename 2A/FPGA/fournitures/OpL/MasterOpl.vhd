library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MasterOpl is
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
end MasterOpl;

architecture behavior of MasterOpl is

component er_1octet port(
        rst : in std_logic ;
        clk : in std_logic ;
        en : in std_logic ;
        din : in std_logic_vector (7 downto 0);    
        miso : in std_logic ;
        sclk : out std_logic ;
        mosi : out std_logic ;
        dout : out std_logic_vector (7 downto 0);   
        busy : out std_logic
    );
	 end component ;
	 signal sig_din : std_logic_vector(7 downto 0) := (others => 'U');
   
    signal sig_dout : std_logic_vector(7 downto 0) := (others => 'U');
    
    signal sig_busy : std_logic;

    signal sig_en : std_logic := '0';
    
    type t_etat is (idle, attente, echange);

    signal etat : t_etat;
    

begin


er_1octet_Inst: er_1octet port map(
        rst=>rst,
        clk=>clk,
        en=>sig_en,
        din=>sig_din,
        miso=>miso,
        sclk=>sclk,
        mosi=>mosi,
        dout=>sig_dout,
        busy=>sig_busy
    );


master: process (clk, rst)
    
        variable cpt : natural := 0;
        
        variable rank : natural := 0;
        
        constant number_octet : natural := 3;
        
        constant wait_esclave : natural := 10;
        
        constant wait_envoie : natural := 3;
    
    begin

        if (rst = '0') then

            etat <= idle;
            ss <= '1';           
            busy <= '0';
				sig_en <= '0';
            val_nand <= "00000000";
				val_xor <= "00000000";
            val_nor <= "00000000"; 

				
				elsif (rising_edge(clk)) then
            case (etat) is
                when idle =>
					 if (en = '1') then
                        ss <= '0';                      
                        busy <= '1';                    
                        cpt := wait_esclave;        
                        rank := 0;
                        etat <= attente;
                    end if;                            

                when attente =>
                
                    if (cpt = 0) then                   
                        case rank is
                            when 1 =>
                                sig_din <= v2; 
									  when 0 =>
                                sig_din <= v1; 
                            when others => null;
                        end case;
                        
                        sig_en <= '1';                 
                        etat <= echange;
                        
                    else
                        cpt := cpt - 1;                
                        
                    end if;
                        
                when echange =>
                    if (sig_busy = '0' and sig_en = '0') then 
                        case rank is
                            when 2 =>
                                val_nor <= sig_dout;     
                                ss <= '1'; 
										  etat <= idle; 
                                busy <= '0';           
                                sig_en <= '0';   
                            when 1 =>
                                val_xor <= sig_dout;      
                                etat <= attente;
									 when 0 =>
                                val_nand <= sig_dout;     
                                etat <=attente;										  
                            when others => null;
                        end case;
                    
                        rank := rank + 1;
                        cpt := wait_envoie;           
                            
                    else
                        sig_en <= '0';                  
                    end if;
                    
            end case;
            
        end if;
    
    end process;

end behavior;
