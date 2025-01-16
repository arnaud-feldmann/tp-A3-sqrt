library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity racine_combinatorial_test is
    end entity;

architecture racine_combinatorial_test_arch of racine_combinatorial_test is
    signal A : std_logic_vector(63 downto 0);
    signal result : std_logic_vector(31 downto 0);
    signal clk : std_logic;
    constant clk_period : time := 50 ns;
    signal A_5b : std_logic_vector(9 downto 0);
    signal result_5b : std_logic_vector(4 downto 0);
begin
    r : entity work.racinecomb(Combinatorial)
    port map
    (
        A => A,
        result => result
    );
    r_5b : entity work.racinecomb(Combinatorial)
    generic map
    (
        n => 5
    )
    port map
    (
        A => A_5b,
        result => result_5b
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
        A <= (others => '0');
        wait for 20 ns;

        A <= std_logic_vector(to_signed(0, 64));
        wait for clk_period;
        assert unsigned(result) = 0 report "sqrt(0)" severity error;
        wait for 2*clk_period + 10 ns;

        A <= std_logic_vector(to_signed(1, 64));
        wait for clk_period;
        assert unsigned(result) = 1 report "sqrt(1)" severity error;
        wait for 2*clk_period + 10 ns;

        A <= std_logic_vector(to_signed(512, 64));
        wait for clk_period;
        assert unsigned(result) = 22 report "sqrt(512)" severity error;
        wait for 2*clk_period + 10 ns;

        A <= std_logic_vector(to_signed(1194877489, 64));
        wait for clk_period;
        assert unsigned(result) = 34567 report "sqrt(1104877489)" severity error;
        wait for 2*clk_period + 10 ns;

        A <= (31 downto 0 => '1', others => '0');
        wait for clk_period;
        assert unsigned(result) = 65535 report "sqrt(4294967295)" severity error;
        wait for 2*clk_period + 10 ns;
        finish;
    end process;

    process
    begin
        A_5b <= (others => '0');
        wait for 20 ns;

        A_5b <= std_logic_vector(to_signed(16, 10));
        wait for clk_period;
        assert unsigned(result_5b) = 4 report "sqrt(16) en 5b" severity error;
        wait;
    end process;

end architecture;

