library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity reg_decg_accu_test is
    end entity;

architecture reg_decg_accu_test_arch of reg_decg_accu_test is
    signal entree_concat : std_logic_vector(1 downto 0);
    signal entree_chargement : std_logic_vector(4 downto 0);
    signal enable_chargement : std_logic;
    signal enable_decalage : std_logic;
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
        entree_concat => entree_concat,
        entree_chargement => entree_chargement,
        enable_chargement => enable_chargement,
        enable_decalage => enable_decalage,
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
        entree_concat <= "00";
        entree_chargement <= "11001";
        raz <= '1';
        enable_chargement <= '1';
        enable_decalage <= '1';
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
        enable_chargement <= '0';
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "00100" report "Premier décalage" severity error;
        entree_concat <= "10";
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "10010" report "Deuxième décalage" severity error;
        wait until clk = '1';
        wait for 10 ns;
        assert sortie = "01010" report "Troisième décalage" severity error;
        finish;
    end process;

end architecture;

