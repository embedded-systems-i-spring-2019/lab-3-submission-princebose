library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    Port ( clk,en,send,rst : in STD_LOGIC;
           char : in STD_LOGIC_VECTOR (7 downto 0);
           ready,tx : out STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is
type state is (idle,start,data);
signal current_state : state := idle;
signal TempData  : std_logic_vector(7 downto 0) := X"00";
begin
process(clk)
variable count : natural := 0;
begin

    if(rising_edge (clk)) then
        if rst = '1' then
            TempData <= X"00";
            current_state <= idle;
        end if;
    
        if en = '1' then
            case current_state is
                
                when idle => 
                    ready <= '1'; tx <= '1';
                    if send = '1' then
                        current_state <= start;
                    end if;
                
                when start => 
                    ready <= '0'; tx <= '0';
                    TempData <= char;
                    count := 0;
                    current_state <= data;
                
                when data =>
                    if count < 8 then
                        tx <= TempData(count);
                        count := count + 1;
                    else
                        tx <= '1';
                        current_state <= idle;
                    end if;
                end case;
        end if;
    end if;    
end process;

end Behavioral;
