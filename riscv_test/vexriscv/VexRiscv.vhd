-- Generator : SpinalHDL v1.4.3    git head : adf552d8f500e7419fff395b7049228e4bc5de26
-- Component : VexRiscv
-- Git hash  : 36b3cd918896c94c4e8a224d97c559ab6dbf3ec9

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

package pkg_enum is
  type BranchCtrlEnum is (INC,B,JAL,JALR);
  type ShiftCtrlEnum is (DISABLE_1,SLL_1,SRL_1,SRA_1);
  type AluBitwiseCtrlEnum is (XOR_1,OR_1,AND_1);
  type EnvCtrlEnum is (NONE,XRET);
  type Src2CtrlEnum is (RS,IMI,IMS,PC);
  type AluCtrlEnum is (ADD_SUB,SLT_SLTU,BITWISE);
  type Src1CtrlEnum is (RS,IMU,PC_INCREMENT,URS1);

  function pkg_mux (sel : std_logic; one : BranchCtrlEnum; zero : BranchCtrlEnum) return BranchCtrlEnum;
  subtype BranchCtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant BranchCtrlEnum_defaultEncoding_INC : BranchCtrlEnum_defaultEncoding_type := "00";
  constant BranchCtrlEnum_defaultEncoding_B : BranchCtrlEnum_defaultEncoding_type := "01";
  constant BranchCtrlEnum_defaultEncoding_JAL : BranchCtrlEnum_defaultEncoding_type := "10";
  constant BranchCtrlEnum_defaultEncoding_JALR : BranchCtrlEnum_defaultEncoding_type := "11";

  function pkg_mux (sel : std_logic; one : ShiftCtrlEnum; zero : ShiftCtrlEnum) return ShiftCtrlEnum;
  subtype ShiftCtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant ShiftCtrlEnum_defaultEncoding_DISABLE_1 : ShiftCtrlEnum_defaultEncoding_type := "00";
  constant ShiftCtrlEnum_defaultEncoding_SLL_1 : ShiftCtrlEnum_defaultEncoding_type := "01";
  constant ShiftCtrlEnum_defaultEncoding_SRL_1 : ShiftCtrlEnum_defaultEncoding_type := "10";
  constant ShiftCtrlEnum_defaultEncoding_SRA_1 : ShiftCtrlEnum_defaultEncoding_type := "11";

  function pkg_mux (sel : std_logic; one : AluBitwiseCtrlEnum; zero : AluBitwiseCtrlEnum) return AluBitwiseCtrlEnum;
  subtype AluBitwiseCtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : AluBitwiseCtrlEnum_defaultEncoding_type := "00";
  constant AluBitwiseCtrlEnum_defaultEncoding_OR_1 : AluBitwiseCtrlEnum_defaultEncoding_type := "01";
  constant AluBitwiseCtrlEnum_defaultEncoding_AND_1 : AluBitwiseCtrlEnum_defaultEncoding_type := "10";

  function pkg_mux (sel : std_logic; one : EnvCtrlEnum; zero : EnvCtrlEnum) return EnvCtrlEnum;
  subtype EnvCtrlEnum_defaultEncoding_type is std_logic_vector(0 downto 0);
  constant EnvCtrlEnum_defaultEncoding_NONE : EnvCtrlEnum_defaultEncoding_type := "0";
  constant EnvCtrlEnum_defaultEncoding_XRET : EnvCtrlEnum_defaultEncoding_type := "1";

  function pkg_mux (sel : std_logic; one : Src2CtrlEnum; zero : Src2CtrlEnum) return Src2CtrlEnum;
  subtype Src2CtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant Src2CtrlEnum_defaultEncoding_RS : Src2CtrlEnum_defaultEncoding_type := "00";
  constant Src2CtrlEnum_defaultEncoding_IMI : Src2CtrlEnum_defaultEncoding_type := "01";
  constant Src2CtrlEnum_defaultEncoding_IMS : Src2CtrlEnum_defaultEncoding_type := "10";
  constant Src2CtrlEnum_defaultEncoding_PC : Src2CtrlEnum_defaultEncoding_type := "11";

  function pkg_mux (sel : std_logic; one : AluCtrlEnum; zero : AluCtrlEnum) return AluCtrlEnum;
  subtype AluCtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant AluCtrlEnum_defaultEncoding_ADD_SUB : AluCtrlEnum_defaultEncoding_type := "00";
  constant AluCtrlEnum_defaultEncoding_SLT_SLTU : AluCtrlEnum_defaultEncoding_type := "01";
  constant AluCtrlEnum_defaultEncoding_BITWISE : AluCtrlEnum_defaultEncoding_type := "10";

  function pkg_mux (sel : std_logic; one : Src1CtrlEnum; zero : Src1CtrlEnum) return Src1CtrlEnum;
  subtype Src1CtrlEnum_defaultEncoding_type is std_logic_vector(1 downto 0);
  constant Src1CtrlEnum_defaultEncoding_RS : Src1CtrlEnum_defaultEncoding_type := "00";
  constant Src1CtrlEnum_defaultEncoding_IMU : Src1CtrlEnum_defaultEncoding_type := "01";
  constant Src1CtrlEnum_defaultEncoding_PC_INCREMENT : Src1CtrlEnum_defaultEncoding_type := "10";
  constant Src1CtrlEnum_defaultEncoding_URS1 : Src1CtrlEnum_defaultEncoding_type := "11";

end pkg_enum;

package body pkg_enum is
  function pkg_mux (sel : std_logic; one : BranchCtrlEnum; zero : BranchCtrlEnum) return BranchCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : ShiftCtrlEnum; zero : ShiftCtrlEnum) return ShiftCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : AluBitwiseCtrlEnum; zero : AluBitwiseCtrlEnum) return AluBitwiseCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : EnvCtrlEnum; zero : EnvCtrlEnum) return EnvCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : Src2CtrlEnum; zero : Src2CtrlEnum) return Src2CtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : AluCtrlEnum; zero : AluCtrlEnum) return AluCtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : Src1CtrlEnum; zero : Src1CtrlEnum) return Src1CtrlEnum is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

end pkg_enum;


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic;
  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector;
  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector;
  function pkg_not (value : std_logic_vector) return std_logic_vector;
  function pkg_extract (that : unsigned; bitId : integer) return std_logic;
  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned;
  function pkg_cat (a : unsigned; b : unsigned) return unsigned;
  function pkg_not (value : unsigned) return unsigned;
  function pkg_extract (that : signed; bitId : integer) return std_logic;
  function pkg_extract (that : signed; base : unsigned; size : integer) return signed;
  function pkg_cat (a : signed; b : signed) return signed;
  function pkg_not (value : signed) return signed;

  function pkg_mux (sel : std_logic; one : std_logic; zero : std_logic) return std_logic;
  function pkg_mux (sel : std_logic; one : std_logic_vector; zero : std_logic_vector) return std_logic_vector;
  function pkg_mux (sel : std_logic; one : unsigned; zero : unsigned) return unsigned;
  function pkg_mux (sel : std_logic; one : signed; zero : signed) return signed;

  function pkg_toStdLogic (value : boolean) return std_logic;
  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector;
  function pkg_toUnsigned (value : std_logic) return unsigned;
  function pkg_toSigned (value : std_logic) return signed;
  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector;
  function pkg_unsigned (lit : unsigned) return unsigned;
  function pkg_signed (lit : signed) return signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector;
  function pkg_resize (that : unsigned; width : integer) return unsigned;
  function pkg_resize (that : signed; width : integer) return signed;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector;
  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned;
  function pkg_extract (that : signed; high : integer; low : integer) return signed;

  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector;
  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;

  function pkg_shiftRight (that : unsigned; size : natural) return unsigned;
  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned;
  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned;

  function pkg_shiftRight (that : signed; size : natural) return signed;
  function pkg_shiftRight (that : signed; size : unsigned) return signed;
  function pkg_shiftLeft (that : signed; size : natural) return signed;
  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector;
end  pkg_scala2hdl;

