----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.01.2019 09:30:30
-- Design Name: 
-- Module Name: mod_pixels - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod_pixels is
    Port ( 
    clk : in std_logic;
    vid_active_video : in STD_LOGIC;
    vid_data : in STD_LOGIC_VECTOR ( 23 downto 0 );
    vid_field_id : in STD_LOGIC;
    
    vid_hblank : in STD_LOGIC;
    vid_hsync : in STD_LOGIC;
    vid_vblank : in STD_LOGIC;

    vid_vsync : in STD_LOGIC;
    
  
    vid_pData : out STD_LOGIC_VECTOR ( 23 downto 0 );
    vid_pVDE : out STD_LOGIC;
    vid_pHSync : out STD_LOGIC;
    vid_pVSync : out STD_LOGIC);
end mod_pixels;

architecture Behavioral of mod_pixels is

signal counter_h : integer range 0 to 1920;
signal counter_v : integer range 0 to 1080;

constant left : integer := 200;
constant right : integer := 400;
constant top : integer := 200;
constant bot : integer := 400;
constant width : integer := 20;

begin

    process(clk)
    begin
        
        if rising_edge(clk) then
            counter_h <= counter_h + 1;
            if vid_hsync = '1' then
                counter_h <= 0;
                if counter_h /= 0 then
                    counter_v <= counter_v + 1;
                end if;
            end if;
            
            if vid_vsync = '1' then
                counter_v <= 0;
            end if;
            
        end if;
    
    end process;

    process(counter_v, counter_h)
    begin
        vid_pData(7 downto 0) <= vid_data(7 downto 0);
        vid_pData(15 downto 8) <= vid_data(15 downto 8);
        vid_pData(23 downto 16) <= vid_data(23 downto 16);

        if (counter_v > top - width and counter_v < bot + width) then
            if counter_h > left-width and counter_h < right+width then
                
                if counter_v <= top or counter_v >= bot or counter_h <= left or counter_h >=right then
                    vid_pData(7 downto 0) <= vid_data(23 downto 16);
                    vid_pData(15 downto 8) <= vid_data(7 downto 0);
                    vid_pData(23 downto 16) <= vid_data(15 downto 8);
                end if;
                
            end if;
        end if;
       

    
    
--        if counter_v < 300 then
--            vid_pData(7 downto 0) <= vid_data(15 downto 8);
--            vid_pData(15 downto 8) <= vid_data(23 downto 16);
--            vid_pData(23 downto 16) <= vid_data(7 downto 0);
--        elsif counter_v < 600 then
 --           vid_pData(7 downto 0) <= vid_data(7 downto 0);
--            vid_pData(15 downto 8) <= vid_data(15 downto 8);
--            vid_pData(23 downto 16) <= vid_data(23 downto 16);
--        else
--            vid_pData(7 downto 0) <= vid_data(23 downto 16);
--            vid_pData(15 downto 8) <= vid_data(7 downto 0);
 --           vid_pData(23 downto 16) <= vid_data(15 downto 8);
 --       end if;
    end process;
        
    
    vid_pVDE <= vid_active_video;
    vid_pHSync <= vid_hsync;
    vid_pVSync <= vid_vsync;

end Behavioral;
