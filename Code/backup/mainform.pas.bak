unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  {$ifdef Windows}
  Windows,
  {$endif}
  CurveRecon, StdCtrls, ExtCtrls, Math,
  NearestNeighbor, DirectedNearestNeighbor, UpTo5, ImprovedNearestNeighbor2;

const
  cDefaultNum = 1000000;
  {$ifdef Windows}
  cPuntDikte = 3;
  {$else}
  cPuntDikte = 3;
  {$endif}
  cLijnDikte = 1;
  cDrawTurns = 5;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonExport: TButton;
    ButtonINN: TButton;
    ButtonUP25: TButton;
    ButtonMin: TButton;
    ButtonPlus: TButton;
    ButtonLeft: TButton;
    ButtonUp: TButton;
    ButtonDown: TButton;
    ButtonRight: TButton;
    ButtonDNN: TButton;
    ButtonFit: TButton;
    ButtonImport: TButton;
    ButtonRandom: TButton;
    ButtonClear: TButton;
    ButtonNN: TButton;
    ButtonVoegToe: TButton;
    CheckBoxClosed: TCheckBox;
    EditAlpha: TEdit;
    EditRandom: TEdit;
    EditX: TEdit;
    EditY: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LabelRT: TLabel;
    LabelAantal: TLabel;
    LabelOOR: TLabel;
    Panel1: TPanel;
    Tekening: TPaintBox;
    procedure ButtonExportClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonDNNClick(Sender: TObject);
    procedure ButtonDownClick(Sender: TObject);
    procedure ButtonFitClick(Sender: TObject);
    procedure ButtonImportClick(Sender: TObject);
    procedure ButtonINNClick(Sender: TObject);
    procedure ButtonLeftClick(Sender: TObject);
    procedure ButtonMinClick(Sender: TObject);
    procedure ButtonPlusClick(Sender: TObject);
    procedure ButtonRandomClick(Sender: TObject);
    procedure ButtonRightClick(Sender: TObject);
    procedure ButtonUP25Click(Sender: TObject);
    procedure ButtonUpClick(Sender: TObject);
    procedure ButtonVoegToeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonNNClick(Sender: TObject);
    procedure TekeningMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TekeningMouseLeave(Sender: TObject);
    procedure TekeningMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TekeningMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TekeningPaint(Sender: TObject);
    procedure ImportFile(importf: String);
    procedure ExportFile(exportf, curvetype: String);
    procedure UpdateRT(RT: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  FPunten: TPunten;
  FLijnen: TLijnen;
  { Range enzo }
  cRangeXMin: Integer;
  cRangeYMin: Integer;
  cRangeX: Integer;
  cRangeY: Integer;
  { Tekenen }
  FIsDrawing: Boolean;
  FDrawTurn: Integer;
  { Tijden }
  T1, T2: Integer;
  { Overige }
  SkipDisplayCount: Boolean;

implementation

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  junkdouble: Double;
  junkstring: String;
begin
  {$ifdef BSD}
  Form1.Caption := Form1.Caption + ' (Mac)';
  {$else}
    {$ifdef Unix}
    Form1.Caption := Form1.Caption + ' (Unix)';
    {$endif}
  {$endif}
  {$ifdef Windows}
  Form1.Caption := Form1.Caption + ' (Windows)';
  {$endif}

  // debug
  //ShowMessage(FloatToStr(HoekUitZijden(4, 4)));
  //ShowMessage(FloatToStr(HoekUitZijden(-4, 4)));
  //ShowMessage(FloatToStr(HoekUitZijden(4, -4)));
  //ShowMessage(FloatToStr(HoekUitZijden(-4, -4)));

  // Vul FPunten...
  FPunten := TPunten.Create;
  FLijnen := TLijnen.Create;

  // Range
  cRangeXMin := 0;
  cRangeYMin := 0;
  cRangeX := 10;
  cRangeY := 10;

  // Tekenen
  FIsDrawing := false;
  FDrawTurn := 0;

  //FPunten.Insert(0, TPunt.Create(1, 1));
  //FPunten.Insert(0, TPunt.Create(5, 1));
  //FPunten.Insert(0, TPunt.Create(5, 5));
  //FPunten.Insert(0, TPunt.Create(1, 5));

  //junkdouble := TPunt.Create(1, 1).HoekMet(TPunt.Create(1, 1));
  //Str(junkdouble, junkstring);
  //ShowMessage(junkstring);

  Tekening.Refresh;
end;

procedure TForm1.ButtonNNClick(Sender: TObject);
var
  i: Integer;
begin
  {$ifdef Windows}
  T1 := GetTickCount;
  {$endif}

  FPunten := NearestNeighborSort(FPunten);

  {$ifdef Windows}
  T2 := GetTickCount;
  UpdateRT(T2 - T1);
  {$endif}

  SkipDisplayCount := false;

  { de rest is voor de grafische weergave... }

  FLijnen := TLijnen.Create;

  for i := 0 to (FPunten.Count - 2) do begin
    { maak lijn van punt i naar i+1 }
    FLijnen.Add(TLijn.Create(FPunten.Punt(i), FPunten.Punt(i + 1)));
  end{for};

  { closed? dan nog een lijn }
  if (CheckBoxClosed.Checked) and (FPunten.Count > 2) then begin
    FLijnen.Add(TLijn.Create(FPunten.Punt(FPunten.Count - 1), FPunten.Punt(0)));
  end{if};

  Tekening.Refresh;
end;

procedure TForm1.TekeningMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FIsDrawing := true;
end;

procedure TForm1.TekeningMouseLeave(Sender: TObject);
begin
  if FIsDrawing then begin
    FIsDrawing := false;
    FDrawTurn := 0;
  end{if};
end;

procedure TForm1.TekeningMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  px, py: Double;
begin
  if FIsDrawing and (FDrawTurn = 0) then begin
    px := (X * cRangeX / Tekening.Width) + cRangeXMin;
    py := (Y * cRangeY / Tekening.Height) + cRangeYMin;

    FPunten.Add(TPunt.Create(px, py));

    Tekening.Refresh;
  end{if};

  FDrawTurn := (FDrawTurn + 1) mod cDrawTurns;
end;

procedure TForm1.TekeningMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  px, py: Double;
begin
  if FIsDrawing then begin
    FIsDrawing := false;
    FDrawTurn := 0;
  end{if};

  px := (X * cRangeX / Tekening.Width) + cRangeXMin;
  py := (Y * cRangeY / Tekening.Height) + cRangeYMin;

  FPunten.Add(TPunt.Create(px, py));

  Tekening.Refresh;
end;

procedure TForm1.ButtonVoegToeClick(Sender: TObject);
var
  TempX: Double;
  ErrorX: Integer;

  TempY: Double;
  ErrorY: Integer;
begin
  if not (EditX.Text = '') and not (EditY.Text = '') then begin
    Val(EditX.Text, TempX, ErrorX);
    Val(EditY.Text, TempY, ErrorY);

    if (ErrorX = 0) and (ErrorY = 0) then begin
      FPunten.Add(TPunt.Create(TempX, TempY));

      Tekening.Refresh;
    end{if};
  end{if};
end;

procedure TForm1.ButtonExportClick(Sender: TObject);
var
  saveDialog: TSaveDialog;
  curveType: String;
begin
  curveType := InputBox('Curve Type', 'Please enter the type of curve.', 'closed');

  while (curveType <> 'closed') and (curveType <> 'selfintersecting') and (curveType <> 'open') and (curveType <> 'uptofive') do begin
    curveType := InputBox('Curve Type', 'Invalid type. Please choose from open, closed, selfintersecting and uptofive.', 'closed');
  end{while};

  saveDialog := TSaveDialog.Create(self);
  saveDialog.InitialDir := GetCurrentDir + './../TC';
  saveDialog.Filter := 'OGO Points File|*.sam|OGO Solution File|*.sol|All Files|*.*';
  saveDialog.FilterIndex := 1;
  saveDialog.DefaultExt := '.sam';

  if saveDialog.Execute then begin
    ExportFile(saveDialog.FileName, 'closed')
  end
  else begin
    ShowMessage('Export failed.');
  end;

  saveDialog.Free;
end;

procedure TForm1.ButtonClearClick(Sender: TObject);
begin
  FPunten := TPunten.Create(cDefaultNum);
  FLijnen := TLijnen.Create(cDefaultNum - 1);

  Tekening.Refresh;
end;

procedure TForm1.ButtonDNNClick(Sender: TObject);
var
  i: Integer;
  tmp: Double;
begin
  Val(EditAlpha.Text, tmp);

  SetAlpha(tmp);

  {$ifdef Windows}
  T1 := GetTickCount;
  {$endif}

  FPunten := DirectedNearestNeighborSort(FPunten);

  {$ifdef Windows}
  T2 := GetTickCount;
  UpdateRT(T2 - T1);
  {$endif}

  { de rest is voor de grafische weergave... }

  FLijnen := TLijnen.Create;

  for i := 0 to (FPunten.Count - 2) do begin
    { maak lijn van punt i naar i+1 }
    FLijnen.Add(TLijn.Create(FPunten.Punt(i), FPunten.Punt(i + 1)));
  end{for};

  { closed? dan nog een lijn }
  if (CheckBoxClosed.Checked) and (FPunten.Count > 2) then begin
    FLijnen.Add(TLijn.Create(FPunten.Punt(FPunten.Count - 1), FPunten.Punt(0)));
  end{if};

  Tekening.Refresh;
end;

procedure TForm1.ButtonDownClick(Sender: TObject);
var
  delta: Integer;
begin
  delta := Floor(cRangeY * 0.25) + 1;
  cRangeYMin := cRangeYMin + delta;
  //cRangeY := cRangeY + delta;

  Tekening.Refresh;
end;

procedure TForm1.ButtonFitClick(Sender: TObject);
begin
  cRangeXMin := floor(FPunten.Minimum(false));
  cRangeYMin := floor(FPunten.Minimum(true));
  cRangeX := ceil(FPunten.Maximum(false) - cRangeXMin);
  cRangeY := ceil(FPunten.Maximum(true) - cRangeYMin);

  Tekening.Refresh;
end;

procedure TForm1.ButtonImportClick(Sender: TObject);
var
  openDialog : TOpendialog;
begin
  openDialog := TOpenDialog.Create(self);
  openDialog.InitialDir := GetCurrentDir + '/../TC';
  openDialog.Filter := 'OGO Points File|*.sol;*.sam|All Files|*.*';
  openDialog.FilterIndex := 1;

  if openDialog.Execute then begin
    ImportFile(openDialog.FileName)
  end
  else begin
    ShowMessage('Import failed.');
  end;

  openDialog.Free;
end;

procedure TForm1.ButtonINNClick(Sender: TObject);
var
  i: Integer;
begin
  {$ifdef Windows}
  T1 := GetTickCount;
  {$endif}

  FPunten := ImprovedNearestNeighborSort(FPunten);

  { open? }
  if not CheckBoxClosed.Checked or (FPunten.Count <= 2) then begin
    FPunten := MakeOpenCurve(FPunten);
  end{if};

  {$ifdef Windows}
  T2 := GetTickCount;
  UpdateRT(T2 - T1);
  {$endif}

  { de rest is voor de grafische weergave... }

  FLijnen := TLijnen.Create;

  for i := 0 to (FPunten.Count - 2) do begin
    { maak lijn van punt i naar i+1 }
    FLijnen.Add(TLijn.Create(FPunten.Punt(i), FPunten.Punt(i + 1)));
  end{for};

  { closed? dan nog een lijn }
  if (CheckBoxClosed.Checked) and (FPunten.Count > 2) then begin
    FLijnen.Add(TLijn.Create(FPunten.Punt(FPunten.Count - 1), FPunten.Punt(0)));
  end;

  Tekening.Refresh;
end;

procedure TForm1.ButtonLeftClick(Sender: TObject);
var
  delta: Integer;
begin
  delta := Floor(cRangeX * 0.25) + 1;
  cRangeXMin := cRangeXMin - delta;
  //cRangeX := cRangeX - delta;

  Tekening.Refresh;
end;

procedure TForm1.ButtonMinClick(Sender: TObject);
var
  delta: Integer;
begin
  delta := Floor(cRangeX * 0.25) + 1;
  //cRangeXMin := cRangeXMin - delta;
  cRangeX := cRangeX + delta;

  delta := Floor(cRangeY * 0.25) + 1;
  //cRangeYMin := cRangeYMin - delta;
  cRangeY := cRangeY + delta;

  Tekening.Refresh;
end;

procedure TForm1.ButtonPlusClick(Sender: TObject);
var
  delta: Integer;
begin
  delta := Floor(cRangeX * 0.25) + 1;
  if (cRangeX - delta) > 0 then begin
    cRangeX := cRangeX - delta;
  end{if};

  delta := Floor(cRangeY * 0.25) + 1;
  if (cRangeY - delta) > 0 then begin
    cRangeY := cRangeY - delta;
  end{if};

  Tekening.Refresh;
end;

procedure TForm1.ButtonRandomClick(Sender: TObject);
var
  i: Integer;
  n: Integer;
  tmp: Integer;
  nx, ny: Double;
begin
  Val(EditRandom.Text, n, tmp);

  Randomize;

  for i := 1 to n do begin
    nx := (Random(1000) * cRangeX / 1000) + cRangeXMin;
    ny := (Random(1000) * cRangeY / 1000) + cRangeYMin;
    FPunten.Add(TPunt.Create(nx, ny));
  end{for};

  Tekening.Refresh;
end;

procedure TForm1.ButtonRightClick(Sender: TObject);
var
  delta: Integer;
begin
  delta := Floor(cRangeX * 0.25) + 1;
  cRangeXMin := cRangeXMin + delta;
  //cRangeX := cRangeX + delta;

  Tekening.Refresh;
end;

procedure TForm1.ButtonUP25Click(Sender: TObject);
var
  i, j: Integer;
  pa: TPuntenArray;
  p: TPunten;
  curves: String;
begin
  { deze functie verandert niks aan FPunten! }

  p := TPunten.Create;

  for i := 0 to (FPunten.Count - 1) do begin
    p.Add(FPunten.Punt(i));
  end{for};

  {$ifdef Windows}
  T1 := GetTickCount;
  {$endif}

  pa := UpTo5Sort(FPunten);

  {$ifdef Windows}
  T2 := GetTickCount;
  UpdateRT(T2 - T1);
  {$endif}

  FPunten := p;

  { de rest is voor de grafische weergave... }

  FLijnen := TLijnen.Create;

  //ShowMessage('Aantal curves: ' + IntToStr(Length(pa)));

  for i := 0 to (Length(pa) - 1) do begin
   // ShowMessage('Curve ' + IntToStr(i + 1) + ' heeft ' + IntToStr(pa[i].Count) + ' punten');

    for j := 0 to (pa[i].Count - 2) do begin
      { maak lijn van punt j naar j+1 }
      FLijnen.Add(TLijn.Create(pa[i].Punt(j), pa[i].Punt(j + 1)));
    end{for};

    { closed? dan nog een lijn }
    if (CheckBoxClosed.Checked) and (pa[i].Count > 2) then begin
      FLijnen.Add(TLijn.Create(pa[i].Punt(pa[i].Count - 1), pa[i].Punt(0)));
    end{if};
  end{for};

  SkipDisplayCount := true;

  // Aantal curves
  if Length(pa) = 1 then begin
    curves := '1 curve';
  end
  else begin
    curves := IntToStr(Length(pa)) + ' curves';
  end{if};

  // Aantal punten
  if FPunten.Count = 1 then begin
    LabelAantal.Caption := curves + ', 1 point';
  end
  else begin
    LabelAantal.Caption := curves + ', ' + IntToStr(FPunten.Count) + ' points';
  end{if};

  Tekening.Refresh;
end;

procedure TForm1.ButtonUpClick(Sender: TObject);
var
  delta: Integer;
begin
  delta := Floor(cRangeY * 0.25) + 1;
  cRangeYMin := cRangeYMin - delta;
  //cRangeY := cRangeY - delta;

  Tekening.Refresh;
end;

procedure TForm1.TekeningPaint(Sender: TObject);
var
  c: TCanvas;
  i: Integer;
  PuntX: Integer;
  PuntY: Integer;
  Punt2X: Integer;
  Punt2Y: Integer;
  outofrange: Boolean;
begin
  // Aantal punten
  if not SkipDisplayCount then begin
    if FPunten.Count = 1 then begin
      LabelAantal.Caption := '1 point';
    end
    else begin
      LabelAantal.Caption := IntToStr(FPunten.Count) + ' points';
    end{if};
  end
  else begin
    SkipDisplayCount := false; // don't skip twice
  end{if};

  c := Tekening.Canvas;

  c.Brush.Color := clWhite;
  c.FillRect(0, 0, c.Width, c.Height);

  // Teken FPunten
  c.Pen.Color := clBlack;
  c.Pen.Width := cPuntDikte;

  outofrange := false;

  for i := 0 to (FPunten.Count - 1) do begin
    PuntX := round((FPunten.Punt(i).X - cRangeXMin) * Tekening.Width / cRangeX);
    PuntY := round((FPunten.Punt(i).Y - cRangeYMin) * Tekening.Height / cRangeY);

    if (PuntX < 0) or (PuntX > Tekening.Width) or (PuntY < 0) or (PuntY > Tekening.Height) then begin
      outofrange := true;
    end{if};

    //c.Ellipse(PuntX-1, PuntY-1, PuntX+1, PuntY+1);
    if cPuntDikte > 0 then begin
      c.Ellipse(PuntX, PuntY, PuntX+1, PuntY+1);
    end{if};
  end{for};

  // Teken lijnen?
  c.Pen.Color := clBlack;
  c.Pen.Width := cLijnDikte;

  for i := 0 to (FLijnen.Count - 1) do begin
    PuntX := round((FLijnen.Lijn(i).BeginPunt.X - cRangeXMin) * Tekening.Width / cRangeX);
    PuntY := round((FLijnen.Lijn(i).BeginPunt.Y - cRangeYMin) * Tekening.Height / cRangeY);
    Punt2X := round((FLijnen.Lijn(i).EindPunt.X - cRangeXMin) * Tekening.Width / cRangeX);
    Punt2Y := round((FLijnen.Lijn(i).EindPunt.Y - cRangeYMin) * Tekening.Height / cRangeY);
    c.MoveTo(PuntX, PuntY);
    c.LineTo(Punt2X, Punt2Y);
  end{for};

  LabelOOR.Visible := outofrange;
end;



procedure TForm1.ImportFile(importf: String);
var
  F : TextFile;
  t : char;
  Xs : String;
  Ys : String;
  X : Double;
  Y : Double;
  Sort, NrOfP: String;
  NrOfPInt, CountP: Integer;
begin
  // Clear
  FPunten := TPunten.Create(cDefaultNum);
  FLijnen := TLijnen.Create(cDefaultNum - 1);

  // De rest...
  AssignFile(F, importf);
  Reset(F);
  Readln(F, Sort);
  t := 'a';
  while t <> ' ' do begin
      Read(F, t);
      if t <> ' ' then begin
        NrOfP := NrOfP + t;
      end;
  end;
  NrOfPInt := StrToInt(NrOfP);
  while not EOLN(F) do begin
      Read(F, t);
  end;
  //Showmessage(Sort + ' and ' + NrOfP + ' points');
  t := 'a';
  X := 0;
  Y := 0;
  CountP := 0;
  //while not EOF(F) do begin
  while CountP <> NrOfPInt do begin
    // X lezen
    Xs := '';
    while t <> ' ' do begin
      Read(F,t);
      if t <> ' ' then begin
        Xs := Xs + t;
      end;
    end;
    X := StrToFloat(Xs);

    //Y lezen
    Ys := '';
    while not EOLN(F) do begin
      Read(F,t);
      if t <> ' ' then begin
        Ys := Ys + t;
      end;
    end;
    read(F,t);
    Y := StrToFloat(Ys);
    FPunten.Add(TPunt.Create(X, Y));
    //ShowMessage('Ik heb dit punt getekend'+Xs+' '+Ys);
    CountP := CountP + 1;
  end;
  //Showmessage('Imported ' + IntToStr(CountP) + ' points!');
  CloseFile(F);
  Tekening.Refresh;
end;

procedure TForm1.ExportFile(exportf, curvetype: String);
var
  F: TextFile;
  i: Integer;
begin
  AssignFile(F, exportf);
  Rewrite(F);

  WriteLn(F, curvetype);
  Write(F, FPunten.Count);
  WriteLn(F, ' number of points');
  for i := 0 to (FPunten.Count - 1) do begin
    Write(F, FPunten.Punt(i).X:0:8);
    Write(F, ' ');
    WriteLn(F, FPunten.Punt(i).Y:0:8);
  end{for};

  CloseFile(F);
end;

procedure TForm1.UpdateRT(RT: Integer);
begin
  LabelRT.Caption := 'Running time: ' + IntToStr(RT) + 'ms';
  LabelRT.Visible := true;
end;

initialization
  {$I mainform.lrs}

end.

