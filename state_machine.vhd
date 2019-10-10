library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
entity state_machine is
   port ( clrN,clk                 : in  std_logic ;
          write_din, eoc, t1       : in  std_logic ;
          ena_shift,ena_load       : out std_logic ;
          set_tx, ena_tx, clr_tx   : out std_logic ;
          ena_dcount, clr_dcount   : out std_logic ;
          te                       : out std_logic ) ;
end state_machine ;
architecture arc_state_machine of state_machine is
   type state is ( idle,send_start,clear_timer,send_data,test_eoc,shift_count,send_stop ) ;
   signal present_state, next_state : state ; 
begin
    process ( clk , clrN )
    begin
       if clrN = '0' then
          present_state <= idle ;
       elsif clk'event and clk = '1' then
          present_state <= next_state ;
       end if ;
    end process ;
    
    process ( present_state, write_din, eoc, t1 )
    begin
       ena_shift <= '0' ;  ena_load <= '0' ; clr_dcount <= '0' ; te <= '0' ;
       set_tx <= '0' ; ena_tx <= '0' ; clr_tx <= '0' ; ena_dcount <= '0' ;
       next_state <= idle ;
       case present_state is
          when idle =>
             ena_load <= '1' ; clr_dcount <= '1' ;
             if write_din ='1' then
                next_state <= send_start ;
             else
                next_state <= idle ;
             end if ;
          when send_start =>
             te <= '1' ; clr_tx <= '1' ;
             if t1 = '1' then
                next_state <= clear_timer ;
             else
                next_state <= send_start ;
             end if ;
          when clear_timer =>
             next_state <= send_data ;
          when send_data =>
             te <= '1' ; ena_tx <= '1' ;
             if t1 = '1' then
                next_state <= test_eoc ;
             else
                next_state <= send_data ;
             end if ;
          when test_eoc =>
             if eoc = '1' then
               next_state <= send_stop ;
             else
               next_state <= shift_count ;
             end if ;
          when shift_count =>
             ena_shift <= '1' ; ena_dcount <= '1' ;
             next_state <= send_data ;
          when send_stop =>
             te <= '1' ; set_tx <= '1' ;
             if t1 = '1' then
                next_state <= idle ;
             else
                next_state <= send_stop ;
             end if ;
       end case ;
   end process ;
end arc_state_machine ;