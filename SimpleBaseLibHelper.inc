{ *********************************************************************************** }
{ *                             SimpleBaseLib Library                               * }
{ *                 Copyright (c) 2018 - 2019 Ugochukwu Mmaduekwe                   * }
{ *                 Github Repository <https://github.com/Xor-el>                   * }

{ *  Distributed under the MIT software license, see the accompanying file LICENSE  * }
{ *          or visit http://www.opensource.org/licenses/mit-license.php.           * }

{ * ******************************************************************************* * }

(* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& *)

{$MACRO ON}
{$IFDEF ENDIAN_BIG}
{$MESSAGE FATAL 'This Library does not support "Big Endian" processors yet.'}
{$ENDIF}
// FPC 3.0.0 and Above
// Had to Include this here since Delphi does not allow it Compile in "SimpleBaseLib.inc".
{$IF FPC_FULLVERSION < 30000}
{$MESSAGE ERROR 'This Library requires FreePascal 3.0.0 or higher.'}
{$IFEND}
