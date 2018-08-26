--------------------------------------------------------------------------------
--  ПРОШИВКА ПЛИС ДЛЯ УСТРОЙСТВА: "Z Controller"                              --                        
--  ВЕРСИЯ:                                                 ДАТА:             --
--  АВТОР:   fomonster                                                        --
--                                                                            --
--  ПЛИС: EPM7128SLC84-15                                                     --
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
--                    ВХОДНЫЕ СИГНАЛЫ ПЛИС СО СПЕКТРУМА                       --
--------------------------------------------------------------------------------

-- шина адреса

A        : in std_logic_vector(15 downto 0) := "0000000000000000";

-- управляющие сигналы процессора Z80

IORQ	 : in std_logic := '1';  -- Трехстабильный выход. Активный уровень - низкий. Сигнал /IORQ указывает, что
								 -- пика адреса содержит адрес внешнего устройства для операции ввода или вывода. Кроме
								 -- того, сигнал IORQ генерируется также совместно с сигналом /M1 в цикле подтверждения
								 -- прерывания. Тем самым устройству, запросившему прерывание, указывается, что вектор
								 -- прерывания может быть помещен на шину данных.

RD	 	 : in std_logic := '1';  -- Трехстабильный выход. Активный уровень - низкий. Сигнал /RD указывает, что ЦП
								 -- выполняет цикл чтения данных из памяти или устройства ввода-вывода. Адресованное
								 -- устройство ввода-вывода или память должны использовать этот сигнал для стробирования
								 -- подачи данных на шину данных.

WR	 	 : in std_logic := '1';  -- Трехстабильный выход. Активный уровень - низкий. Сигнал /WR указывает, что
								 -- процессор выдает на ШД данные, предназначенные для записи в адресованную ячейку
								 -- памяти или устройство вывода.

M1	 	 : in std_logic := '1';  -- Трёхстабильный выход. Активный уровень - низкий. /M1 указывает, что в текущей
								 -- машинном цикле происходит чтение кода операции из памяти. При считывании кода
								 
-- управляющие сигналы ZX BUS
								 
DOS		 : in std_logic := '1';  -- сигнал, показывающий, какая из половин  внутреннего  ПЗУ  выбрана  в данный  момент. 
								 -- Если DOS/  = лог. 0, то выбрано ПЗУ Monitor или TR - DOS, 
								 -- если DOS/ - лог. 1, то выбрано ПЗУ Basic  128 или Basic 48.

IORQGE	 : inout std_logic := 'Z';  -- IRQGE on all ZX Spectrum models can disable only ula port #FE but all other port is always enable.
								 -- сигнал, вырабатываемый периферийным устройством для блокировки обращения к портам ввода/вывода, 
								 -- расположенным на плате. На этом входе должен быть выставлен уровень лог. 1 тогда, когда выбрано 
								 -- одно из внешних устройств. Во всех других случаях этот вход должен быть отключен от внешних схем. 
								 -- Примерный вариант схемотехнического решения данной задачи приведен на рис. 17. 
								 -- На плате этот сигнал формируется из IORQ/ (как показано на рис. 18).

--------------------------------------------------------------------------------
--                     ВХОДНЫЕ СИГНАЛЫ ПЛИС PIC                               --
--------------------------------------------------------------------------------

PB        : in std_logic_vector(7 downto 0) := "00000000";
STROBE	  : in std_logic := '0';  
RESTRIG	  : in std_logic := '0';  

--------------------------------------------------------------------------------
--                     ВХОДНЫЕ СИГНАЛЫ ПЛИС NEMO IDE                          --
--------------------------------------------------------------------------------

WRH	  : out std_logic := '0';  
IOW	  : out std_logic := '1';
RDH	  : out std_logic := '1';
IOR	  : out std_logic := '0';  
EBL	  : out std_logic := '1';

--------------------------------------------------------------------------------
--                     ВХОДНЫЕ СИГНАЛЫ ПЛИС SD КАРТА                          --
--------------------------------------------------------------------------------

SDTAKT		 : in std_logic := '0';  -- тактовый генератор для SD карты
SDDET		 : in std_logic := '0';  -- детектор SD
SDRO		 : in std_logic := '0';  -- сигнал только чтение
SDIN		 : in std_logic := '0';  -- 
SDCS		 : in std_logic := '0';  -- 
SDEN		 : out std_logic := '1';  -- питание SD карты (включено, когда 0)
SDDO		 : out std_logic := '0';  -- 
SC			 : out std_logic := '0';  -- 

--------------------------------------------------------------------------------
--                     ВЫХОДНЫЕ СИГНАЛЫ ПЛИС К СПЕКТРУМУ
--------------------------------------------------------------------------------

-- шина данных

D          : inout std_logic_vector(7 downto 0) := "ZZZZZZZZ";

-- другие

RES 	: in std_logic := '1'; -- Сброс. Вход. Активный уровень - низкий. Сигнал /RESET имеет самый высокий приоритет
								-- и приводит ЦП в начальное состояние:
								--  - сброс счетчика команд PC=0000H;
								--  - сброс триггера разрешения прерываний
								--  - очистка регистров I и R;
								--  - установка режима прерываний IM0.
								-- Для корректного сброса сигнал /RESET должен быть активен не менее 3-х периодов
								-- тактовой частоты. В это время адресная шина и шина данных находятся в высокоомном
								-- состоянии, а все выходы сигналов управления неактивны.

NMI 	: in std_logic := '1';  -- Немаскируемый запрос прерывания
								-- Вход, запускаемый отрицательным фронтом. Фронт запуска активизирует
								-- внутренний триггер NMI. Линия /NMI имеет более высокий приоритет, чем /INT и всегда
								-- распознается в конце выполнения текущей команды, независимо от состояния триггера
								-- разрешения прерываний. /NMI автоматически производит перезапуск (рестарт) ЦП с адрес
								-- 66H. Содержимое счётчика команд (адрес возврата) автоматически сохраняется во внешнем
								-- стеке. Т. о. пользователь может возвратиться к прерванной программе.				

-- другое

IO0 : out std_logic := '0';
IO1 : out std_logic := '0';
IO2 : out std_logic := '0';
IO3 : out std_logic := '0';
IO4 : out std_logic := '0';
IO5 : out std_logic := '0';
IO6 : out std_logic := '0';
IO7 : out std_logic := '0';
IO3D : in std_logic := '0' -- дубликат

);
end zcontroller;

architecture RTL of zcontroller is

--------------------------------------------------------------------------------
--                       ВНУТРЕННИЕ СИГНАЛЫ ПЛИС                              --
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
--                            ПРОЦЕССЫ                                        --
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

-- ПОРТ КЛАВИАТУРЫ #FE (254) "11111110"
--  чтение
--   D0-D4 - отображают состояние определённого полуряда клавиатуры ZX Spectrum. 
--      младший байт всегда равен #FE (254), а в старшем сбрасывается соответствующий бит.

--      Возможно одновременное чтение нескольких полурядов при сбросе нескольких бит в старшем байте адреса порта.
--   D6 - отображает состояние магнитофонного входа (EAR).
--   D5, D7 - обычно не используются. 
--  запись
--   D0-D2 - определяют цвет бордюра.
--   D3 - управляет состоянием выхода записи на магнитофон MIC.
--   D4 - управляет внутренним динамиком (бипером).
--   D5-D7 - обычно не используются.

-- ПОРТ МЫШКИ

	
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
	--		#FBDF — X-coord
	--		#FFDF — Y-coord 
	
	

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

