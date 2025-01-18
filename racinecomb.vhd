library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity racinecomb is
    generic
    (
        n : integer := 32
    );
    port
    (
        A : in std_logic_vector(2*n - 1 downto 0);
        result : out std_logic_vector(n - 1 downto 0)
    );
end entity;

architecture Combinatorial of racinecomb is
begin
    process (A) is
        variable A_valide : boolean;
        variable D_temp : unsigned(2*n - 1 downto 0);
        variable R_temp : signed(n + 2 downto 0);
        variable Z_temp : signed(n - 1 downto 0);
    begin
        result <= (others => '0');
        A_valide := true;
        for i in A'range loop
            if not (A(i) = '0' or A(i) = '1' or A(i) = 'L' or A(i) = 'H') then
                A_valide := false;
            end if;
        end loop;
        if A_valide then
            D_temp := unsigned(A);
            R_temp := (others => '0');
            Z_temp := (others => '0');
            for i in n - 1 downto 0 loop
                if R_temp >= 0 then
                    R_temp := (resize(R_temp, R_temp'length - 2) & signed(resize(shift_right(D_temp, 2*n - 2), 2))) - (signed(resize(Z_temp, R_temp'length - 2) & "01"));
                else
                    R_temp := (resize(R_temp, R_temp'length - 2) & signed(resize(shift_right(D_temp, 2*n - 2), 2))) + (signed(resize(Z_temp, R_temp'length - 2) & "11"));
                end if;
                if R_temp >= 0 then
                    Z_temp := shift_left(Z_temp, 1) + 1;
                else
                    Z_temp := shift_left(Z_temp, 1);
                end if;
                D_temp := shift_left(D_temp, 2);
            end loop;
            result <= std_logic_vector(Z_temp);
        end if;
    end process;
end Combinatorial;

