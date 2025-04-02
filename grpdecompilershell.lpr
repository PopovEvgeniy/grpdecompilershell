program grpdecompilershell;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, grpdecompilershellcode
  { you can add units after this };

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainWindow, MainWindow);
  Application.Run;
end.

