library ieee;
use ieee.std_logic_1164.all;

entity complement_a_deux is
    generic
    (
        n : natural := 32 
    );
    port
    (
        entree : in std_logic_vector(n - 1 downto 0);
        enable : in std_logic;
        sortie : out std_logic_vector(n - 1 downto 0)
    );
end entity;

architecture complement_a_deux_archi of complement_a_deux is
    signal comp2 : std_logic_vector(n-1 downto 0);
begin
    ai : entity work.additionneur
    generic map
    (
        n => n
    )
    port map
    (
        x => not entree,
        y => (n-1 downto 1 => '0') & "1",
        resultat => comp2,
        retenue => open
    );

    sortie <= comp2 when enable = '1' or enable = 'H' else entree;
end architecture;

