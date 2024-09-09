unit PelcoD;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type TPelcoCommand = (
  cmdGetPanPos,   {Get Pan Position}
  cmdGetTiltPos,  {Get Tilt Position}
  cmdUp,          {Tilt Up}
  cmdDown,        {Tilt Down}
  cmdLeft,        {Pan Left}
  cmdRight        {Pan Right}
  );

type TMovements = set of TPelcoCommand;

type TPelcoResponse = (
  rspPanPos=$59,  {Pan Position Response}
  rspTiltPos=$5B  {Tilt Position Response}
);

type
  TPacket = array [0..6] of Byte;

  { TPelcoD }

  TPelcoD = class
  private
    const CMD_GET_PAN_POS:  TPacket = ($FF,$00,$00,$51,$00,$00,$00);
    const CMD_GET_TILT_POS: TPacket = ($FF,$00,$00,$53,$00,$00,$00);
    const CMD_UP:           TPacket = ($FF,$00,$00,$08,$00,$00,$00);
    const CMD_DOWN:         TPacket = ($FF,$00,$00,$10,$00,$00,$00);
    const CMD_LEFT:         TPacket = ($FF,$00,$00,$04,$00,$00,$00);
    const CMD_RIGHT:        TPacket = ($FF,$00,$00,$02,$00,$00,$00);
  public
    const Movements: TMovements = [cmdUp,cmdDown,cmdLeft,cmdRight];
    class function GetCommand(var packet: TPacket; command: TPelcoCommand; data1: Byte; data2: Byte; address: Byte): Boolean; static;
    class function GetCheckSum(packet: TPacket): byte; static;
end;

implementation

class function TPelcoD.GetCommand(var packet: TPacket; command: TPelcoCommand; data1: Byte; data2: Byte; address: Byte): Boolean; static;
var
  checksum : Byte;
begin
  try
    case command of
      cmdGetPanPos: packet := CMD_GET_PAN_POS;
      cmdUp:        packet := CMD_UP;
      cmdDown:      packet := CMD_DOWN;
      cmdLeft:      packet := CMD_LEFT;
      cmdRight:     packet := CMD_RIGHT;
    end;

    packet[1] := address;
    packet[4] := data1;
    packet[5] := data2;

    //checksum := (packet[1]+packet[2]+packet[3]+packet[4]+packet[5]) Mod $100;
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

