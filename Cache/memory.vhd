LIBRARY ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

------------
----a simple ram 
----@---------

entity memory is
    port(clock:in STD_LOGIC;
         wr:in STD_LOGIC;
         -- Address size is equal to index + tag
         address:in STD_LOGIC_VECTOR(9 downto 0); --cpu full address
         input_data:in STD_LOGIC_VECTOR(15 downto 0);
         output_data:out STD_LOGIC_VECTOR(15 downto 0);
         ready:out STD_LOGIC := '0'
     );
end memory;

architecture bhv of memory is
    type array_of_data is array (1023 downto 0) of STD_LOGIC_VECTOR (15 downto 0); --10 address bit , 1024 address line
    signal data_array : array_of_data;
begin
    output_data <= data_array(to_integer(unsigned(address)));

    process(clock)
    begin
        ready <= '0';
        if(wr = '1') then
            data_array(to_integer(unsigned(address))) <= input_data;
        end if;

        ready <= '1';

    end process;

end bhv;

