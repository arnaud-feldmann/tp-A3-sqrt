library ieee;
use ieee.std_logic_1164.all;

entity top is port
    (
        key : in std_logic_vector(1 downto 0);
		  sw : in std_logic_vector(9 downto 0);
        clock_50 : in std_logic;
        ledr : out std_logic_vector(4 downto 0);
		  ledg : out std_logic_vector(0 downto 0)
    );
end entity;

architecture top_archi of top is
	signal entree : std_logic_vector(63 downto 0);
	signal sortie : std_logic_vector(31 downto 0);
begin
	entree <= (63 downto 10 => '0') & sw(9 downto 0);
	ledr(4 downto 0) <= sortie(4 downto 0);
    sqrt_inst : entity work.racine(Structural)
	 generic map
	 (
		n => 32
	 )
    port map (
        A => entree,
        clk => clock_50,
        raz => not key(1),
        start => not key(0),
        result => sortie,
        done => ledg(0)
    );
end architecture;
