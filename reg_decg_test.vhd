library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity reg_decg_test is
    end entity;

architecture reg_decg_test_arch of reg_decg_test is
    signal entree : std_logic_vector(4 downto 0);
    signal load : std_logic;
    signal decalage : std_logic;
    signal raz: std_logic;
    signal clk : std_logic;
    signal sortie : std_logic_vector(4 downto 0);
begin
    ra_test : entity work.reg_decg
    generic map
    (
        n => 5,
        d => 2 
    )
    port map
    (
        entree => entree,
        load => load,
        decalage => decalage,
        raz => raz,
        clk => clk,
        sortie => sortie
    );

    process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;

    process
    begin
        entree <= "11001";
        raz <= '1';
        load <= '1';
        decalage <= '0';
        wait until clk = '1';
        wait for 10 ns;
        raz<= '0';
        assert sortie = "00000" report "remise à zéro avant set" severity error;
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "11001" report "load" severity error;
        load <= '0';
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "11001" report "on n'a pas encore le décalage à gauche" severity error;
        decalage <= '1';
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "00100" report "premier décalage" severity error;
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "10000" report "Deuxième décalage" severity error;
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "00000" report "Troisième décalage" severity error;
        wait until clk = '1';
        wait for 10 ns;
        load<= '1';
        entree <= "00001";
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "00001" report "Recharge 1 + loadprioritaire sur Dg" severity error;
        load<= '0';
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "00100" report "Recharge 2" severity error;
        finish;
    end process;

end architecture;

