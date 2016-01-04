unit NearestNeighbor;

// OGO 2.1 2009/2010
// Groep 3

interface

uses
  Classes, SysUtils, CurveRecon;

function NearestNeighborSort(APunten: TPunten): TPunten;

implementation //===============================================================

function NearestNeighborSort(APunten: TPunten): TPunten;
var
  rest: TPunten;
  p, q: TPunt;
  i, j, ls: Integer;
  c, d: Double;
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

  { loop }
  for i := 0 to (rest.Count - 2) do begin
    { verwijder p als keuze }
    rest.Remove(p);

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
    Result.Add(q);

    { ga verder vanuit q }
    p := q;
  end{for};

  {@ Result bevat de punten in goede volgorde }
end;

end.

