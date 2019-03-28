library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sender is
    Port ( clk : in STD_LOGIC;
           clk_en : in STD_LOGIC;
           rst : in STD_LOGIC;
           trigger : in STD_LOGIC;
           ready: in STD_LOGIC;
           send:  out STD_LOGIC; 
           char : out STD_LOGIC_VECTOR (7 downto 0));
end sender;

architecture Behavioral of sender is

type word is array (0 to 4) of STD_LOGIC_VECTOR(7 downto 0);
type state is (idle,busyA,busyB,busyC);
signal current_state : state := idle;
signal netID : word := (X"70",X"6b",X"62",X"34",X"34");
signal i : STD_LOGIC_VECTOR(2 downto 0) := "000";

begin

process(clk)
begin
    if (rising_edge(clk) and (clk_en = '1')) then
        if rst = '1' then
            send <= '0';
            char <= X"00";
            i <= "000";
            current_state <= idle;
        end if;
        case current_state is
            when idle => 
                if ready ='1' and trigger = '1' then
                    if unsigned(i) < 5 then
                        send <= '1';
                        char <= netID(natural(to_integer(unsigned(i))));
                        i <= STD_LOGIC_VECTOR(unsigned(i)+1);
                        current_state <= busyA;
                    else
                        i <= "000";
                    end if;
                end if;
            when busyA =>
                current_state <= busyB;
            when busyB =>
                send <= '0';
                current_state <= busyC;
            when busyC =>
                if ready ='1' and trigger = '0' then
                    current_state <= idle;
                end if;
        end case;
    end if;
end process;

end Behavioral;
