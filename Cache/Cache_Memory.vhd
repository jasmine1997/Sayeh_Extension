library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cache_memory is
    port( clock:in STD_LOGIC;
          reset: in STD_LOGIC;
          read:in STD_LOGIC;
          write:in STD_LOGIC;
         address: in STD_LOGIC_VECTOR(9 downto 0);
         input_data: in STD_LOGIC_VECTOR(15 downto 0); --to_be_written(write this data in ram)--
         output_data: out STD_LOGIC_VECTOR(15 downto 0); -- this data has to be read 
         success: out STD_LOGIC
     );
end cache_memory;

architecture descr of cache_memory is
  
  
    component memory is
        port(clock:in STD_LOGIC;
             wr:in STD_LOGIC;
             -- Address size is equal to index + tag
             address:in STD_LOGIC_VECTOR(9 downto 0); --cpu full address
             input_data:in STD_LOGIC_VECTOR(15 downto 0);
             output_data:out STD_LOGIC_VECTOR(15 downto 0);
             ready:out STD_LOGIC := '0'
         );
    end component;
    
    
    component cache is
        port(clock:in STD_LOGIC;
         reset :in STD_LOGIC;
         write_enable:in STD_LOGIC;
         invalidate :in STD_LOGIC;
         Cpu_full_address :in STD_LOGIC_VECTOR(9 downto 0);
         write_data :in STD_LOGIC_VECTOR(15 downto 0);
         read_data: out STD_LOGIC_VECTOR(15 downto 0);
         
         is_ready: out STD_LOGIC := '1';
         success: out STD_LOGIC
         );
    end component;

  

    component cache_controller is
        port(  clock : in STD_LOGIC;
              read : in STD_LOGIC;
              write : in STD_LOGIC;
              
              hit : in STD_LOGIC;
            
             cache_is_ready: in STD_LOGIC := '0';
             memory_is_ready : in STD_LOGIC := '0';
             
             write_to_cache: out STD_LOGIC := '0';
             write_to_ram: out STD_LOGIC := '0';
             
             invalidate : out STD_LOGIC := '0'
            
         );
    end component;


    
    signal write_cache : STD_LOGIC;
    signal write_ram : STD_LOGIC;
    signal hit : STD_LOGIC;
    signal invalidate : STD_LOGIC;
    signal  enable : STD_LOGIC := '0';
   
    signal cache_is_ready : STD_LOGIC := '1';
    signal memory_is_ready : STD_LOGIC;
     
    signal memory_output : STD_LOGIC_VECTOR( 15 downto 0);
    signal cache_output : STD_LOGIC_VECTOR (15 downto 0);
    
    
     signal select_which_one : STD_LOGIC;

begin
    my_cache: cache port map(clock,reset,write_cache,invalidate, address, memory_output,cache_output,hit,cache_is_ready);
    my_ram : memory port map(clock, write_ram, address, input_data, memory_output, memory_is_ready);
    my_CU: cache_controller port map(clock , read, write, hit, cache_is_ready, memory_is_ready, write_cache,write_ram,invalidate);

  hit <= hit;
    select_which_one <= read;
  
  
  output_data <= cache_output when read = '1' else
  
               
              
              memory_output when write = '1' 
              else
                cache_output ; 
  
             
end descr;

