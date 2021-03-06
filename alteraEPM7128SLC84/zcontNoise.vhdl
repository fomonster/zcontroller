--------------------------------------------------------------------------------
--  �������� ���� ��� ����������: "Z Controller"                              --                        
--  ������:                                                 ����:             --
--  �����:   fomonster                                                        --
--                                                                            --
--  ����: EPM7128SLC84-15                                                     --
--------------------------------------------------------------------------------

library IEEE;
library altera; 
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use altera.altera_primitives_components.all;

entity zcontroller is
port
(

--------------------------------------------------------------------------------
--                    ������� ������� ���� �� ���������                       --
--------------------------------------------------------------------------------

-- ���� ������

A        : in std_logic_vector(15 downto 0) := "0000000000000000";

-- ����������� ������� ���������� Z80

IORQ	 : in std_logic := '1';  -- �������������� �����. �������� ������� - ������. ������ /IORQ ���������, ���
								 -- ���� ������ �������� ����� �������� ���������� ��� �������� ����� ��� ������. �����
								 -- ����, ������ IORQ ������������ ����� ��������� � �������� /M1 � ����� �������������
								 -- ����������. ��� ����� ����������, ������������ ����������, �����������, ��� ������
								 -- ���������� ����� ���� ������� �� ���� ������.

RD	 	 : in std_logic := '1';  -- �������������� �����. �������� ������� - ������. ������ /RD ���������, ��� ��
								 -- ��������� ���� ������ ������ �� ������ ��� ���������� �����-������. ������������
								 -- ���������� �����-������ ��� ������ ������ ������������ ���� ������ ��� �������������
								 -- ������ ������ �� ���� ������.

WR	 	 : in std_logic := '1';  -- �������������� �����. �������� ������� - ������. ������ /WR ���������, ���
								 -- ��������� ������ �� �� ������, ��������������� ��� ������ � ������������ ������
								 -- ������ ��� ���������� ������.

M1	 	 : in std_logic := '1';  -- ������������� �����. �������� ������� - ������. /M1 ���������, ��� � �������
								 -- �������� ����� ���������� ������ ���� �������� �� ������. ��� ���������� ����
								 
-- ����������� ������� ZX BUS
								 
DOS		 : in std_logic := '1';  -- ������, ������������, ����� �� �������  �����������  ���  �������  � ������  ������. 
								 -- ���� DOS/  = ���. 0, �� ������� ��� Monitor ��� TR - DOS, 
								 -- ���� DOS/ - ���. 1, �� ������� ��� Basic  128 ��� Basic 48.

IORQGE	 : inout std_logic := 'Z';  -- IRQGE on all ZX Spectrum models can disable only ula port #FE but all other port is always enable.
								 -- ������, �������������� ������������ ����������� ��� ���������� ��������� � ������ �����/������, 
								 -- ������������� �� �����. �� ���� ����� ������ ���� ��������� ������� ���. 1 �����, ����� ������� 
								 -- ���� �� ������� ���������. �� ���� ������ ������� ���� ���� ������ ���� �������� �� ������� ����. 
								 -- ��������� ������� ����������������� ������� ������ ������ �������� �� ���. 17. 
								 -- �� ����� ���� ������ ����������� �� IORQ/ (��� �������� �� ���. 18).

--------------------------------------------------------------------------------
--                     ������� ������� ���� PIC                               --
--------------------------------------------------------------------------------

PB        : in std_logic_vector(7 downto 0) := "00000000";
STROBE	  : in std_logic := '0';  
RESTRIG	  : in std_logic := '0';  

--------------------------------------------------------------------------------
--                     ������� ������� ���� NEMO IDE                          --
--------------------------------------------------------------------------------

WRH	  : out std_logic := '0';  
IOW	  : out std_logic := '1';
RDH	  : out std_logic := '1';
IOR	  : out std_logic := '0';  
EBL	  : out std_logic := '1';

--------------------------------------------------------------------------------
--                     ������� ������� ���� SD �����                          --
--------------------------------------------------------------------------------

SDTAKT		 : in std_logic := '0';  -- �������� ��������� ��� SD �����
SDDET		 : in std_logic := '0';  -- �������� SD
SDRO		 : in std_logic := '0';  -- ������ ������ ������
SDIN		 : in std_logic := '0';  -- 
SDCS		 : in std_logic := '0';  -- 
SDEN		 : out std_logic := '1';  -- ������� SD ����� (��������, ����� 0)
SDDO		 : out std_logic := '0';  -- 
SC			 : out std_logic := '0';  -- 

--------------------------------------------------------------------------------
--                     �������� ������� ���� � ���������
--------------------------------------------------------------------------------

-- ���� ������

D          : inout std_logic_vector(7 downto 0) := "ZZZZZZZZ";

-- ������

RES 	: in std_logic := '1'; -- �����. ����. �������� ������� - ������. ������ /RESET ����� ����� ������� ���������
								-- � �������� �� � ��������� ���������:
								--  - ����� �������� ������ PC=0000H;
								--  - ����� �������� ���������� ����������
								--  - ������� ��������� I � R;
								--  - ��������� ������ ���������� IM0.
								-- ��� ����������� ������ ������ /RESET ������ ���� ������� �� ����� 3-� ��������
								-- �������� �������. � ��� ����� �������� ���� � ���� ������ ��������� � �����������
								-- ���������, � ��� ������ �������� ���������� ���������.

NMI 	: in std_logic := '1';  -- ������������� ������ ����������
								-- ����, ����������� ������������� �������. ����� ������� ������������
								-- ���������� ������� NMI. ����� /NMI ����� ����� ������� ���������, ��� /INT � ������
								-- ������������ � ����� ���������� ������� �������, ���������� �� ��������� ��������
								-- ���������� ����������. /NMI ������������� ���������� ���������� (�������) �� � �����
								-- 66H. ���������� �������� ������ (����� ��������) ������������� ����������� �� �������
								-- �����. �. �. ������������ ����� ������������ � ���������� ���������.				

-- ������

IO0 : out std_logic := '0';
IO1 : out std_logic := '0';
IO2 : out std_logic := '0';
IO3 : out std_logic := '0';
IO4 : out std_logic := '0';
IO5 : out std_logic := '0';
IO6 : out std_logic := '0';
IO7 : out std_logic := '0';
IO3D : in std_logic := '0' -- ��������

);
end zcontroller;

