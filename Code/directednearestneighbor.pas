unit DirectedNearestNeighbor;

// OGO 2.1 2009/2010
// Groep 3

interface

uses
  Classes, SysUtils, Math, CurveRecon, Dialogs, ImprovedNearestNeighbor2;

function DirectedNearestNeighborSort(APunten: TPunten): TPunten;
function GiveBestPoint(B: TPunten): TPunt;
function FindPointsInRange(APunten: TPunten; APunt: TPunt; ARange: Double): TPunten;
procedure SetAlpha(AAlpha: Double);
function HoekUitZijden(tempx, tempy: Real): Real;

var
  FAlpha: Double;

implementation //===============================================================

function DirectedNearestNeighborSort(APunten: TPunten): TPunten;
var
  rest, mogelijk: TPunten;
  p, q, beginpunt: TPunt;
  i, j, ls: Integer;
  c, d: Double;
  skip: Boolean;
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
  toegevoegd := false;
  loopcount := 0;

  { loop }
  repeat begin
    loopcount := loopcount + 1;

    { verwijder p als keuze }
    rest.Remove(p);

    { voeg het beginpunt weer toe }
    if ((loopcount = 7) or (rest.Count = 0)) and not toegevoegd then begin
      rest.Add(beginpunt);
      toegevoegd := true;
    end{if};

    skip := false;

    if Result.Count >= 2 then begin
      skip := true;

      { maak range d }
      d := FAlpha * Result.Punt(Result.Count - 2).AfstandTot(Result.Punt(Result.Count - 1));

      { vind punten in range d (met een handige functie!) }
      mogelijk := FindPointsInRange(rest, p, d);

      if mogelijk.Count = 0 then begin
        { we hebben geen punten binnen de range, doe alsnog nearest neighbor }
        skip := false;
      end
      else if mogelijk.Count = 1 then begin
        { 1 punt in de range, pak 'm! }
        q := mogelijk.Punt(0);
      end
      else begin
        { de punten waar je vandaan komt (reverse order, omdat je insert) }
        mogelijk.Insert(0, Result.Punt(Result.Count - 1));
        mogelijk.Insert(0, Result.Punt(Result.Count - 2));

        { kies q met de richtingfunctie }
        q := GiveBestPoint(mogelijk);
      end{if};
    end{if};

    if not skip then begin
      { nog geen richting, gebruik standaard nearest neighbor }
      d := MaxInt;
      q := p;
      for j := 0 to (rest.Count - 1) do begin
        c := p.AfstandTot(rest.Punt(j));
        if (c < d) then begin
          d := c;
          q := rest.Punt(j);
        end{if};
      end{for};
    end{if};

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

  if rest.Count > 0 then begin
    Result := InsertLostPoints(rest,Result);
  end;

  {@ Result bevat de punten in goede volgorde }
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
    // lijst minimaal 4 punten, anders trivial welk punt te pakken, of niet compleet
    Assert(B.Count >= 4, 'DirectedNearestNeighbor.GiveBestPoint.pre failed');

    // berekenen van hoek tussen oude lijn
    tempx := B.Punt(1).X - B.Punt(0).X;
    tempy := B.Punt(1).Y - B.Punt(0).Y;

    hoofdhoek := HoekUitZijden(tempx, tempy);

    // eerste punt hoek berekenen
    tempx := B.Punt(2).X - B.Punt(1).X;
    tempy := B.Punt(2).Y - B.Punt(1).Y;

    bestehoek := HoekUitZijden(tempx, tempy);

    Result := B.Punt(2);
    Beste := 3;

    for i := 3 to  B.Count - 1 do begin
      tempx := B.Punt(i).X - B.Punt(1).X;
      tempy := B.Punt(i).Y - B.Punt(1).Y;

      tussenhoek := HoekUitZijden(tempx, tempy);

      if (Abs(hoofdhoek - bestehoek)) > (Abs(hoofdhoek - tussenhoek)) then begin
        Result := B.Punt(i);
        Beste := i + 1;
        bestehoek := tussenhoek;
      end;
    end;
end;

function FindPointsInRange(APunten: TPunten; APunt: TPunt; ARange: Double): TPunten;
var
  i: Integer;
begin
  Result := TPunten.Create;

  { zoek punten binnen range d }
  for i := 0 to (APunten.Count - 1) do begin
    if (APunt.AfstandTot(APunten.Punt(i)) <= ARange) then begin
      Result.Add(APunten.Punt(i));
    end{if};
  end{for};

  {@ Result bevat alle punten uit APunten, binnen range ARange vanuit APunt }
end;

procedure SetAlpha(AAlpha: Double);
begin
  FAlpha := AAlpha;
end;

function HoekUitZijden(tempx, tempy: Real): Real;
var
  tempangle: Real;
begin
  if tempx <> 0 then begin
    if tempy <> 0 then begin
      tempangle := (tempy / tempx);
      Result := (ArcTan(tempangle) / pi) * 180;

      if tempx < 0 then begin
        if tempy < 0 then begin
          Result := Result - 180;
        end
        else begin
          Result := Result + 180;
        end{if};
      end{if};
    end
    else begin
      if tempx < 0 then begin
        Result := 180;
      end
      else begin
        Result := 0;
      end{if};
    end{if};
  end
  else begin
    if tempy < 0 then begin
      Result := -90;
    end
    else begin
      Result := 90;
    end{if};
  end{if};
end;

end.

