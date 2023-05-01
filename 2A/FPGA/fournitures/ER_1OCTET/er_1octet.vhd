library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity er_1octet is
  port ( rst : in std_logic ;
         clk : in std_logic ;
         en : in std_logic ;
         din : in std_logic_vector (7 downto 0) ;
         miso : in std_logic ;
         sclk : out std_logic ;
         mosi : out std_logic ;
         dout : out std_logic_vector (7 downto 0) ;
         busy : out std_logic);
end er_1octet;

architecture Behavioral of er_1octet is
 -- États possibles 
    type t_etat is (idle,bits_emis,bits_reception);
    
    -- État actuel
    signal etat : t_etat;
begin

 er : process (clk, rst)
  variable cpt: integer :=7;
  variable registre : std_logic_vector(7 downto 0) :=(others => '0');
  
 begin
       
        if(rst = '0') then
            -- réinitialisation des variables du process
            -- et des signaux calculés par le process
				etat <= idle;
            sclk <= '1'; 
            -- Mise à zéro de tous les signaux et variables
            mosi <= '0';
            dout <= "00000000";
            busy <= '0';
            cpt := 0;
            registre := "00000000";
				
				 elsif(rising_edge(clk)) then 
                  case etat is
						when idle =>
                        -- état d'attente d'un ordre d'envoi

                      if(en = '1') then
								  busy <= '1';
					      	-- mémoriser din pour être sûr qu'elle ne change pas
						        registre := din;
						        --dout <= (others => '0');
						      -- placer (envoyer) le 1er bit
						      cpt:= 7;
						      mosi <= registre(7); 
						      etat <= bits_emis;
								-- on place sclk a 0
								sclk <= '0';
						    end if; --en
							 
						 when bits_emis =>
						  sclk <= '1'; -- stock la valeur du bits recu
                    registre(cpt) := miso;
						  -- dout(8-(cpt+1)) <= miso;
                            -- on envoie les données 
						      if(cpt > 0) then
                              -- Changement d'état
                                etat <= bits_reception;
                            else 
                                -- le cpt repasse à 0
                                busy <= '0';
                                dout <= registre;
                                -- on change d'état
                                etat <= idle;
                            end if;
									 
						 when bits_reception =>
						          -- Décrementation de cpt                      
                                cpt := cpt - 1;
                                sclk <= '0';
                                mosi <= registre(cpt);
                                -- changement d'état
                                etat <= bits_emis;
                  end case;
             end if;
    end process;         
end Behavioral;
