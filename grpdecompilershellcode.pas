unit grpdecompilershellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    OpenButton: TButton;
    BrowseButton: TButton;
    ExtractButton: TButton;
    FileField: TLabeledEdit;
    DirectoryField: TLabeledEdit;
    OpenDialog: TOpenDialog;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    OperationStatus: TStatusBar;
    procedure OpenButtonClick(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure ExtractButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileFieldChange(Sender: TObject);
    procedure DirectoryFieldChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var MainWindow: TMainWindow;

implementation

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 convert_file_name:=target;
end;

function correct_path(const source:string ): string;
var target:string;
begin
 target:=source;
 if LastDelimiter(DirectorySeparator,source)<>Length(source) then
 begin
  target:=source+DirectorySeparator;
 end;
 correct_path:=target;
end;

function execute_program(const executable:string;const argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  code:=-1;
 end;
 execute_program:=code;
end;

function decompile_grp(const target:string;const directory:string):string;
var host,argument,message:string;
var messages:array[0..4] of string=('The operation was successfully completed','Cant open the input file','Cant create the output file','Cant allocate memory','Invalid format');
var status:Integer;
begin
 message:='Can not execute an external program';
 host:=ExtractFilePath(Application.ExeName)+'grpdecompiler.exe';
 argument:=convert_file_name(target)+' '+convert_file_name(directory);
 status:=execute_program(host,argument);
 if status<>-1 then
 begin
  message:=messages[status];
 end;
 decompile_grp:=message;
end;

procedure window_setup();
begin
 Application.Title:='GRP DECOMPILER SHELL';
 MainWindow.Caption:='GRP DECOMPILER SHELL 1.2';
 MainWindow.BorderStyle:=bsDialog;
 MainWindow.Font.Name:=Screen.MenuFont.Name;
 MainWindow.Font.Size:=14;
end;

procedure dialog_setup();
begin
 MainWindow.OpenDialog.FileName:='*.grp';
 MainWindow.OpenDialog.DefaultExt:='*.grp';
 MainWindow.OpenDialog.Filter:='GRP pseudo-archive|*.grp';
end;

procedure interface_setup();
begin
 MainWindow.OpenButton.ShowHint:=False;
 MainWindow.BrowseButton.ShowHint:=MainWindow.OpenButton.ShowHint;
 MainWindow.ExtractButton.ShowHint:=MainWindow.OpenButton.ShowHint;
 MainWindow.ExtractButton.Enabled:=False;
 MainWindow.FileField.Text:='';
 MainWindow.DirectoryField.Text:=MainWindow.FileField.Text;
 MainWindow.FileField.LabelPosition:=lpLeft;
 MainWindow.DirectoryField.LabelPosition:=MainWindow.FileField.LabelPosition;
 MainWindow.FileField.Enabled:=False;
 MainWindow.DirectoryField.Enabled:=MainWindow.FileField.Enabled;
end;

procedure language_setup();
begin
 MainWindow.FileField.EditLabel.Caption:='File';
 MainWindow.DirectoryField.EditLabel.Caption:='Directory';
 MainWindow.OpenButton.Caption:='Open';
 MainWindow.BrowseButton.Caption:='Browse';
 MainWindow.ExtractButton.Caption:='Extract';
 MainWindow.OpenDialog.Title:='Open the existing file';
 MainWindow.SelectDirectoryDialog.Title:='Select a directory';
 MainWindow.OperationStatus.SimpleText:='Ready to work';
end;

procedure setup();
begin
 window_setup();
 interface_setup();
 dialog_setup();
 language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TMainWindow.FileFieldChange(Sender: TObject);
begin
 MainWindow.ExtractButton.Enabled:=(MainWindow.FileField.Text<>'') and (MainWindow.DirectoryField.Text<>'');
end;

procedure TMainWindow.DirectoryFieldChange(Sender: TObject);
begin
 MainWindow.ExtractButton.Enabled:=(MainWindow.FileField.Text<>'') and (MainWindow.DirectoryField.Text<>'');
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if MainWindow.OpenDialog.Execute()=True then
 begin
  MainWindow.FileField.Text:=MainWindow.OpenDialog.FileName;
  MainWindow.DirectoryField.Text:=ExtractFilePath(MainWindow.OpenDialog.FileName);
 end;

end;

procedure TMainWindow.BrowseButtonClick(Sender: TObject);
begin
 if MainWindow.SelectDirectoryDialog.Execute()=True then
 begin
  MainWindow.DirectoryField.Text:=correct_path(MainWindow.SelectDirectoryDialog.FileName);
 end;

end;

procedure TMainWindow.ExtractButtonClick(Sender: TObject);
begin
 MainWindow.OperationStatus.SimpleText:=decompile_grp(MainWindow.FileField.Text,MainWindow.DirectoryField.Text);
end;

{$R *.lfm}

end.
