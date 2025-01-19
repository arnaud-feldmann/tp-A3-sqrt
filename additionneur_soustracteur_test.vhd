library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity additionneur_soustracteur_test is
    end entity;

architecture additionneur_soustracteur_test_arch of additionneur_soustracteur_test is
    signal x : std_logic_vector(31 downto 0);
    signal y : std_logic_vector(31 downto 0);
    signal soustract_y : std_logic;
    signal resultat : std_logic_vector(31 downto 0);
begin
    as: entity work.additionneur_soustracteur
    port map (
                 x => x,
                 y => y,
                 soustract_y => soustract_y,
                 resultat => resultat
             );
    process
    begin
        x <= std_logic_vector(to_signed(10, 32));
        y <= std_logic_vector(to_signed(5, 32));
        soustract_y <= '0';
        wait for 10 ns;
        assert resultat = std_logic_vector(to_signed(15, 32))
        report "Addition de 10 + 5" severity error;

        x <= std_logic_vector(to_signed(10, 32));
        y <= std_logic_vector(to_signed(5, 32));
        soustract_y <= '1';
        wait for 10 ns;
        assert resultat = std_logic_vector(to_signed(5, 32))
        report "Soustraction 10 - 5" severity error;

        x <= std_logic_vector(to_signed(2, 32));
        y <= std_logic_vector(to_signed(5, 32));
        soustract_y <= '1';
        wait for 10 ns;
        assert resultat = std_logic_vector(to_signed(-3, 32)) report "Soustraction 2 - -3" severity error;
        finish;
    end process;

end architecture;

