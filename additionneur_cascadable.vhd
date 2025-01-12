library ieee;
use ieee.std_logic_1164.all;

entity additionneur_cascadable is port
    (
        x : in std_logic;
        y : in std_logic;
        retenue_prec : in std_logic;
        resultat : out std_logic;
        retenue : out std_logic
    );
end entity;

architecture additionneur_cascadable_archi of additionneur_cascadable is
begin
    resultat <= retenue_prec xor x xor y;
    retenue <= (retenue_prec and x) or (retenue_prec and y) or (x and y);
end additionneur_cascadable_archi;
