library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_div is
port (
  clk : in std_logic;
  div : out std_logic
);
end clock_div;

architecture clk_div of clock_div is
  signal count : std_logic_vector (25 downto 0) := (others => '0');
begin
  process(clk) 
  begin
    if rising_edge(clk) then
        if(unsigned(count) < 124999999/115200) then
        count <= std_logic_vector( unsigned(count) + 1 );
        div<='0';
        else
        
        count <= (others => '0');
        div<= '1';
        end if;
    end if;
  end process;
end clk_div;


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std.all;

--entity clock_div is
--    Port (clk: in std_logic;
--          div: out std_logic);
--end clock_div;

--architecture Behavioral of clock_div is

--signal counter  : std_logic_vector(26 downto 0) := (others => '0');
--begin
--    process(clk)
--        begin
--            if rising_edge(clk) then
--                if (unsigned(counter) < 62500000) then
--                    counter <= std_logic_vector(unsigned(counter) + 1) ;
--                    else 
--                        counter <= (others => '0');
--                 end if;
                 
--                 if (unsigned(counter) = 31250000) then 
--                    div <= '1';
--                 else 
--                    div <= '0';
--                 end if;
--            end if;
--    end process;
--end Behavioral;
