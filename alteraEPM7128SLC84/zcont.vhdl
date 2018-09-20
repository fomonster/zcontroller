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
SDIN		 : in std_logic := '0';  -- данные от SD карты
SDCS		 : out std_logic := '0';  -- сигнал CS управления SD картой
SDEN		 : out std_logic := '1';  -- питание SD карты (включено, когда 0)
SDDO		 : out std_logic := '0';  -- данные к SD карте
SC			 : out std_logic := '0';  -- тактовые SD карты

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

signal selector: STD_LOGIC_VECTOR (2 downto 0) := "000";


shared variable count   : STD_LOGIC_VECTOR (3 downto 0) := "0000";
--signal mouseData : STD_LOGIC_VECTOR (7 downto 0) := "ZZZZZZZZ";

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
shared variable portI : STD_LOGIC_VECTOR (0 downto 0) := "0";
shared variable portJ : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
shared variable portK : STD_LOGIC_VECTOR (7 downto 0) := "00000000";

signal row0, row1, row2, row3, row4, row5, row6, row7 : std_logic_vector(4 downto 0);

signal kb_do_bus	: std_logic_vector(4 downto 0);

-- sd card signals

shared variable cnt		: std_logic_vector(3 downto 0) := "1000";
signal shift_in		: std_logic_vector(7 downto 0) := "11111111";
signal shift_out	: std_logic_vector(7 downto 0) := "11111111";
signal csn		: std_logic := '1';
signal enn		: std_logic := '1';	

signal read_port		: std_logic := '0';
signal write_port		: std_logic := '0';
signal zc_do_bus	: std_logic_vector(7 downto 0) := "ZZZZZZZZ";
--------------------------------------------------------------------------------
--                            ПРОЦЕССЫ                                        --
--------------------------------------------------------------------------------

begin
	--------------------------------------------------------------------------------
	-- селектор чтения портов
	--------------------------------------------------------------------------------
	read_port <= '1' when IORQ = '0' and RD = '0' and DOS = '1' and M1 = '1' else '0';
	write_port <= '1' when IORQ = '0' and WR = '0' and DOS = '1' and M1 = '1' else '0';
	
	-- селектор 
	selector <= "001" when A(7 downto 0) = X"FE" and read_port = '1' else -- порт клавиатуры
			    "010" when A(7 downto 6) = "01" and A(4 downto 0) = "10111" and write_port = '1' else -- запись портов ZCard
			    "011" when A(7 downto 6) = "01" and A(4 downto 0) = "10111" and read_port = '1' else -- чтение портов ZCard			    
			    "100" when A(15 downto 0) = X"FADF" and read_port = '1' else -- чтение портов мышки
			    "101" when A(15 downto 0) = X"FBDF" and read_port = '1' else 
			    "110" when A(15 downto 0) = X"FFDF" and read_port = '1' else 
			    --"001" when A(7 downto 0) = X"FE" and IORQ = '0' and RD = '0' and DOS = '1' else
				"000";
	
	-- селектор чтения записи в порты 77h, 57h
	--zc_wr <= '1' when selector = "010" else '0';
	--zc_rd <= '1' when selector = "011" else '0';
	
	--------------------------------------------------------------------------------
	-- Клавиатура
	--------------------------------------------------------------------------------
	
	-- получение данных клавиатуры и мышки от PIC 			
	clk_proc : process (STROBE, RESTRIG)
    begin
		if RESTRIG = '1' then
			count := "0000"; 
		else
			if STROBE'event and STROBE = '0' then --falling_edge STROBE'event and STROBE = '0'	
			
				case count is
					when X"0" => portA := PB(4 downto 0); -- Keyboard
					when X"1" => portB := PB(4 downto 0);
					when X"2" => portC := PB(4 downto 0);
					when X"3" => portD := PB(4 downto 0);
					when X"4" => portE := PB(4 downto 0);
					when X"5" => portF := PB(4 downto 0);
					when X"6" => portG := PB(4 downto 0);
					when X"7" => portH := PB(4 downto 0);
					when X"8" => portI := PB(0 downto 0); -- KempstonMouse
					when X"9" => portJ := PB(7 downto 0);
					when X"A" => portK := PB(7 downto 0);
					when others => null;
				end case;
                
                count := count + 1;
            end if;
        end if;
    end process;
    
    -- клавиатурная матица
	row0 <= portA when A(8) = '0' else (others => '1');
	row1 <= portB when A(9) = '0' else (others => '1');
	row2 <= portC when A(10) = '0' else (others => '1');
	row3 <= portD when A(11) = '0' else (others => '1');
	row4 <= portE when A(12) = '0' else (others => '1');
	row5 <= portF when A(13) = '0' else (others => '1');
	row6 <= portG when A(14) = '0' else (others => '1');
	row7 <= portH when A(15) = '0' else (others => '1');
	
	-- объединение колонок клавиатурной матрицы
	kb_do_bus <= row0 and row1 and row2 and row3 and row4 and row5 and row6 and row7;

	--------------------------------------------------------------------------------
	-- SD Карта ZCard
	--------------------------------------------------------------------------------

	
	--process (RES)
	--begin
	--	if RES = '0' then -- При нажатии на RESET сбрасываем питание и управляющий сигнал 
	--		SDCS <= '1'; -- CS to 1
	--		SDEN <= '1'; -- power off
