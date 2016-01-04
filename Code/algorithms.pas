unit Algorithms;


interface
uses
  Classes, SysUtils, CurveRecon, Math;
Type

Punten= TPunten;
Depth = Integer;
Punt = TPunt;
Edge = TLijn;
Edges = TLijnen;
Nummers = array of Double;
Kleuren = (cWhite,cGray,cBlack);

PKDTree = ^KDTree;
KDTree = Record

  Median: Double;
  Parent: PKDTree;
  Left: PKDTree;
  Right: PKDTree;
  Value: Punt;
  Kleur: Kleuren;
end;

//Algorithms
Function BuildTree(P: Punten; D: Depth):KDTree;
Function FindMedian(X:Nummers):Double;
procedure QuickSort(var A: TDoubleList; Lo, Hi: Integer);
Function Algorithm(P: Punten):Punten;
function NNSearch(p: Punt; Tree: PKDTree): Punten;
function NNSearchSub(p: Punt; Tree: PKDTree; d: Integer; cNN: PKDTree): PKDTree;
Function SortEdges(E: Edges): Edges;

// Debug
procedure OutputKDTree(Tree: PKDTree; Prefix: String);
procedure OpenKDLog;
procedure CloseKDLog;

procedure OutputChoice(p1: Punt; p2: Punt);
procedure OpenChoiceLog;
procedure CloseChoiceLog;

procedure ExportPunten(P: Punten);

var
  LogKDFile: TextFile;
  LogKDOpened: Boolean;
  LogChoiceFile: TextFile;
  LogChoiceOpened: Boolean;
  ExportFile: TextFile;

implementation

Function Algorithm(P: Punten):Punten;
var
  KD: PKDTree;
  i,j: integer;
  E: Edges;
  NN,List: Punten;
  L1,L2,L1s,L2s: Edge;
  B,Richting: Boolean;
  Start,HP,Vorige: Punt;
begin
  if (P.Count = 0) or (P.Count = 1) then
  begin
     Result := P;
  end
  else
  begin
  E := Edges.Create(2*(P.Count*(P.Count-1)));
  New(KD);
  KD^ := BuildTree(P,0);

  //Find starting point lexiographic
  Start := P.Punt(0);
  for i := 1 to P.Count -1 do
  begin
    if (P.Punt(i).X < Start.X) then
    begin
      Start := P.Punt(i);
    end
    else
    begin
       if (P.Punt(i).X = Start.X) and (P.Punt(i).Y < Start.Y) then
       begin
         Start := P.Punt(i);
       end;
    end;
  end;

  // Start is now the starting point
  List := Punten.Create(P.Count-1);
  List.Add(Start);
   HP := Start;              //HP = Huidig Punt
  For i := 0 to P.Count-2 do
  begin
    NN := NNSearch( HP, KD);
    L1 := Edge.Create(HP, NN.Punt(0));
    E.Add(L1);
    HP := NN.Punt(0);
  end;
  L1 := Edge.Create(HP, List.Punt(0));
  E.Add(L1);
  L2 := E.Lijn(0);
  //L1 gaat naar begin L2 gaat vanuit begin
  if (L1.BeginPunt.X < L2.EindPunt.X) then
  begin
    List.Add(L1.BeginPunt);
    Richting := False;
  end;

  if L1.BeginPunt.X > L2.EindPunt.X then
  begin
    List.Add(L2.EindPunt);
    Richting := True;
  end;

  if (L1.BeginPunt.X = L2.EindPunt.X) and (L1.BeginPunt.Y < L2.EindPunt.Y) then
  begin
    List.Add(L1.BeginPunt);
    Richting := False;
  end;

  if (L1.BeginPunt.X = L2.EindPunt.X) and (L1.BeginPunt.Y > L2.EindPunt.Y) then
  begin
    List.Add(L2.EindPunt);
    Richting := True;
  end;

  //Richting; True = edge lijst normaal afgaan
  //          False = edge lijst anders om afgaan
  if Richting then
  begin
     Vorige := L2.EindPunt;
     i := 1;
     while (Start.X <> Vorige.X) and (Start.Y <> Vorige.Y) do
     begin
       List.Add(E.Lijn(i).EindPunt);
       Vorige := E.Lijn(i).EindPunt;
       i := i + 1;
     end;{while}

  end{if}
  else
  begin
    Vorige := L1.BeginPunt;
     i := E.Count-2;
     while (Start.X <> Vorige.X) and (Start.Y <> Vorige.Y) do
     begin
       List.Add(E.Lijn(i).BeginPunt);
       Vorige := E.Lijn(i).BeginPunt;
       i := i - 1;
     end;{while}
  end;{else}

      //kijk lijst na op fouten (closed curve eigenschappen moeten kloppen)
  //repareer mogelijke fouten


  Result := List;
  end;
