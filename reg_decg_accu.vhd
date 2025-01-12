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
        entree : in std_logic_vector(n-1 downto 0);
        enable : in std_logic;
        raz : in std_logic;
        clk : in std_logic;
        sortie : out std_logic_vector(n-1 downto 0)
    );
end entity;

architecture reg_decg_accu of reg_decg_accu is
    signal entree_bis : std_logic_vector(entree'range); 
    signal sortie_bis : std_logic_vector(sortie'high + d downto 0); 
begin
    sortie_bis(d - 1 downto 0) <= (others => '0');
    a : entity work.additionneur
    generic map
    (
        n => n
    )
    port map
    (
        x => sortie_bis(n-1 downto 0),
        y => entree,
        resultat => entree_bis,
        retenue => open
    );
    f : for i in entree_bis'range generate
        u : entity work.bascule_d
        port map
        (
            raz => raz,
            h => clk,
            chargement => enable,
            entree => entree_bis(i),
            sortie => sortie_bis(i+d)
        );
    end generate;
    sortie <= sortie_bis(n + d - 1 downto d);
end architecture;

