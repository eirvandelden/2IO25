unit ImprovedNearestNeighbor2;

// OGO 2.1 2009/2010
// Groep 3

interface

uses
  Classes, SysUtils, CurveRecon, Math, Dialogs, NearestNeighbor;

function InsertLostPoints(lps: TPunten; Solution: TPunten): TPunten;
function ImprovedNearestNeighborSort(APunten: TPunten): TPunten;
function MakeOpenCurve(APunten: TPunten): TPunten;

implementation //===============================================================

function MakeOpenCurve(APunten: TPunten): TPunten;
var
  i, lp, ls: integer;          // lp = longest point, ls= lexicographic smallest
  distance, ldistance: Double; // distance = possible longest distance,
                               // ldistance = current longest distance
begin
  // find longest edge
  ldistance := 0;
  for i := 0 to (APunten.Count - 1) do begin
    if i < (APunten.Count - 1) then begin
      distance := APunten.Punt(i).AfstandTot(APunten.Punt(i + 1));
    end
    else begin
      distance := APunten.Punt(i).AfstandTot(APunten.Punt(0));
    end{if};

    if ldistance < distance then begin
      ldistance := distance;
      lp := i;
    end;
  end{for};
  // lp is now the starting point of the longest edge

  Result := TPunten.Create;
  if lp = (APunten.Count - 1) then begin
    // answer is already correct
    Result := APunten;
  end
  else begin
    // determine lexicographic smallest of the edge
    Result.Add(APunten.Punt(lp));
    Result.Add(APunten.Punt(lp + 1));
    ls := LexicographicSmallest(Result);

    Result.Destroy;
    Result := TPunten.Create;

    if ls = 0 then begin
      ls := lp;

      for i := ls downto 0 do begin
        Result.Add(APunten.Punt(i));
      end{for};

      for i := (APunten.Count - 1) downto (ls + 1) do begin
        Result.Add(APunten.Punt(i));
      end{for};
    end
    else begin
      ls := lp + 1;

      for i := ls to (APunten.Count - 1) do begin
        Result.Add(APunten.Punt(i));
      end{for};

      for i := 0 to (ls - 1) do begin
        Result.Add(APunten.Punt(i));
      end{for};
    end{if};
  end{if};
end;

function InsertLostPoints(lps: TPunten; Solution: TPunten): TPunten;
var
  p, lp: TPunt;
  i, j, k: Integer;
  c, d: Double;
begin
  if lps.Count <> 0 then begin
    lps := NearestNeighborSort(lps);

    for k := 0 to lps.Count-1 do begin
      lp := lps.Punt(k);
      d := MaxInt;
      for i := 0 to (Solution.Count - 1) do begin
        c := lp.AfstandTot(Solution.Punt(i));
        if (c <= d) then begin
          d := c;
          j := i;
        end{if};
      end{for};
      {@ j is now the index of the NN of lp }

      if j = 0 then begin
        c := lp.AfstandTot(Solution.Punt(Solution.Count - 1));
      end
      else begin
        c := lp.AfstandTot(Solution.Punt(j - 1));
      end{if};

      if j = Solution.Count-1 then begin
        d := lp.AfstandTot(Solution.Punt(0));
      end
      else begin
        d := lp.AfstandTot(Solution.Punt(j + 1));
      end{if};

      if c <= d then begin
        Solution.Insert(j,lp);
      end
      else begin
        Solution.Insert(j+1,lp);
      end{if};
    end{for};

    Result := TPunten.Create;
    Result := Solution;
  end{if};
end;

function ImprovedNearestNeighborSort(APunten: TPunten): TPunten;
var
  rest: TPunten;
  beginpunt, p, q: TPunt;
  i, j, k, ls: Integer;
  c, d: Double;
  loopcount, aantalp: Integer;
begin
  { doe het algoritme twee keer; betere resultaten }
  for k := 0 to 1 do begin
    if k = 1 then begin
      APunten := MakeOpenCurve(APunten);
    end{if};

    Result := TPunten.Create;
    aantalp := Floor(APunten.Count / 5);
    { kopieer punten }
    rest := TPunten.Create;
    for i := 0 to (APunten.Count - 1) do begin
      rest.Add(APunten.Punt(i));
    end{for};

    { beginpunt = lexicografisch kleinste }
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
      if loopcount = aantalp then begin
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

    APunten := Result;
  end{for};
end;

end.

