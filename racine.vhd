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

architecture Behavorial of racine is
    type etat is (ATTENDRE, INIT, CALC, FIN);
    signal present, futur : etat;
    signal i : unsigned(n - 1 downto 0);
    signal D : unsigned(2*n - 1 downto 0);
    signal R : signed(n downto 0);
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
                        R_temp := (resize(R, R'length - 2) & signed(resize(shift_right(D, 2*n - 2), 2))) - (resize(Z, R'length - 2) & "01");
                    else
                        R_temp := (resize(R, R'length - 2) & signed(resize(shift_right(D, 2*n - 2), 2))) + (resize(Z, R'length - 2) & "11");
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
end Behavorial;

architecture Structural of racine is
    signal D : std_logic_vector(2*n - 1 downto 0);
    signal R : std_logic_vector(n downto 0);
    signal Z : std_logic_vector(n - 1 downto 0);
    signal att : std_logic;
    signal init : std_logic;
    signal calcul : std_logic;
    signal done_temp : std_logic;
    signal Z_plus : std_logic_vector(R'range);
    signal R_add : std_logic_vector(R'range);
    signal R_futur : std_logic_vector(R'range);
begin
    done <= done_temp;
    result <= Z;

    -- uc
    uc_inst : entity work.uc
    generic map
    (
        n => n
    )
    port map
    (
        start => start,
        raz => raz,
        clk => clk,
        att => att,
        init => init,
        calcul => calcul,
        done => done_temp
    );

    -- R
    Z_plus <= (Z(R'high - 2 downto 0) & "01") when not R(R'high) else (Z(R'high - 2 downto 0) & "11");
    addi : entity work.additionneur_soustracteur
    generic map
    (
        n => R'length
    )
    port map
    (
        x => R(R'high - 2 downto 0) & D(D'high downto D'high - 1),
        y => Z_plus,
        soustract_y => not R(R'high),
        resultat => R_add
    );
    R_futur <= (others => '0') when init else R_add;
    r_reg : entity work.reg_decg_accu
    generic map
    (
        n => R'length,
        d => 0
    )
    port map
    (
        entree_chargement => R_futur,
        entree_concat => "",
        enable_chargement => init or calcul,
        enable_decalage => '0',
        raz => raz or att,
        clk => clk,
        sortie => R
    );

    -- Z
    z_reg : entity work.reg_decg_accu
    generic map
    (
        n => n,
        d => 1
    )
    port map
    (
        entree_concat => (0 downto 0 => not R_futur(R_futur'high)),
        entree_chargement => (others => '0'),
        enable_chargement => init,
        enable_decalage => calcul,
        raz => raz or att,
        clk => clk,
        sortie => Z
    );

    --D
    D_reg : entity work.reg_decg_accu
    generic map
    (
        n => 2*n,
        d => 2
    )
    port map
    (
        entree_concat => "00",
        entree_chargement => A,
        enable_chargement => init,
        enable_decalage => calcul,
        raz => raz or att,
        clk => clk,
        sortie => D
    );

end Structural;

