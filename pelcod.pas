unit PelcoD;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

  { TPelcoCommand }

type TPelcoCommand = (
  cmdGetPanPos,   {Get Pan Position}
  cmdGetTiltPos,  {Get Tilt Position}
  cmdUp,          {Tilt Up}
  cmdDown,        {Tilt Down}
  cmdLeft,        {Pan Left}
  cmdRight,       {Pan Right}
  cmdAbsolutePan, {Pan to Absolute Position}
  cmdAbsoluteTilt {Tilt to Absolute Position}
  );

  { TMovements }

type TMovements = set of TPelcoCommand;

  { TPanDirection }

type TPanDirection = (
  pdRight,        {Pan Right}
  pdLeft          {Pan Left}
);

type TTiltDirection = (
  tdUp            {Tilt Up},
  tdDown          {Tilt Down}
);

  { TPelcoResponse }

type TPelcoResponse = (
  rspPanPos=$59,  {Pan Position Response}
  rspTiltPos=$5B  {Tilt Position Response}
);

  { TPelcoSpeed }

type TPelcoSpeed = (
  spdStop=$00, {Stop Pan/Tilt}
  spd01=$01, spd02=$02, spd03=$03, spd04=$04, spd05=$05, spd06=$06, spd07=$07,
  spd08=$08, spd09=$09, spd10=$0a, spd11=$0b, spd12=$0c, spd13=$0d, spd14=$0e,
  spd15=$0f, spd16=$10, spd17=$11, spd18=$12, spd19=$13, spd20=$14, spd21=$15,
  spd22=$16, spd23=$17, spd24=$18, spd25=$19, spd26=$1a, spd27=$1b, spd28=$1c,
  spd29=$1d, spd30=$1e, spd31=$1f, spd32=$20, spd33=$21, spd34=$22, spd35=$23,
  spd36=$24, spd37=$25, spd38=$26, spd39=$27, spd40=$28, spd41=$29, spd42=$2a,
  spd43=$2b, spd44=$2c, spd45=$2d, spd46=$2e, spd47=$2f, spd48=$30, spd49=$31,
  spd50=$32, spd51=$33, spd52=$34, spd53=$35, spd54=$36, spd55=$37, spd56=$38,
  spd57=$39, spd58=$3a, spd59=$3b, spd60=$3c, spd61=$3d, spd62=$3e, spd63=$3f,
  spdMax=$FF {Turbo}
);

  { TPacket }

type
  TPacket = array [0..6] of Byte;

  { TPelcoD }

  TPelcoD = class
  private
    { Constants: Pelco Command Packets }
    const CMD_GET_PAN_POS:  TPacket = ($FF,$00,$00,$51,$00,$00,$00);
    const CMD_GET_TILT_POS: TPacket = ($FF,$00,$00,$53,$00,$00,$00);
    const CMD_UP:           TPacket = ($FF,$00,$00,$08,$00,$00,$00);
    const CMD_DOWN:         TPacket = ($FF,$00,$00,$10,$00,$00,$00);
    const CMD_LEFT:         TPacket = ($FF,$00,$00,$04,$00,$00,$00);
    const CMD_RIGHT:        TPacket = ($FF,$00,$00,$02,$00,$00,$00);
    const CMD_ABS_PAN:      TPacket = ($FF,$00,$00,$4B,$00,$00,$00);
    const CMD_ABS_TILT:     TPacket = ($FF,$00,$00,$4D,$00,$00,$00);
  public
    const Movements: TMovements = [cmdUp,cmdDown,cmdLeft,cmdRight,cmdAbsolutePan,cmdAbsoluteTilt];

    { Data Methods }
    class function GetCommand(var packet: TPacket; command: TPelcoCommand; data1: Byte; data2: Byte; address: Byte): Boolean; static;
    class function GetCheckSum(packet: TPacket): byte; static;
end;

implementation

{ Public - Data Methods }

class function TPelcoD.GetCommand(var packet: TPacket; command: TPelcoCommand; data1: Byte; data2: Byte; address: Byte): Boolean; static;
var
  checksum : Byte;
begin
  try
    case command of
      cmdGetPanPos:    packet := CMD_GET_PAN_POS;
      cmdGetTiltPos:   packet := CMD_GET_TILT_POS;
      cmdUp:           packet := CMD_UP;
      cmdDown:         packet := CMD_DOWN;
      cmdLeft:         packet := CMD_LEFT;
      cmdRight:        packet := CMD_RIGHT;
      cmdAbsolutePan:  packet := CMD_ABS_PAN;
      cmdAbsoluteTilt: packet := CMD_ABS_TILT;
    end;

    packet[1] := address;
    packet[4] := data1;
    packet[5] := data2;

    checksum := GetCheckSum(packet);
    packet[6] := checksum;
  except
    result := false;
  end;

  result := true;
end;

class function TPelcoD.GetCheckSum(packet: TPacket): byte;
begin
  Result := (packet[1]+packet[2]+packet[3]+packet[4]+packet[5]) Mod $100;
end;

end.

