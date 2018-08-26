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

signal dataBus : STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";
signal iorqgeBus : std_logic := 'Z';
signal port_read: std_logic := '0';
signal port_read_sel: std_logic := '0';
signal port_write: std_logic := '0';

shared variable count   : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal mouseData : STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";
--signal countA   : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";

-- keyboard ports data
shared variable portA : STD_LOGIC_VECTOR (4 downto 0) := "00000";
shared variable portB : STD_LOGIC_VECTOR (4 downto 0) := "00000";
shared variable portC : STD_LOGIC_VECTOR (4 downto 0) := "00000";
shared variable portD : STD_LOGIC_VECTOR (4 downto 0) := "00000";
shared variable portE : STD_LOGIC_VECTOR (4 downto 0) := "00000";
shared variable portF : STD_LOGIC_VECTOR (4 downto 0) := "00000";
shared variable portG : STD_LOGIC_VECTOR (4 downto 0) := "00000";
shared variable portH : STD_LOGIC_VECTOR (4 downto 0) := "00000";
-- mouse ports data
shared variable portI : STD_LOGIC_VECTOR (2 downto 0) := "000";
shared variable portJ : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
shared variable portK : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
--------------------------------------------------------------------------------
--                            ��������                                        --
--------------------------------------------------------------------------------

