unit BacktrackingOfzo;

interface

uses
  CurveRecon, Math, Dialogs, Classes, SysUtils;

type

{ Datatype voor de output van Backtracking: }
TBTOutput = record
  MinCost: Double;
  Solution: TPunten;
end{record};

function Backtracking(A, B: TPunten; MinCost: Double; Solution: TPunten): TBTOutput;
function Closed(P: TPunten): TPunten;
function Intersect(P: TPunten): Boolean;
function SubIntersect(A, B, C, D: TPunt): Boolean;
function GiveBestPoint(B: TPunten): TPunt;

implementation

function Backtracking(A, B: TPunten; MinCost: Double; Solution: TPunten): TBTOutput;
{ A = gehad, B = nog te doen }
var
  bt: TBTOutput;
  i: Integer;
begin
  if B.Count = 0 then begin
    {@ A is a complete solution }
    
    { A looks like [0, 1, 2, ... n, 0], A.Count = n + 2 }
    
    { Calculate MinCost for A }
    { We don't do the last point, hence we use "A.Count - 2" }
    MinCost := 0;
    for i := 0 to (A.Count - 2) do begin
      MinCost := MinCost + A.Punt(i).AfstandTot(A.Punt(i + 1));
    end{for};
    
    { Clear Solution }
    for i := 0 to (Solution.Count - 1) do begin
      Solution.Remove(0);
    end{for};
    {@ Solution = [] }
    
    { Put A in Solution }
    { Again, don't do the last point, because it's the starting point }
    for i := 0 to (A.Count - 2) do begin
      Solution.Add(A.Punt(i));
    end{for};
    {@ Solution = A, without the starting point duplicate at the end }
  end
  else begin
    {@ A is not a complete solution }
    
    MinCost := MaxInt;
    Solution := TPunten.Create;
    
    { For each choice C, do: }
    for i := 0 to (B.Count - 1) do begin
      { Add choice C }
      A.Add(B.Punt(i));
      B.Remove(i);
      
      { Is B empty now? If so, connect to starting point as well }
      if B.Count = 0 then begin
        A.Add(A.Punt(0));
      end{if};
      
      { Can this be an optimal solution? }
      if Intersect(A) then begin
        { Skip }
      end
      else begin
        {@ A could be an optimal solution }
        
        bt := Backtracking(A, B, MinCost, Solution);
        if bt.MinCost < MinCost then begin
          { bt.MinCost is beter }
          MinCost := bt.MinCost;
          Solution := bt.Solution;
        end{if};
        {@ Solution is optimaal }
      end{if};
      
      { Is B empty? If so, remove starting point again }
      if B.Count = 0 then begin
        A.Remove(A.Count - 1);
      end{if};
      
      { Undo choice C }
      B.Insert(i, A.Punt(A.Count - 1));
      A.Remove(A.Count - 1);
    end{for};
  end{if};
  
  Result.MinCost := MinCost;
  Result.Solution := Solution;
end;

function Closed(P: TPunten): TPunten;
var
  ls: Integer;
  A, Solution: TPunten;
  bt: TBTOutput;
begin
  A := TPunten.Create;

  { Zoek index van het lexicografisch kleinste punt }
  ls := LexicographicSmallest(P);

  { Stop beginpunt in A }
  A.Add(P.Punt(ls));
  P.Remove(ls);
  
  { Lege solution }
  Solution := TPunten.Create;
  
  bt := Backtracking(A, P, MaxInt, Solution);
  Result := bt.Solution;
  
  { TODO: Controleer de volgorde }
end;

function Intersect(P: TPunten): Boolean;
var
  i: Integer;
  A, B, C, D: TPunt;
begin
  Result := false;
  
  if P.Count > 2 then begin
    { Voor alle punten, minus laatste en één na laatste }
    for i := 0 to (P.Count - 3) do begin
      if SubIntersect(P.Punt(i), P.Punt(i + 1), 
                      P.Punt(P.Count - 2), P.Punt(P.Count - 1)
                      ) then begin
        Result := true;
      end{if};
    end{for};
  end{if};
end;

function SubIntersect(A, B, C, D: TPunt): Boolean;
var
  t, n, breuk: Double;
  E, F, G, P: TPunt;
begin
  E := TPunt.Create(B.X - A.X, B.Y - A.Y);
  F := TPunt.Create(D.X - C.X, D.Y - C.Y);
  G := TPunt.Create(A.X - C.X, A.Y - C.Y);
  P := TPunt.Create(-E.Y, E.X);
  
  t := (G.X * P.X) + (G.Y * P.Y);
  n := (F.X * P.X) + (F.Y * P.Y);
  
  if n <> 0 then begin
    breuk := t / n;
    Result := (0 < breuk) and (breuk < 1);
  end
  else begin
    Result := false;
  end;
end;

function GiveBestPoint(B: TPunten): TPunt;
var
  tempangle: Real;
  tempx, tempy: Real;
  hoofdhoek: Real;
  tussenhoek: Real;
  bestehoek: Real;
  beste: Integer;
  i: Integer;
  Str: String;
begin
    // Lijst minimaal 4 punten, anders trivial welk punt te pakken, of niet compleet
    Assert((B.Count < 4), 'BackTracking.GiveBestPoint.pre failed');

    // Berekenen van hoek tussen oude lijn
    tempx := B.Punt(1).X - B.Punt(0).X;
    tempy := B.Punt(1).Y - B.Punt(0).Y;

    tempangle := (tempy) / (tempx);
    hoofdhoek := (ArcTan (tempangle) /pi)*180;

    // eerste punt hoek berekenen
    tempx := B.Punt(2).X - B.Punt(1).X;
    tempy := B.Punt(2).Y - B.Punt(1).Y;
    if tempx <> 0 then begin
      tempangle := (tempy) / (tempx);
      bestehoek := (ArcTan (tempangle) /pi)*180;
    end
    else begin
      bestehoek := 0;
    end;
    Result := B.Punt(2);
    Beste := 3;
    ShowMessage('Hoek van punt 3 is ' + FloatToStr(bestehoek));

    for i := 3 to  B.Count - 1 do begin
      tempx := B.Punt(i).X - B.Punt(1).X;
      tempy := B.Punt(i).Y - B.Punt(1).Y;
      tempangle := (tempy) / (tempx);
      tussenhoek := (ArcTan (tempangle) /pi)*180;

      if (Abs(hoofdhoek - bestehoek)) > (Abs(hoofdhoek - tussenhoek)) then begin
        Result := B.Punt(i);
        Beste := i + 1;
        bestehoek := tussenhoek;
      end;

      Str := IntToStr(i + 1);
      ShowMessage('Hoek van punt ' + Str + ' is ' + FloatToStr(tussenhoek));

    end;
    Str := IntToStr(Beste);
    ShowMessage(' Beste punt is ' + Str );
end;

end.
