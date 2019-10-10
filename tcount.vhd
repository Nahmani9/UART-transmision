library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
entity tcount is
   port ( clrN,clk : in  std_logic ;
          te    : in  std_logic ;
          t1        : out std_logic ) ;
end tcount ;
architecture arc_tcount of tcount is
   signal count : integer range 0 to 511 ;
   constant clockfreq : integer := 25000000 ; --33333000 for nios
   constant baud      : integer := 115200 ;
   constant t1_count  : integer := clockfreq / baud ; --218
begin
    process ( clk , clrN )
    begin
       if clrN = '0' then
          count <= 0 ; 
       elsif clk'event and clk = '1' then
          if te = '0' then
             count <= 0 ;  
          elsif count < t1_count then
             count <= count + 1 ; 
          end if ;
       end if ;
    end process ;
    t1 <= '0' when count < t1_count else '1' ;
end arc_tcount ;