begin

	port_read <= '1' when (IORQ = '0') and (RD = '0') and (M1 = '1') and (DOS = '1')  else '0';  -- and (IORQGE = '0')
	
	--mouseData <= "11111" & portI(2 downto 0) when ( A(15 downto 8) = X"FA" ) else
	--			  portJ(7 downto 0) when ( A(15 downto 8) = X"FB" ) else
	--			  portK(7 downto 0) when ( A(15 downto 8) = X"FF" ) else
	--			  "11111111";
				  
	--port_read_sel <= '0' when (A(7 downto 0) = X"FE") else 
	--				 '1' when (A(7 downto 0) = X"DF") else
	--				 'Z';
					 
	
	--IORQGE <= 'Z' when (port_read = '0' ) or (port_read_sel = 'Z') else '1';
	
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
                
                if count = 0 then portA := PB(4 downto 0);
                elsif count = 1 then portB := PB(4 downto 0);
                elsif count = 2 then portC := PB(4 downto 0);
                elsif count = 3 then portD := PB(4 downto 0);
                elsif count = 4 then portE := PB(4 downto 0);
                elsif count = 5 then portF := PB(4 downto 0);
                elsif count = 6 then portG := PB(4 downto 0);
                elsif count = 7 then portH := PB(4 downto 0);
                elsif count = 8 then portI := PB(2 downto 0);
                elsif count = 9 then portJ := PB(7 downto 0);
                elsif count = 10 then portK := PB(7 downto 0);
                end if;
                
                count := count + 1;
            else
                count := "0000"; --(others => '0');
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
	
	

	-- works but bad
	--D(7 downto 0) <= "ZZZZZZZZ" when (port_read = '0') or (port_read_sel = 'Z') else	
	--				 mouseData(7 downto 0) when port_read_sel = '1' else
					 --"11111" & portI when ( A(15 downto 8) = X"FA" ) and (port_read_sel = "10") else	
					--portJ when ( A(15 downto 8) = X"FB" ) and (port_read_sel = "10")  else
					--portK when ( A(15 downto 8) = X"FF" ) and (port_read_sel = "10")  else				
	--				 "111" & not portA(4 downto 0) when A(15 downto 8) = X"FE" else 
	--				 "111" & not portB(4 downto 0) when A(15 downto 8) = X"FD" else 
	--				 "111" & not portC(4 downto 0) when A(15 downto 8) = X"FB" else 
	--				 "111" & not portD(4 downto 0) when A(15 downto 8) = X"F7" else
	--				 "111" & not portE(4 downto 0) when A(15 downto 8) = X"EF" else 
	--				 "111" & not portF(4 downto 0) when A(15 downto 8) = X"DF" else 
	--				 "111" & not portG(4 downto 0) when A(15 downto 8) = X"BF" else 
	--				 "111" & not portH(4 downto 0) when A(15 downto 8) = X"7F" else
	--				 "111" & not (portA(4 downto 0) or portB(4 downto 0) or portC(4 downto 0) or portD(4 downto 0) or portE(4 downto 0) or portF(4 downto 0) or portG(4 downto 0) or portH(4 downto 0));
	
  data_bus : process(port_read)
  begin
	if (port_read = '1') and (IORQGE = '0') then
		if (A(7 downto 0) = X"FE") then
			
			if A(15 downto 8) = X"FE" then dataBus <= "111" & not portA(4 downto 0);
			elsif A(15 downto 8) = X"FD" then dataBus <= "111" & not portB(4 downto 0);
			elsif A(15 downto 8) = X"FB" then dataBus <= "111" & not portC(4 downto 0);
			elsif A(15 downto 8) = X"F7" then dataBus <= "111" & not portD(4 downto 0);
			elsif A(15 downto 8) = X"EF" then dataBus <= "111" & not portE(4 downto 0);
			elsif A(15 downto 8) = X"DF" then dataBus <= "111" & not portF(4 downto 0);
			elsif A(15 downto 8) = X"BF" then dataBus <= "111" & not portG(4 downto 0);
			elsif A(15 downto 8) = X"7F" then dataBus <= "111" & not portH(4 downto 0);
			else dataBus <= "111" & not (portA(4 downto 0) or portB(4 downto 0) or portC(4 downto 0) or portD(4 downto 0) or portE(4 downto 0) or portF(4 downto 0) or portG(4 downto 0) or portH(4 downto 0));
			end if;
			
			iorqgeBus <= '1';

		elsif (A(7 downto 0) = X"DF") then
			
			if A(15 downto 8) = X"FA" then dataBus <= "11111111"; -- & not portI(2 downto 0);
			elsif A(15 downto 8) = X"FB" then dataBus <= portJ(7 downto 0);
			elsif A(15 downto 8) = X"FF" then dataBus <= portK(7 downto 0);
			else dataBus <= "ZZZZZZZZ";
			end if;		
			
			iorqgeBus <= '1';
		else
			
			dataBus <= "ZZZZZZZZ";
			iorqgeBus <= 'Z';
			
		end if;
	else
			
		dataBus <= "ZZZZZZZZ";
		iorqgeBus <= 'Z';
				
	end if;
  end process data_bus;
  
  D(7 downto 0) <= dataBus;
  IORQGE <= iorqgeBus;
  
		--case port_read_sel is
			--when "01" =>  "11110000";
					 --if "111" & not portA(4 downto 0) when A(15 downto 8) = X"FE" else 
					 --"111" & not portB(4 downto 0) when A(15 downto 8) = X"FD" else 
					 --"111" & not portC(4 downto 0) when A(15 downto 8) = X"FB" else 
					 --"111" & not portD(4 downto 0) when A(15 downto 8) = X"F7" else
					 --"111" & not portE(4 downto 0) when A(15 downto 8) = X"EF" else 
					 ---"111" & not portF(4 downto 0) when A(15 downto 8) = X"DF" else 
					 --"111" & not portG(4 downto 0) when A(15 downto 8) = X"BF" else 
					 --"111" & not portH(4 downto 0) when A(15 downto 8) = X"7F" else
					 --"111" & not (portA(4 downto 0) or portB(4 downto 0) or portC(4 downto 0) or portD(4 downto 0) or portE(4 downto 0) or portF(4 downto 0) or portG(4 downto 0) or portH(4 downto 0));
			--when "10" => "11111111";
			--when others =>  "ZZZZZZZZ";
					 --portI when port_read = '1' and A(15 downto 0) = X"FADF" else 
					 --portJ when port_read = '1' and A(15 downto 0) = X"FBDF" else
					 --portK when port_read = '1' and A(15 downto 0) = X"FFDF" else	
	--end case;
	
	-- mouse
	
	

	-- nemo ide
	
	
	
	-- sd card
	--portG <= PB(4 downto 0);
	SDEN <= not portG(0);
	
end RTL;

