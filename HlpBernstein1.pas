unit HlpBernstein1;

{$I HashLib.inc}

interface

uses
  HlpHashLibTypes,
  HlpHash,
  HlpIHash,
  HlpIHashInfo,
  HlpHashResult,
  HlpIHashResult;

type
  TBernstein1 = class sealed(THash, IHash32, ITransformBlock)
  strict private
  var
    FHash: UInt32;

  public
    constructor Create();
    procedure Initialize(); override;
    procedure TransformBytes(const AData: THashLibByteArray; AIndex, ALength: Int32); override;
    function TransformFinal(): IHashResult; override;
    function Clone(): IHash; override;
  end;

implementation

{ TBernstein1 }

function TBernstein1.Clone(): IHash;
var
  LHashInstance: TBernstein1;
begin
  LHashInstance := TBernstein1.Create();
  LHashInstance.FHash := FHash;
  result := LHashInstance as IHash;
  result.BufferSize := BufferSize;
end;

constructor TBernstein1.Create;
begin
  inherited Create(4, 1);
end;

procedure TBernstein1.Initialize;
begin
  FHash := 5381;
end;

procedure TBernstein1.TransformBytes(const AData: THashLibByteArray; AIndex, ALength: Int32);
var
  LIdx: Int32;
begin
{$IFDEF DEBUG}
  System.Assert(AIndex >= 0);
  System.Assert(ALength >= 0);
  System.Assert(AIndex + ALength <= System.Length(AData));
{$ENDIF DEBUG}
  LIdx := AIndex;
  while ALength > 0 do
  begin
    FHash := (FHash * 33) xor AData[LIdx];
    System.Inc(LIdx);
    System.Dec(ALength);
  end;
end;

function TBernstein1.TransformFinal: IHashResult;
begin
  result := THashResult.Create(FHash);
  Initialize();
end;

end.
