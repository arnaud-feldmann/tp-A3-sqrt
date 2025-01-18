library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity reg_decg_accu_test is
    end entity;

architecture reg_decg_accu_test_arch of reg_decg_accu_test is
    signal entree_add : std_logic_vector(4 downto 0);
    signal entree_concat : std_logic_vector(1 downto 0);
    signal enable : std_logic;
    signal raz: std_logic;
    signal clk : std_logic;
    signal sortie : std_logic_vector(4 downto 0);
begin
    ra_test : entity work.reg_decg_accu
    generic map
    (
        n => 5,
        d => 2 
    )
    port map
    (
        entree_add => entree_add,
        entree_concat => entree_concat,
        enable => enable,
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
        entree_add <= "11001";
        entree_concat <= "00";
        raz <= '1';
        enable <= '1';
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "00000" report "remise à zéro avant set" severity error;
        wait for 10 ns;
        wait until clk = '1';
        raz<= '0';
        assert sortie = "00000" report "ne se remplit pas si raz" severity error;
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "11001" report "Chargement" severity error;
        entree_add <= "00001";
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "00101" report "Premier décalage" severity error;
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "10101" report "Deuxième décalage" severity error;
        entree_add <= "00111";
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "11011" report "Troisième décalage" severity error;
        entree_add <= "00111";
        entree_concat <= "10";
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "10101" report "Décalage avec concaténation" severity error;
        finish;
    end process;

end architecture;

