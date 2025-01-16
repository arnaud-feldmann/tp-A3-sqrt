library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity uc_test is
    end entity;

architecture uc_test_arch of uc_test is
    signal clk : std_logic;
    signal raz : std_logic;
    signal start : std_logic;
    signal att : std_logic;
    signal init : std_logic;
    signal done : std_logic;
    constant clk_period : time := 50 ns;
begin
    r : entity work.uc
    generic map
    (
        n => 5
    )
    port map
    (
        clk => clk,
        raz => raz,
        att => att,
        start => start,
        init => init,
        done => done
    );

    process
    begin
        clk <= '0';
        wait for clk_period;
        clk <= '1';
        wait for clk_period;
    end process;

    process
    begin
        raz <= '1';
        start <= '0';
        wait for 20 ns;
        raz <= '0';
        start <= '1';
        wait until rising_edge(clk);
        wait for 10 ns;
        assert init = '0' report "not init before init" severity error;
        assert done = '0' report "not done before init" severity error;
        assert att = '1' report "att during att" severity error;
        wait until rising_edge(clk); -- Init
        wait for 10 ns;
        assert att = '0' report "not att during not att" severity error;
        assert init = '1' report "init during init" severity error;
        assert done = '0' report "not done during init" severity error;
        wait until rising_edge(clk); --4
        wait for 10 ns;
        assert init = '0' report "not init after init" severity error;
        assert done = '0' report "not done after init" severity error;
        wait until rising_edge(clk); --3
        wait until rising_edge(clk); --2
        wait until rising_edge(clk); --1
        wait until rising_edge(clk); --0
        wait for 10 ns;
        assert done = '0' report "not done at 5 iter" severity error;
        wait until rising_edge(clk); -- Fin
        wait for 10 ns;
        assert done = '1' report "done after 5 iter" severity error;

        finish;
    end process;

end architecture;

