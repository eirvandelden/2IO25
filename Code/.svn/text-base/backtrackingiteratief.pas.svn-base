unit BacktrackingIteratief;

interface

uses
  CurveRecon, Math, Dialogs, Classes, SysUtils;

const
  NRijen = 100; { aantal Punten }
  NKolommen = 100; { aantal Punten }
  NElementen = 3; { aantal elementwaarden, >= 1 }

type

TRijIndex = 0 .. NRijen - 1; { rijnummers }
TKolomIndex = 0 .. NKolommen - 1; { kolomnummers }
TElement = -1 .. NElementen; { elementwaarden }
TMatrix = array [ TRijIndex, TKolomIndex ] of TElement;

{ Datatype voor de output van Backtracking: }
{TBTOutput = record
  MinCost: Double;
  Solution: TPunten;
end{record};}

function Backtracking(A, B: TPunten): TPunten;
function Closed(P: TPunten): TPunten;
function LexicographicSmallest(P: TPunten): Integer;
function Intersect(P: TPunten): Boolean;
function SubIntersect(A, B, C, D: TPunt): Boolean;
function GiveBestPoint(B: TPunten): TPunt;

implementation

function Backtracking(A, B: TPunten): TPunten;
{ A = gehad, B = nog te doen }
var
  i,j,k,l: Integer;
  Done: Boolean;
  Agenda: TMatrix;
  //x,y: TElement; {x plek van herkomst  y plek waar je naar toe gaat}
  //xp, yp: Integer; {xp punt van herkomst  yp punt waar je naartoe gaat}
  Element: TElement;
  Rijen,Kolommen: Integer;
begin
  Done := False;
  Rijen := A.Count + B.Count;
  Kolommen := Rijen;
  {Init matrix}
  for i := 0 to Rijen-1 do begin
    for j := 0 to Kolommen-1 do begin
      if (i = j) or (j=0) then begin
        Agenda[i,j] := 3;
      end
      else begin
        Agenda[i,j] := -1;
      end{if};
    end{for};
  end{for};

  {A[0] is het eerste punt  B heeft de andere punten}

  while (not Done) do begin

    while A.Count-1 <> B.Count do begin

      i := A.Count-1;
      if i > 0 then begin
        k := 0;
        while A.Punt(i) <> B.Punt(k) do begin
          k := k + 1;
        end{while};
        i := k + 1;
      end{if};
      j := 0;
      Element := 0;
      while (Element <> -1) and (j<Rijen-1) do begin
        j := j + 1;
        Element := Agenda[i,j];
      end{while};

      if Element = -1 then begin
        //kies dit element
        A.Add(B.Punt(j-1));
        if Intersect(A) then begin
          //punt intersect en mag dus niet meer gekozen worden
          A.Remove(A.Count-1);
          Agenda[i,j] := 0;
        end
        else begin
          //Punt is goedgekeurt geen intersecties
          Agenda[i,j] := 1;
          for k := 0 to Rijen-1 do begin
            if Agenda[k,i] = -1 then begin
              Agenda[k,i] := 2;
            end{if};
          end{for};
        end{if};
      end
      else begin
        //kan niks meer kiezen ga stap terug
        for k := 0 to Rijen-1 do begin
          if Agenda[i,k] = 0 then begin
            Agenda[i,k] := -1;
          end{if};
        end{for};
        l := i;
        A.Remove(A.Count-1);
        i := A.Count-1;
        if i <> 0 then begin
          k := 0;
          while A.Punt(i) <> B.Punt(k) do begin
            k := k + 1;
          end{while};
          i := k + 1; //i is nou het punt waar we naar terug moeten (rij)
        end{if};
        Agenda[i,l] := 0; //i mag l niet meer kiezen
        for k := 0 to Kolommen-1 do begin
          if Agenda[k,i] = 2 then begin
            Agenda[k,i] := -1;
          end{if};
        end{for};
      end{if};

    end{while};

    //A heeft nu alle punten
    //check nu of de lijn terug naar het begin punt niet intersect
    A.Add(A.Punt(0));
    if Intersect(A) then begin
      A.Remove(A.Count-1); //beginpunt weer weghalen
      l := i;
      A.Remove(A.Count-1);
      i := A.Count-1;
      if i <> 0 then begin
        k := 0;
        while A.Punt(i) <> B.Punt(k) do begin
          k := k + 1;
        end{while};
        i := k + 1; //i is nou het punt waar we naar terug moeten (rij)
      end{if};
      Agenda[i,l] := 0; //i mag l niet meer kiezen
      for k := 0 to Kolommen-1 do begin
        if Agenda[k,i] = 2 then begin
          Agenda[k,i] := -1;
        end{if};
      end{for};
    end
    else begin
    //goede oplossing
      A.Remove(A.Count-1);
      Done := True;
    end{else};

  end{while};

Result := A;
end;

function Closed(P: TPunten): TPunten;
var
  ls,i: Integer;
  A, Solution: TPunten;
begin
  A := TPunten.Create;

  { Zoek index van het lexicografisch kleinste punt }
  ls := LexicographicSmallest(P);

  { Stop beginpunt in A }
  A.Add(P.Punt(ls));
  P.Remove(ls);
  
  { Lege solution }
  Solution := TPunten.Create;
  
  Solution := Backtracking(A, P);

  { TODO: Controleer de volgorde }
  if Solution.Punt(1).X < Solution.Punt(Solution.Count-1).X then begin
  //goede volgorde niks veranderen
  end
  else if Solution.Punt(1).X = Solution.Punt(Solution.Count-1).X then begin
    if Solution.Punt(1).Y < Solution.Punt(Solution.Count-1).Y then begin
      //goed volgorde
    end
    else begin
      //slechte volgorde
      for i := 1 to (Ceil((Solution.Count)/2)-1) do begin
        Solution.Swap(i,Solution.Count-i);
      end{for};
    end{if};
  end
  else begin
   //slechte volgorde
   for i := 1 to (Ceil((Solution.Count)/2)-1) do begin
        Solution.Swap(i,Solution.Count-i);
   end{for};
  end;


  Result := Solution;
end;

function LexicographicSmallest(P: TPunten): Integer;
var
  i: Integer;
  punt: TPunt;
begin
  { Garandeer dat er een beter punt gevonden wordt }
  punt := TPunt.Create(MaxInt, MaxInt);

  { Ga alle punten langs }
  for i := 0 to (P.Count - 1) do begin
    if P.Punt(i).X < punt.X then begin
      {@ De X is kleiner }
      punt := P.Punt(i);
      Result := i;
    end
    else if P.Punt(i).X = punt.X then begin
      if P.Punt(i).Y < punt.Y then begin
        {@ De X is gelijk, maar de Y is kleiner }
        punt := P.Punt(i);
        Result := i;
      end{if};
    end{if};
  end{for};
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
