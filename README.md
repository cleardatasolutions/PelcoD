# Pelco D Protocol Library in Pascal

**NOTE:** This library was written in Object Pascal using Lazarus IDE (a free development environment for Delphi and Object Pascal) available here: https://www.lazarus-ide.org/.  The library a work in progress.

**LICENSE:** This software is made available under the MIT No Attribution license, copyright 2024 Clear Data Solutions, Inc.  For details regarding this license see the file "LICENSE" in this project.

## Pelco-D

The Pelco-D protocol is a PTZ (Pan/Tilt/Zoom) protocol for controlling many brands of cameras and motors.  More information can be found at the following links:

https://www.commfront.com/pages/pelco-d-protocol-tutorial

https://asset.fujifilm.com/www/us/files/2020-03/5cc3680592a1a16d8e6e067e34910c32/Pelco-D_Protocol_Specification_for_SX800_801_V.2.51_ENG.pdf

https://www.epiphan.com/userguides/LUMiO12x/Content/UserGuides/PTZ/3-operation/PELCODcommands.htm

## Use

The Pelco-D protocol specifies commands formed as 7-byte "packets", each containing a synchronization byte, device address, 1 or 2 commands, 1 or 2 data instructions, and a checksum byte.  TPacket is an array of bytes, which is 7-bytes long to conform to this format.

The TPelcoD class can be used to generate appropriately formed "packets" recognized by Pelco-D compatible devices.  Simply call the static class function "GetCommand" with the appropriate parameters.  The 7th byte is a "checksum" which will be calculated automatically.

### GetCommand 

**packet:** A TPacket variable which will be populated with the necessary values to send to the Pelco-D device.

**command** A TPelcoCommand (cmdGetPanPos, cmdLeft, cmdRight, etc) which indicates what action the Pelco-D device should perform.

**data1** The first data byte.  The purpose of this byte depends on the command being sent.  For pan commands (left or right) this is the pan speed, ranging from 00 (stop panning) to 3F (high speed), but also FF (turbo or "max" speed).

**data2** The second data byte.  The purpose of this byte depends on the command being sent.  For tilt commands (Up or Down) this is the tilt speed, ranging from 00 (stop tilting) to 3F (high speed).

**address** The address of the Pelco-D device (often set via dip-switch on the device).  Many devices can be "daisy-chained" together on the same wire, so addressing allows the application to specify which device on the chain to command.

Find more information about Clear Data Solutions, Inc. at: https://cleardata.it 
