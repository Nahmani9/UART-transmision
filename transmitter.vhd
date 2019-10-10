library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
entity transmitter is
   port ( resetN,clk     : in  std_logic ;
          din            : in  std_logic_vector ( 7 downto 0 ) ;
          write_din      : in  std_logic ;
          tx, tx_ready   : out std_logic ) ;
end transmitter ;
architecture arc_transmitter of transmitter is
   component shift_register 
       port ( resetN,clk,pl,se : in  std_logic ;
               din             :in std_logic_vector (7 downto 0 );
               LSB             : out std_logic ) ;
   end component ;
   component out_ff 
      port ( preN,clk : in  std_logic ;
             s,e,d,r  : in  std_logic ;  
             q        : out std_logic ) ;
   end component ;
   component  dcount 
      port ( resetN,clk : in  std_logic ;
             en, clr    : in  std_logic ;
             eoc        : out std_logic ) ;
   end component ;
   component tcount 
      port ( clrN,clk : in  std_logic ;
             te       : in  std_logic ;
             t1       : out std_logic ) ;
   end component ;
   component state_machine 
   port ( clrN,clk                 : in  std_logic ;
          write_din, eoc, t1       : in  std_logic ;
          ena_shift,ena_load       : out std_logic ;
          set_tx, ena_tx, clr_tx   : out std_logic ;
          ena_dcount, clr_dcount   : out std_logic ;
          te                       : out std_logic ) ;
   end component ;
   signal te,t1, set_tx, ena_tx, clr_tx, pl,LSB, eoc          : std_logic ;
   signal ena_shift, ena_load, ena_dcount, clr_dcount     : std_logic ;
begin
   pl <= ena_load and write_din ;
   p1: dcount port map ( resetN,clk,ena_dcount,clr_dcount,eoc ) ;
   p2: state_machine port map ( resetN,clk,write_din,eoc,t1,ena_shift,ena_load,set_tx,ena_tx,clr_tx,ena_dcount,clr_dcount,te );
   p3: shift_register port map ( resetN,clk,pl,ena_shift,din,LSB ) ;
   p4: out_ff port map ( resetN,clk,set_tx,ena_tx,LSB,clr_tx,tx ) ;
   p5: tcount port map ( resetN,clk,te,t1 ) ;
   tx_ready <= ena_load ;
end arc_transmitter ;