end; {Algorithm}



Function BuildTree(P: Punten; D: Depth): KDTree;
var
v1,v2: KDTree;
p1,p2: Punten;
pv1,pv2: PKDTree;
median: Double;
i: integer;
xy: Nummers;
Gehad: Boolean;
begin
setLength(xy, P.Count);

Result.Median := 0;
Result.Parent:= nil;
Result.Left := nil;
Result.Right:= nil;
Result.Value := nil;
Result.Kleur:=cWhite;


If P.Count = 1 then
begin
  //leaf
  Result.Value := P.Punt(0);
end {if}
else
begin
  // p1 en p2 definieren via median
  p1 := Punten.Create(P.Count);
  p2 := Punten.Create(Ceil(P.Count/2));

   if (D mod 2 = 0) then
   begin
   //Find median on x coor
      For i := 0 to P.Count-1 do
      begin
        xy[i] := P.Punt(i).X;
      end{for};
      median := FindMedian(xy);
      Gehad := False;
      for i := 0 to P.Count-1 do
      begin
        if (P.Punt(i).X = median) and (not Gehad) then
        begin
         Result.Value := P.Punt(i);
         Gehad := True;
        end
        else
        begin
          if (P.Punt(i).X <= median) then
          begin
            p1.Add(P.Punt(i));
          end {if}
          else
          begin
            p2.Add(P.Punt(i));
          end; {else}
        end; {if}
      end; {for}
   end{if}
   else
   begin
   //Find median on y coor
      For i := 0 to P.Count-1 do
      begin
        xy[i] := P.Punt(i).Y;
      end{for};
      median := FindMedian(xy);
      Gehad := False;
      for i := 0 to P.Count-1 do
      begin
        if (P.Punt(i).Y = median) and (not Gehad) then
        begin
          Result.Value := P.Punt(i);
          Gehad := True;
        end
        else
        begin
          if (P.Punt(i).Y <= median) then
          begin
            p1.Add(P.Punt(i));
          end {if}
          else
          begin
            p2.Add(P.Punt(i));
          end; {else}
        end; {else}
      end;{for}
   end{else};

if p1.Count>0 then
begin
v1 := BuildTree(P1,D+1);
New(v1.Parent);
v1.Parent^ := Result;
New(pv1);
pv1^ := v1;
Result.Left := pv1;
end;
if p2.Count>0 then
begin
v2 := BuildTree(p2,D+1);
New(v2.Parent);
v2.Parent^ := Result;
New(pv2);
pv2^ := v2;
Result.Right := pv2;
end;

//Tree invullen
Result.Median := median;


end{else};

end;{BuildTree}



procedure QuickSort(var A: TDoubleList; Lo, Hi: Integer) ;
var
  Pivot, T: Double;
  Low, High: Integer;
begin
  Low := Lo;
  High := Hi;
  Pivot := A.Element((Low + High) div 2);
  repeat
    while A.Element(Low) < Pivot do Low := Low + 1;
    while A.Element(High) > Pivot do High := High - 1;
    if Lo <= Hi then
    begin
      T := A.Element(Low);
      A.Replace(Low, A.Element(High));
      A.Replace(High, T);
      Low := Low + 1;
      High := High - 1;
    end;
  until Low > High;
  if High > Lo then begin
     QuickSort(A, Lo, High);
  end;
  if Low < Hi then begin
     QuickSort(A, Low, Hi);
  end;
end;


Function FindMedian(X:Nummers):Double;
var
   IndexX: LongInt;
   BucketIndex: LongInt;
   Buckets: array of TDoubleList;
   SortedList: TDoublelist;
   Sortedloop: Integer;
