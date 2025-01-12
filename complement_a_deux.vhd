library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
begin
    sortie <= std_logic_vector(-signed(entree)) when enable = '1' or enable = 'H' else entree;
end architecture;