architecture RTL of zcontroller is

--------------------------------------------------------------------------------
--                       ���������� ������� ����                              --
--------------------------------------------------------------------------------

--signal port_data : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
signal port_read: std_logic := '0';
signal port_write: std_logic := '0';
signal port_read_sel: STD_LOGIC_VECTOR (1 downto 0) := "00";

signal count : integer range 0 to 15 := 0;

--signal countA   : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
signal keyboardData : STD_LOGIC_VECTOR (4 downto 0) := "00000";
--signal mouseData : STD_LOGIC_VECTOR (7 downto 0) := "00000000";

-- keyboard ports data
signal portA : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal portB : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal portC : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal portD : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal portE : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal portF : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal portG : STD_LOGIC_VECTOR (4 downto 0) := "00000";
signal portH : STD_LOGIC_VECTOR (4 downto 0) := "00000";
-- mouse ports data
signal portI : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal portJ : STD_LOGIC_VECTOR (7 downto 0) := "11111111";
signal portK : STD_LOGIC_VECTOR (7 downto 0) := "11111111";

--type REG_TYPE is array (0 to 10) of std_logic_vector(7 downto 0);
--signal ports : REG_TYPE := (x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00");
     
--------------------------------------------------------------------------------
--                            ��������                                        --
--------------------------------------------------------------------------------

begin

	port_read <= '1' when IORQ = '0' and RD = '0' and M1 = '1' and DOS = '1' and IORQGE = '0' else '0';  -- 
	
	port_read_sel <= "00" when port_read = '0' else
					 "01"  when A(7 downto 0) = X"FE" else 
					 "10"  when A(7 downto 0) = X"DF" else 
					 "00";
	
	IORQGE <= '1' when port_read = '1' and ( not (port_read_sel = "00")) else 'Z';
	
	--port_write <= '1' when IORQ = '0' and RD = '0' and M1 = '1' and DOS = '1' and IORQGE = '0' else '0'; 

-- ���� ���������� #FE (254) "11111110"
--  ������
--   D0-D4 - ���������� ��������� ������������ �������� ���������� ZX Spectrum. 
--      ������� ���� ������ ����� #FE (254), � � ������� ������������ ��������������� ���.

--      �������� ������������� ������ ���������� ��������� ��� ������ ���������� ��� � ������� ����� ������ �����.
--   D6 - ���������� ��������� �������������� ����� (EAR).
--   D5, D7 - ������ �� ������������. 
--  ������
--   D0-D2 - ���������� ���� �������.
--   D3 - ��������� ���������� ������ ������ �� ���������� MIC.
--   D4 - ��������� ���������� ��������� (�������).
--   D5-D7 - ������ �� ������������.

-- ���� �����

	
	-- keyboard

	-- receive data from PIC ps2 reader
	
	-------------------

	clk_proc : process (STROBE)
    begin
        if falling_edge(STROBE) then
            if RESTRIG = '0' then
                
                --ports(count) <=  PB(7 downto 0);
                --case count is
				--	when 0 => ports(0) <= PB(4 downto 0);
				--	when 1 => ports(1) <= PB(4 downto 0);
				--	when 2 => ports(2) <= PB(4 downto 0);
				--	when 3 => ports(3) <= PB(4 downto 0);
				--	when 4 => ports(4) <= PB(4 downto 0);
				--	when 5 => ports(5) <= PB(4 downto 0);
				--	when 6 => ports(6) <= PB(4 downto 0);
				--	when 7 => ports(7) <= PB(4 downto 0);
				--	when 8 => ports(8) <= PB(7 downto 0);
				--	when 9 => ports(9) <= PB(7 downto 0);
				--	when 10 => ports(10) <= PB(7 downto 0);
				--	when others => null;
				--end case;
				--keyboardDataA <= keyboardDataA or PB(4 downto 0);
				
                if count = 0 then portA <= PB(4 downto 0);
                elsif count = 1 then portB <= PB(4 downto 0); 
                elsif count = 2 then portC <= PB(4 downto 0); 
                elsif count = 3 then portD <= PB(4 downto 0); 
                elsif count = 4 then portE <= PB(4 downto 0); 
                elsif count = 5 then portF <= PB(4 downto 0); 
                elsif count = 6 then portG <= PB(4 downto 0); 
                elsif count = 7 then portH <= PB(4 downto 0); 
                elsif count = 8 then portI <= PB(2 downto 0); 
                elsif count = 9 then portJ <= PB(7 downto 0);
                elsif count = 10 then portK <= PB(7 downto 0);
                end if;
                
                count <= count + 1;
            else				
                count <= 0;
            end if;
        end if;
    end process;
    
    
    
    -------------------
    
	--count <= "0000" when RESTRIG = '1' else count + X"1" when falling_edge(STROBE);
		
	-- keyboard
	--portA <= PB(4 downto 0) when count = X"0" and falling_edge(STROBE) else portA;
	--portB <= PB(4 downto 0) when count = X"1" and falling_edge(STROBE) else portB;
	--portC <= PB(4 downto 0) when count = X"2" and falling_edge(STROBE) else portC;
	--portD <= PB(4 downto 0) when count = X"3" and falling_edge(STROBE) else portD;
	--portE <= PB(4 downto 0) when count = X"4" and falling_edge(STROBE) else portE;
	--portF <= PB(4 downto 0) when count = X"5" and falling_edge(STROBE) else portF;
	--portG <= PB(4 downto 0) when count = X"6" and falling_edge(STROBE) else portG;
	--portH <= PB(4 downto 0) when count = X"7" and falling_edge(STROBE) else portH;
	--portG <= PB(4 downto 0) when STROBE = '0' else portG;
	
	-- mouse
	--portI <= PB when count = "1000" and falling_edge(STROBE);
	--portJ <= PB when count = "1001" and falling_edge(STROBE);
	--portK <= PB when count = "1010" and falling_edge(STROBE);
	
	--		#7FFE - Space...B "01111111" 
	--		#BFFE - Enter...H "10111111"
	--		#DFFE - P...Y     "11011111"
	--		#EFFE - 0...6     "11101111"
	--		#F7FE - 1...5     "11110111"
	--		#FBFE - Q...T     "11111011"
	--		#FDFE - A...G     "11111101" 
	--		#FEFE - CS...V    "11111110" 
	--		#FADF - buttons and wheel
	--		#FBDF � X-coord
	--		#FFDF � Y-coord 
	
			 

	
	keyboardData <= portA when A(8) = '0' else
					portB when A(9) = '0' else
					portC when A(10) = '0' else
					portD when A(11) = '0' else
					portE when A(12) = '0' else
					portF when A(13) = '0' else
					portG when A(14) = '0' else	 
					portH when A(15) = '0' else	
					portA or portB or portC or portD or portE or portF or portG or portH;
				
	
				 
	--key_proc: process (port_read_fe) 
	--begin
		
	--	if ( rising_edge(port_read_fe) ) then 
			
			-- keyboard
			--case A(15 downto 8) is
			--	when "11111110"  => keyboardData <= portA;
			--	when "11111101"  => keyboardData <= portB;
			--	when "11111011"  => keyboardData <= portC;
			--	when "11110111"  => keyboardData <= portD;
			--	when "11101111"  => keyboardData <= portE;
			--	when "11011111"  => keyboardData <= portF;
			--	when "10111111"  => keyboardData <= portG;
			--	when "01111111"  => keyboardData <= portH;
			--	when others => null;
			--end case;
	--		if A(8) = '0' then keyboardData <= portA;
	--		elsif A(9) = '0' then keyboardData <= portB;
	--		elsif A(10) = '0' then keyboardData <= portC;
	--		elsif A(11) = '0' then keyboardData <= portD;
	--		elsif A(12) = '0' then keyboardData <= portE;
	--		elsif A(13) = '0' then keyboardData <= portF;
	--		elsif A(14) = '0' then keyboardData <= portG;
	--		elsif A(15) = '0' then keyboardData <= portH;
	--		else keyboardData <= portA or portB or portC or portD or portE or portF or portG or portH;
	--		end if;

	--	end if;
		
	--end process;

	--mouse_proc: process (port_read_df) 
	--begin
		
	--	if ( rising_edge(port_read_df) ) then 
			
			-- mouse 
			
	--		if A(8) = '0' and A(10) = '0' then mouseData <= portI;
	--		elsif A(10) = '0' then mouseData <= portJ;
	--		else mouseData <= portK; 
	--		end if;

	--	end if;
		
	--end process;

	-- nemo ide
	
	
	
	-- sd card

	-- data bus
	
	--D(7 downto 0) <= "ZZZZZZZZ" when port_read_fe = '0' and port_read_df = '0' else
	--				 portI when A(8) = '0' and A(10) = '0' and port_read_df = '1' else
	--				 portJ when A(10) = '0' and port_read_df = '1' else
	--				 portK when port_read_df = '1' else						 
	--				 "111" & not portA when A(8) = '0' else
	--				 "111" & not portB when A(9) = '0' else 
	--				 "111" & not portC when A(10) = '0' else
	--				 "111" & not portD when A(11) = '0' else
	--				 "111" & not portE when A(12) = '0' else
	--				 "111" & not portF when A(13) = '0' else
	--				 "111" & not portG when A(14) = '0' else
	--				 "111" & not portH when A(15) = '0' else
	--				 "111" & not ( portA or portB or portC or portD or portE or portF or portG or portH );
					  
	
	D(7 downto 0) <= "111" & not keyboardData when port_read_sel = "01" else 
					"ZZZZZZZZ" when port_read_sel = "00" else
					"00000" & portI when A(15 downto 8) = X"FA" else 
					portJ when A(15 downto 8) = X"FB" else
					portK when A(15 downto 8) = X"FF" else
					"ZZZZZZZZ";
					
		
	SDEN <= not portG(1);
	
end RTL;

