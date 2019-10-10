library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
entity out_ff is
   port ( preN,clk : in  std_logic ;
          s,e,d,r  : in  std_logic ;  
          q        : out std_logic ) ;
end out_ff ;
architecture arc_out_ff of out_ff is
   signal sampled1 , sampled2 : std_logic ;
begin
    process ( clk , preN )
    begin
       if preN = '0' then
          q <= '1' ;
       elsif clk'event and clk = '1' then
          if r = '1' then --start bit
             q <= '0' ;
          elsif s = '1' then --stop bit
             q <= '1' ;
          elsif e = '1' then --transmit bit
             q <= d ;
          end if ;
       end if ;
    end process ;
end arc_out_ff ;