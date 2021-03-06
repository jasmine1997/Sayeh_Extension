library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

---------------------
entity Mru is
    port( clock : in STD_LOGIC;
          address : in STD_LOGIC_VECTOR(5 downto 0);
          x : in STD_LOGIC;
          enable : in STD_LOGIC;
          reset : in STD_LOGIC;
          set_0_valid : out STD_LOGIC;
          set_1_valid:  out STD_LOGIC
     );
end entity;

architecture bhv of Mru is
    type data_array is array (63 downto 0) of integer;
    signal set_0 : data_array := (others => 0);
    signal set_1 : data_array := (others => 0);
    signal my_signal: STD_LOGIC;
    signal Most_recently_used_address : STD_LOGIC_VECTOR(5 downto 0);
   
begin
    process (clock,reset,enable)
    begin
        if(reset = '1') then
            
            --initialize set1 to '0'--  
            if(x = '1') then
                set_1(to_integer(unsigned(address))) <= 0;
            elsif(x='0') then 
              --initialize set0 to '0'--
                set_0(to_integer(unsigned(address))) <= 0;
            end if;
            
            --initialize the address of cpu
            Most_recently_used_address  <= "UUUUUU";
            my_signal <= 'U';
         
        elsif(enable = '1') then
            if(x = '0' and ( (my_signal ='1') or (Most_recently_used_address /= address )) )then   -- /=:not equal to 
                set_0(to_integer(unsigned(address))) <= set_0(to_integer(unsigned(address))) + 1;
                --putting the address
                 Most_recently_used_address <= address;
              
               my_signal <= x;
          
            elsif(  (x = '1') and ((my_signal='0')  or (Most_recently_used_address /= address) )) then  
                set_1(to_integer(unsigned(address))) <= set_1(to_integer(unsigned(address))) + 1;
                Most_recently_used_address  <= address;
                my_signal <= x;
            end if;

            if((set_0(to_integer(unsigned(address))) <= set_1(to_integer(unsigned(address))))) then
                                                     set_0_valid <= '1';
                                                 else
                                                     set_1_valid <= '0';
                                                 end if;
        end if;

    end process;
end bhv;