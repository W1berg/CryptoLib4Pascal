{ *********************************************************************************** }
{ *                              CryptoLib Library                                  * }
{ *                Copyright (c) 2018 - 20XX Ugochukwu Mmaduekwe                    * }
{ *                 Github Repository <https://github.com/Xor-el>                   * }

{ *  Distributed under the MIT software license, see the accompanying file LICENSE  * }
{ *          or visit http://www.opensource.org/licenses/mit-license.php.           * }

{ *                              Acknowledgements:                                  * }
{ *                                                                                 * }
{ *      Thanks to Sphere 10 Software (http://www.sphere10.com/) for sponsoring     * }
{ *                           development of this library                           * }

{ * ******************************************************************************* * }

(* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& *)

unit ClpConverters;

{$I CryptoLib.inc}

interface

uses
  Classes,
  StrUtils,
  SysUtils,
  ClpCryptoLibTypes,
  ClpBits,
  ClpBitConverter;

resourcestring
  SEncodingInstanceNil = 'Encoding Instance Cannot Be Nil';

type
  TConverters = class sealed(TObject)

  strict private
    class function SplitString(const S: string; Delimiter: Char): TCryptoLibStringArray; static;

{$IFDEF DEBUG}
    class procedure Check(const a_in: TCryptoLibByteArray; a_in_size, a_out_size: Int32); overload; static;
{$ENDIF DEBUG}
    class procedure swap_copy_str_to_u32(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32); static;

    class procedure swap_copy_str_to_u64(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32); static;

  public

    class function be2me_32(x: UInt32): UInt32; static; inline;

    class function be2me_64(x: UInt64): UInt64; static; inline;

    class function le2me_32(x: UInt32): UInt32; static; inline;

    class function le2me_64(x: UInt64): UInt64; static; inline;

    class procedure be32_copy(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32); static; inline;

    class procedure le32_copy(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32); static; inline;

    class procedure be64_copy(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32); static; inline;

    class procedure le64_copy(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32); static; inline;

    class function ReadBytesAsUInt32LE(a_in: PByte; a_index: Int32): UInt32; static; inline;

    class function ReadBytesAsUInt32BE(a_in: PByte; a_index: Int32): UInt32; static; inline;

    class function ReadBytesAsUInt64LE(a_in: PByte; a_index: Int32): UInt64; static; inline;

    class function ReadBytesAsUInt64BE(a_in: PByte; a_index: Int32): UInt64; static; inline;

    class function ReadUInt32AsBytesLE(a_in: UInt32): TCryptoLibByteArray; overload; static; inline;

    class function ReadUInt32AsBytesBE(a_in: UInt32): TCryptoLibByteArray; overload; static; inline;

    class function ReadUInt64AsBytesBE(a_in: UInt64): TCryptoLibByteArray; overload; static; inline;

    class function ReadUInt64AsBytesLE(a_in: UInt64): TCryptoLibByteArray; overload; static; inline;

    class procedure ReadUInt32AsBytesLE(a_in: UInt32; const a_out: TCryptoLibByteArray; a_index: Int32); overload; static; inline;

    class procedure ReadUInt32AsBytesBE(a_in: UInt32; const a_out: TCryptoLibByteArray; a_index: Int32); overload; static; inline;

    class procedure ReadUInt64AsBytesLE(a_in: UInt64; const a_out: TCryptoLibByteArray; a_index: Int32); overload; static; inline;

    class procedure ReadUInt64AsBytesBE(a_in: UInt64; const a_out: TCryptoLibByteArray; a_index: Int32); overload; static; inline;

    class function ConvertStringToBytes(const a_in: string; a_encoding: TEncoding): TCryptoLibByteArray; overload; static;

    class function ConvertBytesToString(const a_in: TCryptoLibByteArray; const a_encoding: TEncoding): string; overload; static;

    class function ConvertHexStringToBytes(const a_in: string): TCryptoLibByteArray; static; inline;

    class function ConvertBytesToHexString(const a_in: TCryptoLibByteArray; a_group: Boolean): string; static;

  end;

implementation

{ TConverters }

{$IFDEF DEBUG}

class procedure TConverters.Check(const a_in: TCryptoLibByteArray; a_in_size, a_out_size: Int32);
begin
  System.Assert(((System.length(a_in) * a_in_size) mod a_out_size) = 0);
end;

{$ENDIF DEBUG}

class procedure TConverters.swap_copy_str_to_u32(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32);
var
  lsrc, ldest, lend: PCardinal;
  lbsrc: PByte;
  lLength: Int32;
begin
  // if all pointers and length are 32-bits aligned
  if ((Int32(PByte(dest) - PByte(0)) or (PByte(src) - PByte(0)) or src_index or dest_index or length) and 3) = 0 then
  begin
    // copy memory as 32-bit words
    lsrc := PCardinal(PByte(src) + src_index);
    lend := PCardinal((PByte(src) + src_index) + length);
    ldest := PCardinal(PByte(dest) + dest_index);
    while lsrc < lend do
    begin
      ldest^ := TBits.ReverseBytesUInt32(lsrc^);
      System.Inc(ldest);
      System.Inc(lsrc);
    end;
  end
  else
  begin
    lbsrc := (PByte(src) + src_index);

    lLength := length + dest_index;
    while dest_index < lLength do
    begin

      PByte(dest)[dest_index xor 3] := lbsrc^;

      System.Inc(lbsrc);
      System.Inc(dest_index);
    end;

  end;
end;

class procedure TConverters.swap_copy_str_to_u64(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32);
var
  lsrc, ldest, lend: PUInt64;
  lbsrc: PByte;
  lLength: Int32;
begin
  // if all pointers and length are 64-bits aligned
  if ((Int32(PByte(dest) - PByte(0)) or (PByte(src) - PByte(0)) or src_index or dest_index or length) and 7) = 0 then
  begin
    // copy aligned memory block as 64-bit integers
    lsrc := PUInt64(PByte(src) + src_index);
    lend := PUInt64((PByte(src) + src_index) + length);
    ldest := PUInt64(PByte(dest) + dest_index);
    while lsrc < lend do
    begin
      ldest^ := TBits.ReverseBytesUInt64(lsrc^);
      System.Inc(ldest);
      System.Inc(lsrc);
    end;
  end
  else
  begin
    lbsrc := (PByte(src) + src_index);

    lLength := length + dest_index;
    while dest_index < lLength do
    begin

      PByte(dest)[dest_index xor 7] := lbsrc^;

      System.Inc(lbsrc);
      System.Inc(dest_index);
    end;

  end;
end;

class function TConverters.be2me_32(x: UInt32): UInt32;
begin
  if TBitConverter.IsLittleEndian then
    result := TBits.ReverseBytesUInt32(x)
  else
    result := x;
end;

class function TConverters.be2me_64(x: UInt64): UInt64;
begin
  if TBitConverter.IsLittleEndian then
    result := TBits.ReverseBytesUInt64(x)
  else
    result := x;
end;

class procedure TConverters.be32_copy(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32);
begin
  if TBitConverter.IsLittleEndian then
    swap_copy_str_to_u32(src, src_index, dest, dest_index, length)
  else
    System.Move(Pointer(PByte(src) + src_index)^, Pointer(PByte(dest) + dest_index)^, length);
end;

class procedure TConverters.be64_copy(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32);
begin
  if TBitConverter.IsLittleEndian then
    swap_copy_str_to_u64(src, src_index, dest, dest_index, length)
  else
    System.Move(Pointer(PByte(src) + src_index)^, Pointer(PByte(dest) + dest_index)^, length);
end;

class function TConverters.le2me_32(x: UInt32): UInt32;
begin
  if not TBitConverter.IsLittleEndian then
    result := TBits.ReverseBytesUInt32(x)
  else
    result := x;
end;

class function TConverters.le2me_64(x: UInt64): UInt64;
begin
  if not TBitConverter.IsLittleEndian then
    result := TBits.ReverseBytesUInt64(x)
  else
    result := x;
end;

class procedure TConverters.le32_copy(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32);
begin
  if TBitConverter.IsLittleEndian then
    System.Move(Pointer(PByte(src) + src_index)^, Pointer(PByte(dest) + dest_index)^, length)
  else
    swap_copy_str_to_u32(src, src_index, dest, dest_index, length);
end;

class procedure TConverters.le64_copy(src: Pointer; src_index: Int32; dest: Pointer; dest_index: Int32; length: Int32);
begin
  if TBitConverter.IsLittleEndian then
    System.Move(Pointer(PByte(src) + src_index)^, Pointer(PByte(dest) + dest_index)^, length)
  else
    swap_copy_str_to_u64(src, src_index, dest, dest_index, length);
end;

class function TConverters.ReadBytesAsUInt32LE(a_in: PByte; a_index: Int32): UInt32;
begin
{$IFDEF FPC}
{$IFDEF FPC_REQUIRES_PROPER_ALIGNMENT}
  System.Move(a_in[a_index], result, System.SizeOf(UInt32));
{$ELSE}
  result := PCardinal(a_in + a_index)^;
{$ENDIF FPC_REQUIRES_PROPER_ALIGNMENT}
{$ELSE}
  // Delphi does not handle unaligned memory access on ARM Devices properly.
  System.Move(a_in[a_index], result, System.SizeOf(UInt32));
{$ENDIF FPC}
  result := le2me_32(result);
end;

class function TConverters.ReadBytesAsUInt32BE(a_in: PByte; a_index: Int32): UInt32;
begin
{$IFDEF FPC}
{$IFDEF FPC_REQUIRES_PROPER_ALIGNMENT}
  System.Move(a_in[a_index], result, System.SizeOf(UInt32));
{$ELSE}
  result := PCardinal(a_in + a_index)^;
{$ENDIF FPC_REQUIRES_PROPER_ALIGNMENT}
{$ELSE}
  // Delphi does not handle unaligned memory access on ARM Devices properly.
  System.Move(a_in[a_index], result, System.SizeOf(UInt32));
{$ENDIF FPC}
  result := be2me_32(result);
end;

class function TConverters.ReadBytesAsUInt64LE(a_in: PByte; a_index: Int32): UInt64;
begin
{$IFDEF FPC}
{$IFDEF FPC_REQUIRES_PROPER_ALIGNMENT}
  System.Move(a_in[a_index], result, System.SizeOf(UInt64));
{$ELSE}
  result := PUInt64(a_in + a_index)^;
{$ENDIF FPC_REQUIRES_PROPER_ALIGNMENT}
{$ELSE}
  // Delphi does not handle unaligned memory access on ARM Devices properly.
  System.Move(a_in[a_index], result, System.SizeOf(UInt64));
{$ENDIF FPC}
  result := le2me_64(result);
end;

class function TConverters.ReadBytesAsUInt64BE(a_in: PByte; a_index: Int32): UInt64;
begin
{$IFDEF FPC}
{$IFDEF FPC_REQUIRES_PROPER_ALIGNMENT}
  System.Move(a_in[a_index], result, System.SizeOf(UInt64));
{$ELSE}
  result := PUInt64(a_in + a_index)^;
{$ENDIF FPC_REQUIRES_PROPER_ALIGNMENT}
{$ELSE}
  // Delphi does not handle unaligned memory access on ARM Devices properly.
  System.Move(a_in[a_index], result, System.SizeOf(UInt64));
{$ENDIF FPC}
  result := be2me_64(result);
end;

class function TConverters.ReadUInt32AsBytesLE(a_in: UInt32): TCryptoLibByteArray;
begin
  result := TCryptoLibByteArray.Create(Byte(a_in), Byte(a_in shr 8), Byte(a_in shr 16), Byte(a_in shr 24));
end;

class function TConverters.ReadUInt32AsBytesBE(a_in: UInt32): TCryptoLibByteArray;
begin
  result := TCryptoLibByteArray.Create(Byte(a_in shr 24), Byte(a_in shr 16), Byte(a_in shr 8), Byte(a_in));
end;

class function TConverters.ReadUInt64AsBytesLE(a_in: UInt64): TCryptoLibByteArray;
begin
  result := TCryptoLibByteArray.Create(Byte(a_in), Byte(a_in shr 8), Byte(a_in shr 16), Byte(a_in shr 24), Byte(a_in shr 32), Byte(a_in shr 40), Byte(a_in shr 48), Byte(a_in shr 56));
end;

class function TConverters.ReadUInt64AsBytesBE(a_in: UInt64): TCryptoLibByteArray;
begin
  result := TCryptoLibByteArray.Create(Byte(a_in shr 56), Byte(a_in shr 48), Byte(a_in shr 40), Byte(a_in shr 32), Byte(a_in shr 24), Byte(a_in shr 16), Byte(a_in shr 8), Byte(a_in));
end;

class procedure TConverters.ReadUInt32AsBytesBE(a_in: UInt32; const a_out: TCryptoLibByteArray; a_index: Int32);
begin
  a_out[a_index] := Byte(a_in shr 24);
  a_out[a_index + 1] := Byte(a_in shr 16);
  a_out[a_index + 2] := Byte(a_in shr 8);
  a_out[a_index + 3] := Byte(a_in);
end;

class procedure TConverters.ReadUInt32AsBytesLE(a_in: UInt32; const a_out: TCryptoLibByteArray; a_index: Int32);
begin
  a_out[a_index] := Byte(a_in);
  a_out[a_index + 1] := Byte(a_in shr 8);
  a_out[a_index + 2] := Byte(a_in shr 16);
  a_out[a_index + 3] := Byte(a_in shr 24);
end;

class procedure TConverters.ReadUInt64AsBytesLE(a_in: UInt64; const a_out: TCryptoLibByteArray; a_index: Int32);
begin
  a_out[a_index] := Byte(a_in);
  a_out[a_index + 1] := Byte(a_in shr 8);
  a_out[a_index + 2] := Byte(a_in shr 16);
  a_out[a_index + 3] := Byte(a_in shr 24);
  a_out[a_index + 4] := Byte(a_in shr 32);
  a_out[a_index + 5] := Byte(a_in shr 40);
  a_out[a_index + 6] := Byte(a_in shr 48);
  a_out[a_index + 7] := Byte(a_in shr 56);
end;

class procedure TConverters.ReadUInt64AsBytesBE(a_in: UInt64; const a_out: TCryptoLibByteArray; a_index: Int32);
begin
  a_out[a_index] := Byte(a_in shr 56);
  a_out[a_index + 1] := Byte(a_in shr 48);
  a_out[a_index + 2] := Byte(a_in shr 40);
  a_out[a_index + 3] := Byte(a_in shr 32);
  a_out[a_index + 4] := Byte(a_in shr 24);
  a_out[a_index + 5] := Byte(a_in shr 16);
  a_out[a_index + 6] := Byte(a_in shr 8);
  a_out[a_index + 7] := Byte(a_in);
end;

class function TConverters.ConvertBytesToHexString(const a_in: TCryptoLibByteArray; a_group: Boolean): string;
var
  I: Int32;
  hex, workstring: string;
  ar: TCryptoLibStringArray;
begin

  hex := UpperCase(TBitConverter.ToString(a_in));

  if System.length(a_in) = 1 then
  begin
    result := hex;
    Exit;
  end;

  if System.length(a_in) = 2 then
  begin
    result := StringReplace(hex, '-', '', [rfIgnoreCase, rfReplaceAll]);
    Exit;
  end;

  if (a_group) then
  begin
{$IFDEF DEBUG}
    Check(a_in, 1, 4);
{$ENDIF DEBUG}
    workstring := UpperCase(TBitConverter.ToString(a_in));

    ar := TConverters.SplitString(workstring, '-');
    hex := '';
    I := 0;

    while I < (System.length(ar) shr 2) do
    begin
      if (I <> 0) then
        hex := hex + '-';
      hex := hex + ar[I * 4] + ar[I * 4 + 1] + ar[I * 4 + 2] + ar[I * 4 + 3];

      System.Inc(I);
    end;

  end
  else
  begin
    hex := StringReplace(hex, '-', '', [rfIgnoreCase, rfReplaceAll]);
  end;
  result := hex;
end;

class function TConverters.ConvertHexStringToBytes(const a_in: string): TCryptoLibByteArray;
var
  l_in: string;
begin
  l_in := a_in;
  l_in := StringReplace(l_in, '-', '', [rfIgnoreCase, rfReplaceAll]);

{$IFDEF DEBUG}
  System.Assert(System.length(l_in) and 1 = 0);
{$ENDIF DEBUG}
  System.SetLength(result, System.length(l_in) shr 1);
{$IFNDEF NEXTGEN}
  HexToBin(PChar(l_in), @result[0], System.length(result));
{$ELSE}
  HexToBin(PChar(l_in), 0, result, 0, System.length(l_in));
{$ENDIF !NEXTGEN}
end;

class function TConverters.ConvertStringToBytes(const a_in: string; a_encoding: TEncoding): TCryptoLibByteArray;
begin

  if a_encoding = nil then
  begin
    raise EArgumentNilCryptoLibException.CreateRes(@SEncodingInstanceNil);
  end;

{$IFDEF FPC}
  result := a_encoding.GetBytes(UnicodeString(a_in));
{$ELSE}
  result := a_encoding.GetBytes(a_in);
{$ENDIF FPC}
end;

class function TConverters.ConvertBytesToString(const a_in: TCryptoLibByteArray; const a_encoding: TEncoding): string;
begin

  if a_encoding = nil then
  begin
    raise EArgumentNilCryptoLibException.CreateRes(@SEncodingInstanceNil);
  end;

{$IFDEF FPC}
  result := string(a_encoding.GetString(a_in));
{$ELSE}
  result := a_encoding.GetString(a_in);
{$ENDIF FPC}
end;

class function TConverters.SplitString(const S: string; Delimiter: Char): TCryptoLibStringArray;
var
  PosStart, PosDel, SplitPoints, I, Len: Int32;
begin
  result := nil;
  if S <> '' then
  begin
    { Determine the length of the resulting array }
    SplitPoints := 0;
    for I := 1 to System.length(S) do
    begin
      if (Delimiter = S[I]) then
        System.Inc(SplitPoints);
    end;

    System.SetLength(result, SplitPoints + 1);

    { Split the string and fill the resulting array }

    I := 0;
    Len := System.length(Delimiter);
    PosStart := 1;
    PosDel := System.Pos(Delimiter, S);
    while PosDel > 0 do
    begin
      result[I] := System.Copy(S, PosStart, PosDel - PosStart);
      PosStart := PosDel + Len;
      PosDel := PosEx(Delimiter, S, PosStart);
      System.Inc(I);
    end;
    result[I] := System.Copy(S, PosStart, System.length(S));
  end;
end;

end.
