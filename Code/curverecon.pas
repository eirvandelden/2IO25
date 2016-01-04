unit CurveRecon;

// OGO 2.1 2009/2010
// Groep 3

{$MODE Delphi}

interface

type

  { TPunt }

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
    function HoekMet(APunt: TPunt): Double;
    // pre: APunt <> (FX,FY)
    // ret: hoek in graden tussen (FX,FY) en (APunt.X,APunt.Y)
    //      (ten opzichte van de x-as)
  end;
  
  { TPunten }

  TPunten =
  class(TObject)
  private
    FPunten: array of TPunt;
    FCap: Integer;
    FCount: Integer;
    
    procedure DoubleCap;
    // pre: true
    // post: FCap' = 'FCap * 2

    // invariants
    // 0 <= FCount <= FCap
    // FCount = |FPunten|
  public
    // construction
    constructor Create; overload;
    constructor Create(ACapacity: Integer); overload;
    // pre: true
    // post: FPunten = []
    
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
    function Minimum(Y: Boolean): Double;
    // pre: Count > 0
    // ret: als Y, dan:
    //        Y zodat voor alle p: TPunt in FPunten geldt Y <= p.Y
    //      anders:
    //        X ..                                     .. X <= p.X
    function Maximum(Y: Boolean): Double;
    // pre: Count > 0
    // ret: als Y, dan:
    //        Y zodat voor alle p: TPunt in FPunten geldt Y >= p.Y
    //      anders:
    //        X ..                                     .. X >= p.X
    
    // commands
    procedure Add(APunt: TPunt);
    // pre: true
    // post: FPunten' = 'FPunten ++ [APunt]
    procedure Remove(var APunt: TPunt); overload;
    // pre: 'FPunten = FPuntenSub ++ [APunt]
    // post: FPunten' = FPuntenSub
    procedure Insert(APos: Integer; APunt: TPunt);
    // pre: 0 <= APos < Count
    // post: FPunten' = 'FPunten[0..APos) ++ [APunt] ++ 'FPunten[APos..Count)
    procedure Swap(APosA, APosB: Integer);
    // pre: 0 <= APosA < Count /\ 0 <= APosB < Count
    // post: FPunten'[APosA] = 'FPunten[APosB] /\ FPunten'[APosB] = 'FPunten[APosA]
    procedure Remove(APos: Integer); overload;
    // pre: 0 <= APos < Count /\ 'FPunten = FPuntenSub ++ [FPunten[APos]]
    // post: FPunten' = FPuntenSub
    procedure Output;
    // pre: true
  end;
  
  { TLijn }

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

    procedure DoubleCap;
    // pre: true
    // post: FCap' = 'FCap * 2

    // invariants
    // 0 <= FCount <= FCap
    // FCount = |FLijnen|
  public
    // construction
    constructor Create; overload;
    constructor Create(ACapacity: Integer); overload;
    // pre: true
    // post: FPunten = []

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
    // pre: true
    // post: FLijnen' = 'FLijnen ++ [ALijn]
    procedure Remove(var ALijn: TLijn);
    // pre: 'FLijnen = FLijnenSub ++ [ALijn]
    // post: FLijnen' = FLijnenSub
  end;

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

function LexicographicSmallest(P: TPunten): Integer;
// pre: P is niet leeg
// ret: lexicografisch kleinste punt in P
  
implementation //===============================================================

uses
  Math, SysUtils;

function LexicographicSmallest(P: TPunten): Integer;
var
  i: Integer;
  punt: TPunt;
begin
  Assert(P.Count >= 1, 'LexicographicSmallest.pre failed');

  { garandeer dat er een beter punt gevonden wordt }
  punt := TPunt.Create(MaxInt, MaxInt);

  { ga alle punten langs }
  for i := 0 to (P.Count - 1) do begin
    if P.Punt(i).X < punt.X then begin
      {@ de X is kleiner }
      punt := P.Punt(i);
      Result := i;
    end
    else if P.Punt(i).X = punt.X then begin
      if P.Punt(i).Y < punt.Y then begin
        {@ de X is gelijk, maar de Y is kleiner }
        punt := P.Punt(i);
        Result := i;
      end{if};
    end{if};
  end{for};
end;

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

function TPunt.HoekMet(APunt: TPunt): Double;
var
  o, a: Double;
