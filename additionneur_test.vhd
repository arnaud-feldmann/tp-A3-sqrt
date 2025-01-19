library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity additionneur_test is
    end entity;

architecture additionneur_test_arch of additionneur_test is
    signal x : std_logic_vector(31 downto 0);
    signal y : std_logic_vector(31 downto 0);
    signal soustract_y : std_logic;
    signal resultat : std_logic_vector(31 downto 0);
begin
    as: entity work.additionneur
    port map (
                 x => x,
                 y => y,
                 resultat => resultat
             );
    process
    begin
        x <= std_logic_vector(to_signed(10, 32));
        y <= std_logic_vector(to_signed(5, 32));
        wait for 10 ns;
        assert resultat = std_logic_vector(to_signed(15, 32))
        report "Addition de 10 + 5" severity error;
        finish;
    end process;

end architecture;
