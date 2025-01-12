library ieee;
use ieee.std_logic_1164.all;

entity reg_decg is
    generic
    (
        n : natural := 32;
        d : natural := 1
    );
    port
    (
        entree : in std_logic_vector(n-1 downto 0);
        load : in std_logic;
        decalage : in std_logic;
        raz : in std_logic;
        clk : in std_logic;
        sortie : out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture reg_decg of reg_decg is
    signal entree_bis : std_logic_vector(entree'range); 
    signal sortie_bis : std_logic_vector(sortie'high + d downto 0); 
begin
    sortie_bis(d-1 downto 0) <= (others => '0');
    f : for i in entree_bis'range generate
        entree_bis(i) <= entree(i) when load ='1' or load = 'H'  else sortie_bis(i);
        u : entity work.bascule_d
        port map
        (
            raz => raz,
            h => clk,
            chargement => load or decalage,
            entree => entree_bis(i),
            sortie => sortie_bis(i+d)
        );
    end generate;
    sortie <= sortie_bis(sortie'high + d downto d);
end architecture;

