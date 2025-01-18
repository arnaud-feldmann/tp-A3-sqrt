library ieee;
use ieee.std_logic_1164.all;

entity reg_decg_accu is
    generic
    (
        n : natural := 32;
        d : natural := 1
    );
    port
    (
        entree_concat : in std_logic_vector(d - 1 downto 0);
        entree_chargement : in std_logic_vector(n - 1 downto 0);
        enable_chargement : in std_logic;
        enable_decalage : in std_logic;
        raz : in std_logic;
        clk : in std_logic;
        sortie : out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture reg_decg_accu of reg_decg_accu is
    signal entree_bis : std_logic_vector(entree_chargement'range); 
    signal sortie_bis : std_logic_vector(sortie'high + d downto 0); 
begin
    sortie_bis(d - 1 downto 0) <= entree_concat;
    entree_bis <= entree_chargement when enable_chargement = '1' or enable_chargement = 'H' else sortie_bis(entree_bis'range);
    f : for i in entree_bis'range generate
        u : entity work.bascule_d
        port map
        (
            raz => raz,
            h => clk,
            chargement => enable_decalage or enable_chargement,
            entree => entree_bis(i),
            sortie => sortie_bis(i+d)
        );
    end generate;
    sortie <= sortie_bis(n + d - 1 downto d);
end architecture;

