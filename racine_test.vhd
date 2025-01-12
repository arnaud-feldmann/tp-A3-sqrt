library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity racine_test is
    end entity;

architecture racine_test_arch of racine_test is
    signal A : std_logic_vector(63 downto 0);
    signal clk : std_logic;
    signal raz : std_logic;
    signal start : std_logic;
    signal result : std_logic_vector(31 downto 0);
    signal done : std_logic;
    constant clk_period : time := 50 ns;
    signal A_5b : std_logic_vector(9 downto 0);
    signal start_5b : std_logic;
    signal raz_5b : std_logic;
    signal result_5b : std_logic_vector(4 downto 0);
    signal done_5b : std_logic;
begin
    r : entity work.racine
    port map
    (
        A => A,
        clk => clk,
        raz => raz,
        start => start,
        result => result,
        done => done
    );
    r_5b : entity work.racine
    generic map
    (
        n => 5
    )
    port map
    (
        A => A_5b,
        clk => clk,
        raz => raz_5b,
        start => start_5b,
        result => result_5b,
        done => done_5b
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
        A <= (others => '0');
        wait for 20 ns;
        raz <= '0';

        A <= std_logic_vector(to_signed(0, 64));
        start <= '1';
        wait for clk_period;
        wait until done = '1';
        assert unsigned(result) = 0 report "sqrt(0)" severity error;
        start <= '0';
        wait for 2*clk_period + 10 ns;

        A <= std_logic_vector(to_signed(1, 64));
        start <= '1';
        wait for clk_period;
        wait until done = '1';
        assert unsigned(result) = 1 report "sqrt(1)" severity error;
        start <= '0';
        wait for 2*clk_period + 10 ns;

        A <= std_logic_vector(to_signed(512, 64));
        start <= '1';
        wait for clk_period;
        wait until done = '1';
        assert unsigned(result) = 22 report "sqrt(512)" severity error;
        start <= '0';
        wait for 2*clk_period + 10 ns;

        A <= std_logic_vector(to_signed(1194877489, 64));
        start <= '1';
        wait for clk_period;
        wait until done = '1';
        assert unsigned(result) = 34567 report "sqrt(1104877489)" severity error;
        start <= '0';
        wait for 2*clk_period + 10 ns;

        A <= (31 downto 0 => '1', others => '0');
        start <= '1';
        wait for clk_period;
        wait until done = '1';
        assert unsigned(result) = 65535 report "sqrt(4294967295)" severity error;
        start <= '0';
        wait for 2*clk_period + 10 ns;
        finish;
    end process;

    process
    begin
        raz_5b <= '1';
        start_5b <= '0';
        A_5b <= (others => '0');
        wait for 20 ns;
        raz_5b <= '0';

        A_5b <= std_logic_vector(to_signed(16, 10));
        start_5b <= '1';
        wait for clk_period;
        wait until done_5b = '1';
        assert unsigned(result_5b) = 4 report "sqrt(16) en 5b" severity error;
        wait;
    end process;

end architecture;

