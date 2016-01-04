unit CurveRecon;

// OGO 2.1 2009/2010
// Groep 3

{$MODE Delphi}

interface

type
  TPunt =
  class(TObject)
  private
    FX: Double;
    FY: Double;
  public
    // construction
    constructor Create(AX: Double; AY: Double);
    // pre: true
    // post: (inherited Create).post and X = AX and Y = AY
    
    // queries
    function X: Double;
    // pre: true
    // ret: FX
    function Y: Double;
    // pre: true
    // ret: FY
    function AfstandTot(APunt: TPunt): Double;
    // pre: true
    // ret: |APunt - (FX,FY)|
  end;
  
  TPunten = 
  class(TObject)
  private
    FPunten: array of TPunt;
    FCap: Integer;
    FCount: Integer;
    
    // invariants
    // 0 <= FCount <= FCap
    // FCount = |FPunten|
  public
    // construction
    constructor Create(ACapacity: Integer);
    // pre: 0 <= ACapacity
    // post: FPunten = [], Cap = ACapacity
    
    // queries
    function Capacity: Integer;
    // pre: true
    // ret: FCap
    function Count: Integer;
    // pre: true
    // ret: |FPunten|
    function Punt(I: Integer): TPunt;
    // pre: 0 <= I < Count
    // ret: FPunten(I)
    
    // commands
    procedure Add(APunt: TPunt);
    // pre: Count < Capacity
    // post: FPunten' = 'FPunten ++ [APunt]
    procedure Remove(var APunt: TPunt);
    // pre: 'FPunten = FPuntenSub ++ [APunt]
    // post: FPunten' = FPuntenSub
  end;
  
  TLijn = 
  class(TObject)
  private
    FBegin: TPunt;
    FEind: TPunt;
  public
    // construction
    constructor Create(ABegin: TPunt; AEind: TPunt);
    // pre: true
    // post: BeginPunt = ABegin and EindPunt = AEind
    
    // queries
    function BeginPunt: TPunt;
    // pre: true
    // ret: FBegin
    function EindPunt: TPunt;
    // pre: true
    // ret: FEind
    function Lengte: Double;
    // pre: true
    // ret: |FEind - FBegin|
    function HeeftPunt(APunt: TPunt): Boolean;
    // pre: true
    // ret: FBegin = APunt || FEind = APunt
  end;

  { TLijnen }

  TLijnen =
  class(TObject)
  private
    FLijnen: array of TLijn;
    FCap: Integer;
    FCount: Integer;

    // invariants
    // 0 <= FCount <= FCap
    // FCount = |FLijnen|
  public
    // construction
    constructor Create(ACapacity: Integer);
    // pre: 0 <= ACapacity
    // post: FPunten = [], Cap = ACapacity

    // queries
    function Capacity: Integer;
    // pre: true
    // ret: FCap
    function Count: Integer;
    // pre: true
    // ret: |FLijnen|
    function Lijn(I: Integer): TLijn;
    // pre: 0 <= I < Count
    // ret: FLijnen(I)

    // commands
    procedure Add(ALijn: TLijn);
    // pre: Count < Capacity
    // post: FLijnen' = 'FLijnen ++ [ALijn]
    procedure Remove(var ALijn: TLijn);
    // pre: 'FLijnen = FLijnenSub ++ [ALijn]
    // post: FLijnen' = FLijnenSub
  end;

  { TLijnen }

  { TDoubleList }

  TDoubleList =
  class(TObject)
  private
    FDoubles: array of Double;
    FCap: Integer;
    FCount: Integer;

    // invariants
    // 0 <= FCount <= FCap
    // FCount = |FDoubles|
  public
    // construction
    constructor Create(ACapacity: Integer);
    // pre: 0 <= ACapacity
    // post: FPunten = [], Cap = ACapacity

    // queries
    function Capacity: Integer;
    // pre: true
    // ret: FCap
    function Count: Integer;
    // pre: true
    // ret: |FDoubles|
    function Element(I: Integer): Double;
    // pre: 0 <= I < Count
    // ret: FDoubles(I)

    // commands
    procedure Add(ADouble: Double);
    // pre: Count < Capacity
    // post: FDoubles' = 'FDoubles ++ [ADouble]
    procedure Remove(var ADouble: Double);
    // pre: 'FDoubles = FDoublesSub ++ [ADouble]
    // post: FDoubles' = FDoublesSub
    procedure Replace(APos: Integer; ADouble: Double);
    // pre: 0 <= APos < Count
    // post: FDoubles(APos) = ADouble
  end;
  
implementation //===============================================================

uses
  Math, SysUtils;

{ TPunt }

constructor TPunt.Create(AX: Double; AY: Double);
begin
  inherited Create;
  
  FX := AX;
  FY := AY;
end;

function TPunt.X: Double;
begin
  Result := FX;
end;

function TPunt.Y: Double;
begin
  Result := FY;
end;

function TPunt.AfstandTot(APunt: TPunt): Double;
begin
  Result := Sqrt(Sqr(Abs(APunt.X - FX)) + 
                 Sqr(Abs(APunt.Y - FY)));
end;

{ TPunten }

constructor TPunten.Create(ACapacity: Integer);
var
  i: Integer;
begin
  inherited Create;
  
  Assert(0 <= ACapacity, 'TPunten.Create.pre failed');

  // hack
  ACapacity := ACapacity * 2;

  SetLength(FPunten, ACapacity);
  FCap := ACapacity;
  FCount := 0;
  
  for i := 0 to (FCap - 1) do begin
    FPunten[i] := nil;
  end{for};
