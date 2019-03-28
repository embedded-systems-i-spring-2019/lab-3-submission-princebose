library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sender_TOP is
    Port ( TXD : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (1 downto 0);
           clk : in STD_LOGIC;
           RXD : out STD_LOGIC;
           CTS : out STD_LOGIC;
           RTS : out STD_LOGIC);
end sender_TOP;

architecture Behavioral of sender_TOP is

component uart
 port (

   clk, en, send, rx, rst      : in std_logic;
   charSend                    : in std_logic_vector (7 downto 0);
   ready, tx, newChar          : out std_logic;
   charRec                     : out std_logic_vector (7 downto 0)

);
end component;

component debounce
    Port( clk : in STD_LOGIC;
       btn : in STD_LOGIC;
       dbnc : out STD_LOGIC);
end component;

component clock_div
port (
  clk : in std_logic;
  div : out std_logic
);
end component;

component sender
    Port ( clk : in STD_LOGIC;
       clk_en : in STD_LOGIC;
       rst : in STD_LOGIC;
       trigger : in STD_LOGIC;
       ready: in STD_LOGIC;
       send:  out STD_LOGIC; 
       char : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal RESET_BTN, Trigger : STD_LOGIC;
signal div,SEND,READY : STD_LOGIC;
signal char: STD_LOGIC_VECTOR(7 downto 0);

begin
rts<='0';
cts<='0';

Clock_Divider: clock_div
port map( clk => clk,
          div => div);

Debounce_Reset: debounce
port map(clk => clk,
       btn => btn(0),
       dbnc => RESET_BTN);

Debounce_Trigger: debounce
port map(clk => clk,
         btn => btn(1),
         dbnc => Trigger);

SenderDeclaration: sender
port map( clk => clk,
          trigger => Trigger,
          clk_en => div,
          ready => READY,
          rst => RESET_BTN,
          send => SEND,
          char => char);

uut: uart
port map(   clk=> clk,
            en => div,
            send => SEND,
            rx => TXD,
            rst => RESET_BTN,
            charSend => char,
            ready => READY,
            tx => RXD);
            

end Behavioral;
