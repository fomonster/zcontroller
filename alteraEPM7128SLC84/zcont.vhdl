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
--                     ������� ������� ���� ����������                        --
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

signal port_read: std_logic := '0';

signal port_write: std_logic := '0';

signal count   : STD_LOGIC_VECTOR (7 downto 0) := X"00";

signal countA   : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";

-- ������� ����������

signal sdbuffer : STD_LOGIC_VECTOR (7 downto 0) := X"00";
--------------------------------------------------------------------------------
--                            ��������                                        --
--------------------------------------------------------------------------------

begin

-- ���� ���������� #FE (254) "11111110"
--  ������
--   D0-D4 - ���������� ��������� ������������ �������� ���������� ZX Spectrum. 
--      ������� ���� ������ ����� #FE (254), � � ������� ������������ ��������������� ���.
--		#7FFE - ������� Space...B "01111111" 
--		#BFFE - ������� Enter...H "10111111"
--		#DFFE - ������� P...Y     "11011111"
--		#EFFE - ������� 0...6     "11101111"
--		#F7FE - ������� 1...5     "11110111"
--		#FBFE - ������� Q...T     "11111011"
--		#FDFE - ������� A...G     "11111101" 
--		#FEFE - ������� CS...V    "11111110" 
--      �������� ������������� ������ ���������� ��������� ��� ������ ���������� ��� � ������� ����� ������ �����.
--   D6 - ���������� ��������� �������������� ����� (EAR).
--   D5, D7 - ������ �� ������������. 
--  ������
--   D0-D2 - ���������� ���� �������.
--   D3 - ��������� ���������� ������ ������ �� ���������� MIC.
--   D4 - ��������� ���������� ��������� (�������).
--   D5-D7 - ������ �� ������������.

--������� ����� ���������� ��� a1,a2,a5,DOS/=1;IORQGE=0
--process ( IORQ )
--begin
	
	--if A(7 DOWNTO 0) = "11111110" THEN
		
		
	  
	  
	--end if;
	
--end process;

-- ���� �����
--		#FADF � ���� ������ � (�� �������������� ���������) �������. "1111101011011111"
--			D0: ����� ������ (0=������)
--			D1: ������ ������ (0=������)
--			D2: ������� ������ (0=������)
--			D3: ��������������� ��� ��� ���� ������ (0=������)
--			D4-D7: ���������� �������
--		#FBDF � X-���������� (����� ����� �������) "1111101111011111"
--		#FFDF � Y-���������� (����� ����� �����)   "1111111111011111"

	--process ( SDTAKT )
	--begin
	--	if ( rising_edge(SDTAKT ) ) then
	--		countA <= countA + '1';
	--		if countA(24) = '1' then
	--			count <= count + '1';
	--		end if;
	--	end if;
			
		--if ( IORQ = '0' and RD = '0' ) then
			
			--count <= count + '1';
			
			--case A is
			--	when X"FBDF" => D <= count;
			--	when others => D <= "ZZZZZZZZ";			
			--end case;
		--else 
		--	D <= "ZZZZZZZZ";
		--end if;

	--end process;

	-- debug
	SDEN <= PB(1);
	
	-- 
	
	--port_read <= '1' when IORQ = '0' and RD = '0' and M1 = '1' and DOS = '1' and IORQGE = '0' else '0'; 
	
	--port_write <= '1' when IORQ = '0' and RD = '0' and M1 = '1' and DOS = '1' and IORQGE = '0' else '0'; 
	
	-- keyboard
	
	--IORQGE <= '1' when port_access = '1' and A(7 downto 0) = X"FE" else 'Z';
	
	
	--D(7 downto 0) <= "ZZZ11111" when port_access = '1' and A(15 downto 0) = X"7FFE" else -- #7FFE
	--				 "ZZZ11111" when port_access = '1' and A(15 downto 0) = X"BFFE" else -- #BFFE
	--				 "ZZZ11111" when port_access = '1' and A(15 downto 0) = X"DFFE" else -- #DFFE
	--				 "ZZZ1111" & count(0) when port_access = '1' and A(15 downto 0) = X"EFFE" else -- #EFFE
	--				 "ZZZ11111" when port_access = '1' and A(15 downto 0) = X"F7FE" else -- #F7FE
	--				 "ZZZ11111" when port_access = '1' and A(15 downto 0) = X"FBFE" else -- #FBFE
	--				 "ZZZ11111" when port_access = '1' and A(15 downto 0) = X"FDFE" else -- #FDFE
	--				 "ZZZ11111" when port_access = '1' and A(15 downto 0) = X"FEFE" else -- #FEFE	
	--				 "ZZZ1111" & count(0) when port_access = '1' and A(7 downto 0) = X"FE" else -- #FE
	--				 "ZZZZZZZZ";
	
	
	-- mouse
	
	

	-- nemo ide
	
	
	
	-- sd card
	
	
	
end RTL;
