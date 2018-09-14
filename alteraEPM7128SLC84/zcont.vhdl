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
SDCS		 : out std_logic := '1';  -- 
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

signal selector: STD_LOGIC_VECTOR (1 downto 0) := "00";
signal dataBus : STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";
signal iorqgeBus : std_logic := 'Z';
--signal port_read: std_logic := '0';
--signal port_read_sel: std_logic := '0';
--signal port_write: std_logic := '0';

shared variable count   : STD_LOGIC_VECTOR (3 downto 0) := "0000";
--signal mouseData : STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";
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

signal row0, row1, row2, row3, row4, row5, row6, row7 : std_logic_vector(4 downto 0);

signal kb_do_bus	: std_logic_vector(4 downto 0);

-- sd card signals

shared variable cnt		: std_logic_vector(3 downto 0) := "0000";
signal shift_in		: std_logic_vector(7 downto 0) := "11111111";
signal shift_out	: std_logic_vector(7 downto 0) := "11111111";
signal cnt_en		: std_logic := '0';
signal csn		: std_logic := '1';
signal enn		: std_logic := '1';	

signal zc_rd		: std_logic := '0';
signal zc_wr		: std_logic := '0';
signal zc_do_bus	: std_logic_vector(7 downto 0) := "ZZZZZZZZ";
--------------------------------------------------------------------------------
--                            ��������                                        --
--------------------------------------------------------------------------------

