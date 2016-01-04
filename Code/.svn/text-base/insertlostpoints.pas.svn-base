unit insertlostpoints;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

implementation

function InsertLostPoints(lps: Punten; Solution: Punten): Punten;
var
  p, lp: TPunt;
  i, j, k: Integer;
  c, d: Double;
begin
  for k := 0 to lps.Count-1 do begin
    lp := lps.Punt(k);
    d := MaxInt;
    for i := 0 to (Solution.Count - 1) do begin
      c := lp.AfstandTot(Solution.Punt(i));
      if (c < d) then begin
        d := c;
        j := i;
      end{if};
    end{for};
    //j is now the index of the NN of lp

    c := lp.AfstandTot(Solution.Punt(j-1);
    d := lp.AfstandTot(Solution.Punt(j+1);

    if c <= d then begin
      Solution.Insert(j,lp);
    end{if}
    else begin
      Solution.Insert(j+1,lp);
    end{else};

  end{for};

Result := Punten.Create;
Result := Solution;
end;

function GetRidOfIntersections (P:Punten): Punten;
var
  S: TPunten;
  Intersecting: sect;
  i, j, k, l, m: integer;
  done: Boolean;
begin
  //find intersections
  P.Add(P.Punt(0));
  S := TPunten.Create;
  S.Add(P.Punt(0));
  S.Add(P.Punt(1));
  S.Add(P.Punt(2));
  for i := 3 to P.Count-1 do begin
    S.Add(P.Punt(i));
   // while not done do begin
    //  done := True;
      Setlength(Intersecting, 2);
      Intersecting := Intersect(S);
      j := 0;
      while Intersecting[j] <> 0 do begin
      //remove intersection by swapping 2 points
      //  done := False;
        l := Intersecting[j];
        m := Intersecting[j+1];
        for k := 0 to Floor((m - l)/2) do begin
          P.Swap(l, m);
          m := m - 1;
          l := l + 1;
        end{for};
        j := j + 2;
      end{while};
      Setlength(Intersecting, 0);
    //end{while};
  end{for};
  P.Remove(P.Count-1);
  Result := TPunten.Create;
  Result := P;
end;

function Intersect(P: TPunten): array of Integer;
var
  i, j: Integer;
 // A, B, C, D: TPunt;
begin
  Setlength(Result, P.Count);
  if P.Count > 2 then begin
    { Voor alle punten, minus laatste en één na laatste }
    j := 0;
    i := P.Count;
    for i := 0 to (P.Count - 3) do begin
      if SubIntersect(P.Punt(i), P.Punt(i + 1),
                      P.Punt(P.Count - 2), P.Punt(P.Count - 1)
                      ) then begin
        Result[j] := i + 1;
        Result[j+1] := P.Count - 2;
        Break; //break for loop
        //break is possible because only one intersection is possible
      end{if};
    end{for};
  end{if};
end;

function SubIntersect(A, B, C, D: TPunt): Boolean;
var
  a1, a2, b1, b2, interx, intery: Double;
begin
  a1 := (B.Y-A.Y)/(B.X-A.X);
  a2 := (D.Y-C.Y)/(D.X-C.X);

  if (a1 - a2) = 0 then begin
   Result := False;
  end
  else begin

    b1 := (a1*(-1*(A.X)) + A.Y;
    b2 := (a2*(-1*(C.X)) + C.Y;

    interx := (b2 - b1)/(a1 - a2);
    intery := (a1*interx) + b1;

    if (A.X < interx) and (A.Y < intery) and (B.X > interx) and (B.Y > intery) then begin
      Result := True;
    end
    else begin
      Result := False;
    end;

  end;
end;

end.

