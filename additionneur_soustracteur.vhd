library ieee;
use ieee.std_logic_1164.all;

entity additionneur_soustracteur is
    generic
    (
        n : natural := 32
    );
    port
    (
        x : in std_logic_vector(n - 1 downto 0);
        y : in std_logic_vector(n - 1 downto 0);
        soustract_y : in std_logic;
        resultat : out std_logic_vector(n - 1 downto 0)
    );
end entity;

architecture additionneur_soustracteur_archi of additionneur_soustracteur is
    signal y_bis : std_logic_vector(y'range);
begin
    c : entity work.complement_a_deux
    generic map
    (
        n => n
    )
    port map
    (
        entree => y,
        enable => soustract_y,
        sortie => y_bis
    );
    a : entity work.additionneur
    generic map
    (
        n => n
    )
    port map
    (
        x => x,
        y => y_bis,
        resultat => resultat,
        retenue => open
    );
end additionneur_soustracteur_archi;