begin
	--------------------------------------------------------------------------------
	-- �������� ������ ������
	--------------------------------------------------------------------------------

	selector <= "01" when A(7 downto 0) = X"FE" and IORQ = '0' and RD = '0' and DOS = '1' and RES = '1' else
			    "10" when A(7 downto 6) = "01" and A(4 downto 0) = "10111" and IORQ = '0' and RD = '0' and DOS = '1' and RES = '1' else
			    "11" when A(7 downto 0) = X"DF" and IORQ = '0' and RD = '0' and DOS = '1' and RES = '1' else
				"00";
	
	--------------------------------------------------------------------------------
	-- ����������
	--------------------------------------------------------------------------------
	
	-- ��������� ������ ���������� � ����� �� PIC 			
	clk_proc : process (STROBE, RESTRIG, PB)
    begin
		if RESTRIG = '1' then
			count := "0000"; 
		else
			if STROBE'event and STROBE = '0' then --falling_edge STROBE'event and STROBE = '0'	
			
                if count = 0 then portA := PB(4 downto 0);
                elsif count = 1 then portB := PB(4 downto 0);
                elsif count = 2 then portC := PB(4 downto 0);
                elsif count = 3 then portD := PB(4 downto 0);
                elsif count = 4 then portE := PB(4 downto 0);
                elsif count = 5 then portF := PB(4 downto 0);
                elsif count = 6 then portG := PB(4 downto 0);
                elsif count = 7 then portH := PB(4 downto 0);
                --elsif count = 8 then portI := PB(2 downto 0);
                --elsif count = 9 then portJ := PB(7 downto 0);
                --elsif count = 10 then portK := PB(7 downto 0);
                end if;
                
                count := count + 1;
            end if;
        end if;
    end process;
    
    -- ������������ ������
	row0 <= portA when A(8) = '0' else (others => '1');
	row1 <= portB when A(9) = '0' else (others => '1');
	row2 <= portC when A(10) = '0' else (others => '1');
	row3 <= portD when A(11) = '0' else (others => '1');
	row4 <= portE when A(12) = '0' else (others => '1');
	row5 <= portF when A(13) = '0' else (others => '1');
	row6 <= portG when A(14) = '0' else (others => '1');
	row7 <= portH when A(15) = '0' else (others => '1');
	
	-- ����������� ������� ������������ �������
	kb_do_bus <= row0 and row1 and row2 and row3 and row4 and row5 and row6 and row7;

	--------------------------------------------------------------------------------
	-- SD �����
	--------------------------------------------------------------------------------

	-- �������� ������ ������ � ����� 77h, 57h
	zc_wr 	<= '1' when (IORQ = '0' and WR = '0' and DOS = '1' and A(7 downto 6) = "01" and A(4 downto 0) = "10111") else '0';
	zc_rd 	<= '1' when (IORQ = '0' and RD = '0' and DOS = '1' and A(7 downto 6) = "01" and A(4 downto 0) = "10111") else '0';

	-- ������ � 77h ����
	process (RES, SDTAKT, A(5), zc_wr, D)
	begin
		if RES = '0' then -- ��� ������� �� RESET ���������� ������� � ����������� ������ 
			csn <= '1'; -- CS to 1
			enn <= '1'; -- power off
		elsif SDTAKT'event and SDTAKT = '1' then 
			if (A(5) = '1' and zc_wr = '1') then -- ������ 0, 1-� �����
				enn <= not D(0); -- sd card power 0-off, 1-on
				csn <= D(1); -- CS
			end if;
		end if;
	end process;
	
	-- Z-Card	
	-- cnt (11) - 1110, 1111, 0000, 0001, 0010, 0011, 0100, 0101, 0110, 0111 1000 (stop)
	-- cnt_en       1     1     1     1     1     1     1     1     1     1    0
	-- SC           0     0   ...................SDTAKT.....................   0	
	process (SDTAKT, cnt_en, A(5), zc_rd, zc_wr)
	begin	
		if A(5) = '0' and zc_wr = '1' then 
			cnt := "1110"; 
			shift_out <= D;
		elsif A(5) = '0' and zc_rd = '1' then
			cnt := "1110"; 			
		else
			if SDTAKT'event and SDTAKT = '1' then
				if cnt(3) = '0' then
					shift_in <= shift_in(6 downto 0) & SDIN; 
				end if;
			end if;
			if SDTAKT'event and SDTAKT = '0' then 				
				if cnt(3) = '0' then 
					shift_out(7 downto 0) <= shift_out(6 downto 0) & '1';	
				end if;				
				if cnt(3) = '0' or cnt(2) = '1' or cnt(1) = '1' or cnt(0) = '1' then -- 1000 stop
					cnt := cnt + 1;	
				end if;
			end if;
		end if;
	end process;

	-- ���������� ���� � SD 
	SDDO  <= shift_out(7);
	-- ������ CS � SD
	SDCS  <= csn;
	-- ���������� �������� SD
	SDEN  <= enn;	
	-- �������� ������ SD 
	SC  <= SDTAKT and (not cnt(3));
	-- ���� ������ ��� ������ SD ������
	zc_do_bus <= cnt(3) & "11111" & SDRO & SDDET when A(5) = '1' else shift_in;
	--------------------------------------------------------------------------------
	-- ���� ������ ��� ������ �� ������
	--------------------------------------------------------------------------------
	
	process (selector, kb_do_bus, zc_do_bus, D)
	begin
		case selector is
			when "00" => IORQGE	<= 'Z';
			when others => IORQGE <= '1';
		end case;
		case selector is			
			when "01" => D <= "111" & kb_do_bus;	-- Read port #xxFE Keyboard
			when "10" => D <= zc_do_bus;			-- Z-Controller
			--when X"2" => BUS_D <= ms0_z(3 downto 0) & '1' & not ms0_b(2) & not ms0_b(0) & not ms0_b(1);		-- Mouse0 port key, z			
			when others => D <= "ZZZZZZZZ";
		end case;		
	end process;


	--D <= "111" & kb_do_bus when selector = "01" else
	--	 zc_do_bus when selector = "10" else 
	--	 "ZZZZZZZZ";
	--D <= dataBus;	 
	--IORQGE	<= 'Z' when selector = "00" else '1';	-- or selector = X"1" or selector = X"2"  1=aeiee?oai ii?oa a/a ia oeia Niaeo?oia
	
	
	
	--IORQGE <= iorqgeBus;
	
	-- debug
	
	--SDEN <= not keys(0)(0);
	
end RTL;

