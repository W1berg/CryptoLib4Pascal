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

{$MACRO ON}
{$IFDEF ENDIAN_BIG}
{$MESSAGE FATAL 'This Library does not support "Big Endian" processors yet.'}
{$ENDIF}
// FPC 3.0.4 and Above
// Had to Include this here since Delphi does not allow it Compile in "CryptoLib.inc".
{$IF FPC_FULLVERSION < 30004}
{$MESSAGE ERROR 'This Library requires FreePascal 3.0.4 or higher.'}
{$IFEND}
{$IF FPC_FULLVERSION > 30004}
{$DEFINE FPC_GREATER_THAN_3.0.4}
{$IFEND}
{$IF FPC_FULLVERSION >= 30301}
{$DEFINE HAS_VOLATILE}
{$IFEND}
