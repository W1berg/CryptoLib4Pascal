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

unit ClpECKeyGenerationParameters;

{$I CryptoLib.inc}

interface

uses
  ClpBigInteger,
  ClpISecureRandom,
  ClpIECKeyGenerationParameters,
  ClpIECDomainParameters,
  ClpKeyGenerationParameters;

type
  TECKeyGenerationParameters = class sealed(TKeyGenerationParameters, IECKeyGenerationParameters)

  strict private
  var
    FdomainParams: IECDomainParameters;

    function GetDomainParameters: IECDomainParameters;

  public
    constructor Create(const domainParameters: IECDomainParameters; const random: ISecureRandom);
    property domainParameters: IECDomainParameters read GetDomainParameters;
  end;

implementation

{ TECKeyGenerationParameters }

constructor TECKeyGenerationParameters.Create(const domainParameters: IECDomainParameters; const random: ISecureRandom);
begin
  inherited Create(random, domainParameters.N.BitLength);
  FdomainParams := domainParameters;
end;

function TECKeyGenerationParameters.GetDomainParameters: IECDomainParameters;
begin
  Result := FdomainParams;
end;

end.
