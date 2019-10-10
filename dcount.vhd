library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
entity dcount is
   port ( resetN,clk : in  std_logic ;
          en, clr    : in  std_logic ;
          eoc        : out std_logic ) ;
end dcount ;
architecture arc_dcount of dcount is
   signal count : integer range 0 to 7  ;
begin
    process ( clk , resetN )
    begin
       if resetN = '0' then
          count <= 0 ;
       elsif clk'event and clk = '1' then
          if clr = '1' then
             count <= 0 ;
          elsif en = '1' and count < 7 then
             count <= count + 1 ;
          end if ;
       end if ;
    end process ;
    eoc <= '1' when count = 7 else '0' ;
end arc_dcount ;