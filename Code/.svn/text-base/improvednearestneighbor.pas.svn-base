unit ImprovedNearestNeighbor;

// OGO 2.1 2009/2010
// Groep 3

interface

uses
  Classes, SysUtils, CurveRecon, Math;

function InsertLostPoints(lps: TPunten; Solution: TPunten): TPunten;
function ImprovedNearestNeighborSort(APunten: TPunten): TPunten;

implementation //===============================================================

function InsertLostPoints(lps: TPunten; Solution: TPunten): TPunten;
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

    c := lp.AfstandTot(Solution.Punt(j-1));
    d := lp.AfstandTot(Solution.Punt(j+1));

    if c <= d then begin
      Solution.Insert(j,lp);
    end{if}
    else begin
      Solution.Insert(j+1,lp);
    end{else};

  end{for};

  Result := TPunten.Create;
  Result := Solution;
end;

function ImprovedNearestNeighborSort(APunten: TPunten): TPunten;
var
  rest: TPunten;
  beginpunt, p, q: TPunt;
  i, j, ls: Integer;
  c, d: Double;
  loopcount: Integer;
begin
  Result := TPunten.Create;

  { kopieer punten }
  rest := TPunten.Create;
  for i := 0 to (APunten.Count - 1) do begin
    rest.Add(APunten.Punt(i));
  end{for};

  { index lexicografisch kleinste }
  ls := LexicographicSmallest(rest);

  { beginpunt }
  p := rest.Punt(ls);
  Result.Add(p);

  beginpunt := p;
  loopcount := 0;

  { loop }
  repeat begin
    loopcount := loopcount + 1;

    { verwijder p als keuze }
    rest.Remove(p);

    { voeg het beginpunt weer toe }
    if loopcount = 5 then begin
      rest.Add(beginpunt);
    end{if};

    { zoek punt dichtste bij p }
    d := MaxInt;
    q := p;
    for j := 0 to (rest.Count - 1) do begin
      c := p.AfstandTot(rest.Punt(j));
      if (c < d) then begin
        d := c;
        q := rest.Punt(j);
      end{if};
    end{for};

    { voeg q toe aan uitkomst }
    if q <> beginpunt then begin
      Result.Add(q);
    end{if};

    { ga verder vanuit q }
    p := q;
  end
  until p = beginpunt;

  { verwijder p }
  rest.Remove(p);

  {@ Result bevat een closed curve van het beginpunt naar zichzelf }
  if rest.Count > 0 then begin
    Result := InsertLostPoints(rest,Result);
  end;
end;

end.