package body pkg_scala2hdl is
  function pkg_extract (that : std_logic_vector; bitId : integer) return std_logic is
  begin
    return that(bitId);
  end pkg_extract;

  function pkg_extract (that : std_logic_vector; base : unsigned; size : integer) return std_logic_vector is
   constant elementCount : integer := (that'length-size)+1;
   type tableType is array (0 to elementCount-1) of std_logic_vector(size-1 downto 0);
   variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := that(i + size - 1 downto i);
    end loop;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : std_logic_vector; b : std_logic_vector) return std_logic_vector is
    variable cat : std_logic_vector(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;

  function pkg_extract (that : unsigned; bitId : integer) return std_logic is
  begin
    return that(bitId);
  end pkg_extract;

  function pkg_extract (that : unsigned; base : unsigned; size : integer) return unsigned is
   constant elementCount : integer := (that'length-size)+1;
   type tableType is array (0 to elementCount-1) of unsigned(size-1 downto 0);
   variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := that(i + size - 1 downto i);
    end loop;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : unsigned; b : unsigned) return unsigned is
    variable cat : unsigned(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : unsigned) return unsigned is
    variable ret : unsigned(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;

  function pkg_extract (that : signed; bitId : integer) return std_logic is
  begin
    return that(bitId);
  end pkg_extract;

  function pkg_extract (that : signed; base : unsigned; size : integer) return signed is
   constant elementCount : integer := (that'length-size)+1;
   type tableType is array (0 to elementCount-1) of signed(size-1 downto 0);
   variable table : tableType;
  begin
    for i in 0 to elementCount-1 loop
      table(i) := that(i + size - 1 downto i);
    end loop;
    return table(to_integer(base));
  end pkg_extract;

  function pkg_cat (a : signed; b : signed) return signed is
    variable cat : signed(a'length + b'length-1 downto 0);
  begin
    cat := a & b;
    return cat;
  end pkg_cat;

  function pkg_not (value : signed) return signed is
    variable ret : signed(value'length-1 downto 0);
  begin
    ret := not value;
    return ret;
  end pkg_not;


  -- unsigned shifts
  function pkg_shiftRight (that : unsigned; size : natural) return unsigned is
  begin
    if size >= that'length then
      return "";
    else
      return shift_right(that,size)(that'length-1-size downto 0);
    end if;
  end pkg_shiftRight;

  function pkg_shiftRight (that : unsigned; size : unsigned) return unsigned is
  begin
    return shift_right(that,to_integer(size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : unsigned; size : natural) return unsigned is
  begin
    return shift_left(resize(that,that'length + size),size);
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : unsigned; size : unsigned) return unsigned is
  begin
    return shift_left(resize(that,that'length + 2**size'length - 1),to_integer(size));
  end pkg_shiftLeft;

  -- std_logic_vector shifts
  function pkg_shiftRight (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : std_logic_vector; size : natural) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  -- signed shifts
  function pkg_shiftRight (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftRight(unsigned(that),size));
  end pkg_shiftRight;

  function pkg_shiftRight (that : signed; size : unsigned) return signed is
  begin
    return shift_right(that,to_integer(size));
  end pkg_shiftRight;

  function pkg_shiftLeft (that : signed; size : natural) return signed is
  begin
    return signed(pkg_shiftLeft(unsigned(that),size));
  end pkg_shiftLeft;

  function pkg_shiftLeft (that : signed; size : unsigned; w : integer) return signed is
  begin
    return shift_left(resize(that,w),to_integer(size));
  end pkg_shiftLeft;

  function pkg_rotateLeft (that : std_logic_vector; size : unsigned) return std_logic_vector is
  begin
    return std_logic_vector(rotate_left(unsigned(that),to_integer(size)));
  end pkg_rotateLeft;

  function pkg_extract (that : std_logic_vector; high : integer; low : integer) return std_logic_vector is
    variable temp : std_logic_vector(high-low downto 0);
  begin
    temp := that(high downto low);
    return temp;
  end pkg_extract;

  function pkg_extract (that : unsigned; high : integer; low : integer) return unsigned is
    variable temp : unsigned(high-low downto 0);
  begin
    temp := that(high downto low);
    return temp;
  end pkg_extract;

  function pkg_extract (that : signed; high : integer; low : integer) return signed is
    variable temp : signed(high-low downto 0);
  begin
    temp := that(high downto low);
    return temp;
  end pkg_extract;

  function pkg_mux (sel : std_logic; one : std_logic; zero : std_logic) return std_logic is
  begin
    if sel = '1' then
      return one;
    else
      return zero;
    end if;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : std_logic_vector; zero : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : unsigned; zero : unsigned) return unsigned is
    variable ret : unsigned(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_mux (sel : std_logic; one : signed; zero : signed) return signed is
    variable ret : signed(zero'range);
  begin
    if sel = '1' then
      ret := one;
    else
      ret := zero;
    end if;
    return ret;
  end pkg_mux;

  function pkg_toStdLogic (value : boolean) return std_logic is
  begin
    if value = true then
      return '1';
    else
      return '0';
    end if;
  end pkg_toStdLogic;

  function pkg_toStdLogicVector (value : std_logic) return std_logic_vector is
    variable ret : std_logic_vector(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toStdLogicVector;

  function pkg_toUnsigned (value : std_logic) return unsigned is
    variable ret : unsigned(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toUnsigned;

  function pkg_toSigned (value : std_logic) return signed is
    variable ret : signed(0 downto 0);
  begin
    ret(0) := value;
    return ret;
  end pkg_toSigned;

  function pkg_stdLogicVector (lit : std_logic_vector) return std_logic_vector is
    variable ret : std_logic_vector(lit'length-1 downto 0);
  begin
    ret := lit;
    return ret;
  end pkg_stdLogicVector;

  function pkg_unsigned (lit : unsigned) return unsigned is
    variable ret : unsigned(lit'length-1 downto 0);
  begin
    ret := lit;
    return ret;
  end pkg_unsigned;

  function pkg_signed (lit : signed) return signed is
    variable ret : signed(lit'length-1 downto 0);
  begin
    ret := lit;
    return ret;
  end pkg_signed;

  function pkg_resize (that : std_logic_vector; width : integer) return std_logic_vector is
  begin
    return std_logic_vector(resize(unsigned(that),width));
  end pkg_resize;

  function pkg_resize (that : unsigned; width : integer) return unsigned is
    variable ret : unsigned(width-1 downto 0);
  begin
    if that'length = 0 then
       ret := (others => '0');
    else
       ret := resize(that,width);
    end if;
    return ret;
  end pkg_resize;
  function pkg_resize (that : signed; width : integer) return signed is
    variable ret : signed(width-1 downto 0);
  begin
    if that'length = 0 then
       ret := (others => '0');
    elsif that'length >= width then
       ret := that(width-1 downto 0);
    else
       ret := resize(that,width);
    end if;
    return ret;
  end pkg_resize;
end pkg_scala2hdl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity StreamFifoLowLatency is
  port(
    io_push_valid : in std_logic;
    io_push_ready : out std_logic;
    io_push_payload_error : in std_logic;
    io_push_payload_inst : in std_logic_vector(31 downto 0);
    io_pop_valid : out std_logic;
    io_pop_ready : in std_logic;
    io_pop_payload_error : out std_logic;
    io_pop_payload_inst : out std_logic_vector(31 downto 0);
    io_flush : in std_logic;
    io_occupancy : out unsigned(0 downto 0);
    clk : in std_logic;
    reset : in std_logic
  );
end StreamFifoLowLatency;

architecture arch of StreamFifoLowLatency is
  signal zz_4 : std_logic;
  signal zz_5 : std_logic;
  signal zz_6 : std_logic;

  signal zz_1 : std_logic;
  signal pushPtr_willIncrement : std_logic;
  signal pushPtr_willClear : std_logic;
  signal pushPtr_willOverflowIfInc : std_logic;
  signal pushPtr_willOverflow : std_logic;
  signal popPtr_willIncrement : std_logic;
  signal popPtr_willClear : std_logic;
  signal popPtr_willOverflowIfInc : std_logic;
  signal popPtr_willOverflow : std_logic;
  signal ptrMatch : std_logic;
  signal risingOccupancy : std_logic;
  signal empty : std_logic;
  signal full : std_logic;
  signal pushing : std_logic;
  signal popping : std_logic;
  signal zz_2 : std_logic_vector(32 downto 0);
  signal zz_3 : std_logic_vector(32 downto 0);
begin
  io_push_ready <= zz_4;
  io_pop_valid <= zz_5;
  zz_6 <= (not empty);
  process(pushing)
  begin
    zz_1 <= pkg_toStdLogic(false);
    if pushing = '1' then
      zz_1 <= pkg_toStdLogic(true);
    end if;
  end process;

  process(pushing)
  begin
    pushPtr_willIncrement <= pkg_toStdLogic(false);
    if pushing = '1' then
      pushPtr_willIncrement <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_flush)
  begin
    pushPtr_willClear <= pkg_toStdLogic(false);
    if io_flush = '1' then
      pushPtr_willClear <= pkg_toStdLogic(true);
    end if;
  end process;

  pushPtr_willOverflowIfInc <= pkg_toStdLogic(true);
  pushPtr_willOverflow <= (pushPtr_willOverflowIfInc and pushPtr_willIncrement);
  process(popping)
  begin
    popPtr_willIncrement <= pkg_toStdLogic(false);
    if popping = '1' then
      popPtr_willIncrement <= pkg_toStdLogic(true);
    end if;
  end process;

  process(io_flush)
  begin
    popPtr_willClear <= pkg_toStdLogic(false);
    if io_flush = '1' then
      popPtr_willClear <= pkg_toStdLogic(true);
    end if;
  end process;

  popPtr_willOverflowIfInc <= pkg_toStdLogic(true);
  popPtr_willOverflow <= (popPtr_willOverflowIfInc and popPtr_willIncrement);
  ptrMatch <= pkg_toStdLogic(true);
  empty <= (ptrMatch and (not risingOccupancy));
  full <= (ptrMatch and risingOccupancy);
  pushing <= (io_push_valid and zz_4);
  popping <= (zz_5 and io_pop_ready);
  zz_4 <= (not full);
  process(zz_6,io_push_valid)
  begin
    if zz_6 = '1' then
      zz_5 <= pkg_toStdLogic(true);
    else
      zz_5 <= io_push_valid;
    end if;
  end process;

  zz_2 <= zz_3;
  process(zz_6,zz_2,io_push_payload_error)
  begin
    if zz_6 = '1' then
      io_pop_payload_error <= pkg_extract(pkg_extract(zz_2,0,0),0);
    else
      io_pop_payload_error <= io_push_payload_error;
    end if;
  end process;

  process(zz_6,zz_2,io_push_payload_inst)
  begin
    if zz_6 = '1' then
      io_pop_payload_inst <= pkg_extract(zz_2,32,1);
    else
      io_pop_payload_inst <= io_push_payload_inst;
    end if;
  end process;

  io_occupancy <= unsigned(pkg_toStdLogicVector((risingOccupancy and ptrMatch)));
  process(clk, reset)
  begin
    if reset = '1' then
      risingOccupancy <= pkg_toStdLogic(false);
    elsif rising_edge(clk) then
      if pkg_toStdLogic(pushing /= popping) = '1' then
        risingOccupancy <= pushing;
      end if;
      if io_flush = '1' then
        risingOccupancy <= pkg_toStdLogic(false);
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if zz_1 = '1' then
        zz_3 <= pkg_cat(io_push_payload_inst,pkg_toStdLogicVector(io_push_payload_error));
      end if;
    end if;
  end process;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pkg_scala2hdl.all;
use work.all;
use work.pkg_enum.all;


entity VexRiscv is
  port(
    iBus_cmd_valid : out std_logic;
    iBus_cmd_ready : in std_logic;
    iBus_cmd_payload_pc : out unsigned(31 downto 0);
    iBus_rsp_valid : in std_logic;
    iBus_rsp_payload_error : in std_logic;
    iBus_rsp_payload_inst : in std_logic_vector(31 downto 0);
    timerInterrupt : in std_logic;
    externalInterrupt : in std_logic;
    softwareInterrupt : in std_logic;
    debug_bus_cmd_valid : in std_logic;
    debug_bus_cmd_ready : out std_logic;
    debug_bus_cmd_payload_wr : in std_logic;
    debug_bus_cmd_payload_address : in unsigned(7 downto 0);
    debug_bus_cmd_payload_data : in std_logic_vector(31 downto 0);
    debug_bus_rsp_data : out std_logic_vector(31 downto 0);
    debug_resetOut : out std_logic;
    dBus_cmd_valid : out std_logic;
    dBus_cmd_ready : in std_logic;
    dBus_cmd_payload_wr : out std_logic;
    dBus_cmd_payload_address : out unsigned(31 downto 0);
    dBus_cmd_payload_data : out std_logic_vector(31 downto 0);
    dBus_cmd_payload_size : out unsigned(1 downto 0);
    dBus_rsp_ready : in std_logic;
    dBus_rsp_error : in std_logic;
    dBus_rsp_data : in std_logic_vector(31 downto 0);
    clk : in std_logic;
    reset : in std_logic;
    debugReset : in std_logic
  );
end VexRiscv;

architecture arch of VexRiscv is
  signal zz_152 : std_logic;
  signal zz_153 : std_logic;
  signal zz_154 : std_logic_vector(31 downto 0);
  signal zz_155 : std_logic_vector(31 downto 0);
  signal zz_156 : unsigned(31 downto 0);
  signal zz_157 : unsigned(1 downto 0);
  signal zz_158 : std_logic;
  signal zz_159 : unsigned(31 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy : unsigned(0 downto 0);
  signal zz_160 : std_logic;
  signal zz_161 : std_logic;
  signal zz_162 : std_logic;
  signal zz_163 : std_logic;
  signal zz_164 : std_logic;
  signal zz_165 : std_logic;
  signal zz_166 : std_logic;
  signal zz_167 : std_logic;
  signal zz_168 : std_logic;
  signal zz_169 : std_logic;
  signal zz_170 : std_logic_vector(1 downto 0);
  signal zz_171 : std_logic;
  signal zz_172 : std_logic;
  signal zz_173 : std_logic;
  signal zz_174 : std_logic;
  signal zz_175 : std_logic;
  signal zz_176 : std_logic;
  signal zz_177 : std_logic;
  signal zz_178 : unsigned(5 downto 0);
  signal zz_179 : std_logic;
  signal zz_180 : std_logic;
  signal zz_181 : std_logic;
  signal zz_182 : std_logic;
  signal zz_183 : std_logic_vector(1 downto 0);
  signal zz_184 : std_logic;
  signal zz_185 : std_logic;
  signal zz_186 : std_logic;
  signal zz_187 : unsigned(1 downto 0);
  signal zz_188 : std_logic_vector(0 downto 0);
  signal zz_189 : std_logic_vector(7 downto 0);
  signal zz_190 : std_logic;
  signal zz_191 : std_logic_vector(0 downto 0);
  signal zz_192 : std_logic_vector(0 downto 0);
  signal zz_193 : std_logic_vector(31 downto 0);
  signal zz_194 : std_logic;
  signal zz_195 : std_logic;
  signal zz_196 : std_logic_vector(0 downto 0);
  signal zz_197 : std_logic_vector(0 downto 0);
  signal zz_198 : std_logic;
  signal zz_199 : std_logic_vector(0 downto 0);
  signal zz_200 : std_logic_vector(19 downto 0);
  signal zz_201 : std_logic_vector(31 downto 0);
  signal zz_202 : std_logic_vector(31 downto 0);
  signal zz_203 : std_logic_vector(31 downto 0);
  signal zz_204 : std_logic_vector(31 downto 0);
  signal zz_205 : std_logic_vector(31 downto 0);
  signal zz_206 : std_logic_vector(31 downto 0);
  signal zz_207 : std_logic;
  signal zz_208 : std_logic_vector(0 downto 0);
  signal zz_209 : std_logic_vector(0 downto 0);
  signal zz_210 : std_logic;
  signal zz_211 : std_logic_vector(0 downto 0);
  signal zz_212 : std_logic_vector(15 downto 0);
  signal zz_213 : std_logic_vector(31 downto 0);
  signal zz_214 : std_logic_vector(31 downto 0);
  signal zz_215 : std_logic_vector(31 downto 0);
  signal zz_216 : std_logic_vector(31 downto 0);
  signal zz_217 : std_logic_vector(31 downto 0);
  signal zz_218 : std_logic_vector(31 downto 0);
  signal zz_219 : std_logic_vector(0 downto 0);
  signal zz_220 : std_logic_vector(0 downto 0);
  signal zz_221 : std_logic_vector(1 downto 0);
  signal zz_222 : std_logic_vector(1 downto 0);
  signal zz_223 : std_logic;
  signal zz_224 : std_logic_vector(0 downto 0);
  signal zz_225 : std_logic_vector(11 downto 0);
  signal zz_226 : std_logic_vector(31 downto 0);
  signal zz_227 : std_logic_vector(31 downto 0);
  signal zz_228 : std_logic_vector(31 downto 0);
  signal zz_229 : std_logic_vector(31 downto 0);
  signal zz_230 : std_logic_vector(31 downto 0);
  signal zz_231 : std_logic_vector(31 downto 0);
  signal zz_232 : std_logic;
  signal zz_233 : std_logic_vector(0 downto 0);
  signal zz_234 : std_logic_vector(0 downto 0);
  signal zz_235 : std_logic;
  signal zz_236 : std_logic_vector(0 downto 0);
  signal zz_237 : std_logic_vector(0 downto 0);
  signal zz_238 : std_logic;
  signal zz_239 : std_logic_vector(0 downto 0);
  signal zz_240 : std_logic_vector(8 downto 0);
  signal zz_241 : std_logic_vector(31 downto 0);
  signal zz_242 : std_logic_vector(31 downto 0);
  signal zz_243 : std_logic_vector(31 downto 0);
  signal zz_244 : std_logic_vector(0 downto 0);
  signal zz_245 : std_logic_vector(0 downto 0);
  signal zz_246 : std_logic_vector(0 downto 0);
  signal zz_247 : std_logic_vector(4 downto 0);
  signal zz_248 : std_logic_vector(1 downto 0);
  signal zz_249 : std_logic_vector(1 downto 0);
  signal zz_250 : std_logic;
  signal zz_251 : std_logic_vector(0 downto 0);
  signal zz_252 : std_logic_vector(5 downto 0);
  signal zz_253 : std_logic_vector(31 downto 0);
  signal zz_254 : std_logic_vector(31 downto 0);
  signal zz_255 : std_logic_vector(31 downto 0);
  signal zz_256 : std_logic_vector(31 downto 0);
  signal zz_257 : std_logic;
  signal zz_258 : std_logic_vector(0 downto 0);
  signal zz_259 : std_logic_vector(1 downto 0);
  signal zz_260 : std_logic_vector(31 downto 0);
  signal zz_261 : std_logic_vector(31 downto 0);
  signal zz_262 : std_logic;
  signal zz_263 : std_logic;
  signal zz_264 : std_logic_vector(0 downto 0);
  signal zz_265 : std_logic_vector(0 downto 0);
  signal zz_266 : std_logic;
  signal zz_267 : std_logic_vector(0 downto 0);
  signal zz_268 : std_logic_vector(2 downto 0);
  signal zz_269 : std_logic_vector(31 downto 0);
  signal zz_270 : std_logic_vector(31 downto 0);
  signal zz_271 : std_logic_vector(31 downto 0);
  signal zz_272 : std_logic;
  signal zz_273 : std_logic;
  signal zz_274 : std_logic_vector(31 downto 0);
  signal zz_275 : std_logic_vector(31 downto 0);
  signal zz_276 : std_logic_vector(31 downto 0);
  signal zz_277 : std_logic_vector(31 downto 0);
  signal zz_278 : std_logic_vector(0 downto 0);
  signal zz_279 : std_logic_vector(2 downto 0);
  signal zz_280 : std_logic_vector(0 downto 0);
  signal zz_281 : std_logic_vector(0 downto 0);
  signal zz_282 : std_logic;
  signal zz_283 : std_logic_vector(0 downto 0);
  signal zz_284 : std_logic_vector(0 downto 0);
  signal zz_285 : std_logic_vector(31 downto 0);
  signal zz_286 : std_logic_vector(31 downto 0);
  signal zz_287 : std_logic_vector(31 downto 0);
  signal zz_288 : std_logic;
  signal zz_289 : std_logic;
  signal zz_290 : std_logic_vector(31 downto 0);
  signal zz_291 : std_logic;
  signal zz_292 : std_logic_vector(0 downto 0);
  signal zz_293 : std_logic_vector(0 downto 0);
  signal zz_294 : std_logic_vector(0 downto 0);
  signal zz_295 : std_logic_vector(0 downto 0);
  signal zz_296 : std_logic_vector(0 downto 0);
  signal zz_297 : std_logic_vector(0 downto 0);
  signal zz_298 : std_logic_vector(0 downto 0);
  signal zz_299 : std_logic_vector(7 downto 0);
  signal zz_300 : std_logic;
  signal zz_301 : std_logic_vector(0 downto 0);
  signal zz_302 : std_logic_vector(0 downto 0);
  attribute keep : boolean;
  attribute syn_keep : boolean;

  signal memory_MEMORY_READ_DATA : std_logic_vector(31 downto 0);
  signal execute_SHIFT_RIGHT : std_logic_vector(31 downto 0);
  signal writeBack_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal execute_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal memory_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal execute_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal decode_DO_EBREAK : std_logic;
  signal decode_PREDICTION_HAD_BRANCHED2 : std_logic;
  signal decode_SRC2_FORCE_ZERO : std_logic;
  signal zz_1 : BranchCtrlEnum_defaultEncoding_type;
  signal zz_2 : BranchCtrlEnum_defaultEncoding_type;
  signal zz_3 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_4 : ShiftCtrlEnum_defaultEncoding_type;
  signal decode_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_5 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_6 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_7 : ShiftCtrlEnum_defaultEncoding_type;
  signal decode_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_8 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_9 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_10 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal decode_SRC_LESS_UNSIGNED : std_logic;
  signal zz_11 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_12 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_13 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_14 : EnvCtrlEnum_defaultEncoding_type;
  signal decode_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal zz_15 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_16 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_17 : EnvCtrlEnum_defaultEncoding_type;
  signal decode_IS_CSR : std_logic;
  signal decode_MEMORY_STORE : std_logic;
  signal execute_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal decode_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal decode_BYPASSABLE_EXECUTE_STAGE : std_logic;
  signal decode_SRC2_CTRL : Src2CtrlEnum_defaultEncoding_type;
  signal zz_18 : Src2CtrlEnum_defaultEncoding_type;
  signal zz_19 : Src2CtrlEnum_defaultEncoding_type;
  signal zz_20 : Src2CtrlEnum_defaultEncoding_type;
  signal decode_ALU_CTRL : AluCtrlEnum_defaultEncoding_type;
  signal zz_21 : AluCtrlEnum_defaultEncoding_type;
  signal zz_22 : AluCtrlEnum_defaultEncoding_type;
  signal zz_23 : AluCtrlEnum_defaultEncoding_type;
  signal decode_MEMORY_ENABLE : std_logic;
  signal decode_SRC1_CTRL : Src1CtrlEnum_defaultEncoding_type;
  signal zz_24 : Src1CtrlEnum_defaultEncoding_type;
  signal zz_25 : Src1CtrlEnum_defaultEncoding_type;
  signal zz_26 : Src1CtrlEnum_defaultEncoding_type;
  signal decode_CSR_READ_OPCODE : std_logic;
  signal decode_CSR_WRITE_OPCODE : std_logic;
  signal writeBack_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal memory_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal execute_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal decode_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal memory_PC : unsigned(31 downto 0);
  signal execute_DO_EBREAK : std_logic;
  signal decode_IS_EBREAK : std_logic;
  signal execute_BRANCH_CALC : unsigned(31 downto 0);
  signal execute_BRANCH_DO : std_logic;
  signal execute_PC : unsigned(31 downto 0);
  signal execute_PREDICTION_HAD_BRANCHED2 : std_logic;
  signal execute_RS1 : std_logic_vector(31 downto 0);
  signal execute_BRANCH_COND_RESULT : std_logic;
  signal execute_BRANCH_CTRL : BranchCtrlEnum_defaultEncoding_type;
  signal zz_27 : BranchCtrlEnum_defaultEncoding_type;
  signal decode_RS2_USE : std_logic;
  signal decode_RS1_USE : std_logic;
  signal execute_REGFILE_WRITE_VALID : std_logic;
  signal execute_BYPASSABLE_EXECUTE_STAGE : std_logic;
  signal memory_REGFILE_WRITE_VALID : std_logic;
  signal memory_INSTRUCTION : std_logic_vector(31 downto 0);
  signal memory_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal writeBack_REGFILE_WRITE_VALID : std_logic;
  signal decode_RS2 : std_logic_vector(31 downto 0);
  signal decode_RS1 : std_logic_vector(31 downto 0);
  signal memory_SHIFT_RIGHT : std_logic_vector(31 downto 0);
  signal zz_28 : std_logic_vector(31 downto 0);
  signal memory_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_29 : ShiftCtrlEnum_defaultEncoding_type;
  signal execute_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_30 : ShiftCtrlEnum_defaultEncoding_type;
  signal execute_SRC_LESS_UNSIGNED : std_logic;
  signal execute_SRC2_FORCE_ZERO : std_logic;
  signal execute_SRC_USE_SUB_LESS : std_logic;
  signal zz_31 : unsigned(31 downto 0);
  signal execute_SRC2_CTRL : Src2CtrlEnum_defaultEncoding_type;
  signal zz_32 : Src2CtrlEnum_defaultEncoding_type;
  signal execute_SRC1_CTRL : Src1CtrlEnum_defaultEncoding_type;
  signal zz_33 : Src1CtrlEnum_defaultEncoding_type;
  signal decode_SRC_USE_SUB_LESS : std_logic;
  signal decode_SRC_ADD_ZERO : std_logic;
  signal execute_SRC_ADD_SUB : std_logic_vector(31 downto 0);
  signal execute_SRC_LESS : std_logic;
  signal execute_ALU_CTRL : AluCtrlEnum_defaultEncoding_type;
  signal zz_34 : AluCtrlEnum_defaultEncoding_type;
  signal execute_SRC2 : std_logic_vector(31 downto 0);
  signal execute_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_35 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_36 : std_logic_vector(31 downto 0);
  signal zz_37 : std_logic;
  signal zz_38 : std_logic;
  signal decode_INSTRUCTION_ANTICIPATED : std_logic_vector(31 downto 0);
  signal decode_REGFILE_WRITE_VALID : std_logic;
  signal zz_39 : BranchCtrlEnum_defaultEncoding_type;
  signal zz_40 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_41 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_42 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_43 : Src2CtrlEnum_defaultEncoding_type;
  signal zz_44 : AluCtrlEnum_defaultEncoding_type;
  signal zz_45 : Src1CtrlEnum_defaultEncoding_type;
  signal zz_46 : std_logic_vector(31 downto 0);
  signal execute_SRC1 : std_logic_vector(31 downto 0);
  signal execute_CSR_READ_OPCODE : std_logic;
  signal execute_CSR_WRITE_OPCODE : std_logic;
  signal execute_IS_CSR : std_logic;
  signal memory_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal zz_47 : EnvCtrlEnum_defaultEncoding_type;
  signal execute_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal zz_48 : EnvCtrlEnum_defaultEncoding_type;
  signal writeBack_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal zz_49 : EnvCtrlEnum_defaultEncoding_type;
  signal writeBack_MEMORY_STORE : std_logic;
  signal zz_50 : std_logic_vector(31 downto 0);
  signal writeBack_MEMORY_ENABLE : std_logic;
  signal writeBack_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal writeBack_MEMORY_READ_DATA : std_logic_vector(31 downto 0);
  signal memory_ALIGNEMENT_FAULT : std_logic;
  signal memory_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal memory_MEMORY_STORE : std_logic;
  signal memory_MEMORY_ENABLE : std_logic;
  signal execute_SRC_ADD : std_logic_vector(31 downto 0);
  signal execute_RS2 : std_logic_vector(31 downto 0);
  signal execute_INSTRUCTION : std_logic_vector(31 downto 0);
  signal execute_MEMORY_STORE : std_logic;
  signal execute_MEMORY_ENABLE : std_logic;
  signal execute_ALIGNEMENT_FAULT : std_logic;
  signal decode_BRANCH_CTRL : BranchCtrlEnum_defaultEncoding_type;
  signal zz_51 : BranchCtrlEnum_defaultEncoding_type;
  signal zz_52 : unsigned(31 downto 0);
  signal zz_53 : unsigned(31 downto 0);
  signal decode_PC : unsigned(31 downto 0);
  signal decode_INSTRUCTION : std_logic_vector(31 downto 0);
  signal writeBack_PC : unsigned(31 downto 0);
  signal writeBack_INSTRUCTION : std_logic_vector(31 downto 0);
  signal decode_arbitration_haltItself : std_logic;
  signal decode_arbitration_haltByOther : std_logic;
  signal decode_arbitration_removeIt : std_logic;
  signal decode_arbitration_flushIt : std_logic;
  signal decode_arbitration_flushNext : std_logic;
  signal decode_arbitration_isValid : std_logic;
  signal decode_arbitration_isStuck : std_logic;
  signal decode_arbitration_isStuckByOthers : std_logic;
  signal decode_arbitration_isFlushed : std_logic;
  signal decode_arbitration_isMoving : std_logic;
  signal decode_arbitration_isFiring : std_logic;
  signal execute_arbitration_haltItself : std_logic;
  signal execute_arbitration_haltByOther : std_logic;
  signal execute_arbitration_removeIt : std_logic;
  signal execute_arbitration_flushIt : std_logic;
  signal execute_arbitration_flushNext : std_logic;
  signal execute_arbitration_isValid : std_logic;
  signal execute_arbitration_isStuck : std_logic;
  signal execute_arbitration_isStuckByOthers : std_logic;
  signal execute_arbitration_isFlushed : std_logic;
  signal execute_arbitration_isMoving : std_logic;
  signal execute_arbitration_isFiring : std_logic;
  signal memory_arbitration_haltItself : std_logic;
  signal memory_arbitration_haltByOther : std_logic;
  signal memory_arbitration_removeIt : std_logic;
  signal memory_arbitration_flushIt : std_logic;
  signal memory_arbitration_flushNext : std_logic;
  signal memory_arbitration_isValid : std_logic;
  signal memory_arbitration_isStuck : std_logic;
  signal memory_arbitration_isStuckByOthers : std_logic;
  signal memory_arbitration_isFlushed : std_logic;
  signal memory_arbitration_isMoving : std_logic;
  signal memory_arbitration_isFiring : std_logic;
  signal writeBack_arbitration_haltItself : std_logic;
  signal writeBack_arbitration_haltByOther : std_logic;
  signal writeBack_arbitration_removeIt : std_logic;
  signal writeBack_arbitration_flushIt : std_logic;
  signal writeBack_arbitration_flushNext : std_logic;
  signal writeBack_arbitration_isValid : std_logic;
  signal writeBack_arbitration_isStuck : std_logic;
  signal writeBack_arbitration_isStuckByOthers : std_logic;
  signal writeBack_arbitration_isFlushed : std_logic;
  signal writeBack_arbitration_isMoving : std_logic;
  signal writeBack_arbitration_isFiring : std_logic;
  signal lastStageInstruction : std_logic_vector(31 downto 0);
  signal lastStagePc : unsigned(31 downto 0);
  signal lastStageIsValid : std_logic;
  signal lastStageIsFiring : std_logic;
  signal IBusSimplePlugin_fetcherHalt : std_logic;
  signal IBusSimplePlugin_incomingInstruction : std_logic;
  signal IBusSimplePlugin_predictionJumpInterface_valid : std_logic;
  signal IBusSimplePlugin_predictionJumpInterface_payload : unsigned(31 downto 0);
  attribute keep of IBusSimplePlugin_predictionJumpInterface_payload : signal is true;
  attribute syn_keep of IBusSimplePlugin_predictionJumpInterface_payload : signal is true;
  signal IBusSimplePlugin_decodePrediction_cmd_hadBranch : std_logic;
  signal IBusSimplePlugin_decodePrediction_rsp_wasWrong : std_logic;
  signal IBusSimplePlugin_pcValids_0 : std_logic;
  signal IBusSimplePlugin_pcValids_1 : std_logic;
  signal IBusSimplePlugin_pcValids_2 : std_logic;
  signal IBusSimplePlugin_pcValids_3 : std_logic;
  signal DBusSimplePlugin_memoryExceptionPort_valid : std_logic;
  signal DBusSimplePlugin_memoryExceptionPort_payload_code : unsigned(3 downto 0);
  signal DBusSimplePlugin_memoryExceptionPort_payload_badAddr : unsigned(31 downto 0);
  signal CsrPlugin_inWfi : std_logic;
  signal CsrPlugin_thirdPartyWake : std_logic;
  signal CsrPlugin_jumpInterface_valid : std_logic;
  signal CsrPlugin_jumpInterface_payload : unsigned(31 downto 0);
  signal CsrPlugin_exceptionPendings_0 : std_logic;
  signal CsrPlugin_exceptionPendings_1 : std_logic;
  signal CsrPlugin_exceptionPendings_2 : std_logic;
  signal CsrPlugin_exceptionPendings_3 : std_logic;
  signal contextSwitching : std_logic;
  signal CsrPlugin_privilege : unsigned(1 downto 0);
  signal CsrPlugin_forceMachineWire : std_logic;
  signal CsrPlugin_allowInterrupts : std_logic;
  signal CsrPlugin_allowException : std_logic;
  signal BranchPlugin_jumpInterface_valid : std_logic;
  signal BranchPlugin_jumpInterface_payload : unsigned(31 downto 0);
  signal BranchPlugin_branchExceptionPort_valid : std_logic;
  signal BranchPlugin_branchExceptionPort_payload_code : unsigned(3 downto 0);
  signal BranchPlugin_branchExceptionPort_payload_badAddr : unsigned(31 downto 0);
  signal IBusSimplePlugin_injectionPort_valid : std_logic;
  signal IBusSimplePlugin_injectionPort_ready : std_logic;
  signal IBusSimplePlugin_injectionPort_payload : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_externalFlush : std_logic;
  signal IBusSimplePlugin_jump_pcLoad_valid : std_logic;
  signal IBusSimplePlugin_jump_pcLoad_payload : unsigned(31 downto 0);
  signal zz_54 : unsigned(2 downto 0);
  signal zz_55 : std_logic_vector(2 downto 0);
  signal zz_56 : std_logic;
  signal zz_57 : std_logic;
  signal IBusSimplePlugin_fetchPc_output_valid : std_logic;
  signal IBusSimplePlugin_fetchPc_output_ready : std_logic;
  signal IBusSimplePlugin_fetchPc_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_fetchPc_pcReg : unsigned(31 downto 0);
  signal IBusSimplePlugin_fetchPc_correction : std_logic;
  signal IBusSimplePlugin_fetchPc_correctionReg : std_logic;
  signal IBusSimplePlugin_fetchPc_corrected : std_logic;
  signal IBusSimplePlugin_fetchPc_pcRegPropagate : std_logic;
  signal IBusSimplePlugin_fetchPc_booted : std_logic;
  signal IBusSimplePlugin_fetchPc_inc : std_logic;
  signal IBusSimplePlugin_fetchPc_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_fetchPc_flushed : std_logic;
  signal IBusSimplePlugin_iBusRsp_redoFetch : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_input_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_input_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_input_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_0_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_0_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_0_halt : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_input_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_input_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_input_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_1_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_1_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_1_halt : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_input_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_input_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_input_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_2_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_stages_2_output_payload : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_stages_2_halt : std_logic;
  signal zz_58 : std_logic;
  signal zz_59 : std_logic;
  signal zz_60 : std_logic;
  signal IBusSimplePlugin_iBusRsp_flush : std_logic;
  signal zz_61 : std_logic;
  signal zz_62 : std_logic;
  signal zz_63 : std_logic;
  signal zz_64 : std_logic;
  signal zz_65 : std_logic;
  signal zz_66 : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_readyForError : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_valid : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_ready : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_output_payload_rsp_error : std_logic;
  signal IBusSimplePlugin_iBusRsp_output_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_iBusRsp_output_payload_isRvc : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_valid : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_ready : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_injector_decodeInput_payload_rsp_error : std_logic;
  signal IBusSimplePlugin_injector_decodeInput_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_injector_decodeInput_payload_isRvc : std_logic;
  signal zz_67 : std_logic;
  signal zz_68 : unsigned(31 downto 0);
  signal zz_69 : std_logic;
  signal zz_70 : std_logic_vector(31 downto 0);
  signal zz_71 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_0 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_1 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_2 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_3 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_4 : std_logic;
  signal IBusSimplePlugin_injector_nextPcCalc_valids_5 : std_logic;
  signal IBusSimplePlugin_injector_formal_rawInDecode : std_logic_vector(31 downto 0);
  signal zz_72 : std_logic;
  signal zz_73 : std_logic_vector(18 downto 0);
  signal zz_74 : std_logic;
  signal zz_75 : std_logic_vector(10 downto 0);
  signal zz_76 : std_logic;
  signal zz_77 : std_logic_vector(18 downto 0);
  signal zz_78 : std_logic;
  signal zz_79 : std_logic;
  signal zz_80 : std_logic_vector(10 downto 0);
  signal zz_81 : std_logic;
  signal zz_82 : std_logic_vector(18 downto 0);
  signal IBusSimplePlugin_cmd_valid : std_logic;
  signal IBusSimplePlugin_cmd_ready : std_logic;
  signal IBusSimplePlugin_cmd_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_pending_inc : std_logic;
  signal IBusSimplePlugin_pending_dec : std_logic;
  signal IBusSimplePlugin_pending_value : unsigned(2 downto 0);
  signal IBusSimplePlugin_pending_next : unsigned(2 downto 0);
  signal IBusSimplePlugin_cmdFork_canEmit : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_output_valid : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_output_ready : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error : std_logic;
  signal IBusSimplePlugin_rspJoin_rspBuffer_output_payload_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBuffer_discardCounter : unsigned(2 downto 0);
  signal IBusSimplePlugin_rspJoin_rspBuffer_flush : std_logic;
  signal IBusSimplePlugin_rspJoin_fetchRsp_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_rspJoin_fetchRsp_rsp_error : std_logic;
  signal IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_fetchRsp_isRvc : std_logic;
  signal IBusSimplePlugin_rspJoin_join_valid : std_logic;
  signal IBusSimplePlugin_rspJoin_join_ready : std_logic;
  signal IBusSimplePlugin_rspJoin_join_payload_pc : unsigned(31 downto 0);
  signal IBusSimplePlugin_rspJoin_join_payload_rsp_error : std_logic;
  signal IBusSimplePlugin_rspJoin_join_payload_rsp_inst : std_logic_vector(31 downto 0);
  signal IBusSimplePlugin_rspJoin_join_payload_isRvc : std_logic;
  signal IBusSimplePlugin_rspJoin_exceptionDetected : std_logic;
  signal zz_83 : std_logic;
  signal zz_84 : std_logic;
  signal execute_DBusSimplePlugin_skipCmd : std_logic;
  signal zz_85 : std_logic_vector(31 downto 0);
  signal zz_86 : std_logic_vector(3 downto 0);
  signal execute_DBusSimplePlugin_formalMask : std_logic_vector(3 downto 0);
  signal writeBack_DBusSimplePlugin_rspShifted : std_logic_vector(31 downto 0);
  signal zz_87 : std_logic;
  signal zz_88 : std_logic_vector(31 downto 0);
  signal zz_89 : std_logic;
  signal zz_90 : std_logic_vector(31 downto 0);
  signal writeBack_DBusSimplePlugin_rspFormated : std_logic_vector(31 downto 0);
  signal CsrPlugin_misa_base : unsigned(1 downto 0);
  signal CsrPlugin_misa_extensions : std_logic_vector(25 downto 0);
  signal CsrPlugin_mtvec_mode : std_logic_vector(1 downto 0);
  signal CsrPlugin_mtvec_base : unsigned(29 downto 0);
  signal CsrPlugin_mepc : unsigned(31 downto 0);
  signal CsrPlugin_mstatus_MIE : std_logic;
  signal CsrPlugin_mstatus_MPIE : std_logic;
  signal CsrPlugin_mstatus_MPP : unsigned(1 downto 0);
  signal CsrPlugin_mip_MEIP : std_logic;
  signal CsrPlugin_mip_MTIP : std_logic;
  signal CsrPlugin_mip_MSIP : std_logic;
  signal CsrPlugin_mie_MEIE : std_logic;
  signal CsrPlugin_mie_MTIE : std_logic;
  signal CsrPlugin_mie_MSIE : std_logic;
  signal CsrPlugin_mcause_interrupt : std_logic;
  signal CsrPlugin_mcause_exceptionCode : unsigned(3 downto 0);
  signal CsrPlugin_mtval : unsigned(31 downto 0);
  signal CsrPlugin_mcycle : unsigned(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
  signal CsrPlugin_minstret : unsigned(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
  signal zz_91 : std_logic;
  signal zz_92 : std_logic;
  signal zz_93 : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValids_decode : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValids_execute : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValids_memory : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack : std_logic;
  signal CsrPlugin_exceptionPortCtrl_exceptionContext_code : unsigned(3 downto 0);
  signal CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr : unsigned(31 downto 0);
  signal CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped : unsigned(1 downto 0);
  signal CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege : unsigned(1 downto 0);
  signal CsrPlugin_interrupt_valid : std_logic;
  signal CsrPlugin_interrupt_code : unsigned(3 downto 0);
  signal CsrPlugin_interrupt_targetPrivilege : unsigned(1 downto 0);
  signal CsrPlugin_exception : std_logic;
  signal CsrPlugin_lastStageWasWfi : std_logic;
  signal CsrPlugin_pipelineLiberator_pcValids_0 : std_logic;
  signal CsrPlugin_pipelineLiberator_pcValids_1 : std_logic;
  signal CsrPlugin_pipelineLiberator_pcValids_2 : std_logic;
  signal CsrPlugin_pipelineLiberator_active : std_logic;
  signal CsrPlugin_pipelineLiberator_done : std_logic;
  signal CsrPlugin_interruptJump : std_logic;
  signal CsrPlugin_hadException : std_logic;
  signal CsrPlugin_targetPrivilege : unsigned(1 downto 0);
  signal CsrPlugin_trapCause : unsigned(3 downto 0);
  signal CsrPlugin_xtvec_mode : std_logic_vector(1 downto 0);
  signal CsrPlugin_xtvec_base : unsigned(29 downto 0);
  signal execute_CsrPlugin_wfiWake : std_logic;
  signal execute_CsrPlugin_blockedBySideEffects : std_logic;
  signal execute_CsrPlugin_illegalAccess : std_logic;
  signal execute_CsrPlugin_illegalInstruction : std_logic;
  signal execute_CsrPlugin_readData : std_logic_vector(31 downto 0);
  signal execute_CsrPlugin_writeInstruction : std_logic;
  signal execute_CsrPlugin_readInstruction : std_logic;
  signal execute_CsrPlugin_writeEnable : std_logic;
  signal execute_CsrPlugin_readEnable : std_logic;
  signal execute_CsrPlugin_readToWriteData : std_logic_vector(31 downto 0);
  signal execute_CsrPlugin_writeData : std_logic_vector(31 downto 0);
  signal execute_CsrPlugin_csrAddress : std_logic_vector(11 downto 0);
  signal zz_94 : std_logic_vector(25 downto 0);
  signal zz_95 : std_logic;
  signal zz_96 : std_logic;
  signal zz_97 : std_logic;
  signal zz_98 : Src1CtrlEnum_defaultEncoding_type;
  signal zz_99 : AluCtrlEnum_defaultEncoding_type;
  signal zz_100 : Src2CtrlEnum_defaultEncoding_type;
  signal zz_101 : EnvCtrlEnum_defaultEncoding_type;
  signal zz_102 : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal zz_103 : ShiftCtrlEnum_defaultEncoding_type;
  signal zz_104 : BranchCtrlEnum_defaultEncoding_type;
  signal decode_RegFilePlugin_regFileReadAddress1 : unsigned(4 downto 0);
  signal decode_RegFilePlugin_regFileReadAddress2 : unsigned(4 downto 0);
  signal decode_RegFilePlugin_rs1Data : std_logic_vector(31 downto 0);
  signal decode_RegFilePlugin_rs2Data : std_logic_vector(31 downto 0);
  signal lastStageRegFileWrite_valid : std_logic;
  signal lastStageRegFileWrite_payload_address : unsigned(4 downto 0);
  signal lastStageRegFileWrite_payload_data : std_logic_vector(31 downto 0);
  signal zz_105 : std_logic;
  signal execute_IntAluPlugin_bitwise : std_logic_vector(31 downto 0);
  signal zz_106 : std_logic_vector(31 downto 0);
  signal zz_107 : std_logic_vector(31 downto 0);
  signal zz_108 : std_logic;
  signal zz_109 : std_logic_vector(19 downto 0);
  signal zz_110 : std_logic;
  signal zz_111 : std_logic_vector(19 downto 0);
  signal zz_112 : std_logic_vector(31 downto 0);
  signal execute_SrcPlugin_addSub : std_logic_vector(31 downto 0);
  signal execute_SrcPlugin_less : std_logic;
  signal execute_FullBarrelShifterPlugin_amplitude : unsigned(4 downto 0);
  signal zz_113 : std_logic_vector(31 downto 0);
  signal execute_FullBarrelShifterPlugin_reversed : std_logic_vector(31 downto 0);
  signal zz_114 : std_logic_vector(31 downto 0);
  signal zz_115 : std_logic;
  signal zz_116 : std_logic;
  signal zz_117 : std_logic;
  signal zz_118 : std_logic_vector(4 downto 0);
  signal zz_119 : std_logic_vector(31 downto 0);
  signal zz_120 : std_logic;
  signal zz_121 : std_logic;
  signal zz_122 : std_logic;
  signal zz_123 : std_logic;
  signal zz_124 : std_logic;
  signal zz_125 : std_logic;
  signal execute_BranchPlugin_eq : std_logic;
  signal zz_126 : std_logic_vector(2 downto 0);
  signal zz_127 : std_logic;
  signal zz_128 : std_logic;
  signal zz_129 : std_logic;
  signal zz_130 : std_logic_vector(19 downto 0);
  signal zz_131 : std_logic;
  signal zz_132 : std_logic_vector(10 downto 0);
  signal zz_133 : std_logic;
  signal zz_134 : std_logic_vector(18 downto 0);
  signal zz_135 : std_logic;
  signal execute_BranchPlugin_missAlignedTarget : std_logic;
  signal execute_BranchPlugin_branch_src1 : unsigned(31 downto 0);
  signal execute_BranchPlugin_branch_src2 : unsigned(31 downto 0);
  signal zz_136 : std_logic;
  signal zz_137 : std_logic_vector(19 downto 0);
  signal zz_138 : std_logic;
  signal zz_139 : std_logic_vector(10 downto 0);
  signal zz_140 : std_logic;
  signal zz_141 : std_logic_vector(18 downto 0);
  signal execute_BranchPlugin_branchAdder : unsigned(31 downto 0);
  signal DebugPlugin_firstCycle : std_logic;
  signal DebugPlugin_secondCycle : std_logic;
  signal DebugPlugin_resetIt : std_logic;
  signal DebugPlugin_haltIt : std_logic;
  signal DebugPlugin_stepIt : std_logic;
  signal DebugPlugin_isPipBusy : std_logic;
  signal DebugPlugin_godmode : std_logic;
  signal DebugPlugin_haltedByBreak : std_logic;
  signal DebugPlugin_busReadDataReg : std_logic_vector(31 downto 0);
  signal zz_142 : std_logic;
  signal DebugPlugin_allowEBreak : std_logic;
  signal DebugPlugin_resetIt_regNext : std_logic;
  signal decode_to_execute_PC : unsigned(31 downto 0);
  signal execute_to_memory_PC : unsigned(31 downto 0);
  signal memory_to_writeBack_PC : unsigned(31 downto 0);
  signal decode_to_execute_INSTRUCTION : std_logic_vector(31 downto 0);
  signal execute_to_memory_INSTRUCTION : std_logic_vector(31 downto 0);
  signal memory_to_writeBack_INSTRUCTION : std_logic_vector(31 downto 0);
  signal decode_to_execute_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal execute_to_memory_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal memory_to_writeBack_FORMAL_PC_NEXT : unsigned(31 downto 0);
  signal decode_to_execute_CSR_WRITE_OPCODE : std_logic;
  signal decode_to_execute_CSR_READ_OPCODE : std_logic;
  signal decode_to_execute_SRC1_CTRL : Src1CtrlEnum_defaultEncoding_type;
  signal decode_to_execute_SRC_USE_SUB_LESS : std_logic;
  signal decode_to_execute_MEMORY_ENABLE : std_logic;
  signal execute_to_memory_MEMORY_ENABLE : std_logic;
  signal memory_to_writeBack_MEMORY_ENABLE : std_logic;
  signal decode_to_execute_ALU_CTRL : AluCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_SRC2_CTRL : Src2CtrlEnum_defaultEncoding_type;
  signal decode_to_execute_REGFILE_WRITE_VALID : std_logic;
  signal execute_to_memory_REGFILE_WRITE_VALID : std_logic;
  signal memory_to_writeBack_REGFILE_WRITE_VALID : std_logic;
  signal decode_to_execute_BYPASSABLE_EXECUTE_STAGE : std_logic;
  signal decode_to_execute_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal execute_to_memory_BYPASSABLE_MEMORY_STAGE : std_logic;
  signal decode_to_execute_MEMORY_STORE : std_logic;
  signal execute_to_memory_MEMORY_STORE : std_logic;
  signal memory_to_writeBack_MEMORY_STORE : std_logic;
  signal decode_to_execute_IS_CSR : std_logic;
  signal decode_to_execute_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal execute_to_memory_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal memory_to_writeBack_ENV_CTRL : EnvCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_SRC_LESS_UNSIGNED : std_logic;
  signal decode_to_execute_ALU_BITWISE_CTRL : AluBitwiseCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal execute_to_memory_SHIFT_CTRL : ShiftCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_BRANCH_CTRL : BranchCtrlEnum_defaultEncoding_type;
  signal decode_to_execute_RS1 : std_logic_vector(31 downto 0);
  signal decode_to_execute_RS2 : std_logic_vector(31 downto 0);
  signal decode_to_execute_SRC2_FORCE_ZERO : std_logic;
  signal decode_to_execute_PREDICTION_HAD_BRANCHED2 : std_logic;
  signal decode_to_execute_DO_EBREAK : std_logic;
  signal execute_to_memory_ALIGNEMENT_FAULT : std_logic;
  signal execute_to_memory_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal memory_to_writeBack_MEMORY_ADDRESS_LOW : unsigned(1 downto 0);
  signal execute_to_memory_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal memory_to_writeBack_REGFILE_WRITE_DATA : std_logic_vector(31 downto 0);
  signal execute_to_memory_SHIFT_RIGHT : std_logic_vector(31 downto 0);
  signal memory_to_writeBack_MEMORY_READ_DATA : std_logic_vector(31 downto 0);
  signal zz_143 : unsigned(2 downto 0);
  signal execute_CsrPlugin_csr_768 : std_logic;
  signal execute_CsrPlugin_csr_836 : std_logic;
  signal execute_CsrPlugin_csr_772 : std_logic;
  signal execute_CsrPlugin_csr_833 : std_logic;
  signal execute_CsrPlugin_csr_834 : std_logic;
  signal execute_CsrPlugin_csr_835 : std_logic;
  signal execute_CsrPlugin_csr_3072 : std_logic;
  signal execute_CsrPlugin_csr_3200 : std_logic;
  signal zz_144 : std_logic_vector(31 downto 0);
  signal zz_145 : std_logic_vector(31 downto 0);
  signal zz_146 : std_logic_vector(31 downto 0);
  signal zz_147 : std_logic_vector(31 downto 0);
  signal zz_148 : std_logic_vector(31 downto 0);
  signal zz_149 : std_logic_vector(31 downto 0);
  signal zz_150 : std_logic_vector(31 downto 0);
  signal zz_151 : std_logic_vector(31 downto 0);
  type RegFilePlugin_regFile_type is array (0 to 31) of std_logic_vector(31 downto 0);
  signal RegFilePlugin_regFile : RegFilePlugin_regFile_type;
begin
  dBus_cmd_payload_address <= zz_156;
  dBus_cmd_payload_size <= zz_157;
  debug_bus_cmd_ready <= zz_158;
  zz_160 <= (writeBack_arbitration_isValid and writeBack_REGFILE_WRITE_VALID);
  zz_161 <= pkg_toStdLogic(true);
  zz_162 <= (memory_arbitration_isValid and memory_REGFILE_WRITE_VALID);
  zz_163 <= (execute_arbitration_isValid and execute_REGFILE_WRITE_VALID);
  zz_164 <= (execute_arbitration_isValid and execute_IS_CSR);
  zz_165 <= (execute_arbitration_isValid and execute_DO_EBREAK);
  zz_166 <= pkg_toStdLogic(pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_isValid),pkg_toStdLogicVector(memory_arbitration_isValid)) /= pkg_stdLogicVector("00")) = pkg_toStdLogic(false));
  zz_167 <= (CsrPlugin_hadException or CsrPlugin_interruptJump);
  zz_168 <= (writeBack_arbitration_isValid and pkg_toStdLogic(writeBack_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET));
  zz_169 <= (DebugPlugin_stepIt and IBusSimplePlugin_incomingInstruction);
  zz_170 <= pkg_extract(writeBack_INSTRUCTION,29,28);
  zz_171 <= pkg_toStdLogic(CsrPlugin_privilege < unsigned(pkg_extract(execute_CsrPlugin_csrAddress,9,8)));
  zz_172 <= (writeBack_arbitration_isValid and writeBack_REGFILE_WRITE_VALID);
  zz_173 <= (pkg_toStdLogic(false) or (not pkg_toStdLogic(true)));
  zz_174 <= (memory_arbitration_isValid and memory_REGFILE_WRITE_VALID);
  zz_175 <= (pkg_toStdLogic(false) or (not memory_BYPASSABLE_MEMORY_STAGE));
  zz_176 <= (execute_arbitration_isValid and execute_REGFILE_WRITE_VALID);
  zz_177 <= (pkg_toStdLogic(false) or (not execute_BYPASSABLE_EXECUTE_STAGE));
  zz_178 <= pkg_extract(debug_bus_cmd_payload_address,7,2);
  zz_179 <= (CsrPlugin_mstatus_MIE or pkg_toStdLogic(CsrPlugin_privilege < pkg_unsigned("11")));
  zz_180 <= ((zz_91 and pkg_toStdLogic(true)) and (not pkg_toStdLogic(false)));
  zz_181 <= ((zz_92 and pkg_toStdLogic(true)) and (not pkg_toStdLogic(false)));
  zz_182 <= ((zz_93 and pkg_toStdLogic(true)) and (not pkg_toStdLogic(false)));
  zz_183 <= pkg_extract(writeBack_INSTRUCTION,13,12);
  zz_184 <= pkg_extract(execute_INSTRUCTION,13);
  zz_185 <= pkg_toStdLogic(true);
  zz_186 <= pkg_toStdLogic(true);
  zz_187 <= unsigned(pkg_cat(pkg_toStdLogicVector(zz_57),pkg_toStdLogicVector(zz_56)));
  zz_188 <= pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31));
  zz_189 <= pkg_extract(decode_INSTRUCTION,19,12);
  zz_190 <= pkg_extract(decode_INSTRUCTION,20);
  zz_191 <= pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31));
  zz_192 <= pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,7));
  zz_193 <= pkg_stdLogicVector("00010000000000000011000001010000");
  zz_194 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000011100")) = pkg_stdLogicVector("00000000000000000000000000000100"));
  zz_195 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001011000")) = pkg_stdLogicVector("00000000000000000000000001000000"));
  zz_196 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000111000001010100")) = pkg_stdLogicVector("00000000000000000101000000010000")));
  zz_197 <= pkg_stdLogicVector("0");
  zz_198 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_201 = zz_202)),pkg_toStdLogicVector(pkg_toStdLogic(zz_203 = zz_204))) /= pkg_stdLogicVector("00"));
  zz_199 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic(zz_205 = zz_206)) /= pkg_stdLogicVector("0")));
  zz_200 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_207) /= pkg_stdLogicVector("0"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_208 /= zz_209)),pkg_cat(pkg_toStdLogicVector(zz_210),pkg_cat(zz_211,zz_212))));
  zz_201 <= (decode_INSTRUCTION and pkg_stdLogicVector("01000000000000000011000001010100"));
  zz_202 <= pkg_stdLogicVector("01000000000000000001000000010000");
  zz_203 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000111000001010100"));
  zz_204 <= pkg_stdLogicVector("00000000000000000001000000010000");
  zz_205 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001100100"));
  zz_206 <= pkg_stdLogicVector("00000000000000000000000000100100");
  zz_207 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000001000000000000")) = pkg_stdLogicVector("00000000000000000001000000000000"));
  zz_208 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000011000000000000")) = pkg_stdLogicVector("00000000000000000010000000000000")));
  zz_209 <= pkg_stdLogicVector("0");
  zz_210 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_213 = zz_214)),pkg_toStdLogicVector(pkg_toStdLogic(zz_215 = zz_216))) /= pkg_stdLogicVector("00"));
  zz_211 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic(zz_217 = zz_218)) /= pkg_stdLogicVector("0")));
  zz_212 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_219,zz_220) /= pkg_stdLogicVector("00"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_221 /= zz_222)),pkg_cat(pkg_toStdLogicVector(zz_223),pkg_cat(zz_224,zz_225))));
  zz_213 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000010000000010000"));
  zz_214 <= pkg_stdLogicVector("00000000000000000010000000000000");
  zz_215 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000101000000000000"));
  zz_216 <= pkg_stdLogicVector("00000000000000000001000000000000");
  zz_217 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000100000011000001010000"));
  zz_218 <= pkg_stdLogicVector("00000000000000000000000001010000");
  zz_219 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_226) = pkg_stdLogicVector("00000000000000000001000001010000")));
  zz_220 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_227) = pkg_stdLogicVector("00000000000000000010000001010000")));
  zz_221 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_228 = zz_229)),pkg_toStdLogicVector(pkg_toStdLogic(zz_230 = zz_231)));
  zz_222 <= pkg_stdLogicVector("00");
  zz_223 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_232),pkg_cat(zz_233,zz_234)) /= pkg_stdLogicVector("000"));
  zz_224 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_235) /= pkg_stdLogicVector("0")));
  zz_225 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_236 /= zz_237)),pkg_cat(pkg_toStdLogicVector(zz_238),pkg_cat(zz_239,zz_240)));
  zz_226 <= pkg_stdLogicVector("00000000000000000001000001010000");
  zz_227 <= pkg_stdLogicVector("00000000000000000010000001010000");
  zz_228 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000110100"));
  zz_229 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_230 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001100100"));
  zz_231 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_232 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001010000")) = pkg_stdLogicVector("00000000000000000000000001000000"));
  zz_233 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_241) = pkg_stdLogicVector("00000000000000000000000000000000")));
  zz_234 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_242) = pkg_stdLogicVector("00000000000000000000000001000000")));
  zz_235 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000100000")) = pkg_stdLogicVector("00000000000000000000000000100000"));
  zz_236 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_243) = pkg_stdLogicVector("00000000000000000000000000010000")));
  zz_237 <= pkg_stdLogicVector("0");
  zz_238 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_96),pkg_cat(zz_244,zz_245)) /= pkg_stdLogicVector("000"));
  zz_239 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_246,zz_247) /= pkg_stdLogicVector("000000")));
  zz_240 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_248 /= zz_249)),pkg_cat(pkg_toStdLogicVector(zz_250),pkg_cat(zz_251,zz_252)));
  zz_241 <= pkg_stdLogicVector("00000000000000000000000000111000");
  zz_242 <= pkg_stdLogicVector("00000000000100000011000001000000");
  zz_243 <= pkg_stdLogicVector("00000000000000000000000000010000");
  zz_244 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_253) = pkg_stdLogicVector("00000000000000000010000000010000")));
  zz_245 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_254) = pkg_stdLogicVector("00000000000000000000000000010000")));
  zz_246 <= pkg_toStdLogicVector(zz_97);
  zz_247 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_255 = zz_256)),pkg_cat(pkg_toStdLogicVector(zz_257),pkg_cat(zz_258,zz_259)));
  zz_248 <= pkg_cat(pkg_toStdLogicVector(zz_96),pkg_toStdLogicVector(pkg_toStdLogic(zz_260 = zz_261)));
  zz_249 <= pkg_stdLogicVector("00");
  zz_250 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_96),pkg_toStdLogicVector(zz_262)) /= pkg_stdLogicVector("00"));
  zz_251 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_263) /= pkg_stdLogicVector("0")));
  zz_252 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_264 /= zz_265)),pkg_cat(pkg_toStdLogicVector(zz_266),pkg_cat(zz_267,zz_268)));
  zz_253 <= pkg_stdLogicVector("00000000000000000010000001010000");
  zz_254 <= pkg_stdLogicVector("00000000000000000001000001010000");
  zz_255 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000001000000010000"));
  zz_256 <= pkg_stdLogicVector("00000000000000000001000000010000");
  zz_257 <= pkg_toStdLogic((decode_INSTRUCTION and zz_269) = pkg_stdLogicVector("00000000000000000010000000010000"));
  zz_258 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_270 = zz_271));
  zz_259 <= pkg_cat(pkg_toStdLogicVector(zz_272),pkg_toStdLogicVector(zz_273));
  zz_260 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001110000"));
  zz_261 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_262 <= pkg_toStdLogic((decode_INSTRUCTION and zz_274) = pkg_stdLogicVector("00000000000000000000000000000000"));
  zz_263 <= pkg_toStdLogic((decode_INSTRUCTION and zz_275) = pkg_stdLogicVector("00000000000000000100000000010000"));
  zz_264 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_276 = zz_277));
  zz_265 <= pkg_stdLogicVector("0");
  zz_266 <= pkg_toStdLogic(pkg_cat(zz_278,zz_279) /= pkg_stdLogicVector("0000"));
  zz_267 <= pkg_toStdLogicVector(pkg_toStdLogic(zz_280 /= zz_281));
  zz_268 <= pkg_cat(pkg_toStdLogicVector(zz_282),pkg_cat(zz_283,zz_284));
  zz_269 <= pkg_stdLogicVector("00000000000000000010000000010000");
  zz_270 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001010000"));
  zz_271 <= pkg_stdLogicVector("00000000000000000000000000010000");
  zz_272 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000001100")) = pkg_stdLogicVector("00000000000000000000000000000100"));
  zz_273 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000101000")) = pkg_stdLogicVector("00000000000000000000000000000000"));
  zz_274 <= pkg_stdLogicVector("00000000000000000000000000100000");
  zz_275 <= pkg_stdLogicVector("00000000000000000100000000010100");
  zz_276 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000110000000010100"));
  zz_277 <= pkg_stdLogicVector("00000000000000000010000000010000");
  zz_278 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_285) = pkg_stdLogicVector("00000000000000000000000000000000")));
  zz_279 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_286 = zz_287)),pkg_cat(pkg_toStdLogicVector(zz_288),pkg_toStdLogicVector(zz_289)));
  zz_280 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_290) = pkg_stdLogicVector("00000000000000000000000000000000")));
  zz_281 <= pkg_stdLogicVector("0");
  zz_282 <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_291),pkg_cat(zz_292,zz_293)) /= pkg_stdLogicVector("000"));
  zz_283 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_294,zz_295) /= pkg_stdLogicVector("00")));
  zz_284 <= pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(zz_296,zz_297) /= pkg_stdLogicVector("00")));
  zz_285 <= pkg_stdLogicVector("00000000000000000000000001000100");
  zz_286 <= (decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000011000"));
  zz_287 <= pkg_stdLogicVector("00000000000000000000000000000000");
  zz_288 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000110000000000100")) = pkg_stdLogicVector("00000000000000000010000000000000"));
  zz_289 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000101000000000100")) = pkg_stdLogicVector("00000000000000000001000000000000"));
  zz_290 <= pkg_stdLogicVector("00000000000000000000000001011000");
  zz_291 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001000100")) = pkg_stdLogicVector("00000000000000000000000001000000"));
  zz_292 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000010000000010100")) = pkg_stdLogicVector("00000000000000000010000000010000")));
  zz_293 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("01000000000000000000000000110100")) = pkg_stdLogicVector("01000000000000000000000000110000")));
  zz_294 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000010100")) = pkg_stdLogicVector("00000000000000000000000000000100")));
  zz_295 <= pkg_toStdLogicVector(zz_95);
  zz_296 <= pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001000100")) = pkg_stdLogicVector("00000000000000000000000000000100")));
  zz_297 <= pkg_toStdLogicVector(zz_95);
  zz_298 <= pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31));
  zz_299 <= pkg_extract(execute_INSTRUCTION,19,12);
  zz_300 <= pkg_extract(execute_INSTRUCTION,20);
  zz_301 <= pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31));
  zz_302 <= pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,7));
  process(clk)
  begin
    if rising_edge(clk) then
      if zz_185 = '1' then
        zz_154 <= RegFilePlugin_regFile(to_integer(decode_RegFilePlugin_regFileReadAddress1));
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if zz_186 = '1' then
        zz_155 <= RegFilePlugin_regFile(to_integer(decode_RegFilePlugin_regFileReadAddress2));
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if zz_38 = '1' then
        RegFilePlugin_regFile(to_integer(lastStageRegFileWrite_payload_address)) <= lastStageRegFileWrite_payload_data;
      end if;
    end if;
  end process;

  IBusSimplePlugin_rspJoin_rspBuffer_c : entity work.StreamFifoLowLatency
    port map ( 
      io_push_valid => iBus_rsp_valid,
      io_push_ready => IBusSimplePlugin_rspJoin_rspBuffer_c_io_push_ready,
      io_push_payload_error => iBus_rsp_payload_error,
      io_push_payload_inst => iBus_rsp_payload_inst,
      io_pop_valid => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid,
      io_pop_ready => zz_152,
      io_pop_payload_error => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error,
      io_pop_payload_inst => IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst,
      io_flush => zz_153,
      io_occupancy => IBusSimplePlugin_rspJoin_rspBuffer_c_io_occupancy,
      clk => clk,
      reset => reset 
    );
  process(zz_187,CsrPlugin_jumpInterface_payload,BranchPlugin_jumpInterface_payload,IBusSimplePlugin_predictionJumpInterface_payload)
  begin
    case zz_187 is
      when "00" =>
        zz_159 <= CsrPlugin_jumpInterface_payload;
      when "01" =>
        zz_159 <= BranchPlugin_jumpInterface_payload;
      when others =>
        zz_159 <= IBusSimplePlugin_predictionJumpInterface_payload;
    end case;
  end process;

  memory_MEMORY_READ_DATA <= dBus_rsp_data;
  execute_SHIFT_RIGHT <= std_logic_vector(pkg_extract(pkg_shiftRight(signed(pkg_cat(pkg_toStdLogicVector((pkg_toStdLogic(execute_SHIFT_CTRL = ShiftCtrlEnum_defaultEncoding_SRA_1) and pkg_extract(execute_FullBarrelShifterPlugin_reversed,31))),execute_FullBarrelShifterPlugin_reversed)),execute_FullBarrelShifterPlugin_amplitude),31,0));
  writeBack_REGFILE_WRITE_DATA <= memory_to_writeBack_REGFILE_WRITE_DATA;
  execute_REGFILE_WRITE_DATA <= zz_106;
  memory_MEMORY_ADDRESS_LOW <= execute_to_memory_MEMORY_ADDRESS_LOW;
  execute_MEMORY_ADDRESS_LOW <= pkg_extract(zz_156,1,0);
  decode_DO_EBREAK <= (((not DebugPlugin_haltIt) and (decode_IS_EBREAK or pkg_toStdLogic(false))) and DebugPlugin_allowEBreak);
  decode_PREDICTION_HAD_BRANCHED2 <= IBusSimplePlugin_decodePrediction_cmd_hadBranch;
  decode_SRC2_FORCE_ZERO <= (decode_SRC_ADD_ZERO and (not decode_SRC_USE_SUB_LESS));
  zz_1 <= zz_2;
  zz_3 <= zz_4;
  decode_SHIFT_CTRL <= zz_5;
  zz_6 <= zz_7;
  decode_ALU_BITWISE_CTRL <= zz_8;
  zz_9 <= zz_10;
  decode_SRC_LESS_UNSIGNED <= pkg_extract(pkg_extract(zz_94,17,17),0);
  zz_11 <= zz_12;
  zz_13 <= zz_14;
  decode_ENV_CTRL <= zz_15;
  zz_16 <= zz_17;
  decode_IS_CSR <= pkg_extract(pkg_extract(zz_94,15,15),0);
  decode_MEMORY_STORE <= pkg_extract(pkg_extract(zz_94,12,12),0);
  execute_BYPASSABLE_MEMORY_STAGE <= decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  decode_BYPASSABLE_MEMORY_STAGE <= pkg_extract(pkg_extract(zz_94,11,11),0);
  decode_BYPASSABLE_EXECUTE_STAGE <= pkg_extract(pkg_extract(zz_94,10,10),0);
  decode_SRC2_CTRL <= zz_18;
  zz_19 <= zz_20;
  decode_ALU_CTRL <= zz_21;
  zz_22 <= zz_23;
  decode_MEMORY_ENABLE <= pkg_extract(pkg_extract(zz_94,3,3),0);
  decode_SRC1_CTRL <= zz_24;
  zz_25 <= zz_26;
  decode_CSR_READ_OPCODE <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,13,7) /= pkg_stdLogicVector("0100000"));
  decode_CSR_WRITE_OPCODE <= (not ((pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,14,13) = pkg_stdLogicVector("01")) and pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,19,15) = pkg_stdLogicVector("00000"))) or (pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,14,13) = pkg_stdLogicVector("11")) and pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,19,15) = pkg_stdLogicVector("00000")))));
  writeBack_FORMAL_PC_NEXT <= memory_to_writeBack_FORMAL_PC_NEXT;
  memory_FORMAL_PC_NEXT <= execute_to_memory_FORMAL_PC_NEXT;
  execute_FORMAL_PC_NEXT <= decode_to_execute_FORMAL_PC_NEXT;
  decode_FORMAL_PC_NEXT <= (decode_PC + pkg_unsigned("00000000000000000000000000000100"));
  memory_PC <= execute_to_memory_PC;
  execute_DO_EBREAK <= decode_to_execute_DO_EBREAK;
  decode_IS_EBREAK <= pkg_extract(pkg_extract(zz_94,25,25),0);
  execute_BRANCH_CALC <= unsigned(pkg_cat(std_logic_vector(pkg_extract(execute_BranchPlugin_branchAdder,31,1)),std_logic_vector(pkg_unsigned("0"))));
  execute_BRANCH_DO <= (pkg_toStdLogic(execute_PREDICTION_HAD_BRANCHED2 /= execute_BRANCH_COND_RESULT) or execute_BranchPlugin_missAlignedTarget);
  execute_PC <= decode_to_execute_PC;
  execute_PREDICTION_HAD_BRANCHED2 <= decode_to_execute_PREDICTION_HAD_BRANCHED2;
  execute_RS1 <= decode_to_execute_RS1;
  execute_BRANCH_COND_RESULT <= zz_128;
  execute_BRANCH_CTRL <= zz_27;
  decode_RS2_USE <= pkg_extract(pkg_extract(zz_94,14,14),0);
  decode_RS1_USE <= pkg_extract(pkg_extract(zz_94,4,4),0);
  execute_REGFILE_WRITE_VALID <= decode_to_execute_REGFILE_WRITE_VALID;
  execute_BYPASSABLE_EXECUTE_STAGE <= decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  memory_REGFILE_WRITE_VALID <= execute_to_memory_REGFILE_WRITE_VALID;
  memory_INSTRUCTION <= execute_to_memory_INSTRUCTION;
  memory_BYPASSABLE_MEMORY_STAGE <= execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  writeBack_REGFILE_WRITE_VALID <= memory_to_writeBack_REGFILE_WRITE_VALID;
  process(decode_RegFilePlugin_rs2Data,zz_117,zz_118,decode_INSTRUCTION,zz_119,zz_160,zz_161,zz_121,zz_50,zz_162,memory_BYPASSABLE_MEMORY_STAGE,zz_123,zz_28,zz_163,execute_BYPASSABLE_EXECUTE_STAGE,zz_125,zz_46)
  begin
    decode_RS2 <= decode_RegFilePlugin_rs2Data;
    if zz_117 = '1' then
      if pkg_toStdLogic(zz_118 = pkg_extract(decode_INSTRUCTION,24,20)) = '1' then
        decode_RS2 <= zz_119;
      end if;
    end if;
    if zz_160 = '1' then
      if zz_161 = '1' then
        if zz_121 = '1' then
          decode_RS2 <= zz_50;
        end if;
      end if;
    end if;
    if zz_162 = '1' then
      if memory_BYPASSABLE_MEMORY_STAGE = '1' then
        if zz_123 = '1' then
          decode_RS2 <= zz_28;
        end if;
      end if;
    end if;
    if zz_163 = '1' then
      if execute_BYPASSABLE_EXECUTE_STAGE = '1' then
        if zz_125 = '1' then
          decode_RS2 <= zz_46;
        end if;
      end if;
    end if;
  end process;

  process(decode_RegFilePlugin_rs1Data,zz_117,zz_118,decode_INSTRUCTION,zz_119,zz_160,zz_161,zz_120,zz_50,zz_162,memory_BYPASSABLE_MEMORY_STAGE,zz_122,zz_28,zz_163,execute_BYPASSABLE_EXECUTE_STAGE,zz_124,zz_46)
  begin
    decode_RS1 <= decode_RegFilePlugin_rs1Data;
    if zz_117 = '1' then
      if pkg_toStdLogic(zz_118 = pkg_extract(decode_INSTRUCTION,19,15)) = '1' then
        decode_RS1 <= zz_119;
      end if;
    end if;
    if zz_160 = '1' then
      if zz_161 = '1' then
        if zz_120 = '1' then
          decode_RS1 <= zz_50;
        end if;
      end if;
    end if;
    if zz_162 = '1' then
      if memory_BYPASSABLE_MEMORY_STAGE = '1' then
        if zz_122 = '1' then
          decode_RS1 <= zz_28;
        end if;
      end if;
    end if;
    if zz_163 = '1' then
      if execute_BYPASSABLE_EXECUTE_STAGE = '1' then
        if zz_124 = '1' then
          decode_RS1 <= zz_46;
        end if;
      end if;
    end if;
  end process;

  memory_SHIFT_RIGHT <= execute_to_memory_SHIFT_RIGHT;
  process(memory_REGFILE_WRITE_DATA,memory_arbitration_isValid,memory_SHIFT_CTRL,zz_114,memory_SHIFT_RIGHT)
  begin
    zz_28 <= memory_REGFILE_WRITE_DATA;
    if memory_arbitration_isValid = '1' then
      case memory_SHIFT_CTRL is
        when ShiftCtrlEnum_defaultEncoding_SLL_1 =>
          zz_28 <= zz_114;
        when ShiftCtrlEnum_defaultEncoding_SRL_1 | ShiftCtrlEnum_defaultEncoding_SRA_1 =>
          zz_28 <= memory_SHIFT_RIGHT;
        when others =>
      end case;
    end if;
  end process;

  memory_SHIFT_CTRL <= zz_29;
  execute_SHIFT_CTRL <= zz_30;
  execute_SRC_LESS_UNSIGNED <= decode_to_execute_SRC_LESS_UNSIGNED;
  execute_SRC2_FORCE_ZERO <= decode_to_execute_SRC2_FORCE_ZERO;
  execute_SRC_USE_SUB_LESS <= decode_to_execute_SRC_USE_SUB_LESS;
  zz_31 <= execute_PC;
  execute_SRC2_CTRL <= zz_32;
  execute_SRC1_CTRL <= zz_33;
  decode_SRC_USE_SUB_LESS <= pkg_extract(pkg_extract(zz_94,2,2),0);
  decode_SRC_ADD_ZERO <= pkg_extract(pkg_extract(zz_94,20,20),0);
  execute_SRC_ADD_SUB <= execute_SrcPlugin_addSub;
  execute_SRC_LESS <= execute_SrcPlugin_less;
  execute_ALU_CTRL <= zz_34;
  execute_SRC2 <= zz_112;
  execute_ALU_BITWISE_CTRL <= zz_35;
  zz_36 <= writeBack_INSTRUCTION;
  zz_37 <= writeBack_REGFILE_WRITE_VALID;
  process(lastStageRegFileWrite_valid)
  begin
    zz_38 <= pkg_toStdLogic(false);
    if lastStageRegFileWrite_valid = '1' then
      zz_38 <= pkg_toStdLogic(true);
    end if;
  end process;

  decode_INSTRUCTION_ANTICIPATED <= pkg_mux(decode_arbitration_isStuck,decode_INSTRUCTION,IBusSimplePlugin_iBusRsp_output_payload_rsp_inst);
  process(zz_94,decode_INSTRUCTION)
  begin
    decode_REGFILE_WRITE_VALID <= pkg_extract(pkg_extract(zz_94,9,9),0);
    if pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,11,7) = pkg_stdLogicVector("00000")) = '1' then
      decode_REGFILE_WRITE_VALID <= pkg_toStdLogic(false);
    end if;
  end process;

  process(execute_REGFILE_WRITE_DATA,zz_164,execute_CsrPlugin_readData)
  begin
    zz_46 <= execute_REGFILE_WRITE_DATA;
    if zz_164 = '1' then
      zz_46 <= execute_CsrPlugin_readData;
    end if;
  end process;

  execute_SRC1 <= zz_107;
  execute_CSR_READ_OPCODE <= decode_to_execute_CSR_READ_OPCODE;
  execute_CSR_WRITE_OPCODE <= decode_to_execute_CSR_WRITE_OPCODE;
  execute_IS_CSR <= decode_to_execute_IS_CSR;
  memory_ENV_CTRL <= zz_47;
  execute_ENV_CTRL <= zz_48;
  writeBack_ENV_CTRL <= zz_49;
  writeBack_MEMORY_STORE <= memory_to_writeBack_MEMORY_STORE;
  process(writeBack_REGFILE_WRITE_DATA,writeBack_arbitration_isValid,writeBack_MEMORY_ENABLE,writeBack_DBusSimplePlugin_rspFormated)
  begin
    zz_50 <= writeBack_REGFILE_WRITE_DATA;
    if (writeBack_arbitration_isValid and writeBack_MEMORY_ENABLE) = '1' then
      zz_50 <= writeBack_DBusSimplePlugin_rspFormated;
    end if;
  end process;

  writeBack_MEMORY_ENABLE <= memory_to_writeBack_MEMORY_ENABLE;
  writeBack_MEMORY_ADDRESS_LOW <= memory_to_writeBack_MEMORY_ADDRESS_LOW;
  writeBack_MEMORY_READ_DATA <= memory_to_writeBack_MEMORY_READ_DATA;
  memory_ALIGNEMENT_FAULT <= execute_to_memory_ALIGNEMENT_FAULT;
  memory_REGFILE_WRITE_DATA <= execute_to_memory_REGFILE_WRITE_DATA;
  memory_MEMORY_STORE <= execute_to_memory_MEMORY_STORE;
  memory_MEMORY_ENABLE <= execute_to_memory_MEMORY_ENABLE;
  execute_SRC_ADD <= execute_SrcPlugin_addSub;
  execute_RS2 <= decode_to_execute_RS2;
  execute_INSTRUCTION <= decode_to_execute_INSTRUCTION;
  execute_MEMORY_STORE <= decode_to_execute_MEMORY_STORE;
  execute_MEMORY_ENABLE <= decode_to_execute_MEMORY_ENABLE;
  execute_ALIGNEMENT_FAULT <= ((pkg_toStdLogic(zz_157 = pkg_unsigned("10")) and pkg_toStdLogic(pkg_extract(zz_156,1,0) /= pkg_unsigned("00"))) or (pkg_toStdLogic(zz_157 = pkg_unsigned("01")) and pkg_toStdLogic(pkg_extract(zz_156,0,0) /= pkg_unsigned("0"))));
  decode_BRANCH_CTRL <= zz_51;
  process(execute_FORMAL_PC_NEXT,BranchPlugin_jumpInterface_valid,BranchPlugin_jumpInterface_payload)
  begin
    zz_52 <= execute_FORMAL_PC_NEXT;
    if BranchPlugin_jumpInterface_valid = '1' then
      zz_52 <= BranchPlugin_jumpInterface_payload;
    end if;
  end process;

  process(decode_FORMAL_PC_NEXT,IBusSimplePlugin_predictionJumpInterface_valid,IBusSimplePlugin_predictionJumpInterface_payload)
  begin
    zz_53 <= decode_FORMAL_PC_NEXT;
    if IBusSimplePlugin_predictionJumpInterface_valid = '1' then
      zz_53 <= IBusSimplePlugin_predictionJumpInterface_payload;
    end if;
  end process;

  decode_PC <= IBusSimplePlugin_injector_decodeInput_payload_pc;
  decode_INSTRUCTION <= IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  writeBack_PC <= memory_to_writeBack_PC;
  writeBack_INSTRUCTION <= memory_to_writeBack_INSTRUCTION;
  process(zz_143)
  begin
    decode_arbitration_haltItself <= pkg_toStdLogic(false);
    case zz_143 is
      when "010" =>
        decode_arbitration_haltItself <= pkg_toStdLogic(true);
      when others =>
    end case;
  end process;

  process(CsrPlugin_pipelineLiberator_active,writeBack_arbitration_isValid,writeBack_ENV_CTRL,memory_arbitration_isValid,memory_ENV_CTRL,execute_arbitration_isValid,execute_ENV_CTRL,decode_arbitration_isValid,zz_115,zz_116)
  begin
    decode_arbitration_haltByOther <= pkg_toStdLogic(false);
    if CsrPlugin_pipelineLiberator_active = '1' then
      decode_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
    if pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector((writeBack_arbitration_isValid and pkg_toStdLogic(writeBack_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET))),pkg_cat(pkg_toStdLogicVector((memory_arbitration_isValid and pkg_toStdLogic(memory_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET))),pkg_toStdLogicVector((execute_arbitration_isValid and pkg_toStdLogic(execute_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET))))) /= pkg_stdLogicVector("000")) = '1' then
      decode_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
    if (decode_arbitration_isValid and (zz_115 or zz_116)) = '1' then
      decode_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
  end process;

  process(decode_arbitration_isFlushed)
  begin
    decode_arbitration_removeIt <= pkg_toStdLogic(false);
    if decode_arbitration_isFlushed = '1' then
      decode_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  decode_arbitration_flushIt <= pkg_toStdLogic(false);
  process(IBusSimplePlugin_predictionJumpInterface_valid)
  begin
    decode_arbitration_flushNext <= pkg_toStdLogic(false);
    if IBusSimplePlugin_predictionJumpInterface_valid = '1' then
      decode_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
  end process;

  process(execute_arbitration_isValid,execute_MEMORY_ENABLE,dBus_cmd_ready,execute_DBusSimplePlugin_skipCmd,zz_84,zz_164,execute_CsrPlugin_blockedBySideEffects)
  begin
    execute_arbitration_haltItself <= pkg_toStdLogic(false);
    if ((((execute_arbitration_isValid and execute_MEMORY_ENABLE) and (not dBus_cmd_ready)) and (not execute_DBusSimplePlugin_skipCmd)) and (not zz_84)) = '1' then
      execute_arbitration_haltItself <= pkg_toStdLogic(true);
    end if;
    if zz_164 = '1' then
      if execute_CsrPlugin_blockedBySideEffects = '1' then
        execute_arbitration_haltItself <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(zz_165)
  begin
    execute_arbitration_haltByOther <= pkg_toStdLogic(false);
    if zz_165 = '1' then
      execute_arbitration_haltByOther <= pkg_toStdLogic(true);
    end if;
  end process;

  process(BranchPlugin_branchExceptionPort_valid,execute_arbitration_isFlushed)
  begin
    execute_arbitration_removeIt <= pkg_toStdLogic(false);
    if BranchPlugin_branchExceptionPort_valid = '1' then
      execute_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
    if execute_arbitration_isFlushed = '1' then
      execute_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  process(zz_165,zz_166)
  begin
    execute_arbitration_flushIt <= pkg_toStdLogic(false);
    if zz_165 = '1' then
      if zz_166 = '1' then
        execute_arbitration_flushIt <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(BranchPlugin_branchExceptionPort_valid,BranchPlugin_jumpInterface_valid,zz_165,zz_166)
  begin
    execute_arbitration_flushNext <= pkg_toStdLogic(false);
    if BranchPlugin_branchExceptionPort_valid = '1' then
      execute_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
    if BranchPlugin_jumpInterface_valid = '1' then
      execute_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
    if zz_165 = '1' then
      if zz_166 = '1' then
        execute_arbitration_flushNext <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(memory_arbitration_isValid,memory_MEMORY_ENABLE,memory_MEMORY_STORE,dBus_rsp_ready)
  begin
    memory_arbitration_haltItself <= pkg_toStdLogic(false);
    if (((memory_arbitration_isValid and memory_MEMORY_ENABLE) and (not memory_MEMORY_STORE)) and ((not dBus_rsp_ready) or pkg_toStdLogic(false))) = '1' then
      memory_arbitration_haltItself <= pkg_toStdLogic(true);
    end if;
  end process;

  memory_arbitration_haltByOther <= pkg_toStdLogic(false);
  process(DBusSimplePlugin_memoryExceptionPort_valid,memory_arbitration_isFlushed)
  begin
    memory_arbitration_removeIt <= pkg_toStdLogic(false);
    if DBusSimplePlugin_memoryExceptionPort_valid = '1' then
      memory_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
    if memory_arbitration_isFlushed = '1' then
      memory_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  memory_arbitration_flushIt <= pkg_toStdLogic(false);
  process(DBusSimplePlugin_memoryExceptionPort_valid)
  begin
    memory_arbitration_flushNext <= pkg_toStdLogic(false);
    if DBusSimplePlugin_memoryExceptionPort_valid = '1' then
      memory_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
  end process;

  writeBack_arbitration_haltItself <= pkg_toStdLogic(false);
  writeBack_arbitration_haltByOther <= pkg_toStdLogic(false);
  process(writeBack_arbitration_isFlushed)
  begin
    writeBack_arbitration_removeIt <= pkg_toStdLogic(false);
    if writeBack_arbitration_isFlushed = '1' then
      writeBack_arbitration_removeIt <= pkg_toStdLogic(true);
    end if;
  end process;

  writeBack_arbitration_flushIt <= pkg_toStdLogic(false);
  process(zz_167,zz_168)
  begin
    writeBack_arbitration_flushNext <= pkg_toStdLogic(false);
    if zz_167 = '1' then
      writeBack_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
    if zz_168 = '1' then
      writeBack_arbitration_flushNext <= pkg_toStdLogic(true);
    end if;
  end process;

  lastStageInstruction <= writeBack_INSTRUCTION;
  lastStagePc <= writeBack_PC;
  lastStageIsValid <= writeBack_arbitration_isValid;
  lastStageIsFiring <= writeBack_arbitration_isFiring;
  process(CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack,CsrPlugin_exceptionPortCtrl_exceptionValids_memory,CsrPlugin_exceptionPortCtrl_exceptionValids_execute,CsrPlugin_exceptionPortCtrl_exceptionValids_decode,zz_167,zz_168,zz_165,zz_166,DebugPlugin_haltIt,zz_169)
  begin
    IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(false);
    if pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack),pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValids_memory),pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValids_execute),pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValids_decode)))) /= pkg_stdLogicVector("0000")) = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
    if zz_167 = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
    if zz_168 = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
    if zz_165 = '1' then
      if zz_166 = '1' then
        IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
      end if;
    end if;
    if DebugPlugin_haltIt = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
    if zz_169 = '1' then
      IBusSimplePlugin_fetcherHalt <= pkg_toStdLogic(true);
    end if;
  end process;

  process(IBusSimplePlugin_iBusRsp_stages_1_input_valid,IBusSimplePlugin_iBusRsp_stages_2_input_valid,IBusSimplePlugin_injector_decodeInput_valid)
  begin
    IBusSimplePlugin_incomingInstruction <= pkg_toStdLogic(false);
    if (IBusSimplePlugin_iBusRsp_stages_1_input_valid or IBusSimplePlugin_iBusRsp_stages_2_input_valid) = '1' then
      IBusSimplePlugin_incomingInstruction <= pkg_toStdLogic(true);
    end if;
    if IBusSimplePlugin_injector_decodeInput_valid = '1' then
      IBusSimplePlugin_incomingInstruction <= pkg_toStdLogic(true);
    end if;
  end process;

  CsrPlugin_inWfi <= pkg_toStdLogic(false);
  process(DebugPlugin_haltIt)
  begin
    CsrPlugin_thirdPartyWake <= pkg_toStdLogic(false);
    if DebugPlugin_haltIt = '1' then
      CsrPlugin_thirdPartyWake <= pkg_toStdLogic(true);
    end if;
  end process;

  process(zz_167,zz_168)
  begin
    CsrPlugin_jumpInterface_valid <= pkg_toStdLogic(false);
    if zz_167 = '1' then
      CsrPlugin_jumpInterface_valid <= pkg_toStdLogic(true);
    end if;
    if zz_168 = '1' then
      CsrPlugin_jumpInterface_valid <= pkg_toStdLogic(true);
    end if;
  end process;

  process(zz_167,CsrPlugin_xtvec_base,zz_168,zz_170,CsrPlugin_mepc)
  begin
    CsrPlugin_jumpInterface_payload <= pkg_unsigned("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    if zz_167 = '1' then
      CsrPlugin_jumpInterface_payload <= unsigned(pkg_cat(std_logic_vector(CsrPlugin_xtvec_base),std_logic_vector(pkg_unsigned("00"))));
    end if;
    if zz_168 = '1' then
      case zz_170 is
        when "11" =>
          CsrPlugin_jumpInterface_payload <= CsrPlugin_mepc;
        when others =>
      end case;
    end if;
  end process;

  process(DebugPlugin_godmode)
  begin
    CsrPlugin_forceMachineWire <= pkg_toStdLogic(false);
    if DebugPlugin_godmode = '1' then
      CsrPlugin_forceMachineWire <= pkg_toStdLogic(true);
    end if;
  end process;

  process(DebugPlugin_haltIt,DebugPlugin_stepIt)
  begin
    CsrPlugin_allowInterrupts <= pkg_toStdLogic(true);
    if (DebugPlugin_haltIt or DebugPlugin_stepIt) = '1' then
      CsrPlugin_allowInterrupts <= pkg_toStdLogic(false);
    end if;
  end process;

  process(DebugPlugin_godmode)
  begin
    CsrPlugin_allowException <= pkg_toStdLogic(true);
    if DebugPlugin_godmode = '1' then
      CsrPlugin_allowException <= pkg_toStdLogic(false);
    end if;
  end process;

  IBusSimplePlugin_externalFlush <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushNext),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushNext),pkg_cat(pkg_toStdLogicVector(execute_arbitration_flushNext),pkg_toStdLogicVector(decode_arbitration_flushNext)))) /= pkg_stdLogicVector("0000"));
  IBusSimplePlugin_jump_pcLoad_valid <= pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(BranchPlugin_jumpInterface_valid),pkg_cat(pkg_toStdLogicVector(CsrPlugin_jumpInterface_valid),pkg_toStdLogicVector(IBusSimplePlugin_predictionJumpInterface_valid))) /= pkg_stdLogicVector("000"));
  zz_54 <= unsigned(pkg_cat(pkg_toStdLogicVector(IBusSimplePlugin_predictionJumpInterface_valid),pkg_cat(pkg_toStdLogicVector(BranchPlugin_jumpInterface_valid),pkg_toStdLogicVector(CsrPlugin_jumpInterface_valid))));
  zz_55 <= std_logic_vector((zz_54 and pkg_not((zz_54 - pkg_unsigned("001")))));
  zz_56 <= pkg_extract(zz_55,1);
  zz_57 <= pkg_extract(zz_55,2);
  IBusSimplePlugin_jump_pcLoad_payload <= zz_159;
  process(IBusSimplePlugin_jump_pcLoad_valid)
  begin
    IBusSimplePlugin_fetchPc_correction <= pkg_toStdLogic(false);
    if IBusSimplePlugin_jump_pcLoad_valid = '1' then
      IBusSimplePlugin_fetchPc_correction <= pkg_toStdLogic(true);
    end if;
  end process;

  IBusSimplePlugin_fetchPc_corrected <= (IBusSimplePlugin_fetchPc_correction or IBusSimplePlugin_fetchPc_correctionReg);
  process(IBusSimplePlugin_iBusRsp_stages_1_input_ready)
  begin
    IBusSimplePlugin_fetchPc_pcRegPropagate <= pkg_toStdLogic(false);
    if IBusSimplePlugin_iBusRsp_stages_1_input_ready = '1' then
      IBusSimplePlugin_fetchPc_pcRegPropagate <= pkg_toStdLogic(true);
    end if;
  end process;

  process(IBusSimplePlugin_fetchPc_pcReg,IBusSimplePlugin_fetchPc_inc,IBusSimplePlugin_jump_pcLoad_valid,IBusSimplePlugin_jump_pcLoad_payload)
  begin
    IBusSimplePlugin_fetchPc_pc <= (IBusSimplePlugin_fetchPc_pcReg + pkg_resize(unsigned(pkg_cat(pkg_toStdLogicVector(IBusSimplePlugin_fetchPc_inc),pkg_stdLogicVector("00"))),32));
    if IBusSimplePlugin_jump_pcLoad_valid = '1' then
      IBusSimplePlugin_fetchPc_pc <= IBusSimplePlugin_jump_pcLoad_payload;
    end if;
    IBusSimplePlugin_fetchPc_pc(0) <= pkg_toStdLogic(false);
    IBusSimplePlugin_fetchPc_pc(1) <= pkg_toStdLogic(false);
  end process;

  process(IBusSimplePlugin_jump_pcLoad_valid)
  begin
    IBusSimplePlugin_fetchPc_flushed <= pkg_toStdLogic(false);
    if IBusSimplePlugin_jump_pcLoad_valid = '1' then
      IBusSimplePlugin_fetchPc_flushed <= pkg_toStdLogic(true);
    end if;
  end process;

  IBusSimplePlugin_fetchPc_output_valid <= ((not IBusSimplePlugin_fetcherHalt) and IBusSimplePlugin_fetchPc_booted);
  IBusSimplePlugin_fetchPc_output_payload <= IBusSimplePlugin_fetchPc_pc;
  IBusSimplePlugin_iBusRsp_redoFetch <= pkg_toStdLogic(false);
  IBusSimplePlugin_iBusRsp_stages_0_input_valid <= IBusSimplePlugin_fetchPc_output_valid;
  IBusSimplePlugin_fetchPc_output_ready <= IBusSimplePlugin_iBusRsp_stages_0_input_ready;
  IBusSimplePlugin_iBusRsp_stages_0_input_payload <= IBusSimplePlugin_fetchPc_output_payload;
  IBusSimplePlugin_iBusRsp_stages_0_halt <= pkg_toStdLogic(false);
  zz_58 <= (not IBusSimplePlugin_iBusRsp_stages_0_halt);
  IBusSimplePlugin_iBusRsp_stages_0_input_ready <= (IBusSimplePlugin_iBusRsp_stages_0_output_ready and zz_58);
  IBusSimplePlugin_iBusRsp_stages_0_output_valid <= (IBusSimplePlugin_iBusRsp_stages_0_input_valid and zz_58);
  IBusSimplePlugin_iBusRsp_stages_0_output_payload <= IBusSimplePlugin_iBusRsp_stages_0_input_payload;
  process(IBusSimplePlugin_iBusRsp_stages_1_input_valid,IBusSimplePlugin_cmdFork_canEmit,IBusSimplePlugin_cmd_ready)
  begin
    IBusSimplePlugin_iBusRsp_stages_1_halt <= pkg_toStdLogic(false);
    if (IBusSimplePlugin_iBusRsp_stages_1_input_valid and ((not IBusSimplePlugin_cmdFork_canEmit) or (not IBusSimplePlugin_cmd_ready))) = '1' then
      IBusSimplePlugin_iBusRsp_stages_1_halt <= pkg_toStdLogic(true);
    end if;
  end process;

  zz_59 <= (not IBusSimplePlugin_iBusRsp_stages_1_halt);
  IBusSimplePlugin_iBusRsp_stages_1_input_ready <= (IBusSimplePlugin_iBusRsp_stages_1_output_ready and zz_59);
  IBusSimplePlugin_iBusRsp_stages_1_output_valid <= (IBusSimplePlugin_iBusRsp_stages_1_input_valid and zz_59);
  IBusSimplePlugin_iBusRsp_stages_1_output_payload <= IBusSimplePlugin_iBusRsp_stages_1_input_payload;
  IBusSimplePlugin_iBusRsp_stages_2_halt <= pkg_toStdLogic(false);
  zz_60 <= (not IBusSimplePlugin_iBusRsp_stages_2_halt);
  IBusSimplePlugin_iBusRsp_stages_2_input_ready <= (IBusSimplePlugin_iBusRsp_stages_2_output_ready and zz_60);
  IBusSimplePlugin_iBusRsp_stages_2_output_valid <= (IBusSimplePlugin_iBusRsp_stages_2_input_valid and zz_60);
  IBusSimplePlugin_iBusRsp_stages_2_output_payload <= IBusSimplePlugin_iBusRsp_stages_2_input_payload;
  IBusSimplePlugin_iBusRsp_flush <= (IBusSimplePlugin_externalFlush or IBusSimplePlugin_iBusRsp_redoFetch);
  IBusSimplePlugin_iBusRsp_stages_0_output_ready <= zz_61;
  zz_61 <= ((pkg_toStdLogic(false) and (not zz_62)) or IBusSimplePlugin_iBusRsp_stages_1_input_ready);
  zz_62 <= zz_63;
  IBusSimplePlugin_iBusRsp_stages_1_input_valid <= zz_62;
  IBusSimplePlugin_iBusRsp_stages_1_input_payload <= IBusSimplePlugin_fetchPc_pcReg;
  IBusSimplePlugin_iBusRsp_stages_1_output_ready <= ((pkg_toStdLogic(false) and (not zz_64)) or IBusSimplePlugin_iBusRsp_stages_2_input_ready);
  zz_64 <= zz_65;
  IBusSimplePlugin_iBusRsp_stages_2_input_valid <= zz_64;
  IBusSimplePlugin_iBusRsp_stages_2_input_payload <= zz_66;
  process(IBusSimplePlugin_injector_decodeInput_valid,IBusSimplePlugin_pcValids_0)
  begin
    IBusSimplePlugin_iBusRsp_readyForError <= pkg_toStdLogic(true);
    if IBusSimplePlugin_injector_decodeInput_valid = '1' then
      IBusSimplePlugin_iBusRsp_readyForError <= pkg_toStdLogic(false);
    end if;
    if (not IBusSimplePlugin_pcValids_0) = '1' then
      IBusSimplePlugin_iBusRsp_readyForError <= pkg_toStdLogic(false);
    end if;
  end process;

  IBusSimplePlugin_iBusRsp_output_ready <= ((pkg_toStdLogic(false) and (not IBusSimplePlugin_injector_decodeInput_valid)) or IBusSimplePlugin_injector_decodeInput_ready);
  IBusSimplePlugin_injector_decodeInput_valid <= zz_67;
  IBusSimplePlugin_injector_decodeInput_payload_pc <= zz_68;
  IBusSimplePlugin_injector_decodeInput_payload_rsp_error <= zz_69;
  IBusSimplePlugin_injector_decodeInput_payload_rsp_inst <= zz_70;
  IBusSimplePlugin_injector_decodeInput_payload_isRvc <= zz_71;
  IBusSimplePlugin_pcValids_0 <= IBusSimplePlugin_injector_nextPcCalc_valids_2;
  IBusSimplePlugin_pcValids_1 <= IBusSimplePlugin_injector_nextPcCalc_valids_3;
  IBusSimplePlugin_pcValids_2 <= IBusSimplePlugin_injector_nextPcCalc_valids_4;
  IBusSimplePlugin_pcValids_3 <= IBusSimplePlugin_injector_nextPcCalc_valids_5;
  IBusSimplePlugin_injector_decodeInput_ready <= (not decode_arbitration_isStuck);
  process(IBusSimplePlugin_injector_decodeInput_valid,zz_143)
  begin
    decode_arbitration_isValid <= IBusSimplePlugin_injector_decodeInput_valid;
    case zz_143 is
      when "010" =>
        decode_arbitration_isValid <= pkg_toStdLogic(true);
      when "011" =>
        decode_arbitration_isValid <= pkg_toStdLogic(true);
      when others =>
    end case;
  end process;

  zz_72 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,7))),pkg_extract(decode_INSTRUCTION,30,25)),pkg_extract(decode_INSTRUCTION,11,8)),11);
  process(zz_72)
  begin
    zz_73(18) <= zz_72;
    zz_73(17) <= zz_72;
    zz_73(16) <= zz_72;
    zz_73(15) <= zz_72;
    zz_73(14) <= zz_72;
    zz_73(13) <= zz_72;
    zz_73(12) <= zz_72;
    zz_73(11) <= zz_72;
    zz_73(10) <= zz_72;
    zz_73(9) <= zz_72;
    zz_73(8) <= zz_72;
    zz_73(7) <= zz_72;
    zz_73(6) <= zz_72;
    zz_73(5) <= zz_72;
    zz_73(4) <= zz_72;
    zz_73(3) <= zz_72;
    zz_73(2) <= zz_72;
    zz_73(1) <= zz_72;
    zz_73(0) <= zz_72;
  end process;

  process(decode_BRANCH_CTRL,zz_73,decode_INSTRUCTION,zz_78)
  begin
    IBusSimplePlugin_decodePrediction_cmd_hadBranch <= (pkg_toStdLogic(decode_BRANCH_CTRL = BranchCtrlEnum_defaultEncoding_JAL) or (pkg_toStdLogic(decode_BRANCH_CTRL = BranchCtrlEnum_defaultEncoding_B) and pkg_extract(pkg_cat(pkg_cat(zz_73,pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,7))),pkg_extract(decode_INSTRUCTION,30,25)),pkg_extract(decode_INSTRUCTION,11,8))),pkg_toStdLogicVector(pkg_toStdLogic(false))),31)));
    if zz_78 = '1' then
      IBusSimplePlugin_decodePrediction_cmd_hadBranch <= pkg_toStdLogic(false);
    end if;
  end process;

  zz_74 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31)),pkg_extract(decode_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,20))),pkg_extract(decode_INSTRUCTION,30,21)),19);
  process(zz_74)
  begin
    zz_75(10) <= zz_74;
    zz_75(9) <= zz_74;
    zz_75(8) <= zz_74;
    zz_75(7) <= zz_74;
    zz_75(6) <= zz_74;
    zz_75(5) <= zz_74;
    zz_75(4) <= zz_74;
    zz_75(3) <= zz_74;
    zz_75(2) <= zz_74;
    zz_75(1) <= zz_74;
    zz_75(0) <= zz_74;
  end process;

  zz_76 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,7))),pkg_extract(decode_INSTRUCTION,30,25)),pkg_extract(decode_INSTRUCTION,11,8)),11);
  process(zz_76)
  begin
    zz_77(18) <= zz_76;
    zz_77(17) <= zz_76;
    zz_77(16) <= zz_76;
    zz_77(15) <= zz_76;
    zz_77(14) <= zz_76;
    zz_77(13) <= zz_76;
    zz_77(12) <= zz_76;
    zz_77(11) <= zz_76;
    zz_77(10) <= zz_76;
    zz_77(9) <= zz_76;
    zz_77(8) <= zz_76;
    zz_77(7) <= zz_76;
    zz_77(6) <= zz_76;
    zz_77(5) <= zz_76;
    zz_77(4) <= zz_76;
    zz_77(3) <= zz_76;
    zz_77(2) <= zz_76;
    zz_77(1) <= zz_76;
    zz_77(0) <= zz_76;
  end process;

  process(decode_BRANCH_CTRL,zz_75,decode_INSTRUCTION,zz_77)
  begin
    case decode_BRANCH_CTRL is
      when BranchCtrlEnum_defaultEncoding_JAL =>
        zz_78 <= pkg_extract(pkg_cat(pkg_cat(zz_75,pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31)),pkg_extract(decode_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,20))),pkg_extract(decode_INSTRUCTION,30,21))),pkg_toStdLogicVector(pkg_toStdLogic(false))),1);
      when others =>
        zz_78 <= pkg_extract(pkg_cat(pkg_cat(zz_77,pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,7))),pkg_extract(decode_INSTRUCTION,30,25)),pkg_extract(decode_INSTRUCTION,11,8))),pkg_toStdLogicVector(pkg_toStdLogic(false))),1);
    end case;
  end process;

  IBusSimplePlugin_predictionJumpInterface_valid <= (decode_arbitration_isValid and IBusSimplePlugin_decodePrediction_cmd_hadBranch);
  zz_79 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31)),pkg_extract(decode_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,20))),pkg_extract(decode_INSTRUCTION,30,21)),19);
  process(zz_79)
  begin
    zz_80(10) <= zz_79;
    zz_80(9) <= zz_79;
    zz_80(8) <= zz_79;
    zz_80(7) <= zz_79;
    zz_80(6) <= zz_79;
    zz_80(5) <= zz_79;
    zz_80(4) <= zz_79;
    zz_80(3) <= zz_79;
    zz_80(2) <= zz_79;
    zz_80(1) <= zz_79;
    zz_80(0) <= zz_79;
  end process;

  zz_81 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(decode_INSTRUCTION,7))),pkg_extract(decode_INSTRUCTION,30,25)),pkg_extract(decode_INSTRUCTION,11,8)),11);
  process(zz_81)
  begin
    zz_82(18) <= zz_81;
    zz_82(17) <= zz_81;
    zz_82(16) <= zz_81;
    zz_82(15) <= zz_81;
    zz_82(14) <= zz_81;
    zz_82(13) <= zz_81;
    zz_82(12) <= zz_81;
    zz_82(11) <= zz_81;
    zz_82(10) <= zz_81;
    zz_82(9) <= zz_81;
    zz_82(8) <= zz_81;
    zz_82(7) <= zz_81;
    zz_82(6) <= zz_81;
    zz_82(5) <= zz_81;
    zz_82(4) <= zz_81;
    zz_82(3) <= zz_81;
    zz_82(2) <= zz_81;
    zz_82(1) <= zz_81;
    zz_82(0) <= zz_81;
  end process;

  IBusSimplePlugin_predictionJumpInterface_payload <= (decode_PC + unsigned(pkg_mux(pkg_toStdLogic(decode_BRANCH_CTRL = BranchCtrlEnum_defaultEncoding_JAL),pkg_cat(pkg_cat(zz_80,pkg_cat(pkg_cat(pkg_cat(zz_188,zz_189),pkg_toStdLogicVector(zz_190)),pkg_extract(decode_INSTRUCTION,30,21))),pkg_toStdLogicVector(pkg_toStdLogic(false))),pkg_cat(pkg_cat(zz_82,pkg_cat(pkg_cat(pkg_cat(zz_191,zz_192),pkg_extract(decode_INSTRUCTION,30,25)),pkg_extract(decode_INSTRUCTION,11,8))),pkg_toStdLogicVector(pkg_toStdLogic(false))))));
  iBus_cmd_valid <= IBusSimplePlugin_cmd_valid;
  IBusSimplePlugin_cmd_ready <= iBus_cmd_ready;
  iBus_cmd_payload_pc <= IBusSimplePlugin_cmd_payload_pc;
  IBusSimplePlugin_pending_next <= ((IBusSimplePlugin_pending_value + pkg_resize(unsigned(pkg_toStdLogicVector(IBusSimplePlugin_pending_inc)),3)) - pkg_resize(unsigned(pkg_toStdLogicVector(IBusSimplePlugin_pending_dec)),3));
  IBusSimplePlugin_cmdFork_canEmit <= (IBusSimplePlugin_iBusRsp_stages_1_output_ready and pkg_toStdLogic(IBusSimplePlugin_pending_value /= pkg_unsigned("111")));
  IBusSimplePlugin_cmd_valid <= (IBusSimplePlugin_iBusRsp_stages_1_input_valid and IBusSimplePlugin_cmdFork_canEmit);
  IBusSimplePlugin_pending_inc <= (IBusSimplePlugin_cmd_valid and IBusSimplePlugin_cmd_ready);
  IBusSimplePlugin_cmd_payload_pc <= unsigned(pkg_cat(std_logic_vector(pkg_extract(IBusSimplePlugin_iBusRsp_stages_1_input_payload,31,2)),std_logic_vector(pkg_unsigned("00"))));
  IBusSimplePlugin_rspJoin_rspBuffer_flush <= (pkg_toStdLogic(IBusSimplePlugin_rspJoin_rspBuffer_discardCounter /= pkg_unsigned("000")) or IBusSimplePlugin_iBusRsp_flush);
  IBusSimplePlugin_rspJoin_rspBuffer_output_valid <= (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid and pkg_toStdLogic(IBusSimplePlugin_rspJoin_rspBuffer_discardCounter = pkg_unsigned("000")));
  IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error <= IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_error;
  IBusSimplePlugin_rspJoin_rspBuffer_output_payload_inst <= IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_payload_inst;
  zz_152 <= (IBusSimplePlugin_rspJoin_rspBuffer_output_ready or IBusSimplePlugin_rspJoin_rspBuffer_flush);
  IBusSimplePlugin_pending_dec <= (IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid and zz_152);
  IBusSimplePlugin_rspJoin_fetchRsp_pc <= IBusSimplePlugin_iBusRsp_stages_2_output_payload;
  process(IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error,IBusSimplePlugin_rspJoin_rspBuffer_output_valid)
  begin
    IBusSimplePlugin_rspJoin_fetchRsp_rsp_error <= IBusSimplePlugin_rspJoin_rspBuffer_output_payload_error;
    if (not IBusSimplePlugin_rspJoin_rspBuffer_output_valid) = '1' then
      IBusSimplePlugin_rspJoin_fetchRsp_rsp_error <= pkg_toStdLogic(false);
    end if;
  end process;

  IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst <= IBusSimplePlugin_rspJoin_rspBuffer_output_payload_inst;
  IBusSimplePlugin_rspJoin_exceptionDetected <= pkg_toStdLogic(false);
  IBusSimplePlugin_rspJoin_join_valid <= (IBusSimplePlugin_iBusRsp_stages_2_output_valid and IBusSimplePlugin_rspJoin_rspBuffer_output_valid);
  IBusSimplePlugin_rspJoin_join_payload_pc <= IBusSimplePlugin_rspJoin_fetchRsp_pc;
  IBusSimplePlugin_rspJoin_join_payload_rsp_error <= IBusSimplePlugin_rspJoin_fetchRsp_rsp_error;
  IBusSimplePlugin_rspJoin_join_payload_rsp_inst <= IBusSimplePlugin_rspJoin_fetchRsp_rsp_inst;
  IBusSimplePlugin_rspJoin_join_payload_isRvc <= IBusSimplePlugin_rspJoin_fetchRsp_isRvc;
  IBusSimplePlugin_iBusRsp_stages_2_output_ready <= pkg_mux(IBusSimplePlugin_iBusRsp_stages_2_output_valid,(IBusSimplePlugin_rspJoin_join_valid and IBusSimplePlugin_rspJoin_join_ready),IBusSimplePlugin_rspJoin_join_ready);
  IBusSimplePlugin_rspJoin_rspBuffer_output_ready <= (IBusSimplePlugin_rspJoin_join_valid and IBusSimplePlugin_rspJoin_join_ready);
  zz_83 <= (not IBusSimplePlugin_rspJoin_exceptionDetected);
  IBusSimplePlugin_rspJoin_join_ready <= (IBusSimplePlugin_iBusRsp_output_ready and zz_83);
  IBusSimplePlugin_iBusRsp_output_valid <= (IBusSimplePlugin_rspJoin_join_valid and zz_83);
  IBusSimplePlugin_iBusRsp_output_payload_pc <= IBusSimplePlugin_rspJoin_join_payload_pc;
  IBusSimplePlugin_iBusRsp_output_payload_rsp_error <= IBusSimplePlugin_rspJoin_join_payload_rsp_error;
  IBusSimplePlugin_iBusRsp_output_payload_rsp_inst <= IBusSimplePlugin_rspJoin_join_payload_rsp_inst;
  IBusSimplePlugin_iBusRsp_output_payload_isRvc <= IBusSimplePlugin_rspJoin_join_payload_isRvc;
  zz_84 <= pkg_toStdLogic(false);
  process(execute_ALIGNEMENT_FAULT)
  begin
    execute_DBusSimplePlugin_skipCmd <= pkg_toStdLogic(false);
    if execute_ALIGNEMENT_FAULT = '1' then
      execute_DBusSimplePlugin_skipCmd <= pkg_toStdLogic(true);
    end if;
  end process;

  dBus_cmd_valid <= (((((execute_arbitration_isValid and execute_MEMORY_ENABLE) and (not execute_arbitration_isStuckByOthers)) and (not execute_arbitration_isFlushed)) and (not execute_DBusSimplePlugin_skipCmd)) and (not zz_84));
  dBus_cmd_payload_wr <= execute_MEMORY_STORE;
  zz_157 <= unsigned(pkg_extract(execute_INSTRUCTION,13,12));
  process(zz_157,execute_RS2)
  begin
    case zz_157 is
      when "00" =>
        zz_85 <= pkg_cat(pkg_cat(pkg_cat(pkg_extract(execute_RS2,7,0),pkg_extract(execute_RS2,7,0)),pkg_extract(execute_RS2,7,0)),pkg_extract(execute_RS2,7,0));
      when "01" =>
        zz_85 <= pkg_cat(pkg_extract(execute_RS2,15,0),pkg_extract(execute_RS2,15,0));
      when others =>
        zz_85 <= pkg_extract(execute_RS2,31,0);
    end case;
  end process;

  dBus_cmd_payload_data <= zz_85;
  process(zz_157)
  begin
    case zz_157 is
      when "00" =>
        zz_86 <= pkg_stdLogicVector("0001");
      when "01" =>
        zz_86 <= pkg_stdLogicVector("0011");
      when others =>
        zz_86 <= pkg_stdLogicVector("1111");
    end case;
  end process;

  execute_DBusSimplePlugin_formalMask <= std_logic_vector(shift_left(unsigned(zz_86),to_integer(pkg_extract(zz_156,1,0))));
  zz_156 <= unsigned(execute_SRC_ADD);
  process(memory_ALIGNEMENT_FAULT,memory_arbitration_isValid,memory_MEMORY_ENABLE,memory_arbitration_isStuckByOthers)
  begin
    DBusSimplePlugin_memoryExceptionPort_valid <= pkg_toStdLogic(false);
    if memory_ALIGNEMENT_FAULT = '1' then
      DBusSimplePlugin_memoryExceptionPort_valid <= pkg_toStdLogic(true);
    end if;
    if (not ((memory_arbitration_isValid and memory_MEMORY_ENABLE) and (pkg_toStdLogic(true) or (not memory_arbitration_isStuckByOthers)))) = '1' then
      DBusSimplePlugin_memoryExceptionPort_valid <= pkg_toStdLogic(false);
    end if;
  end process;

  process(memory_ALIGNEMENT_FAULT,memory_MEMORY_STORE)
  begin
    DBusSimplePlugin_memoryExceptionPort_payload_code <= pkg_unsigned("XXXX");
    if memory_ALIGNEMENT_FAULT = '1' then
      DBusSimplePlugin_memoryExceptionPort_payload_code <= pkg_resize(pkg_mux(memory_MEMORY_STORE,pkg_unsigned("110"),pkg_unsigned("100")),4);
    end if;
  end process;

  DBusSimplePlugin_memoryExceptionPort_payload_badAddr <= unsigned(memory_REGFILE_WRITE_DATA);
  process(writeBack_MEMORY_READ_DATA,writeBack_MEMORY_ADDRESS_LOW)
  begin
    writeBack_DBusSimplePlugin_rspShifted <= writeBack_MEMORY_READ_DATA;
    case writeBack_MEMORY_ADDRESS_LOW is
      when "01" =>
        writeBack_DBusSimplePlugin_rspShifted(7 downto 0) <= pkg_extract(writeBack_MEMORY_READ_DATA,15,8);
      when "10" =>
        writeBack_DBusSimplePlugin_rspShifted(15 downto 0) <= pkg_extract(writeBack_MEMORY_READ_DATA,31,16);
      when "11" =>
        writeBack_DBusSimplePlugin_rspShifted(7 downto 0) <= pkg_extract(writeBack_MEMORY_READ_DATA,31,24);
      when others =>
    end case;
  end process;

  zz_87 <= (pkg_extract(writeBack_DBusSimplePlugin_rspShifted,7) and (not pkg_extract(writeBack_INSTRUCTION,14)));
  process(zz_87,writeBack_DBusSimplePlugin_rspShifted)
  begin
    zz_88(31) <= zz_87;
    zz_88(30) <= zz_87;
    zz_88(29) <= zz_87;
    zz_88(28) <= zz_87;
    zz_88(27) <= zz_87;
    zz_88(26) <= zz_87;
    zz_88(25) <= zz_87;
    zz_88(24) <= zz_87;
    zz_88(23) <= zz_87;
    zz_88(22) <= zz_87;
    zz_88(21) <= zz_87;
    zz_88(20) <= zz_87;
    zz_88(19) <= zz_87;
    zz_88(18) <= zz_87;
    zz_88(17) <= zz_87;
    zz_88(16) <= zz_87;
    zz_88(15) <= zz_87;
    zz_88(14) <= zz_87;
    zz_88(13) <= zz_87;
    zz_88(12) <= zz_87;
    zz_88(11) <= zz_87;
    zz_88(10) <= zz_87;
    zz_88(9) <= zz_87;
    zz_88(8) <= zz_87;
    zz_88(7 downto 0) <= pkg_extract(writeBack_DBusSimplePlugin_rspShifted,7,0);
  end process;

  zz_89 <= (pkg_extract(writeBack_DBusSimplePlugin_rspShifted,15) and (not pkg_extract(writeBack_INSTRUCTION,14)));
  process(zz_89,writeBack_DBusSimplePlugin_rspShifted)
  begin
    zz_90(31) <= zz_89;
    zz_90(30) <= zz_89;
    zz_90(29) <= zz_89;
    zz_90(28) <= zz_89;
    zz_90(27) <= zz_89;
    zz_90(26) <= zz_89;
    zz_90(25) <= zz_89;
    zz_90(24) <= zz_89;
    zz_90(23) <= zz_89;
    zz_90(22) <= zz_89;
    zz_90(21) <= zz_89;
    zz_90(20) <= zz_89;
    zz_90(19) <= zz_89;
    zz_90(18) <= zz_89;
    zz_90(17) <= zz_89;
    zz_90(16) <= zz_89;
    zz_90(15 downto 0) <= pkg_extract(writeBack_DBusSimplePlugin_rspShifted,15,0);
  end process;

  process(zz_183,zz_88,zz_90,writeBack_DBusSimplePlugin_rspShifted)
  begin
    case zz_183 is
      when "00" =>
        writeBack_DBusSimplePlugin_rspFormated <= zz_88;
      when "01" =>
        writeBack_DBusSimplePlugin_rspFormated <= zz_90;
      when others =>
        writeBack_DBusSimplePlugin_rspFormated <= writeBack_DBusSimplePlugin_rspShifted;
    end case;
  end process;

  process(CsrPlugin_forceMachineWire)
  begin
    CsrPlugin_privilege <= pkg_unsigned("11");
    if CsrPlugin_forceMachineWire = '1' then
      CsrPlugin_privilege <= pkg_unsigned("11");
    end if;
  end process;

  CsrPlugin_misa_base <= pkg_unsigned("01");
  CsrPlugin_misa_extensions <= pkg_stdLogicVector("00000000000000000001000010");
  CsrPlugin_mtvec_mode <= pkg_stdLogicVector("00");
  CsrPlugin_mtvec_base <= pkg_unsigned("100000000000000000000000001000");
  zz_91 <= (CsrPlugin_mip_MTIP and CsrPlugin_mie_MTIE);
  zz_92 <= (CsrPlugin_mip_MSIP and CsrPlugin_mie_MSIE);
  zz_93 <= (CsrPlugin_mip_MEIP and CsrPlugin_mie_MEIE);
  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= pkg_toStdLogic(false);
  CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped <= pkg_unsigned("11");
  CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege <= pkg_mux(pkg_toStdLogic(CsrPlugin_privilege < CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped),CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped,CsrPlugin_privilege);
  CsrPlugin_exceptionPortCtrl_exceptionValids_decode <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  process(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute,BranchPlugin_branchExceptionPort_valid,execute_arbitration_isFlushed)
  begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_execute <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
    if BranchPlugin_branchExceptionPort_valid = '1' then
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute <= pkg_toStdLogic(true);
    end if;
    if execute_arbitration_isFlushed = '1' then
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute <= pkg_toStdLogic(false);
    end if;
  end process;

  process(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,DBusSimplePlugin_memoryExceptionPort_valid,memory_arbitration_isFlushed)
  begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_memory <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
    if DBusSimplePlugin_memoryExceptionPort_valid = '1' then
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory <= pkg_toStdLogic(true);
    end if;
    if memory_arbitration_isFlushed = '1' then
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory <= pkg_toStdLogic(false);
    end if;
  end process;

  process(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,writeBack_arbitration_isFlushed)
  begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
    if writeBack_arbitration_isFlushed = '1' then
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack <= pkg_toStdLogic(false);
    end if;
  end process;

  CsrPlugin_exceptionPendings_0 <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  CsrPlugin_exceptionPendings_1 <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  CsrPlugin_exceptionPendings_2 <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  CsrPlugin_exceptionPendings_3 <= CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  CsrPlugin_exception <= (CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack and CsrPlugin_allowException);
  CsrPlugin_lastStageWasWfi <= pkg_toStdLogic(false);
  CsrPlugin_pipelineLiberator_active <= ((CsrPlugin_interrupt_valid and CsrPlugin_allowInterrupts) and decode_arbitration_isValid);
  process(CsrPlugin_pipelineLiberator_pcValids_2,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute,CsrPlugin_hadException)
  begin
    CsrPlugin_pipelineLiberator_done <= CsrPlugin_pipelineLiberator_pcValids_2;
    if pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack),pkg_cat(pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory),pkg_toStdLogicVector(CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute))) /= pkg_stdLogicVector("000")) = '1' then
      CsrPlugin_pipelineLiberator_done <= pkg_toStdLogic(false);
    end if;
    if CsrPlugin_hadException = '1' then
      CsrPlugin_pipelineLiberator_done <= pkg_toStdLogic(false);
    end if;
  end process;

  CsrPlugin_interruptJump <= ((CsrPlugin_interrupt_valid and CsrPlugin_pipelineLiberator_done) and CsrPlugin_allowInterrupts);
  process(CsrPlugin_interrupt_targetPrivilege,CsrPlugin_hadException,CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege)
  begin
    CsrPlugin_targetPrivilege <= CsrPlugin_interrupt_targetPrivilege;
    if CsrPlugin_hadException = '1' then
      CsrPlugin_targetPrivilege <= CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
    end if;
  end process;

  process(CsrPlugin_interrupt_code,CsrPlugin_hadException,CsrPlugin_exceptionPortCtrl_exceptionContext_code)
  begin
    CsrPlugin_trapCause <= CsrPlugin_interrupt_code;
    if CsrPlugin_hadException = '1' then
      CsrPlugin_trapCause <= CsrPlugin_exceptionPortCtrl_exceptionContext_code;
    end if;
  end process;

  process(CsrPlugin_targetPrivilege,CsrPlugin_mtvec_mode)
  begin
    CsrPlugin_xtvec_mode <= pkg_stdLogicVector("XX");
    case CsrPlugin_targetPrivilege is
      when "11" =>
        CsrPlugin_xtvec_mode <= CsrPlugin_mtvec_mode;
      when others =>
    end case;
  end process;

  process(CsrPlugin_targetPrivilege,CsrPlugin_mtvec_base)
  begin
    CsrPlugin_xtvec_base <= pkg_unsigned("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    case CsrPlugin_targetPrivilege is
      when "11" =>
        CsrPlugin_xtvec_base <= CsrPlugin_mtvec_base;
      when others =>
    end case;
  end process;

  contextSwitching <= CsrPlugin_jumpInterface_valid;
  execute_CsrPlugin_blockedBySideEffects <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_isValid),pkg_toStdLogicVector(memory_arbitration_isValid)) /= pkg_stdLogicVector("00")) or pkg_toStdLogic(false));
  process(execute_CsrPlugin_csr_768,execute_CsrPlugin_csr_836,execute_CsrPlugin_csr_772,execute_CsrPlugin_csr_833,execute_CsrPlugin_csr_834,execute_CSR_READ_OPCODE,execute_CsrPlugin_csr_835,execute_CsrPlugin_csr_3072,execute_CsrPlugin_csr_3200,zz_171,execute_arbitration_isValid,execute_IS_CSR)
  begin
    execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(true);
    if execute_CsrPlugin_csr_768 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
    if execute_CsrPlugin_csr_836 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
    if execute_CsrPlugin_csr_772 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
    if execute_CsrPlugin_csr_833 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
    if execute_CsrPlugin_csr_834 = '1' then
      if execute_CSR_READ_OPCODE = '1' then
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      end if;
    end if;
    if execute_CsrPlugin_csr_835 = '1' then
      if execute_CSR_READ_OPCODE = '1' then
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      end if;
    end if;
    if execute_CsrPlugin_csr_3072 = '1' then
      if execute_CSR_READ_OPCODE = '1' then
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      end if;
    end if;
    if execute_CsrPlugin_csr_3200 = '1' then
      if execute_CSR_READ_OPCODE = '1' then
        execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
      end if;
    end if;
    if zz_171 = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(true);
    end if;
    if ((not execute_arbitration_isValid) or (not execute_IS_CSR)) = '1' then
      execute_CsrPlugin_illegalAccess <= pkg_toStdLogic(false);
    end if;
  end process;

  process(execute_arbitration_isValid,execute_ENV_CTRL,CsrPlugin_privilege,execute_INSTRUCTION)
  begin
    execute_CsrPlugin_illegalInstruction <= pkg_toStdLogic(false);
    if (execute_arbitration_isValid and pkg_toStdLogic(execute_ENV_CTRL = EnvCtrlEnum_defaultEncoding_XRET)) = '1' then
      if pkg_toStdLogic(CsrPlugin_privilege < unsigned(pkg_extract(execute_INSTRUCTION,29,28))) = '1' then
        execute_CsrPlugin_illegalInstruction <= pkg_toStdLogic(true);
      end if;
    end if;
  end process;

  process(execute_arbitration_isValid,execute_IS_CSR,execute_CSR_WRITE_OPCODE,zz_171)
  begin
    execute_CsrPlugin_writeInstruction <= ((execute_arbitration_isValid and execute_IS_CSR) and execute_CSR_WRITE_OPCODE);
    if zz_171 = '1' then
      execute_CsrPlugin_writeInstruction <= pkg_toStdLogic(false);
    end if;
  end process;

  process(execute_arbitration_isValid,execute_IS_CSR,execute_CSR_READ_OPCODE,zz_171)
  begin
    execute_CsrPlugin_readInstruction <= ((execute_arbitration_isValid and execute_IS_CSR) and execute_CSR_READ_OPCODE);
    if zz_171 = '1' then
      execute_CsrPlugin_readInstruction <= pkg_toStdLogic(false);
    end if;
  end process;

  execute_CsrPlugin_writeEnable <= (execute_CsrPlugin_writeInstruction and (not execute_arbitration_isStuck));
  execute_CsrPlugin_readEnable <= (execute_CsrPlugin_readInstruction and (not execute_arbitration_isStuck));
  execute_CsrPlugin_readToWriteData <= execute_CsrPlugin_readData;
  process(zz_184,execute_SRC1,execute_INSTRUCTION,execute_CsrPlugin_readToWriteData)
  begin
    case zz_184 is
      when '0' =>
        execute_CsrPlugin_writeData <= execute_SRC1;
      when others =>
        execute_CsrPlugin_writeData <= pkg_mux(pkg_extract(execute_INSTRUCTION,12),(execute_CsrPlugin_readToWriteData and pkg_not(execute_SRC1)),(execute_CsrPlugin_readToWriteData or execute_SRC1));
    end case;
  end process;

  execute_CsrPlugin_csrAddress <= pkg_extract(execute_INSTRUCTION,31,20);
  zz_95 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000100000001010000")) = pkg_stdLogicVector("00000000000000000100000001010000"));
  zz_96 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000000000100")) = pkg_stdLogicVector("00000000000000000000000000000100"));
  zz_97 <= pkg_toStdLogic((decode_INSTRUCTION and pkg_stdLogicVector("00000000000000000000000001001000")) = pkg_stdLogicVector("00000000000000000000000001001000"));
  zz_94 <= pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(pkg_toStdLogic((decode_INSTRUCTION and zz_193) = pkg_stdLogicVector("00000000000000000000000001010000"))) /= pkg_stdLogicVector("0"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_97),pkg_toStdLogicVector(zz_194)) /= pkg_stdLogicVector("00"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(pkg_toStdLogicVector(zz_195) /= pkg_stdLogicVector("0"))),pkg_cat(pkg_toStdLogicVector(pkg_toStdLogic(zz_196 /= zz_197)),pkg_cat(pkg_toStdLogicVector(zz_198),pkg_cat(zz_199,zz_200))))));
  zz_98 <= pkg_extract(zz_94,1,0);
  zz_45 <= zz_98;
  zz_99 <= pkg_extract(zz_94,6,5);
  zz_44 <= zz_99;
  zz_100 <= pkg_extract(zz_94,8,7);
  zz_43 <= zz_100;
  zz_101 <= pkg_extract(zz_94,16,16);
  zz_42 <= zz_101;
  zz_102 <= pkg_extract(zz_94,19,18);
  zz_41 <= zz_102;
  zz_103 <= pkg_extract(zz_94,22,21);
  zz_40 <= zz_103;
  zz_104 <= pkg_extract(zz_94,24,23);
  zz_39 <= zz_104;
  decode_RegFilePlugin_regFileReadAddress1 <= unsigned(pkg_extract(decode_INSTRUCTION_ANTICIPATED,19,15));
  decode_RegFilePlugin_regFileReadAddress2 <= unsigned(pkg_extract(decode_INSTRUCTION_ANTICIPATED,24,20));
  decode_RegFilePlugin_rs1Data <= zz_154;
  decode_RegFilePlugin_rs2Data <= zz_155;
  process(zz_37,writeBack_arbitration_isFiring,zz_105)
  begin
    lastStageRegFileWrite_valid <= (zz_37 and writeBack_arbitration_isFiring);
    if zz_105 = '1' then
      lastStageRegFileWrite_valid <= pkg_toStdLogic(true);
    end if;
  end process;

  process(zz_36,zz_105)
  begin
    lastStageRegFileWrite_payload_address <= unsigned(pkg_extract(zz_36,11,7));
    if zz_105 = '1' then
      lastStageRegFileWrite_payload_address <= pkg_unsigned("00000");
    end if;
  end process;

  process(zz_50,zz_105)
  begin
    lastStageRegFileWrite_payload_data <= zz_50;
    if zz_105 = '1' then
      lastStageRegFileWrite_payload_data <= pkg_stdLogicVector("00000000000000000000000000000000");
    end if;
  end process;

  process(execute_ALU_BITWISE_CTRL,execute_SRC1,execute_SRC2)
  begin
    case execute_ALU_BITWISE_CTRL is
      when AluBitwiseCtrlEnum_defaultEncoding_AND_1 =>
        execute_IntAluPlugin_bitwise <= (execute_SRC1 and execute_SRC2);
      when AluBitwiseCtrlEnum_defaultEncoding_OR_1 =>
        execute_IntAluPlugin_bitwise <= (execute_SRC1 or execute_SRC2);
      when others =>
        execute_IntAluPlugin_bitwise <= (execute_SRC1 xor execute_SRC2);
    end case;
  end process;

  process(execute_ALU_CTRL,execute_IntAluPlugin_bitwise,execute_SRC_LESS,execute_SRC_ADD_SUB)
  begin
    case execute_ALU_CTRL is
      when AluCtrlEnum_defaultEncoding_BITWISE =>
        zz_106 <= execute_IntAluPlugin_bitwise;
      when AluCtrlEnum_defaultEncoding_SLT_SLTU =>
        zz_106 <= pkg_resize(pkg_toStdLogicVector(execute_SRC_LESS),32);
      when others =>
        zz_106 <= execute_SRC_ADD_SUB;
    end case;
  end process;

  process(execute_SRC1_CTRL,execute_RS1,execute_INSTRUCTION)
  begin
    case execute_SRC1_CTRL is
      when Src1CtrlEnum_defaultEncoding_RS =>
        zz_107 <= execute_RS1;
      when Src1CtrlEnum_defaultEncoding_PC_INCREMENT =>
        zz_107 <= pkg_resize(pkg_stdLogicVector("100"),32);
      when Src1CtrlEnum_defaultEncoding_IMU =>
        zz_107 <= pkg_cat(pkg_extract(execute_INSTRUCTION,31,12),std_logic_vector(pkg_unsigned("000000000000")));
      when others =>
        zz_107 <= pkg_resize(pkg_extract(execute_INSTRUCTION,19,15),32);
    end case;
  end process;

  zz_108 <= pkg_extract(pkg_extract(execute_INSTRUCTION,31,20),11);
  process(zz_108)
  begin
    zz_109(19) <= zz_108;
    zz_109(18) <= zz_108;
    zz_109(17) <= zz_108;
    zz_109(16) <= zz_108;
    zz_109(15) <= zz_108;
    zz_109(14) <= zz_108;
    zz_109(13) <= zz_108;
    zz_109(12) <= zz_108;
    zz_109(11) <= zz_108;
    zz_109(10) <= zz_108;
    zz_109(9) <= zz_108;
    zz_109(8) <= zz_108;
    zz_109(7) <= zz_108;
    zz_109(6) <= zz_108;
    zz_109(5) <= zz_108;
    zz_109(4) <= zz_108;
    zz_109(3) <= zz_108;
    zz_109(2) <= zz_108;
    zz_109(1) <= zz_108;
    zz_109(0) <= zz_108;
  end process;

  zz_110 <= pkg_extract(pkg_cat(pkg_extract(execute_INSTRUCTION,31,25),pkg_extract(execute_INSTRUCTION,11,7)),11);
  process(zz_110)
  begin
    zz_111(19) <= zz_110;
    zz_111(18) <= zz_110;
    zz_111(17) <= zz_110;
    zz_111(16) <= zz_110;
    zz_111(15) <= zz_110;
    zz_111(14) <= zz_110;
    zz_111(13) <= zz_110;
    zz_111(12) <= zz_110;
    zz_111(11) <= zz_110;
    zz_111(10) <= zz_110;
    zz_111(9) <= zz_110;
    zz_111(8) <= zz_110;
    zz_111(7) <= zz_110;
    zz_111(6) <= zz_110;
    zz_111(5) <= zz_110;
    zz_111(4) <= zz_110;
    zz_111(3) <= zz_110;
    zz_111(2) <= zz_110;
    zz_111(1) <= zz_110;
    zz_111(0) <= zz_110;
  end process;

  process(execute_SRC2_CTRL,execute_RS2,zz_109,execute_INSTRUCTION,zz_111,zz_31)
  begin
    case execute_SRC2_CTRL is
      when Src2CtrlEnum_defaultEncoding_RS =>
        zz_112 <= execute_RS2;
      when Src2CtrlEnum_defaultEncoding_IMI =>
        zz_112 <= pkg_cat(zz_109,pkg_extract(execute_INSTRUCTION,31,20));
      when Src2CtrlEnum_defaultEncoding_IMS =>
        zz_112 <= pkg_cat(zz_111,pkg_cat(pkg_extract(execute_INSTRUCTION,31,25),pkg_extract(execute_INSTRUCTION,11,7)));
      when others =>
        zz_112 <= std_logic_vector(zz_31);
    end case;
  end process;

  process(execute_SRC1,execute_SRC_USE_SUB_LESS,execute_SRC2,execute_SRC2_FORCE_ZERO)
  begin
    execute_SrcPlugin_addSub <= std_logic_vector(((signed(execute_SRC1) + signed(pkg_mux(execute_SRC_USE_SUB_LESS,pkg_not(execute_SRC2),execute_SRC2))) + pkg_mux(execute_SRC_USE_SUB_LESS,pkg_signed("00000000000000000000000000000001"),pkg_signed("00000000000000000000000000000000"))));
    if execute_SRC2_FORCE_ZERO = '1' then
      execute_SrcPlugin_addSub <= execute_SRC1;
    end if;
  end process;

  execute_SrcPlugin_less <= pkg_mux(pkg_toStdLogic(pkg_extract(execute_SRC1,31) = pkg_extract(execute_SRC2,31)),pkg_extract(execute_SrcPlugin_addSub,31),pkg_mux(execute_SRC_LESS_UNSIGNED,pkg_extract(execute_SRC2,31),pkg_extract(execute_SRC1,31)));
  execute_FullBarrelShifterPlugin_amplitude <= unsigned(pkg_extract(execute_SRC2,4,0));
  process(execute_SRC1)
  begin
    zz_113(0) <= pkg_extract(execute_SRC1,31);
    zz_113(1) <= pkg_extract(execute_SRC1,30);
    zz_113(2) <= pkg_extract(execute_SRC1,29);
    zz_113(3) <= pkg_extract(execute_SRC1,28);
    zz_113(4) <= pkg_extract(execute_SRC1,27);
    zz_113(5) <= pkg_extract(execute_SRC1,26);
    zz_113(6) <= pkg_extract(execute_SRC1,25);
    zz_113(7) <= pkg_extract(execute_SRC1,24);
    zz_113(8) <= pkg_extract(execute_SRC1,23);
    zz_113(9) <= pkg_extract(execute_SRC1,22);
    zz_113(10) <= pkg_extract(execute_SRC1,21);
    zz_113(11) <= pkg_extract(execute_SRC1,20);
    zz_113(12) <= pkg_extract(execute_SRC1,19);
    zz_113(13) <= pkg_extract(execute_SRC1,18);
    zz_113(14) <= pkg_extract(execute_SRC1,17);
    zz_113(15) <= pkg_extract(execute_SRC1,16);
    zz_113(16) <= pkg_extract(execute_SRC1,15);
    zz_113(17) <= pkg_extract(execute_SRC1,14);
    zz_113(18) <= pkg_extract(execute_SRC1,13);
    zz_113(19) <= pkg_extract(execute_SRC1,12);
    zz_113(20) <= pkg_extract(execute_SRC1,11);
    zz_113(21) <= pkg_extract(execute_SRC1,10);
    zz_113(22) <= pkg_extract(execute_SRC1,9);
    zz_113(23) <= pkg_extract(execute_SRC1,8);
    zz_113(24) <= pkg_extract(execute_SRC1,7);
    zz_113(25) <= pkg_extract(execute_SRC1,6);
    zz_113(26) <= pkg_extract(execute_SRC1,5);
    zz_113(27) <= pkg_extract(execute_SRC1,4);
    zz_113(28) <= pkg_extract(execute_SRC1,3);
    zz_113(29) <= pkg_extract(execute_SRC1,2);
    zz_113(30) <= pkg_extract(execute_SRC1,1);
    zz_113(31) <= pkg_extract(execute_SRC1,0);
  end process;

  execute_FullBarrelShifterPlugin_reversed <= pkg_mux(pkg_toStdLogic(execute_SHIFT_CTRL = ShiftCtrlEnum_defaultEncoding_SLL_1),zz_113,execute_SRC1);
  process(memory_SHIFT_RIGHT)
  begin
    zz_114(0) <= pkg_extract(memory_SHIFT_RIGHT,31);
    zz_114(1) <= pkg_extract(memory_SHIFT_RIGHT,30);
    zz_114(2) <= pkg_extract(memory_SHIFT_RIGHT,29);
    zz_114(3) <= pkg_extract(memory_SHIFT_RIGHT,28);
    zz_114(4) <= pkg_extract(memory_SHIFT_RIGHT,27);
    zz_114(5) <= pkg_extract(memory_SHIFT_RIGHT,26);
    zz_114(6) <= pkg_extract(memory_SHIFT_RIGHT,25);
    zz_114(7) <= pkg_extract(memory_SHIFT_RIGHT,24);
    zz_114(8) <= pkg_extract(memory_SHIFT_RIGHT,23);
    zz_114(9) <= pkg_extract(memory_SHIFT_RIGHT,22);
    zz_114(10) <= pkg_extract(memory_SHIFT_RIGHT,21);
    zz_114(11) <= pkg_extract(memory_SHIFT_RIGHT,20);
    zz_114(12) <= pkg_extract(memory_SHIFT_RIGHT,19);
    zz_114(13) <= pkg_extract(memory_SHIFT_RIGHT,18);
    zz_114(14) <= pkg_extract(memory_SHIFT_RIGHT,17);
    zz_114(15) <= pkg_extract(memory_SHIFT_RIGHT,16);
    zz_114(16) <= pkg_extract(memory_SHIFT_RIGHT,15);
    zz_114(17) <= pkg_extract(memory_SHIFT_RIGHT,14);
    zz_114(18) <= pkg_extract(memory_SHIFT_RIGHT,13);
    zz_114(19) <= pkg_extract(memory_SHIFT_RIGHT,12);
    zz_114(20) <= pkg_extract(memory_SHIFT_RIGHT,11);
    zz_114(21) <= pkg_extract(memory_SHIFT_RIGHT,10);
    zz_114(22) <= pkg_extract(memory_SHIFT_RIGHT,9);
    zz_114(23) <= pkg_extract(memory_SHIFT_RIGHT,8);
    zz_114(24) <= pkg_extract(memory_SHIFT_RIGHT,7);
    zz_114(25) <= pkg_extract(memory_SHIFT_RIGHT,6);
    zz_114(26) <= pkg_extract(memory_SHIFT_RIGHT,5);
    zz_114(27) <= pkg_extract(memory_SHIFT_RIGHT,4);
    zz_114(28) <= pkg_extract(memory_SHIFT_RIGHT,3);
    zz_114(29) <= pkg_extract(memory_SHIFT_RIGHT,2);
    zz_114(30) <= pkg_extract(memory_SHIFT_RIGHT,1);
    zz_114(31) <= pkg_extract(memory_SHIFT_RIGHT,0);
  end process;

  process(zz_172,zz_173,zz_120,zz_174,zz_175,zz_122,zz_176,zz_177,zz_124,decode_RS1_USE)
  begin
    zz_115 <= pkg_toStdLogic(false);
    if zz_172 = '1' then
      if zz_173 = '1' then
        if zz_120 = '1' then
          zz_115 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if zz_174 = '1' then
      if zz_175 = '1' then
        if zz_122 = '1' then
          zz_115 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if zz_176 = '1' then
      if zz_177 = '1' then
        if zz_124 = '1' then
          zz_115 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if (not decode_RS1_USE) = '1' then
      zz_115 <= pkg_toStdLogic(false);
    end if;
  end process;

  process(zz_172,zz_173,zz_121,zz_174,zz_175,zz_123,zz_176,zz_177,zz_125,decode_RS2_USE)
  begin
    zz_116 <= pkg_toStdLogic(false);
    if zz_172 = '1' then
      if zz_173 = '1' then
        if zz_121 = '1' then
          zz_116 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if zz_174 = '1' then
      if zz_175 = '1' then
        if zz_123 = '1' then
          zz_116 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if zz_176 = '1' then
      if zz_177 = '1' then
        if zz_125 = '1' then
          zz_116 <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
    if (not decode_RS2_USE) = '1' then
      zz_116 <= pkg_toStdLogic(false);
    end if;
  end process;

  zz_120 <= pkg_toStdLogic(pkg_extract(writeBack_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,19,15));
  zz_121 <= pkg_toStdLogic(pkg_extract(writeBack_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,24,20));
  zz_122 <= pkg_toStdLogic(pkg_extract(memory_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,19,15));
  zz_123 <= pkg_toStdLogic(pkg_extract(memory_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,24,20));
  zz_124 <= pkg_toStdLogic(pkg_extract(execute_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,19,15));
  zz_125 <= pkg_toStdLogic(pkg_extract(execute_INSTRUCTION,11,7) = pkg_extract(decode_INSTRUCTION,24,20));
  execute_BranchPlugin_eq <= pkg_toStdLogic(execute_SRC1 = execute_SRC2);
  zz_126 <= pkg_extract(execute_INSTRUCTION,14,12);
  process(zz_126,execute_BranchPlugin_eq,execute_SRC_LESS)
  begin
    if (zz_126 = pkg_stdLogicVector("000")) then
        zz_127 <= execute_BranchPlugin_eq;
    elsif (zz_126 = pkg_stdLogicVector("001")) then
        zz_127 <= (not execute_BranchPlugin_eq);
    elsif (pkg_toStdLogic((zz_126 and pkg_stdLogicVector("101")) = pkg_stdLogicVector("101")) = '1') then
        zz_127 <= (not execute_SRC_LESS);
    else
        zz_127 <= execute_SRC_LESS;
    end if;
  end process;

  process(execute_BRANCH_CTRL,zz_127)
  begin
    case execute_BRANCH_CTRL is
      when BranchCtrlEnum_defaultEncoding_INC =>
        zz_128 <= pkg_toStdLogic(false);
      when BranchCtrlEnum_defaultEncoding_JAL =>
        zz_128 <= pkg_toStdLogic(true);
      when BranchCtrlEnum_defaultEncoding_JALR =>
        zz_128 <= pkg_toStdLogic(true);
      when others =>
        zz_128 <= zz_127;
    end case;
  end process;

  zz_129 <= pkg_extract(pkg_extract(execute_INSTRUCTION,31,20),11);
  process(zz_129)
  begin
    zz_130(19) <= zz_129;
    zz_130(18) <= zz_129;
    zz_130(17) <= zz_129;
    zz_130(16) <= zz_129;
    zz_130(15) <= zz_129;
    zz_130(14) <= zz_129;
    zz_130(13) <= zz_129;
    zz_130(12) <= zz_129;
    zz_130(11) <= zz_129;
    zz_130(10) <= zz_129;
    zz_130(9) <= zz_129;
    zz_130(8) <= zz_129;
    zz_130(7) <= zz_129;
    zz_130(6) <= zz_129;
    zz_130(5) <= zz_129;
    zz_130(4) <= zz_129;
    zz_130(3) <= zz_129;
    zz_130(2) <= zz_129;
    zz_130(1) <= zz_129;
    zz_130(0) <= zz_129;
  end process;

  zz_131 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_extract(execute_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,20))),pkg_extract(execute_INSTRUCTION,30,21)),19);
  process(zz_131)
  begin
    zz_132(10) <= zz_131;
    zz_132(9) <= zz_131;
    zz_132(8) <= zz_131;
    zz_132(7) <= zz_131;
    zz_132(6) <= zz_131;
    zz_132(5) <= zz_131;
    zz_132(4) <= zz_131;
    zz_132(3) <= zz_131;
    zz_132(2) <= zz_131;
    zz_132(1) <= zz_131;
    zz_132(0) <= zz_131;
  end process;

  zz_133 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,7))),pkg_extract(execute_INSTRUCTION,30,25)),pkg_extract(execute_INSTRUCTION,11,8)),11);
  process(zz_133)
  begin
    zz_134(18) <= zz_133;
    zz_134(17) <= zz_133;
    zz_134(16) <= zz_133;
    zz_134(15) <= zz_133;
    zz_134(14) <= zz_133;
    zz_134(13) <= zz_133;
    zz_134(12) <= zz_133;
    zz_134(11) <= zz_133;
    zz_134(10) <= zz_133;
    zz_134(9) <= zz_133;
    zz_134(8) <= zz_133;
    zz_134(7) <= zz_133;
    zz_134(6) <= zz_133;
    zz_134(5) <= zz_133;
    zz_134(4) <= zz_133;
    zz_134(3) <= zz_133;
    zz_134(2) <= zz_133;
    zz_134(1) <= zz_133;
    zz_134(0) <= zz_133;
  end process;

  process(execute_BRANCH_CTRL,zz_130,execute_INSTRUCTION,execute_RS1,zz_132,zz_134)
  begin
    case execute_BRANCH_CTRL is
      when BranchCtrlEnum_defaultEncoding_JALR =>
        zz_135 <= (pkg_extract(pkg_cat(zz_130,pkg_extract(execute_INSTRUCTION,31,20)),1) xor pkg_extract(execute_RS1,1));
      when BranchCtrlEnum_defaultEncoding_JAL =>
        zz_135 <= pkg_extract(pkg_cat(pkg_cat(zz_132,pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_extract(execute_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,20))),pkg_extract(execute_INSTRUCTION,30,21))),pkg_toStdLogicVector(pkg_toStdLogic(false))),1);
      when others =>
        zz_135 <= pkg_extract(pkg_cat(pkg_cat(zz_134,pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,7))),pkg_extract(execute_INSTRUCTION,30,25)),pkg_extract(execute_INSTRUCTION,11,8))),pkg_toStdLogicVector(pkg_toStdLogic(false))),1);
    end case;
  end process;

  execute_BranchPlugin_missAlignedTarget <= (execute_BRANCH_COND_RESULT and zz_135);
  process(execute_BRANCH_CTRL,execute_RS1,execute_PC)
  begin
    case execute_BRANCH_CTRL is
      when BranchCtrlEnum_defaultEncoding_JALR =>
        execute_BranchPlugin_branch_src1 <= unsigned(execute_RS1);
      when others =>
        execute_BranchPlugin_branch_src1 <= execute_PC;
    end case;
  end process;

  zz_136 <= pkg_extract(pkg_extract(execute_INSTRUCTION,31,20),11);
  process(zz_136)
  begin
    zz_137(19) <= zz_136;
    zz_137(18) <= zz_136;
    zz_137(17) <= zz_136;
    zz_137(16) <= zz_136;
    zz_137(15) <= zz_136;
    zz_137(14) <= zz_136;
    zz_137(13) <= zz_136;
    zz_137(12) <= zz_136;
    zz_137(11) <= zz_136;
    zz_137(10) <= zz_136;
    zz_137(9) <= zz_136;
    zz_137(8) <= zz_136;
    zz_137(7) <= zz_136;
    zz_137(6) <= zz_136;
    zz_137(5) <= zz_136;
    zz_137(4) <= zz_136;
    zz_137(3) <= zz_136;
    zz_137(2) <= zz_136;
    zz_137(1) <= zz_136;
    zz_137(0) <= zz_136;
  end process;

  process(execute_BRANCH_CTRL,zz_137,execute_INSTRUCTION,zz_139,zz_298,zz_299,zz_300,zz_141,zz_301,zz_302,execute_PREDICTION_HAD_BRANCHED2)
  begin
    case execute_BRANCH_CTRL is
      when BranchCtrlEnum_defaultEncoding_JALR =>
        execute_BranchPlugin_branch_src2 <= unsigned(pkg_cat(zz_137,pkg_extract(execute_INSTRUCTION,31,20)));
      when others =>
        execute_BranchPlugin_branch_src2 <= unsigned(pkg_mux(pkg_toStdLogic(execute_BRANCH_CTRL = BranchCtrlEnum_defaultEncoding_JAL),pkg_cat(pkg_cat(zz_139,pkg_cat(pkg_cat(pkg_cat(zz_298,zz_299),pkg_toStdLogicVector(zz_300)),pkg_extract(execute_INSTRUCTION,30,21))),pkg_toStdLogicVector(pkg_toStdLogic(false))),pkg_cat(pkg_cat(zz_141,pkg_cat(pkg_cat(pkg_cat(zz_301,zz_302),pkg_extract(execute_INSTRUCTION,30,25)),pkg_extract(execute_INSTRUCTION,11,8))),pkg_toStdLogicVector(pkg_toStdLogic(false)))));
        if execute_PREDICTION_HAD_BRANCHED2 = '1' then
          execute_BranchPlugin_branch_src2 <= pkg_resize(unsigned(pkg_stdLogicVector("100")),32);
        end if;
    end case;
  end process;

  zz_138 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_extract(execute_INSTRUCTION,19,12)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,20))),pkg_extract(execute_INSTRUCTION,30,21)),19);
  process(zz_138)
  begin
    zz_139(10) <= zz_138;
    zz_139(9) <= zz_138;
    zz_139(8) <= zz_138;
    zz_139(7) <= zz_138;
    zz_139(6) <= zz_138;
    zz_139(5) <= zz_138;
    zz_139(4) <= zz_138;
    zz_139(3) <= zz_138;
    zz_139(2) <= zz_138;
    zz_139(1) <= zz_138;
    zz_139(0) <= zz_138;
  end process;

  zz_140 <= pkg_extract(pkg_cat(pkg_cat(pkg_cat(pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,31)),pkg_toStdLogicVector(pkg_extract(execute_INSTRUCTION,7))),pkg_extract(execute_INSTRUCTION,30,25)),pkg_extract(execute_INSTRUCTION,11,8)),11);
  process(zz_140)
  begin
    zz_141(18) <= zz_140;
    zz_141(17) <= zz_140;
    zz_141(16) <= zz_140;
    zz_141(15) <= zz_140;
    zz_141(14) <= zz_140;
    zz_141(13) <= zz_140;
    zz_141(12) <= zz_140;
    zz_141(11) <= zz_140;
    zz_141(10) <= zz_140;
    zz_141(9) <= zz_140;
    zz_141(8) <= zz_140;
    zz_141(7) <= zz_140;
    zz_141(6) <= zz_140;
    zz_141(5) <= zz_140;
    zz_141(4) <= zz_140;
    zz_141(3) <= zz_140;
    zz_141(2) <= zz_140;
    zz_141(1) <= zz_140;
    zz_141(0) <= zz_140;
  end process;

  execute_BranchPlugin_branchAdder <= (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  BranchPlugin_jumpInterface_valid <= ((execute_arbitration_isValid and execute_BRANCH_DO) and (not pkg_toStdLogic(false)));
  BranchPlugin_jumpInterface_payload <= execute_BRANCH_CALC;
  process(execute_arbitration_isValid,execute_BRANCH_DO,execute_BRANCH_CALC)
  begin
    BranchPlugin_branchExceptionPort_valid <= (execute_arbitration_isValid and (execute_BRANCH_DO and pkg_extract(execute_BRANCH_CALC,1)));
    if pkg_toStdLogic(false) = '1' then
      BranchPlugin_branchExceptionPort_valid <= pkg_toStdLogic(false);
    end if;
  end process;

  BranchPlugin_branchExceptionPort_payload_code <= pkg_unsigned("0000");
  BranchPlugin_branchExceptionPort_payload_badAddr <= execute_BRANCH_CALC;
  IBusSimplePlugin_decodePrediction_rsp_wasWrong <= BranchPlugin_jumpInterface_valid;
  process(debug_bus_cmd_valid,zz_178,debug_bus_cmd_payload_wr,IBusSimplePlugin_injectionPort_ready)
  begin
    zz_158 <= pkg_toStdLogic(true);
    if debug_bus_cmd_valid = '1' then
      case zz_178 is
        when "000001" =>
          if debug_bus_cmd_payload_wr = '1' then
            zz_158 <= IBusSimplePlugin_injectionPort_ready;
          end if;
        when others =>
      end case;
    end if;
  end process;

  process(DebugPlugin_busReadDataReg,zz_142,DebugPlugin_resetIt,DebugPlugin_haltIt,DebugPlugin_isPipBusy,DebugPlugin_haltedByBreak,DebugPlugin_stepIt)
  begin
    debug_bus_rsp_data <= DebugPlugin_busReadDataReg;
    if (not zz_142) = '1' then
      debug_bus_rsp_data(0) <= DebugPlugin_resetIt;
      debug_bus_rsp_data(1) <= DebugPlugin_haltIt;
      debug_bus_rsp_data(2) <= DebugPlugin_isPipBusy;
      debug_bus_rsp_data(3) <= DebugPlugin_haltedByBreak;
      debug_bus_rsp_data(4) <= DebugPlugin_stepIt;
    end if;
  end process;

  process(debug_bus_cmd_valid,zz_178,debug_bus_cmd_payload_wr)
  begin
    IBusSimplePlugin_injectionPort_valid <= pkg_toStdLogic(false);
    if debug_bus_cmd_valid = '1' then
      case zz_178 is
        when "000001" =>
          if debug_bus_cmd_payload_wr = '1' then
            IBusSimplePlugin_injectionPort_valid <= pkg_toStdLogic(true);
          end if;
        when others =>
      end case;
    end if;
  end process;

  IBusSimplePlugin_injectionPort_payload <= debug_bus_cmd_payload_data;
  DebugPlugin_allowEBreak <= pkg_toStdLogic(CsrPlugin_privilege = pkg_unsigned("11"));
  debug_resetOut <= DebugPlugin_resetIt_regNext;
  zz_26 <= decode_SRC1_CTRL;
  zz_24 <= zz_45;
  zz_33 <= decode_to_execute_SRC1_CTRL;
  zz_23 <= decode_ALU_CTRL;
  zz_21 <= zz_44;
  zz_34 <= decode_to_execute_ALU_CTRL;
  zz_20 <= decode_SRC2_CTRL;
  zz_18 <= zz_43;
  zz_32 <= decode_to_execute_SRC2_CTRL;
  zz_17 <= decode_ENV_CTRL;
  zz_14 <= execute_ENV_CTRL;
  zz_12 <= memory_ENV_CTRL;
  zz_15 <= zz_42;
  zz_48 <= decode_to_execute_ENV_CTRL;
  zz_47 <= execute_to_memory_ENV_CTRL;
  zz_49 <= memory_to_writeBack_ENV_CTRL;
  zz_10 <= decode_ALU_BITWISE_CTRL;
  zz_8 <= zz_41;
  zz_35 <= decode_to_execute_ALU_BITWISE_CTRL;
  zz_7 <= decode_SHIFT_CTRL;
  zz_4 <= execute_SHIFT_CTRL;
  zz_5 <= zz_40;
  zz_30 <= decode_to_execute_SHIFT_CTRL;
  zz_29 <= execute_to_memory_SHIFT_CTRL;
  zz_2 <= decode_BRANCH_CTRL;
  zz_51 <= zz_39;
  zz_27 <= decode_to_execute_BRANCH_CTRL;
  decode_arbitration_isFlushed <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushNext),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushNext),pkg_toStdLogicVector(execute_arbitration_flushNext))) /= pkg_stdLogicVector("000")) or pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushIt),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushIt),pkg_cat(pkg_toStdLogicVector(execute_arbitration_flushIt),pkg_toStdLogicVector(decode_arbitration_flushIt)))) /= pkg_stdLogicVector("0000")));
  execute_arbitration_isFlushed <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushNext),pkg_toStdLogicVector(memory_arbitration_flushNext)) /= pkg_stdLogicVector("00")) or pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushIt),pkg_cat(pkg_toStdLogicVector(memory_arbitration_flushIt),pkg_toStdLogicVector(execute_arbitration_flushIt))) /= pkg_stdLogicVector("000")));
  memory_arbitration_isFlushed <= (pkg_toStdLogic(pkg_toStdLogicVector(writeBack_arbitration_flushNext) /= pkg_stdLogicVector("0")) or pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_flushIt),pkg_toStdLogicVector(memory_arbitration_flushIt)) /= pkg_stdLogicVector("00")));
  writeBack_arbitration_isFlushed <= (pkg_toStdLogic(false) or pkg_toStdLogic(pkg_toStdLogicVector(writeBack_arbitration_flushIt) /= pkg_stdLogicVector("0")));
  decode_arbitration_isStuckByOthers <= (decode_arbitration_haltByOther or (((pkg_toStdLogic(false) or execute_arbitration_isStuck) or memory_arbitration_isStuck) or writeBack_arbitration_isStuck));
  decode_arbitration_isStuck <= (decode_arbitration_haltItself or decode_arbitration_isStuckByOthers);
  decode_arbitration_isMoving <= ((not decode_arbitration_isStuck) and (not decode_arbitration_removeIt));
  decode_arbitration_isFiring <= ((decode_arbitration_isValid and (not decode_arbitration_isStuck)) and (not decode_arbitration_removeIt));
  execute_arbitration_isStuckByOthers <= (execute_arbitration_haltByOther or ((pkg_toStdLogic(false) or memory_arbitration_isStuck) or writeBack_arbitration_isStuck));
  execute_arbitration_isStuck <= (execute_arbitration_haltItself or execute_arbitration_isStuckByOthers);
  execute_arbitration_isMoving <= ((not execute_arbitration_isStuck) and (not execute_arbitration_removeIt));
  execute_arbitration_isFiring <= ((execute_arbitration_isValid and (not execute_arbitration_isStuck)) and (not execute_arbitration_removeIt));
  memory_arbitration_isStuckByOthers <= (memory_arbitration_haltByOther or (pkg_toStdLogic(false) or writeBack_arbitration_isStuck));
  memory_arbitration_isStuck <= (memory_arbitration_haltItself or memory_arbitration_isStuckByOthers);
  memory_arbitration_isMoving <= ((not memory_arbitration_isStuck) and (not memory_arbitration_removeIt));
  memory_arbitration_isFiring <= ((memory_arbitration_isValid and (not memory_arbitration_isStuck)) and (not memory_arbitration_removeIt));
  writeBack_arbitration_isStuckByOthers <= (writeBack_arbitration_haltByOther or pkg_toStdLogic(false));
  writeBack_arbitration_isStuck <= (writeBack_arbitration_haltItself or writeBack_arbitration_isStuckByOthers);
  writeBack_arbitration_isMoving <= ((not writeBack_arbitration_isStuck) and (not writeBack_arbitration_removeIt));
  writeBack_arbitration_isFiring <= ((writeBack_arbitration_isValid and (not writeBack_arbitration_isStuck)) and (not writeBack_arbitration_removeIt));
  process(zz_143)
  begin
    IBusSimplePlugin_injectionPort_ready <= pkg_toStdLogic(false);
    case zz_143 is
      when "100" =>
        IBusSimplePlugin_injectionPort_ready <= pkg_toStdLogic(true);
      when others =>
    end case;
  end process;

  process(execute_CsrPlugin_csr_768,CsrPlugin_mstatus_MPP,CsrPlugin_mstatus_MPIE,CsrPlugin_mstatus_MIE)
  begin
    zz_144 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_768 = '1' then
      zz_144(12 downto 11) <= std_logic_vector(CsrPlugin_mstatus_MPP);
      zz_144(7 downto 7) <= pkg_toStdLogicVector(CsrPlugin_mstatus_MPIE);
      zz_144(3 downto 3) <= pkg_toStdLogicVector(CsrPlugin_mstatus_MIE);
    end if;
  end process;

  process(execute_CsrPlugin_csr_836,CsrPlugin_mip_MEIP,CsrPlugin_mip_MTIP,CsrPlugin_mip_MSIP)
  begin
    zz_145 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_836 = '1' then
      zz_145(11 downto 11) <= pkg_toStdLogicVector(CsrPlugin_mip_MEIP);
      zz_145(7 downto 7) <= pkg_toStdLogicVector(CsrPlugin_mip_MTIP);
      zz_145(3 downto 3) <= pkg_toStdLogicVector(CsrPlugin_mip_MSIP);
    end if;
  end process;

  process(execute_CsrPlugin_csr_772,CsrPlugin_mie_MEIE,CsrPlugin_mie_MTIE,CsrPlugin_mie_MSIE)
  begin
    zz_146 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_772 = '1' then
      zz_146(11 downto 11) <= pkg_toStdLogicVector(CsrPlugin_mie_MEIE);
      zz_146(7 downto 7) <= pkg_toStdLogicVector(CsrPlugin_mie_MTIE);
      zz_146(3 downto 3) <= pkg_toStdLogicVector(CsrPlugin_mie_MSIE);
    end if;
  end process;

  process(execute_CsrPlugin_csr_833,CsrPlugin_mepc)
  begin
    zz_147 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_833 = '1' then
      zz_147(31 downto 0) <= std_logic_vector(CsrPlugin_mepc);
    end if;
  end process;

  process(execute_CsrPlugin_csr_834,CsrPlugin_mcause_interrupt,CsrPlugin_mcause_exceptionCode)
  begin
    zz_148 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_834 = '1' then
      zz_148(31 downto 31) <= pkg_toStdLogicVector(CsrPlugin_mcause_interrupt);
      zz_148(3 downto 0) <= std_logic_vector(CsrPlugin_mcause_exceptionCode);
    end if;
  end process;

  process(execute_CsrPlugin_csr_835,CsrPlugin_mtval)
  begin
    zz_149 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_835 = '1' then
      zz_149(31 downto 0) <= std_logic_vector(CsrPlugin_mtval);
    end if;
  end process;

  process(execute_CsrPlugin_csr_3072,CsrPlugin_mcycle)
  begin
    zz_150 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_3072 = '1' then
      zz_150(31 downto 0) <= std_logic_vector(pkg_extract(CsrPlugin_mcycle,31,0));
    end if;
  end process;

  process(execute_CsrPlugin_csr_3200,CsrPlugin_mcycle)
  begin
    zz_151 <= pkg_stdLogicVector("00000000000000000000000000000000");
    if execute_CsrPlugin_csr_3200 = '1' then
      zz_151(31 downto 0) <= std_logic_vector(pkg_extract(CsrPlugin_mcycle,63,32));
    end if;
  end process;

  execute_CsrPlugin_readData <= (((zz_144 or zz_145) or (zz_146 or zz_147)) or ((zz_148 or zz_149) or (zz_150 or zz_151)));
  zz_153 <= pkg_toStdLogic(false);
  process(clk, reset)
  begin
    if reset = '1' then
      IBusSimplePlugin_fetchPc_pcReg <= pkg_unsigned("10000000000000000000000000000000");
      IBusSimplePlugin_fetchPc_correctionReg <= pkg_toStdLogic(false);
      IBusSimplePlugin_fetchPc_booted <= pkg_toStdLogic(false);
      IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(false);
      zz_63 <= pkg_toStdLogic(false);
      zz_65 <= pkg_toStdLogic(false);
      zz_67 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_0 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_1 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_2 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_3 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_4 <= pkg_toStdLogic(false);
      IBusSimplePlugin_injector_nextPcCalc_valids_5 <= pkg_toStdLogic(false);
      IBusSimplePlugin_pending_value <= pkg_unsigned("000");
      IBusSimplePlugin_rspJoin_rspBuffer_discardCounter <= pkg_unsigned("000");
      CsrPlugin_mstatus_MIE <= pkg_toStdLogic(false);
      CsrPlugin_mstatus_MPIE <= pkg_toStdLogic(false);
      CsrPlugin_mstatus_MPP <= pkg_unsigned("11");
      CsrPlugin_mie_MEIE <= pkg_toStdLogic(false);
      CsrPlugin_mie_MTIE <= pkg_toStdLogic(false);
      CsrPlugin_mie_MSIE <= pkg_toStdLogic(false);
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= pkg_toStdLogic(false);
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= pkg_toStdLogic(false);
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= pkg_toStdLogic(false);
      CsrPlugin_interrupt_valid <= pkg_toStdLogic(false);
      CsrPlugin_pipelineLiberator_pcValids_0 <= pkg_toStdLogic(false);
      CsrPlugin_pipelineLiberator_pcValids_1 <= pkg_toStdLogic(false);
      CsrPlugin_pipelineLiberator_pcValids_2 <= pkg_toStdLogic(false);
      CsrPlugin_hadException <= pkg_toStdLogic(false);
      execute_CsrPlugin_wfiWake <= pkg_toStdLogic(false);
      zz_105 <= pkg_toStdLogic(true);
      zz_117 <= pkg_toStdLogic(false);
      execute_arbitration_isValid <= pkg_toStdLogic(false);
      memory_arbitration_isValid <= pkg_toStdLogic(false);
      writeBack_arbitration_isValid <= pkg_toStdLogic(false);
      zz_143 <= pkg_unsigned("000");
    elsif rising_edge(clk) then
      if IBusSimplePlugin_fetchPc_correction = '1' then
        IBusSimplePlugin_fetchPc_correctionReg <= pkg_toStdLogic(true);
      end if;
      if (IBusSimplePlugin_fetchPc_output_valid and IBusSimplePlugin_fetchPc_output_ready) = '1' then
        IBusSimplePlugin_fetchPc_correctionReg <= pkg_toStdLogic(false);
      end if;
      IBusSimplePlugin_fetchPc_booted <= pkg_toStdLogic(true);
      if (IBusSimplePlugin_fetchPc_correction or IBusSimplePlugin_fetchPc_pcRegPropagate) = '1' then
        IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(false);
      end if;
      if (IBusSimplePlugin_fetchPc_output_valid and IBusSimplePlugin_fetchPc_output_ready) = '1' then
        IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(true);
      end if;
      if ((not IBusSimplePlugin_fetchPc_output_valid) and IBusSimplePlugin_fetchPc_output_ready) = '1' then
        IBusSimplePlugin_fetchPc_inc <= pkg_toStdLogic(false);
      end if;
      if (IBusSimplePlugin_fetchPc_booted and ((IBusSimplePlugin_fetchPc_output_ready or IBusSimplePlugin_fetchPc_correction) or IBusSimplePlugin_fetchPc_pcRegPropagate)) = '1' then
        IBusSimplePlugin_fetchPc_pcReg <= IBusSimplePlugin_fetchPc_pc;
      end if;
      if IBusSimplePlugin_iBusRsp_flush = '1' then
        zz_63 <= pkg_toStdLogic(false);
      end if;
      if zz_61 = '1' then
        zz_63 <= (IBusSimplePlugin_iBusRsp_stages_0_output_valid and (not pkg_toStdLogic(false)));
      end if;
      if IBusSimplePlugin_iBusRsp_flush = '1' then
        zz_65 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_iBusRsp_stages_1_output_ready = '1' then
        zz_65 <= (IBusSimplePlugin_iBusRsp_stages_1_output_valid and (not IBusSimplePlugin_iBusRsp_flush));
      end if;
      if decode_arbitration_removeIt = '1' then
        zz_67 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_iBusRsp_output_ready = '1' then
        zz_67 <= (IBusSimplePlugin_iBusRsp_output_valid and (not IBusSimplePlugin_externalFlush));
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= pkg_toStdLogic(false);
      end if;
      if (not (not IBusSimplePlugin_iBusRsp_stages_1_input_ready)) = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_0 <= pkg_toStdLogic(true);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= pkg_toStdLogic(false);
      end if;
      if (not (not IBusSimplePlugin_iBusRsp_stages_2_input_ready)) = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= IBusSimplePlugin_injector_nextPcCalc_valids_0;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_1 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= pkg_toStdLogic(false);
      end if;
      if (not (not IBusSimplePlugin_injector_decodeInput_ready)) = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= IBusSimplePlugin_injector_nextPcCalc_valids_1;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_2 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= pkg_toStdLogic(false);
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= IBusSimplePlugin_injector_nextPcCalc_valids_2;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_3 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= pkg_toStdLogic(false);
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= IBusSimplePlugin_injector_nextPcCalc_valids_3;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_4 <= pkg_toStdLogic(false);
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_5 <= pkg_toStdLogic(false);
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_5 <= IBusSimplePlugin_injector_nextPcCalc_valids_4;
      end if;
      if IBusSimplePlugin_fetchPc_flushed = '1' then
        IBusSimplePlugin_injector_nextPcCalc_valids_5 <= pkg_toStdLogic(false);
      end if;
      IBusSimplePlugin_pending_value <= IBusSimplePlugin_pending_next;
      IBusSimplePlugin_rspJoin_rspBuffer_discardCounter <= (IBusSimplePlugin_rspJoin_rspBuffer_discardCounter - pkg_resize(unsigned(pkg_toStdLogicVector((IBusSimplePlugin_rspJoin_rspBuffer_c_io_pop_valid and pkg_toStdLogic(IBusSimplePlugin_rspJoin_rspBuffer_discardCounter /= pkg_unsigned("000"))))),3));
      if IBusSimplePlugin_iBusRsp_flush = '1' then
        IBusSimplePlugin_rspJoin_rspBuffer_discardCounter <= IBusSimplePlugin_pending_next;
      end if;
      assert (not (((dBus_rsp_ready and memory_MEMORY_ENABLE) and memory_arbitration_isValid) and memory_arbitration_isStuck)) = '1' report "DBusSimplePlugin doesn't allow memory stage stall when read happend"  severity FAILURE;
      assert (not (((writeBack_arbitration_isValid and writeBack_MEMORY_ENABLE) and (not writeBack_MEMORY_STORE)) and writeBack_arbitration_isStuck)) = '1' report "DBusSimplePlugin doesn't allow writeback stage stall when read happend"  severity FAILURE;
      if (not execute_arbitration_isStuck) = '1' then
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= pkg_toStdLogic(false);
      else
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= (CsrPlugin_exceptionPortCtrl_exceptionValids_execute and (not execute_arbitration_isStuck));
      else
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= (CsrPlugin_exceptionPortCtrl_exceptionValids_memory and (not memory_arbitration_isStuck));
      else
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= pkg_toStdLogic(false);
      end if;
      CsrPlugin_interrupt_valid <= pkg_toStdLogic(false);
      if zz_179 = '1' then
        if zz_180 = '1' then
          CsrPlugin_interrupt_valid <= pkg_toStdLogic(true);
        end if;
        if zz_181 = '1' then
          CsrPlugin_interrupt_valid <= pkg_toStdLogic(true);
        end if;
        if zz_182 = '1' then
          CsrPlugin_interrupt_valid <= pkg_toStdLogic(true);
        end if;
      end if;
      if CsrPlugin_pipelineLiberator_active = '1' then
        if (not execute_arbitration_isStuck) = '1' then
          CsrPlugin_pipelineLiberator_pcValids_0 <= pkg_toStdLogic(true);
        end if;
        if (not memory_arbitration_isStuck) = '1' then
          CsrPlugin_pipelineLiberator_pcValids_1 <= CsrPlugin_pipelineLiberator_pcValids_0;
        end if;
        if (not writeBack_arbitration_isStuck) = '1' then
          CsrPlugin_pipelineLiberator_pcValids_2 <= CsrPlugin_pipelineLiberator_pcValids_1;
        end if;
      end if;
      if ((not CsrPlugin_pipelineLiberator_active) or decode_arbitration_removeIt) = '1' then
        CsrPlugin_pipelineLiberator_pcValids_0 <= pkg_toStdLogic(false);
        CsrPlugin_pipelineLiberator_pcValids_1 <= pkg_toStdLogic(false);
        CsrPlugin_pipelineLiberator_pcValids_2 <= pkg_toStdLogic(false);
      end if;
      if CsrPlugin_interruptJump = '1' then
        CsrPlugin_interrupt_valid <= pkg_toStdLogic(false);
      end if;
      CsrPlugin_hadException <= CsrPlugin_exception;
      if zz_167 = '1' then
        case CsrPlugin_targetPrivilege is
          when "11" =>
            CsrPlugin_mstatus_MIE <= pkg_toStdLogic(false);
            CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
            CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
          when others =>
        end case;
      end if;
      if zz_168 = '1' then
        case zz_170 is
          when "11" =>
            CsrPlugin_mstatus_MPP <= pkg_unsigned("00");
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= pkg_toStdLogic(true);
          when others =>
        end case;
      end if;
      execute_CsrPlugin_wfiWake <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(zz_93),pkg_cat(pkg_toStdLogicVector(zz_92),pkg_toStdLogicVector(zz_91))) /= pkg_stdLogicVector("000")) or CsrPlugin_thirdPartyWake);
      zz_105 <= pkg_toStdLogic(false);
      zz_117 <= (zz_37 and writeBack_arbitration_isFiring);
      if ((not execute_arbitration_isStuck) or execute_arbitration_removeIt) = '1' then
        execute_arbitration_isValid <= pkg_toStdLogic(false);
      end if;
      if ((not decode_arbitration_isStuck) and (not decode_arbitration_removeIt)) = '1' then
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end if;
      if ((not memory_arbitration_isStuck) or memory_arbitration_removeIt) = '1' then
        memory_arbitration_isValid <= pkg_toStdLogic(false);
      end if;
      if ((not execute_arbitration_isStuck) and (not execute_arbitration_removeIt)) = '1' then
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end if;
      if ((not writeBack_arbitration_isStuck) or writeBack_arbitration_removeIt) = '1' then
        writeBack_arbitration_isValid <= pkg_toStdLogic(false);
      end if;
      if ((not memory_arbitration_isStuck) and (not memory_arbitration_removeIt)) = '1' then
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end if;
      case zz_143 is
        when "000" =>
          if IBusSimplePlugin_injectionPort_valid = '1' then
            zz_143 <= pkg_unsigned("001");
          end if;
        when "001" =>
          zz_143 <= pkg_unsigned("010");
        when "010" =>
          zz_143 <= pkg_unsigned("011");
        when "011" =>
          if (not decode_arbitration_isStuck) = '1' then
            zz_143 <= pkg_unsigned("100");
          end if;
        when "100" =>
          zz_143 <= pkg_unsigned("000");
        when others =>
      end case;
      if execute_CsrPlugin_csr_768 = '1' then
        if execute_CsrPlugin_writeEnable = '1' then
          CsrPlugin_mstatus_MPP <= unsigned(pkg_extract(execute_CsrPlugin_writeData,12,11));
          CsrPlugin_mstatus_MPIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,7,7),0);
          CsrPlugin_mstatus_MIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,3,3),0);
        end if;
      end if;
      if execute_CsrPlugin_csr_772 = '1' then
        if execute_CsrPlugin_writeEnable = '1' then
          CsrPlugin_mie_MEIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,11,11),0);
          CsrPlugin_mie_MTIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,7,7),0);
          CsrPlugin_mie_MSIE <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,3,3),0);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if IBusSimplePlugin_iBusRsp_stages_1_output_ready = '1' then
        zz_66 <= IBusSimplePlugin_iBusRsp_stages_1_output_payload;
      end if;
      if IBusSimplePlugin_iBusRsp_output_ready = '1' then
        zz_68 <= IBusSimplePlugin_iBusRsp_output_payload_pc;
        zz_69 <= IBusSimplePlugin_iBusRsp_output_payload_rsp_error;
        zz_70 <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
        zz_71 <= IBusSimplePlugin_iBusRsp_output_payload_isRvc;
      end if;
      if IBusSimplePlugin_injector_decodeInput_ready = '1' then
        IBusSimplePlugin_injector_formal_rawInDecode <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
      end if;
      CsrPlugin_mip_MEIP <= externalInterrupt;
      CsrPlugin_mip_MTIP <= timerInterrupt;
      CsrPlugin_mip_MSIP <= softwareInterrupt;
      CsrPlugin_mcycle <= (CsrPlugin_mcycle + pkg_unsigned("0000000000000000000000000000000000000000000000000000000000000001"));
      if writeBack_arbitration_isFiring = '1' then
        CsrPlugin_minstret <= (CsrPlugin_minstret + pkg_unsigned("0000000000000000000000000000000000000000000000000000000000000001"));
      end if;
      if BranchPlugin_branchExceptionPort_valid = '1' then
        CsrPlugin_exceptionPortCtrl_exceptionContext_code <= BranchPlugin_branchExceptionPort_payload_code;
        CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= BranchPlugin_branchExceptionPort_payload_badAddr;
      end if;
      if DBusSimplePlugin_memoryExceptionPort_valid = '1' then
        CsrPlugin_exceptionPortCtrl_exceptionContext_code <= DBusSimplePlugin_memoryExceptionPort_payload_code;
        CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= DBusSimplePlugin_memoryExceptionPort_payload_badAddr;
      end if;
      if zz_179 = '1' then
        if zz_180 = '1' then
          CsrPlugin_interrupt_code <= pkg_unsigned("0111");
          CsrPlugin_interrupt_targetPrivilege <= pkg_unsigned("11");
        end if;
        if zz_181 = '1' then
          CsrPlugin_interrupt_code <= pkg_unsigned("0011");
          CsrPlugin_interrupt_targetPrivilege <= pkg_unsigned("11");
        end if;
        if zz_182 = '1' then
          CsrPlugin_interrupt_code <= pkg_unsigned("1011");
          CsrPlugin_interrupt_targetPrivilege <= pkg_unsigned("11");
        end if;
      end if;
      if zz_167 = '1' then
        case CsrPlugin_targetPrivilege is
          when "11" =>
            CsrPlugin_mcause_interrupt <= (not CsrPlugin_hadException);
            CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
            CsrPlugin_mepc <= writeBack_PC;
            if CsrPlugin_hadException = '1' then
              CsrPlugin_mtval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
            end if;
          when others =>
        end case;
      end if;
      zz_118 <= pkg_extract(zz_36,11,7);
      zz_119 <= zz_50;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_PC <= decode_PC;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_PC <= zz_31;
      end if;
      if ((not writeBack_arbitration_isStuck) and (not CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack)) = '1' then
        memory_to_writeBack_PC <= memory_PC;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_FORMAL_PC_NEXT <= zz_53;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_FORMAL_PC_NEXT <= zz_52;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_FORMAL_PC_NEXT <= memory_FORMAL_PC_NEXT;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC1_CTRL <= zz_25;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_ALU_CTRL <= zz_22;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC2_CTRL <= zz_19;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_MEMORY_STORE <= decode_MEMORY_STORE;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_MEMORY_STORE <= execute_MEMORY_STORE;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_MEMORY_STORE <= memory_MEMORY_STORE;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_IS_CSR <= decode_IS_CSR;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_ENV_CTRL <= zz_16;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_ENV_CTRL <= zz_13;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_ENV_CTRL <= zz_11;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_ALU_BITWISE_CTRL <= zz_9;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SHIFT_CTRL <= zz_6;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_SHIFT_CTRL <= zz_3;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_BRANCH_CTRL <= zz_1;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_RS1 <= decode_RS1;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_RS2 <= decode_RS2;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        decode_to_execute_DO_EBREAK <= decode_DO_EBREAK;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_ALIGNEMENT_FAULT <= execute_ALIGNEMENT_FAULT;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_REGFILE_WRITE_DATA <= zz_46;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_REGFILE_WRITE_DATA <= zz_28;
      end if;
      if (not memory_arbitration_isStuck) = '1' then
        execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
      end if;
      if (not writeBack_arbitration_isStuck) = '1' then
        memory_to_writeBack_MEMORY_READ_DATA <= memory_MEMORY_READ_DATA;
      end if;
      if pkg_toStdLogic(zz_143 /= pkg_unsigned("000")) = '1' then
        zz_70 <= IBusSimplePlugin_injectionPort_payload;
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        execute_CsrPlugin_csr_768 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001100000000"));
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        execute_CsrPlugin_csr_836 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001101000100"));
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        execute_CsrPlugin_csr_772 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001100000100"));
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        execute_CsrPlugin_csr_833 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001101000001"));
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        execute_CsrPlugin_csr_834 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001101000010"));
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        execute_CsrPlugin_csr_835 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("001101000011"));
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        execute_CsrPlugin_csr_3072 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("110000000000"));
      end if;
      if (not execute_arbitration_isStuck) = '1' then
        execute_CsrPlugin_csr_3200 <= pkg_toStdLogic(pkg_extract(decode_INSTRUCTION,31,20) = pkg_stdLogicVector("110010000000"));
      end if;
      if execute_CsrPlugin_csr_836 = '1' then
        if execute_CsrPlugin_writeEnable = '1' then
          CsrPlugin_mip_MSIP <= pkg_extract(pkg_extract(execute_CsrPlugin_writeData,3,3),0);
        end if;
      end if;
      if execute_CsrPlugin_csr_833 = '1' then
        if execute_CsrPlugin_writeEnable = '1' then
          CsrPlugin_mepc <= unsigned(pkg_extract(execute_CsrPlugin_writeData,31,0));
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      DebugPlugin_firstCycle <= pkg_toStdLogic(false);
      if zz_158 = '1' then
        DebugPlugin_firstCycle <= pkg_toStdLogic(true);
      end if;
      DebugPlugin_secondCycle <= DebugPlugin_firstCycle;
      DebugPlugin_isPipBusy <= (pkg_toStdLogic(pkg_cat(pkg_toStdLogicVector(writeBack_arbitration_isValid),pkg_cat(pkg_toStdLogicVector(memory_arbitration_isValid),pkg_cat(pkg_toStdLogicVector(execute_arbitration_isValid),pkg_toStdLogicVector(decode_arbitration_isValid)))) /= pkg_stdLogicVector("0000")) or IBusSimplePlugin_incomingInstruction);
      if writeBack_arbitration_isValid = '1' then
        DebugPlugin_busReadDataReg <= zz_50;
      end if;
      zz_142 <= pkg_extract(debug_bus_cmd_payload_address,2);
      if zz_165 = '1' then
        DebugPlugin_busReadDataReg <= std_logic_vector(execute_PC);
      end if;
      DebugPlugin_resetIt_regNext <= DebugPlugin_resetIt;
    end if;
  end process;

  process(clk, debugReset)
  begin
    if debugReset = '1' then
      DebugPlugin_resetIt <= pkg_toStdLogic(false);
      DebugPlugin_haltIt <= pkg_toStdLogic(false);
      DebugPlugin_stepIt <= pkg_toStdLogic(false);
      DebugPlugin_godmode <= pkg_toStdLogic(false);
      DebugPlugin_haltedByBreak <= pkg_toStdLogic(false);
    elsif rising_edge(clk) then
      if (DebugPlugin_haltIt and (not DebugPlugin_isPipBusy)) = '1' then
        DebugPlugin_godmode <= pkg_toStdLogic(true);
      end if;
      if debug_bus_cmd_valid = '1' then
        case zz_178 is
          when "000000" =>
            if debug_bus_cmd_payload_wr = '1' then
              DebugPlugin_stepIt <= pkg_extract(debug_bus_cmd_payload_data,4);
              if pkg_extract(debug_bus_cmd_payload_data,16) = '1' then
                DebugPlugin_resetIt <= pkg_toStdLogic(true);
              end if;
              if pkg_extract(debug_bus_cmd_payload_data,24) = '1' then
                DebugPlugin_resetIt <= pkg_toStdLogic(false);
              end if;
              if pkg_extract(debug_bus_cmd_payload_data,17) = '1' then
                DebugPlugin_haltIt <= pkg_toStdLogic(true);
              end if;
              if pkg_extract(debug_bus_cmd_payload_data,25) = '1' then
                DebugPlugin_haltIt <= pkg_toStdLogic(false);
              end if;
              if pkg_extract(debug_bus_cmd_payload_data,25) = '1' then
                DebugPlugin_haltedByBreak <= pkg_toStdLogic(false);
              end if;
              if pkg_extract(debug_bus_cmd_payload_data,25) = '1' then
                DebugPlugin_godmode <= pkg_toStdLogic(false);
              end if;
            end if;
          when others =>
        end case;
      end if;
      if zz_165 = '1' then
        if zz_166 = '1' then
          DebugPlugin_haltIt <= pkg_toStdLogic(true);
          DebugPlugin_haltedByBreak <= pkg_toStdLogic(true);
        end if;
      end if;
      if zz_169 = '1' then
        if decode_arbitration_isValid = '1' then
          DebugPlugin_haltIt <= pkg_toStdLogic(true);
        end if;
      end if;
    end if;
  end process;

end arch;