--		elsif SDTAKT'event and SDTAKT = '1'  then --  rising_edge(SDTAKT)SDTAKT'event and SDTAKT = '1'
--			if (A(5) = '1' and zc_wr ) then -- запись 0, 1-х битов
--				enn <= D(0); -- sd card power 0-off, 1-on
--				csn <= D(1); -- CS
--			end if;
	--	end if;
	--end process;
	
	-- Z-Card	
	-- cnt (11) - 1110, 1111, 0000, 0001, 0010, 0011, 0100, 0101, 0110, 0111 1000 (stop)
	-- cnt_en       1     1     1     1     1     1     1     1     1     1    0
	-- SC           0     0   ...................SDTAKT.....................   0	
	process (SDTAKT, A(5), selector, RES)
	begin	
		if RES = '0' then -- 
			SDCS <= '1'; -- CS to 1
			SDEN <= '1'; -- power off
		end if;
		if ( selector = "010" or selector = "011" ) and cnt(3) = '1' then 
			cnt := "1101";
			if ( A(5) = '0' ) and ( selector = "010" ) then -- запись в порт 57h
				shift_out <= D;
			elsif ( A(5) = '1' ) then-- запись в порт 77h
				SDEN <= not D(0); -- sd card power 0-off, 1-on
				SDCS <= D(1); -- CS
			end if;
		else
			if SDTAKT'event and SDTAKT = '0'  then --falling_edge(SDTAKT) SDTAKT'event and SDTAKT = '0'
				if cnt(3) = '0' then 
					shift_out <= shift_out(6 downto 0) & '1';	
					shift_in <= shift_in(6 downto 0) & SDIN; --MISO					
				end if;				
				if not (cnt = "1000") then -- 1000 stop
					cnt := cnt + 1;	
				end if;
			end if;
		end if;
	end process;

	-- отправляем биты в SD 
	SDDO  <= shift_out(7); -- MOSI
	-- тактовый сигнал SD 
	--SC <= transport  (SDTAKT and (not cnt(3))) and enn after 60 ns;--125 ns;
	SC <= SDTAKT and (not cnt(3));
	-- шина данных при чтении SD портов
	zc_do_bus <= cnt(3) & "11111" & SDRO & SDDET when A(5) = '1' else shift_in;

	--------------------------------------------------------------------------------
	-- NemoIde
	--------------------------------------------------------------------------------
	
	
	
	--------------------------------------------------------------------------------
	-- Мышка
	--------------------------------------------------------------------------------
	
	--mouseData <= "1111111" & portI when A(15 downto 8) = X"FA" else	
	--			 portJ when A(15 downto 8) = X"FB" else	
	----			 portK when A(15 downto 8) = X"FF" else
	--			 "ZZZZZZZZ";
	
	--------------------------------------------------------------------------------
	-- Шина данных при чтении из портов
	--------------------------------------------------------------------------------
	
	process (selector, kb_do_bus, zc_do_bus, D)
	begin
		case selector is
			when "000" => IORQGE	<= 'Z';
			when others => IORQGE <= '1';
		end case;
		case selector is			
			when "001" => D <= "111" & kb_do_bus;	-- Read port #xxFE Keyboard
			when "011" => D <= zc_do_bus;			-- Z-Controller
			when "100" => D <= "1111111" & portI; -- Kempston Mouse Button
			when "101" => D <= portJ; -- Kempston Mouse X
			when "110" => D <= portK; -- Kempston Mouse Y
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

