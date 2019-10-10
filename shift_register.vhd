library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
entity shift_register is
   port ( resetN,clk,pl,se : in  std_logic ;
          din           :in std_logic_vector (7 downto 0 );
          LSB           : out std_logic ) ;
end shift_register ;
architecture arc_shift_register of shift_register is
   signal din_n : std_logic_vector (7 downto 0 ) ;
begin
    process ( clk , resetN )
    begin
       if resetN = '0' then
          din_n <= "00000000" ;
       elsif clk'event and clk = '1' then
          if pl = '1' then
             din_n <= din ;
          elsif se = '1' then
             din_n <=  '0' & din_n (7 downto 1 );
          end if ;
       end if ;
    end process ;
    LSB <= din_n(0) ;
end arc_shift_register ;