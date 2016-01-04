unit UpTo5;

// OGO 2.1 2009/2010
// Groep 3

interface

uses
  Classes, SysUtils, CurveRecon, ImprovedNearestNeighbor2;

type
  TPuntenArray = array of TPunten;

function UpTo5Sort(APunten: TPunten): TPuntenArray;
function UpTo5SortSub(APunten: TPunten): TPunten;

implementation //===============================================================

function UpTo5Sort(APunten: TPunten): TPuntenArray;
var
  i, j, z: Integer;
  p, q: TPunt;
  kleinste: Integer;
  kleinsteaantal: Integer;
  dichtstebij: Integer;
  dichtstebijafstand, c, d: Double;
begin
  i := 1;

  while APunten.Count > 0 do begin
    SetLength(Result, i);
    
    Result[i - 1] := UpTo5SortSub(APunten);
    
    for j := 0 to (Result[i - 1].Count - 1) do begin
      p := Result[i - 1].Punt(j);
      APunten.Remove(p);
    end{for};
    
    i := i + 1;
  end{while};

  {@ Result bevat alle gevonden closed curves }

  while Length(Result) > 5 do begin
    { vind de kleinste curve }
    kleinste := 0;
    kleinsteaantal := Result[0].Count;
    for i := 1 to (Length(Result) - 1) do begin
      if Result[i].Count < kleinsteaantal then begin
        kleinste := i;
        kleinsteaantal := Result[i].Count;
      end{if};
    end{for};

    p := Result[kleinste].Punt(0);

    { doe nearest neighbor naar elke curve }
    dichtstebij := kleinste;
    dichtstebijafstand := MaxInt;
    for i := 0 to (Length(Result) - 1) do begin
      if i <> kleinste then begin
        d := MaxInt;
        q := p;
        for j := 0 to (Result[i].Count - 1) do begin
          c := p.AfstandTot(Result[i].Punt(j));
          if (c < d) then begin
            d := c;
            q := Result[i].Punt(j);
          end{if};
        end{for};

        if d < dichtstebijafstand then begin
          dichtstebij := i;
          dichtstebijafstand := d;
        end{if};
      end{if};
    end{for};

    { insert kleine curve in nearest curve }
    Result[dichtstebij] := InsertLostPoints(Result[kleinste], Result[dichtstebij]);

    { verwijder kleinste uit array }
    for i := kleinste to (Length(Result) - 2) do begin
      Result[i] := Result[i + 1];
    end{for};
    SetLength(Result, Length(Result) - 1);
  end{while};
  
  {@ Result bevat een array van closed curves, maximaal 5 }
end;

function UpTo5SortSub(APunten: TPunten): TPunten;
var
  rest: TPunten;
  beginpunt, p, q: TPunt;
  i, j, ls: Integer;
  c, d: Double;
  loopcount: Integer;
  toegevoegd: Boolean;
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
  toegevoegd := false;

  { loop }
  repeat begin
    loopcount := loopcount + 1;

    { verwijder p als keuze }
    rest.Remove(p);

    { voeg het beginpunt weer toe }
    if ((loopcount = 8) or (rest.Count = 0)) and not toegevoegd then begin
      rest.Add(beginpunt);
      toegevoegd := true;
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
end;

end.