end;

function TPunten.Capacity: Integer;
begin
  Result := FCap;
end;

function TPunten.Count: Integer;
begin
  Result := FCount;
end;

function TPunten.Punt(I: Integer): TPunt;
begin
  Assert((0 <= I) and (I < Count), 'TPunten.Punt.pre failed');
  
  Result := FPunten[I];
end;

procedure TPunten.Add(APunt: TPunt);
begin
  Assert(Count < Capacity, 'TPunten.Add.pre failed');
  
  FPunten[FCount] := APunt;
  FCount := FCount + 1;
end;

procedure TPunten.Remove(var APunt: TPunt);
var
  found: Boolean;
  i: Integer;
begin
  { Bestaat APunt? }
  found := false;
  i := 0;
  while (i < FCount) and not found do begin
    if FPunten[i] = APunt then begin
      found := true;
    end
    else begin
      i := i + 1;
    end{if};
  end{while};
  
  Assert(found, 'TPunten.Remove.pre failed');
  {@ APunt bestaat en heeft index i }
  
  for i := i to (FCap - 2) do begin
    FPunten[i] := FPunten[(i + 1)];
  end{for};
  FPunten[(FCap - 1)] := nil;
  
  FCount := FCount - 1;
end;

{ TLijn }

constructor TLijn.Create(ABegin: TPunt; AEind: TPunt);
begin
  FBegin := ABegin;
  FEind := AEind;
end;

function TLijn.BeginPunt: TPunt;
begin
  Result := FBegin;
end;

function TLijn.EindPunt: TPunt;
begin
  Result := FEind;
end;

function TLijn.Lengte: Double;
begin
  Result := FBegin.AfstandTot(FEind);
end;

function TLijn.HeeftPunt(APunt: TPunt): Boolean;
begin
  Result := (FBegin = APunt) or (FEind = APunt);
end;

{ TLijnen }

constructor TLijnen.Create(ACapacity: Integer);
var
  i: Integer;
begin
  inherited Create;

  Assert(0 <= ACapacity, 'TLijnen.Create.pre failed');

  // hack
  ACapacity := ACapacity * 2;

  SetLength(FLijnen, ACapacity);
  FCap := ACapacity;
  FCount := 0;

  for i := 0 to (FCap - 1) do begin
    FLijnen[i] := nil;
  end{for};
end;

function TLijnen.Capacity: Integer;
begin
  Result := FCap;
end;

function TLijnen.Count: Integer;
begin
  Result := FCount;
end;

function TLijnen.Lijn(I: Integer): TLijn;
begin
  Assert((0 <= I) and (I < Count), 'TLijnen.Lijn.pre failed');

  Result := FLijnen[I];
end;

procedure TLijnen.Add(ALijn: TLijn);
begin
  Assert(Count < Capacity, 'TLijnen.Add.pre failed');

  FLijnen[FCount] := ALijn;
  FCount := FCount + 1;
end;

procedure TLijnen.Remove(var ALijn: TLijn);
var
  found: Boolean;
  i: Integer;
begin
  { Bestaat APunt? }
  found := false;
  i := 0;
  while (i < FCount) and not found do begin
    if FLijnen[i] = ALijn then begin
      found := true;
    end
    else begin
      i := i + 1;
    end{if};
  end{while};

  Assert(found, 'TLijnen.Remove.pre failed');
  {@ ALijn bestaat en heeft index i }

  for i := i to (FCap - 2) do begin
    FLijnen[i] := FLijnen[(i + 1)];
  end{for};
  FLijnen[(FCap - 1)] := nil;

  FCount := FCount - 1;
end;

{ TDoubleList }

constructor TDoubleList.Create(ACapacity: Integer);
var
  i: Integer;
begin
  inherited Create;

  Assert(0 <= ACapacity, 'TDoubleList.Create.pre failed');

  SetLength(FDoubles, ACapacity);
  FCap := ACapacity;
  FCount := 0;

  for i := 0 to (FCap - 1) do begin
    FDoubles[i] := 0;
  end{for};
end;

function TDoubleList.Capacity: Integer;
begin
  Result := FCap;
end;

function TDoubleList.Count: Integer;
begin
  Result := FCount;
end;

function TDoubleList.Element(I: Integer): Double;
begin
  Assert((0 <= I) and (I < Count), 'TDoubleList.Lijn.pre failed');

  Result := FDoubles[I];
end;

procedure TDoubleList.Add(ADouble: Double);
begin
  Assert(Count < Capacity, 'TDoubleList.Add.pre failed');

  FDoubles[FCount] := ADouble;
  FCount := FCount + 1;
end;

procedure TDoubleList.Remove(var ADouble: Double);
var
  found: Boolean;
  i: Integer;
begin
  { Bestaat ADouble? }
  found := false;
  i := 0;
  while (i < FCount) and not found do begin
    if FDoubles[i] = ADouble then begin
      found := true;
    end
    else begin
      i := i + 1;
    end{if};
  end{while};

  Assert(found, 'TDoubleList.Remove.pre failed');
  {@ ADouble bestaat en heeft index i }

  for i := i to (FCap - 2) do begin
    FDoubles[i] := FDoubles[(i + 1)];
  end{for};
  FDoubles[(FCap - 1)] := 0;

  FCount := FCount - 1;
end;

procedure TDoubleList.Replace(APos: Integer; ADouble: Double);
begin
  Assert((0 <= APos) and (APos < Count), 'TDoubleList.Replace.pre failed');

  FDoubles[APos] := ADouble;
end;

end.
