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

  {TPelcoResponse }

type TPelcoResponse = (
  rspPanPos=$59,  {Pan Position Response}
  rspTiltPos=$5B  {Tilt Position Response}
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

