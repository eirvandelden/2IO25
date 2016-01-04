program CurveReconIO;

// OGO 2.1 2009/2010
// Groep 3

uses SysUtils, CurveRecon, NearestNeighbor, DirectedNearestNeighbor, UpTo5,
  ImprovedNearestNeighbor2;

const
  CDecimalen = 8;

procedure OutputPuntenLijst(FPunten: TPunten);
var
  i: Integer;
begin
  Write(FPunten.Count);
  WriteLn(' number of points');
  for i := 0 to (FPunten.Count - 1) do begin
    Write(FPunten.Punt(i).X:0:CDecimalen);
    Write(' ');
    WriteLn(FPunten.Punt(i).Y:0:CDecimalen);
  end{for};
end;

function CheckVolgorde(FPunten: TPunten): TPunten;
var
  i: Integer;
  reverse: Boolean;
begin
  // Aangenomen is dat het eerste punt het lexicografisch kleinste is.
  // Deze functie zorgt ervoor dat het tweede punt lexicografisch
  // kleiner is dan het laatste punt. (de twee buren van het eerste punt)

  { check volgorde }
  reverse := false;
  if FPunten.Count > 3 then begin
    if FPunten.Punt(1).X = FPunten.Punt(FPunten.Count - 1).X then begin
      reverse := (FPunten.Punt(1).Y > FPunten.Punt(FPunten.Count - 1).Y);
    end
    else begin
      reverse := (FPunten.Punt(1).X > FPunten.Punt(FPunten.Count - 1).X);
    end{if};
  end{if};

  { moeten we de volgorde omdraaien? }
  if reverse then begin
    Result := TPunten.Create;
    Result.Add(FPunten.Punt(0));
    for i := (FPunten.Count - 1) downto 1 do begin
      Result.Add(FPunten.Punt(i));
    end{for};
  end
  else begin
    Result := FPunten;
  end{if};
end;

//==============================================================================

var
  { curve informatie:  }
  FMethode:     String;
  FPunten:      TPunten;
  FPuntenArray: TPuntenArray; // alleen voor uptofive
  { punt informatie:   }
  x, y:         Double;
  { inlees variabelen: }
  FIn, FX, FY:  String;
  FTmp:         Char;
  FNum:         Integer;
  { overige:           }
  i:            Integer;
begin
  { lees methode }
  ReadLn(FMethode);

  { lees aantal punten }
  FIn := '';
  Read(FTmp);
  while Ord(FTmp) <> 32 do begin
    FIn := FIn + FTmp;
    Read(FTmp);
  end{while};
  ReadLn;
  Val(FIn, FNum);

  { lees punten }
  FPunten := TPunten.Create;
  for i := 0 to (FNum - 1) do begin
    FX := '';
    Read(FTmp);
    while Ord(FTmp) <> 32 do begin
      FX := FX + FTmp;
      Read(FTmp);
    end{while};
    Val(FX, x);

    ReadLn(FY);
    Val(FY, y);

    FPunten.Add(TPunt.Create(x, y));
  end{for};

  { kies algoritme }

  //----------------------------------------------------------------------------
  if FMethode = 'uptofive' then begin
    FPuntenArray := UpTo5Sort(FPunten);

    for i := 0 to (Length(FPuntenArray) - 1) do begin
      FPuntenArray[i] := CheckVolgorde(FPuntenArray[i]);
    end{for};

    { output }
    Write(Length(FPuntenArray));
    WriteLn(' number of curves');
    for i := 0 to (Length(FPuntenArray) - 1) do begin
      OutputPuntenLijst(FPuntenArray[i]);
    end{for};
  end
  //----------------------------------------------------------------------------
  else if FMethode = 'open' then begin
    FPunten := ImprovedNearestNeighborSort(FPunten);
    FPunten := MakeOpenCurve(FPunten);

    { output }
    WriteLn('1 number of curves');
    OutputPuntenLijst(FPunten);
  end
  //----------------------------------------------------------------------------
  else if FMethode = 'closed' then begin
    FPunten := ImprovedNearestNeighborSort(FPunten);
    FPunten := CheckVolgorde(FPunten);

    { output }
    WriteLn('1 number of curves');
    OutputPuntenLijst(FPunten);
  end
  //----------------------------------------------------------------------------
  else if FMethode = 'selfintersecting' then begin
    SetAlpha(1.5);
    FPunten := DirectedNearestNeighborSort(FPunten);

    { output }
    WriteLn('1 number of curves');
    OutputPuntenLijst(FPunten);
  end{if};
  //----------------------------------------------------------------------------
end.
