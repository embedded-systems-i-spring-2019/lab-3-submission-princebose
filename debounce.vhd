library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity debounce is
    Port( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           dbnc : out STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
signal sh : std_logic_vector(1 downto 0) := "00";
signal cnt_value : std_logic_vector(22 downto 0):=(others => '0');
begin
process(clk,btn)
begin

if (rising_edge(clk)) then
    sh(1) <= sh(0);
    sh(0) <= btn;
    if (unsigned(cnt_value) < 2499999) then
        dbnc <= '0';
        if (sh(1) = '1') then
            cnt_value <= std_logic_vector(unsigned(cnt_value)+1);
        else
            cnt_value <= (others => '0');
        end if;
    else
        dbnc <= '1';
        if(btn = '0') then
            dbnc <= '0';
            cnt_value <= (others => '0');
        end if;
    end if;
end if;
end process;
end Behavioral;
