library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys4Joystick is
  port (
    -- les 16 switchs
    swt : in std_logic_vector (15 downto 0);
    -- les 5 boutons noirs
    btnC, btnU, btnL, btnR, btnD : in std_logic;
    -- horloge
    mclk : in std_logic;
    -- les 16 leds
    led : out std_logic_vector (15 downto 0);
    -- les anodes pour sélectionner les afficheurs 7 segments à utiliser
    an : out std_logic_vector (7 downto 0);
    -- valeur affichée sur les 7 segments (point décimal compris, segment 7)
    ssg : out std_logic_vector (7 downto 0);
	 miso : in std_logic;
	 ss : out std_logic;
	 sclk : out std_logic;
	 mosi : out std_logic
  );
end Nexys4Joystick;

architecture synthesis of Nexys4Joystick is

  -- rappel du (des) composant(s)
  -- À COMPLÉTER 
COMPONENT MasterJoystick
		PORT(
		      rst : in std_logic;
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
	END COMPONENT;

    COMPONENT diviseurClk
    generic(facteur : natural);
    PORT(
        clk, reset : IN std_logic;          
        nclk : OUT std_logic
    );
    END COMPONENT;

    COMPONENT All7Segments
    PORT(
        clk : IN std_logic;
        reset : IN std_logic;
        e0 : IN std_logic_vector(3 downto 0);
        e1 : IN std_logic_vector(3 downto 0);
        e2 : IN std_logic_vector(3 downto 0);
        e3 : IN std_logic_vector(3 downto 0);
        e4 : IN std_logic_vector(3 downto 0);
        e5 : IN std_logic_vector(3 downto 0);
        e6 : IN std_logic_vector(3 downto 0);
        e7 : IN std_logic_vector(3 downto 0);          
        an : OUT std_logic_vector(7 downto 0);
        ssg : OUT std_logic_vector(7 downto 0)
    );
    END COMPONENT;
 
	
    signal x : std_logic_vector(15 downto 0);
    signal y : std_logic_vector(15 downto 0);
    signal btn1 : std_logic;
    signal btn2 : std_logic;
    signal btnJ : std_logic;
    signal clk1MHz : std_logic;	
	
	
begin


  -- valeurs des sorties (à modifier)

  -- convention afficheur 7 segments 0 => allumé, 1 => éteint
  --ssg <= (others => '1');
  -- aucun afficheur sélectionné
  -- an(7 downto 0) <= (others => '1');
  -- 16 leds éteintes
  led(15 downto 4  ) <= (others => '0');

  -- connexion du (des) composant(s) avec les ports de la carte
  -- À COMPLÉTER 
     Inst_MasterJoystick: MasterJoystick PORT MAP(
        rst => not btnC,
        clk => clk1MHz,
        en => swt(0),
        led1 => btnU,
        led2 => btnL,
        miso => miso,
        ss => ss,
        sclk => sclk,
        mosi => mosi,
        x => x,
        y => y,
        btn1 => led(0),
        btn2 => led(1),
        btnJ => led(2),
        busy => led(3)
    );

    Inst_diviseurClk: diviseurClk
    GENERIC MAP(100)
    PORT MAP(
        clk => mclk,
        reset => not btnC,
        nclk => clk1MHz
    );

    Inst_All7Segments: All7Segments PORT MAP(
        clk => mclk,
        reset => not btnC,
        e0 => x(15 downto 12),
        e1 => x(11 downto 8),
        e2 => x(7 downto 4),
        e3 => x(3 downto 0),
        e4 => y(15 downto 12),
        e5 => y(11 downto 8),
        e6 => y(7 downto 4),
        e7 => y(3 downto 0),
        an => an(7 downto 0),
        ssg => ssg
    );
end synthesis;
