unit PelcoD;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
type TPelcoCommand = (cmdGetPanPos, cmdLeft, cmdRight);
type
  TPacket = array [0..6] of Byte;

  TPelcoD = class
  private
    const CMD_GET_PAN_POS: TPacket = ($FF,$00,$00,$51,$00,$00,$00);
    const CMD_LEFT: TPacket = ($FF,$00,$00,$04,$00,$00,$00);
    const CMD_RIGHT: TPacket = ($FF,$00,$00,$02,$00,$00,$00);
  public
    class function GetCommand(var packet: TPacket; command: TPelcoCommand; data1: Byte; data2: Byte; address: Byte): Boolean; static;
end;

implementation

class function TPelcoD.GetCommand(var packet: TPacket; command: TPelcoCommand; data1: Byte; data2: Byte; address: Byte): Boolean; static;
var
  checksum : Byte;
begin
  try
    case command of
      cmdGetPanPos: packet := CMD_GET_PAN_POS;
      cmdLeft: packet := CMD_LEFT;
      cmdRight: packet := CMD_RIGHT;
    end;

    packet[1] := address;
    packet[4] := data1;
    packet[5] := data2;

    checksum := (packet[1]+packet[2]+packet[3]+packet[4]+packet[5]) Mod $100;
    packet[6] := checksum;
  except
    result := false;
  end;

  result := true;
end;

end.