begin
  // Buckets aanmaken voor cijfers die beginnen met 0 tot 9
  SetLength(Buckets, 10);
  for BucketIndex := 0 to 9 do begin
    Buckets[Bucketindex] := TDoubleList.Create(Length(X));
  end;

  // Elk punt in bijhorende bucket zetten
  for IndexX := 0 to Length(X)-1 do begin
       Buckets[floor(X[IndexX]*10)].Add(X[IndexX]);
  end;

   // Quicksort uitvoeren op alle buckets
   for BucketIndex := 0 to 9 do begin
    if Buckets[BucketIndex].Count <> 0 then begin
      Quicksort( Buckets[Bucketindex], 0, Buckets[BucketIndex].Count-1);
    end;
  end;

  // Gesorteeerde lijst maken
  Sortedlist := TDoubleList.Create(Length(X));
  for BucketIndex := 0 to 9 do begin
    if Buckets[BucketIndex].Count <> 0 then begin
      for Sortedloop := 0 to Buckets[BucketIndex].Count - 1 do begin
        Sortedlist.Add( Buckets[BucketIndex].Element(Sortedloop) );
      end;
    end;
  end;

  // Mediaan geven
  if (SortedList.Count) mod 2 <> 0 then begin
    Result := (SortedList.Element(    (SortedList.Count div 2) ));
  end
  else begin
    Result := (SortedList.Element(SortedList.Count div 2)) ;
  end;

end;{FindMedian}


function NNSearch(p: Punt; Tree: PKDTree): Punten;
var
  NN1: PKDTree;
  NN2: PKDTree;
begin
  OpenKDLog;
  OutputKDTree(Tree, '');
  CloseKDLog;

  // BREEKPUNT HIER

  NN1 := NNSearchSub(p, Tree, 0, nil);
  //NN1^.Kleur := cGray; { blokkeer NN1 voor de volgende search }
  //NN2 := NNSearchSub(p, Tree, 0, nil);
  //NN1^.Kleur := cWhite;

  Result := Punten.Create(2);
  if (NN1 <> nil) then
  begin
    Result.Add(NN1^.Value);
    Result.Add(NN1^.Value);

    OutputChoice(p, NN1^.Value);

    // BREEKPUNT HIER
  end;

  //if (NN2 <> nil) then begin
  //  Result.Add(NN2^.Value);
  //end{if};
end;

function NNSearchSub(p: Punt; Tree: PKDTree; d: Integer; cNN: PKDTree): PKDTree;
var
  h: Double;         // p.x of p.y
  mNN: PKDTree;      // "maybe" cNN
  richting: PKDTree; // left of right
  LocatiecNN: Punt;
