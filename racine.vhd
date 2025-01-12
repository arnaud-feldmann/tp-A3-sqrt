library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity racine is
    generic
    (
        n : integer := 32
    );
    port
    (
        A : in std_logic_vector(2*n - 1 downto 0);
        clk : in std_logic;
        raz : in std_logic;
        start : in std_logic;
        result : out std_logic_vector(n - 1 downto 0);
        done : out std_logic
    );
end entity;

architecture racine_behavorial of racine is
    type etat is (ATTENDRE, INIT, CALC, FIN);
    signal present, futur : etat;
    signal i : unsigned(n-1 downto 0);
    signal D : unsigned(2*n - 1 downto 0);
    signal R : signed(2*n-1 downto 0);
    signal Z : signed(n-1 downto 0);
begin
    process (present, i, start) is
    begin
        futur <= present;
        case present is
            when ATTENDRE => if start = '1' or start = 'H' then futur <= INIT; else futur <= ATTENDRE; end if;
            when INIT => futur <= CALC;
            when CALC => if i = 0 then futur <= FIN; else futur <= CALC; end if;
            when FIN => if start = '1' or start = 'H' then futur <= FIN; else futur <= ATTENDRE; end if;
        end case;
    end process;
    process (raz, clk) is
        variable D_temp : unsigned(D'range);
        variable R_temp : signed(R'range);
        variable Z_temp : signed(Z'range);
        variable i_temp : unsigned(i'range);
    begin
        if raz then
            present <= ATTENDRE;
        elsif rising_edge(clk)
        then
            present <= futur;
            case present is
                when ATTENDRE => done <= '0';
                when INIT => i <= to_unsigned(n-1,n); D <= unsigned(A); R <= (others => '0'); Z <= (others => '0');
                when CALC =>
                    if R >= 0 then
                        R_temp := R+R+R+R + signed(shift_right(D, 2*n - 2)) - shift_left(signed(resize(Z, 2*n)), 2) - to_signed(1, 2*n);
                    else
                        R_temp := R+R+R+R + signed(shift_right(D, 2*n - 2)) + shift_left(signed(resize(Z, 2*n)), 2) + to_signed(3, 2*n);
                    end if;
                    if R_temp >= 0 then
                        Z_temp := shift_left(Z, 1) + 1;
                    else
                        Z_temp := shift_left(Z, 1);
                    end if;
                    D_temp := shift_left(D, 2);
                    i_temp := i - 1;
                    D <= D_temp;
                    R <= R_temp;
                    Z <= Z_temp;
                    i <= i_temp;
                when FIN => done <= '1'; result <= std_logic_vector(Z);
            end case;
        end if;
    end process;
end racine_behavorial;

