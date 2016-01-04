program curverecondriver;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, mainform, CurveRecon, Algorithms,
  BacktrackingOfzo, NearestNeighbor, DirectedNearestNeighbor,
NearestNeighborGamma, UpTo5, ImprovedNearestNeighbor2;

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