begin
  if (Tree = nil) then begin
    Result := nil;
  end
  else begin
    if (Tree^.Value.X = p.X) and (Tree^.Value.Y = p.Y) then begin
      Tree^.Kleur := cGray;
    end{if};

    if (d = 0) then begin
      if ((Tree^.Value.X <> p.X) or (Tree^.Value.Y <> p.Y)) and (Tree^.Kleur <> cGray) then begin
        cNN := Tree;

        LocatiecNN := cNN^.Value;
      end
      else begin
        cNN := Tree^.Left;

        if (cNN^.Kleur = cGray) or ((cNN^.Value.X = p.X) and (cNN^.Value.Y = p.Y)) then begin
          LocatiecNN := Punt.Create(100, 100);
          cNN^.Kleur := cGray;
        end
        else if (cNN <> nil) then begin
          LocatiecNN := cNN^.Value;
        end{if};
      end{if};
    end
    else begin
      if ((Tree^.Value.X <> p.X) or (Tree^.Value.Y <> p.Y)) and (p.AfstandTot(Tree^.Value) < p.AfstandTot(cNN^.Value)) and (Tree^.Kleur <> cGray) then begin
        cNN := Tree;
      end{if};

      if ((cNN^.Value.X = p.X) and (cNN^.Value.Y = p.Y)) then begin
        LocatiecNN := Punt.Create(100, 100);
        cNN^.Kleur := cGray;
      end
      else if (cNN <> nil) then begin
        LocatiecNN := cNN^.Value;
      end{if};
    end{if};

    if (d mod 2 = 0) then begin
      h := p.x;
    end
    else begin
      h := p.y
    end{if};

    if (cNN = nil) then begin
      Result := nil;
    end
    else begin
      if (p.AfstandTot(LocatiecNN) <= Abs(h - Tree^.Median)) then begin
        if (h <= Tree^.Median) then begin
          richting := Tree^.Left;
        end
        else begin
          richting := Tree^.Right;
        end{if};

        mNN := NNSearchSub(p, richting, d + 1, cNN);
        if (mNN <> nil) then begin
          if (p.AfstandTot(mNN^.Value) < p.AfstandTot(LocatiecNN)) then begin
            cNN := mNN;
            LocatiecNN := cNN^.Value;
          end{if};
        end{if};
      end
      else begin
        mNN := NNSearchSub(p, Tree^.Left, d + 1, cNN);
        if (mNN <> nil) then begin
          if (p.AfstandTot(mNN^.Value) < p.AfstandTot(LocatiecNN)) then begin
            cNN := mNN;
            LocatiecNN := cNN^.Value;
          end{if};
        end{if};

        mNN := NNSearchSub(p, Tree^.Right, d + 1, cNN);
        if (mNN <> nil) then begin
          if (p.AfstandTot(mNN^.Value) < p.AfstandTot(LocatiecNN)) then begin
            cNN := mNN;
            LocatiecNN := cNN^.Value;
          end{if};
        end{if};
      end{if};

      Result := cNN;
    end{if};
  end{if};
end;

Function SortEdges(E: Edges): Edges;
begin
  // BEGIN IDEE
  // MAG WEG OF ZO
end; {SortEdges}

procedure OutputKDTree(Tree: PKDTree; Prefix: String);
var
  temp: String;
  pre: String;
begin
  pre := Prefix;

  if (Tree = nil) then begin
    WriteLn(LogKDFile, pre + 'nil');
  end
  else begin
    Write(LogKDFile, pre + '(');
    Str(Tree^.Value.X, temp);
    Write(LogKDFile, temp + ' ,');
    Str(Tree^.Value.Y, temp);
    Write(LogKDFile, temp + ' )');

    WriteLn(LogKDFile);

    pre := pre + '  ';

    WriteLn(LogKDFile, pre + 'LEFT');
    OutputKDTree(Tree^.Left, pre);

    WriteLn(LogKDFile, pre + 'RIGHT');
    OutputKDTree(Tree^.Right, pre);
  end{if};
end;

procedure OpenKDLog;
begin
  AssignFile(LogKDFile, './log.txt');
  Rewrite(LogKDFile);

  LogKDOpened := true;
end;

procedure CloseKDLog;
begin
  CloseFile(LogKDFile);

  LogKDOpened := false;
end;

procedure OutputChoice(p1: Punt; p2: Punt);
var
  temp: String;
begin
  Write(LogChoiceFile, 'NN(');
  Str(p1.X, temp);
  Write(LogChoiceFile, temp + ' ,');
  Str(p1.Y, temp);
  Write(LogChoiceFile, temp + ' ) = (');

  Str(p2.X, temp);
  Write(LogChoiceFile, temp + ' ,');
  Str(p2.Y, temp);
  Write(LogChoiceFile, temp + ' )');

  WriteLn(LogChoiceFile);
end;

procedure OpenChoiceLog;
begin
  AssignFile(LogChoiceFile, './log2.txt');
  Rewrite(LogChoiceFile);

  LogChoiceOpened := true;
end;

procedure CloseChoiceLog;
begin
  CloseFile(LogChoiceFile);

  LogChoiceOpened := false;
end;

procedure ExportPunten(P: Punten);
var
  i: Integer;
  temp: String;
begin
  AssignFile(ExportFile, './export.txt');
  Rewrite(ExportFile);

  for i := 0 to (P.Count - 1) do begin
    Write(ExportFile, '(');
    Str(P.Punt(i).X, temp);
    Write(ExportFile, temp + ' ,');
    Str(P.Punt(i).Y, temp);
    Write(ExportFile, temp + ' )');

    WriteLn(ExportFile);
  end{for};

  CloseFile(ExportFile);
end;

end.

