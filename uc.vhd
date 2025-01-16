library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    generic
    (
        n : natural := 32
    );
    port
    (
        start : in std_logic;
        raz : in std_logic;
        clk : in std_logic;
        att : out std_logic;
        init : out std_logic;
        calcul : out std_logic;
        done : out std_logic
    );
end entity;

architecture uc_behavorial of uc is
    type etat is (ATTENDRE, INITIALISATION, CALC, FIN);
    signal present, futur : etat;
    signal i : unsigned(n-1 downto 0);
begin
    process (present) is
    begin
        att <= '0';
        init <= '0';
        done <= '0';
        calcul <= '0';
        case present is
            when ATTENDRE => done <= '0'; att <= '1';
            when INITIALISATION => init <= '1'; att <= '0';
            when CALC =>
                init <= '0';
                calcul <= '1';
            when FIN => done <= '1'; calcul <= '0';
        end case;
    end process;
    process (present, i, start) is
    begin
        futur <= present;
        case present is
            when ATTENDRE => if start = '1' or start = 'H' then futur <= INITIALISATION; else futur <= ATTENDRE; end if;
            when INITIALISATION => futur <= CALC;
            when CALC => if i = 0 then futur <= FIN; else futur <= CALC; end if;
            when FIN => if start = '1' or start = 'H' then futur <= FIN; else futur <= ATTENDRE; end if;
        end case;
    end process;
    process (raz, clk) is
        variable i_temp : unsigned(i'range);
    begin
        if raz then
            present <= ATTENDRE;
        elsif rising_edge(clk)
        then
            present <= futur;
            if present = INITIALISATION then
                i <= to_unsigned(n-1,n);
            elsif present = CALC then
                i_temp := i - 1;
                i <= i_temp;
            end if;
        end if;
    end process;
end uc_behavorial;