begin
  Assert((APunt.X <> FX) or (APunt.Y <> FY), 'TPunt.HoekMet.pre failed');

  o := APunt.Y - FY;
  a := APunt.X - FX;

  if (a = 0) then begin
    Result := 90;
  end
  else begin
    Result := Abs(ArcTan(o/a));
    Result := (Result / PI) * 180;
  end{if};
end;

{ TPunten }

procedure TPunten.DoubleCap;
var
  i, oldCap: Integer;
begin
  oldCap := FCap;
  FCap := FCap * 2;

  SetLength(FPunten, FCap);

  for i := oldCap to (FCap - 1) do begin
    FPunten[i] := nil;
  end{for};
end;

constructor TPunten.Create;
begin
  Create(10);
end;

constructor TPunten.Create(ACapacity: Integer);
var
  i: Integer;
begin
  inherited Create;
  
  Assert(0 <= ACapacity, 'TPunten.Create.pre failed');

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

function TPunten.Minimum(Y: Boolean): Double;
var
  i: Integer;
begin
  Result := MaxInt;

  for i := 0 to (FCount - 1) do begin
    if Y then begin
      if FPunten[i].FY < Result then begin
        Result := FPunten[i].FY;
      end{if};
    end
    else begin
      if FPunten[i].FX < Result then begin
        Result := FPunten[i].FX;
      end{if};
    end{if};
  end{for};
end;

function TPunten.Maximum(Y: Boolean): Double;
var
  i: Integer;
begin
  Result := 0;

  for i := 0 to (FCount - 1) do begin
    if Y then begin
      if FPunten[i].FY > Result then begin
        Result := FPunten[i].FY;
      end{if};
    end
    else begin
      if FPunten[i].FX > Result then begin
        Result := FPunten[i].FX;
      end{if};
    end{if};
  end{for};
end;

procedure TPunten.Add(APunt: TPunt);
begin
  if (Count = Capacity) then begin
    DoubleCap;
  end{if};

  //Assert(Count < Capacity, 'TPunten.Add.pre failed');
  
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

procedure TPunten.Insert(APos: Integer; APunt: TPunt);
var
  i: Integer;
begin
  if (Count = Capacity) then begin
    DoubleCap;
  end{if};

  //Assert(Count < Capacity, 'TPunten.Insert.pre failed');
  Assert((0 <= APos) and (APos < Count), 'TPunten.Insert.pre failed');

  for i := (FCount - 1) downto APos do begin
    FPunten[i + 1] := FPunten[i];
  end{for};

  FPunten[APos] := APunt;
  FCount := FCount + 1;
end;

procedure TPunten.Swap(APosA, APosB: Integer);
var
  tmp: TPunt;
begin
  Assert((0 <= APosA) and (APosA < Count), 'TPunten.Swap.pre failed');
  Assert((0 <= APosB) and (APosB < Count), 'TPunten.Swap.pre failed');

  tmp := FPunten[APosA];
  FPunten[APosA] := FPunten[APosB];
  FPunten[APosB] := tmp;
end;

procedure TPunten.Remove(APos: Integer);
var
  i: Integer;
begin
  Assert((0 <= APos) and (APos < Count), 'TPunten.Remove.pre failed');
  {@ APunt bestaat en heeft index APos }

  for i := APos to (FCap - 2) do begin
    FPunten[i] := FPunten[(i + 1)];
  end{for};
  FPunten[(FCap - 1)] := nil;

  FCount := FCount - 1;
end;

procedure TPunten.Output;
var
  i: Integer;
  s, sx, sy: String;
begin
  // this function is for debugging only
  {
  Str(FCount, s);
  ShowMessage('Aantal punten: ' + s);

  for i := 0 to (Count - 1) do begin
    Str(i, s);
    Str(FPunten[i].X, sx);
    Str(FPunten[i].Y, sy);

    ShowMessage('Punt ' + s + ': (' + sx + ',' + sy + ')');
  end;
  }
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

procedure TLijnen.DoubleCap;
var
  i, oldCap: Integer;
begin
  oldCap := FCap;
  FCap := FCap * 2;

  SetLength(FLijnen, FCap);

  for i := oldCap to (FCap - 1) do begin
    FLijnen[i] := nil;
  end{for};
end;

constructor TLijnen.Create;
begin
  Create(10);
end;

constructor TLijnen.Create(ACapacity: Integer);
var
  i: Integer;
begin
  inherited Create;

  Assert(0 <= ACapacity, 'TLijnen.Create.pre failed');

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
  if (Count = Capacity) then begin
    DoubleCap;
  end{if};

  //Assert(Count < Capacity, 'TLijnen.Add.pre failed');

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
