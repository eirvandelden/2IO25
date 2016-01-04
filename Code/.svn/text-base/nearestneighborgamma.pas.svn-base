unit NearestNeighborGamma;

// OGO 2.1 2009/2010
// Groep 3

interface

uses
  Classes, SysUtils, Math, CurveRecon;

function NearestNeighborGammaSort(APunten: TPunten): TPunten;
function GiveBestPointGamma(B: TPunten): TPunt;
function FindNearestNeighbors(APunten: TPunten; APunt: TPunt; AMax: Integer): TPunten;

implementation //===============================================================

function NearestNeighborGammaSort(APunten: TPunten): TPunten;
var
  rest, mogelijk: TPunten;
  p, q: TPunt;
  i, j, ls: Integer;
  c, d: Double;
  skip: Boolean;
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

    skip := false;

    if Result.Count >= 2 then begin
      skip := true;

      { vind punten (met een handige functie!) }
      mogelijk := FindNearestNeighbors(rest, p, 3);

      if mogelijk.Count = 1 then begin
        { 1 punt in de range, pak 'm! }
        q := mogelijk.Punt(0);
      end
      else begin
        { de punten waar je vandaan komt (reverse order, omdat je insert) }
        mogelijk.Insert(0, Result.Punt(Result.Count - 1));
        mogelijk.Insert(0, Result.Punt(Result.Count - 2));

        { kies q met de richtingfunctie }
        q := GiveBestPointGamma(mogelijk);
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
    Result.Add(q);

    { ga verder vanuit q }
    p := q;
  end{for};

  {@ Result bevat de punten in goede volgorde }
end;

function GiveBestPointGamma(B: TPunten): TPunt;
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

    if tempx <> 0 then begin
      tempangle := (tempy) / (tempx);
      hoofdhoek := (ArcTan (tempangle) /pi)*180;
    end
    else begin
      hoofdhoek := 0;
    end;

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
    //ShowMessage('Hoek van punt 3 is ' + FloatToStr(bestehoek));

    for i := 3 to  B.Count - 1 do begin
      tempx := B.Punt(i).X - B.Punt(1).X;
      tempy := B.Punt(i).Y - B.Punt(1).Y;
      if tempx <> 0 then begin
        tempangle := (tempy) / (tempx);
        tussenhoek := (ArcTan (tempangle) /pi)*180;
      end
      else begin
        tussenhoek := 0;
      end;

      if (Abs(hoofdhoek - bestehoek)) > (Abs(hoofdhoek - tussenhoek)) then begin
        Result := B.Punt(i);
        Beste := i + 1;
        bestehoek := tussenhoek;
      end;

      Str := IntToStr(i + 1);
      //ShowMessage('Hoek van punt ' + Str + ' is ' + FloatToStr(tussenhoek));

    end;
    Str := IntToStr(Beste);
    //ShowMessage(' Beste punt is ' + Str );
end;

function FindNearestNeighbors(APunten: TPunten; APunt: TPunt; AMax: Integer): TPunten;
var
  i, j: Integer;
  kandidaten: TPunten;
begin
  kandidaten := TPunten.Create;
  kandidaten.Add(APunten.Punt(0));

  { zoek punten binnen range d }
  for i := 1 to (APunten.Count - 1) do begin
    for j := 0 to Min((AMax - 1), (kandidaten.Count - 1)) do begin
      if (APunt.AfstandTot(APunten.Punt(i)) < APunt.AfstandTot(kandidaten.Punt(j))) then begin
        kandidaten.Insert(j, APunten.Punt(i));
        break;
      end{if};
    end{if};
  end{for};

  Result := TPunten.Create;

  { pak [0..AMax] (of minder, als er minder zijn) uit kandidaten, en zet in Result }
  for i := 0 to Min((AMax - 1), (kandidaten.Count - 1)) do begin
    Result.Add(kandidaten.Punt(i));
  end{for};

  {@ Result bevat alle punten uit APunten, binnen range ARange vanuit APunt }
end;

end.

