library ieee;
use ieee.std_logic_1164.all;

entity additionneur is
    generic
    (
        n : natural := 32
    );
    port
    (
        x : in std_logic_vector(n - 1 downto 0);
        y : in std_logic_vector(n - 1 downto 0);
        retenue_0 : in std_logic;
        resultat : out std_logic_vector(n - 1 downto 0);
        retenue : out std_logic
    );
end entity;

architecture additionneur_archi of additionneur is
    signal resultat_prec_v, retenue_prec_v : std_logic_vector(n downto 0);
begin
    resultat_prec_v(0) <= '0';
    retenue_prec_v(0) <= retenue_0;
    g : for i in n - 1 downto 0
    generate
        u : entity work.additionneur_cascadable port map
        (
            x => x(i),
            y => y(i),
            retenue_prec => retenue_prec_v(i),
            resultat => resultat_prec_v(i + 1),
            retenue => retenue_prec_v(i + 1)
        );
    end generate;
    resultat <= resultat_prec_v(n downto 1);
    retenue <= retenue_prec_v(n);
end additionneur_archi;
