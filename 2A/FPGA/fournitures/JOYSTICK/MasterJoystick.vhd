library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity MasterJoystick is
  Port (  rst : in std_logic;
				clk : in std_logic;
				en : in std_logic;
				led1 : IN std_logic;
            led2 : IN std_logic;
            miso : IN std_logic;          
            ss : OUT std_logic;
            sclk : OUT std_logic;
				mosi : OUT std_logic;
            x : OUT std_logic_vector(15 downto 0);
            y : OUT std_logic_vector(15 downto 0);
				btn1 : out std_logic;
				btn2 : out std_logic;
				btnJ : out std_logic;
				busy : out std_logic);
	END MasterJoystick;
	
	architecture behavior of MasterJoystick is
	

   component er_1octet
	port ( rst : in std_logic ;
         clk : in std_logic ;
         en : in std_logic ;
         din : in std_logic_vector (7 downto 0) ;
         miso : in std_logic ;
         sclk : out std_logic ;
         mosi : out std_logic ;
         dout : out std_logic_vector (7 downto 0) ;
         busy : out std_logic);
	end component;
	
 -- États possibles 
  type t_etat is (idle,attente,echange);
 
signal en_sig: std_logic;
signal din_sig : std_logic_vector(7 downto 0);
signal dout_sig : std_logic_vector(7 downto 0);
signal busy_sig : std_logic;
 
-- Etat actuel
signal etat : t_etat;

begin 

er_1octet_inst: er_1octet port map(
        rst=>rst,
        clk=>clk,
        en=>en_sig,
        din=>din_sig,
        miso=>miso,
        sclk=>sclk,
        mosi=>mosi,
        dout=>dout_sig,
        busy=>busy_sig
    );
	 process(clk,rst) 
	 
	 variable cpt : natural := 0;
	 
	 variable octet: natural;
	 
	 begin

        if (rst = '0') then
		  ss <= '1';
						busy <= '0';
		            octet :=1;
						 x      <= (others => '0');
                   y      <= (others => '0');    
						 etat <= idle; 
						  btn1 <= '0';
                    btn2 <= '0';
                    btnJ <= '0';
			case etat is
                        when idle =>
								
								  if(en = '1') then
								
                            busy <= '1';
									 cpt := 15;
									 ss <= '0';
									 etat <= attente;
                          end if;
                        when attente =>
								  if(cpt = 0) then
                                  en_sig <= '1';
                                    -- On fait en fonction des valeurs de octet
                                    if (octet = 0) then
                                        
                                        din_sig(0) <=led1;
													 din_sig(1) <= led2;
                                        din_sig(7 downto 2) <= "100000";
                                                                  
                              
                                    end if;
											etat <= echange;
                                else
                                    -- on décrémente le compteur 
                                    cpt := cpt - 1;
                                end if;
							  when echange =>
							   -- on rentre dans l'etat echange 
							  if (busy_sig = '0' and en = '0') then 
							      
							  case octet is
                            when 1 =>
									     x(7 downto 0) <= dout_sig;               -- Réception du 1er octet
                                etat <= attente;
                            when 2 =>
                                x (9 downto 8) <= dout_sig ( 1 downto 0);      -- 2ème octet
                                etat <= attente;
                            when 3 =>
									     y(7 downto 0) <= dout_sig;               --3ème octet :
                                etat <= attente;
									 when 4 => 
									     y(9 downto 8) <= dout_sig(1 downto 0);   -- 4ème octet :
                                etat <= attente;
								    when 5 => 
									      btnj <= dout_sig(0);
                                btn1 <= dout_sig(1);
                                btn2 <= dout_sig(2);
                                ss <= '1';             
                                busy <= '0';            
                                etat <= idle;          -- Etat idle
                                en_sig <= '0';         
                            when others => null;
                        end case;
								
								octet := octet + 1;
								cpt := 3; --  compteur prend la valeur 3  
						     end if;
							  en_sig <= '0';      -- on remets le signal a 0 
                   end case;
            end if;
        end process;				
								
end behavior;

	 
	