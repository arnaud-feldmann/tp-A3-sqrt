library ieee;
use ieee.std_logic_1164.all;

entity bascule_d is
    port
    (
        raz : in std_logic;
        h : in std_logic;
        chargement: in std_logic;
        entree : in std_logic; 
        sortie : out std_logic
    );
end entity;

architecture bascule_d_archi of bascule_d is
begin
    process (h, raz)
        variable sortie_temp : std_logic;
    begin
        if raz then
            sortie_temp := '0';
        elsif rising_edge(h) and chargement = '1' then
            sortie_temp := entree;
        end if;
        sortie <= sortie_temp;
    end process;
end architecture;

