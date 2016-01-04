unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  CurveRecon, Algorithms, StdCtrls, ExtCtrls;

const
  cDefaultNum = 1000000;
  cPuntDikte = 1;
  cLijnDikte = 1;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ButtonRandom: TButton;
    ButtonClear: TButton;
    ButtonNN: TButton;
    ButtonVoegToe: TButton;
    CheckBoxClosed: TCheckBox;
    EditRandom: TEdit;
    EditX: TEdit;
    EditY: TEdit;
    Panel1: TPanel;
    Tekening: TPaintBox;
    procedure Button1Click(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonRandomClick(Sender: TObject);
    procedure ButtonVoegToeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonNNClick(Sender: TObject);
    procedure TekeningMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TekeningPaint(Sender: TObject);
    procedure ImportFile(importf: String);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  FPunten: TPunten;
  FLijnen: TLijnen;

implementation

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Vul FPunten...
  FPunten := TPunten.Create(cDefaultNum);
  FLijnen := TLijnen.Create(cDefaultNum - 1);

  Tekening.Refresh;
end;

procedure TForm1.ButtonNNClick(Sender: TObject);
var
  i, j, k: Integer;
  d: Double;
  p, q: TPunt;
  punten: TPunten;
begin
 { FLijnen := TLijnen.Create(FPunten.Count);
  punten := TPunten.Create(FPunten.Count);

  for i := 0 to (FPunten.Count - 1) do begin
    punten.Add(FPunten.Punt(i));
  end{for}; }

 { k := punten.Count - 2;
  p := punten.Punt(0);

  for i := 0 to k do begin
    punten.Remove(p);

    // zoek punt dichtste bij p
    d := 1000000000;
    q := p;
    for j := 0 to (punten.Count - 1) do begin
      if (p.AfstandTot(punten.Punt(j)) < d) then begin
        d := p.AfstandTot(punten.Punt(j));
        q := punten.Punt(j);
      end{if};
    end{for};

    // maak lijn
    FLijnen.Add(TLijn.Create(p, q));

    // verander p naar dat punt
    p := q;
  end{for}; }

  {if (CheckBoxClosed.Checked) and (FPunten.Count > 2) then begin
    FLijnen.Add(TLijn.Create(p, FPunten.Punt(0)));
  end{if}; }

  FPunten := Algorithm(FPunten);
  if FPunten.Count > 1 then
  begin
    for i := 0 to (FPunten.Count - 1) do begin
      //ShowMessage('HALLO DAAR');

      FLijnen.Add(TLijn.Create(FPunten.Punt(i), FPunten.Punt((i + 1) mod (FPunten.Count))));
    end{for};
  end;
  Tekening.Refresh;
end;

procedure TForm1.TekeningMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  px, py: Double;
begin
  px := X / Tekening.Width;
  py := 1 - (Y / Tekening.Height);

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

procedure TForm1.ButtonClearClick(Sender: TObject);
begin
  FPunten := TPunten.Create(cDefaultNum);
  FLijnen := TLijnen.Create(cDefaultNum - 1);

  Tekening.Refresh;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   openDialog : TOpendialog;
begin
  openDialog := TOpenDialog.Create(self);
  openDialog.InitialDir := GetCurrentDir;
  openDialog.Filter :=
    'OGO Points File|*.sol;*.sam|All Files| *.';
  openDialog.FilterIndex := 1;
  if openDialog.Execute then begin
    ImportFile(openDialog.FileName)
  end
  else begin
    ShowMessage('Open file was cancelled!!');
  end;
  openDialog.Free;
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
    nx := Random(1000) / 1000;
    ny := Random(1000) / 1000;
    FPunten.Add(TPunt.Create(nx, ny));
  end{for};

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
begin
  c := Tekening.Canvas;

  c.Brush.Color := clWhite;
  c.FillRect(0, 0, c.Width, c.Height);

  // Teken FPunten
  c.Pen.Color := clBlack;
  c.Pen.Width := cPuntDikte;

  for i := 0 to (FPunten.Count - 1) do begin
    PuntX := (round((FPunten.Punt(i).X/500) * Tekening.Width));
    PuntY := (Tekening.Height - round((FPunten.Punt(i).Y/500) * Tekening.Height));
    c.Ellipse(PuntX-1, PuntY-1, PuntX+1, PuntY+1);
  end{for};

  // Teken lijnen?
  c.Pen.Color := clBlack;
  c.Pen.Width := cLijnDikte;

  for i := 0 to (FLijnen.Count - 1) do begin
    PuntX := round(FLijnen.Lijn(i).BeginPunt.X * Tekening.Width);
    PuntY := Tekening.Height - round(FLijnen.Lijn(i).BeginPunt.Y * Tekening.Height);
    Punt2X := round(FLijnen.Lijn(i).EindPunt.X * Tekening.Width);
    Punt2Y := Tekening.Height - round(FLijnen.Lijn(i).EindPunt.Y * Tekening.Height);
    c.MoveTo(PuntX, PuntY);
    c.LineTo(Punt2X, Punt2Y);
  end{for};
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
  //Tekening Clear
  FPunten := TPunten.Create(cDefaultNum);
  FLijnen := TLijnen.Create(cDefaultNum - 1);

  //
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
  Showmessage(Sort + ' and ' + NrOfP + ' points');
  t := 'a';
  X := 0;
  Y := 0;
  CountP := 0;
 // while not EOF(F) do begin
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
  Showmessage('Drawed ' + IntToStr(CountP) + ' points');
  CloseFile(F);
  Tekening.Refresh;
end;

initialization
  {$I mainform.lrs}

end.

