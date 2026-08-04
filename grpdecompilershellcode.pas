unit grpdecompilershellcode;

{
 This software was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, ComCtrls;

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
  private
    procedure window_setup();
    procedure dialog_setup();
    procedure interface_setup();
    procedure language_setup();
    procedure setup();
  public
    { public declarations }
  end; 

var MainWindow: TMainWindow;

implementation

procedure TMainWindow.window_setup();
begin
 Application.Title:='GRP DECOMPILER SHELL';
 Self.Caption:='GRP DECOMPILER SHELL 1.2.5';
 Self.BorderStyle:=bsDialog;
 Self.Font.Name:=Screen.MenuFont.Name;
 Self.Font.Size:=14;
end;

procedure TMainWindow.dialog_setup();
begin
 Self.OpenDialog.FileName:='*.grp';
 Self.OpenDialog.DefaultExt:='*.grp';
 Self.OpenDialog.Filter:='GRP pseudo-archive|*.grp';
end;

procedure TMainWindow.interface_setup();
begin
 Self.OpenButton.ShowHint:=False;
 Self.BrowseButton.ShowHint:=False;
 Self.ExtractButton.ShowHint:=False;
 Self.ExtractButton.Enabled:=False;
 Self.BrowseButton.Enabled:=False;
 Self.FileField.Text:='';
 Self.DirectoryField.Text:='';
 Self.FileField.LabelPosition:=lpLeft;
 Self.DirectoryField.LabelPosition:=lpLeft;
 Self.FileField.Enabled:=False;
 Self.DirectoryField.Enabled:=False;
end;

procedure TMainWindow.language_setup();
begin
 Self.FileField.EditLabel.Caption:='File';
 Self.DirectoryField.EditLabel.Caption:='Directory';
 Self.OpenButton.Caption:='Open';
 Self.BrowseButton.Caption:='Browse';
 Self.ExtractButton.Caption:='Extract';
 Self.OpenDialog.Title:='Open the existing file';
 Self.SelectDirectoryDialog.Title:='Select a directory';
 Self.OperationStatus.SimpleText:='Ready to work';
end;

procedure TMainWindow.setup();
begin
 Self.window_setup();
 Self.interface_setup();
 Self.dialog_setup();
 Self.language_setup();
end;

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 Result:=target;
end;

function correct_path(const source:string ): string;
var target:string;
begin
 target:=source;
 if LastDelimiter(DirectorySeparator,source)<>Length(source) then
 begin
  target:=source+DirectorySeparator;
 end;
 Result:=target;
end;

function execute_program(const executable:string;const argument:string):Integer;
var code:Integer;
begin
 try
  code:=ExecuteProcess(executable,argument,[]);
 except
  code:=-1;
 end;
 Result:=code;
end;

function decompile_grp(const target:string;const directory:string):string;
var host,argument,message:string;
var messages:array[0..6] of string=('The operation was successfully completed','Cannot open the input file','Cannot create the output file','Cannot read data!','Cannot write data!','Cannot allocate memory','The invalid format');
var status:Integer;
begin
 message:='Cannot execute an external program';
 host:=ExtractFilePath(Application.ExeName)+'grpdecompiler.exe';
 argument:=convert_file_name(target)+' '+convert_file_name(directory);
 status:=execute_program(host,argument);
 if status<>-1 then
 begin
  message:=messages[status];
 end;
 decompile_grp:=message;
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 Self.setup();
end;

procedure TMainWindow.FileFieldChange(Sender: TObject);
begin
 Self.ExtractButton.Enabled:=Self.FileField.Text<>'';
 Self.BrowseButton.Enabled:=Self.ExtractButton.Enabled;
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if Self.OpenDialog.Execute()=True then
 begin
  Self.FileField.Text:=Self.OpenDialog.FileName;
  Self.DirectoryField.Text:=ExtractFilePath(Self.OpenDialog.FileName);
 end;

end;

procedure TMainWindow.BrowseButtonClick(Sender: TObject);
begin
 if Self.SelectDirectoryDialog.Execute()=True then
 begin
  Self.DirectoryField.Text:=correct_path(Self.SelectDirectoryDialog.FileName);
 end;

end;

procedure TMainWindow.ExtractButtonClick(Sender: TObject);
begin
 Self.OperationStatus.SimpleText:=decompile_grp(Self.FileField.Text,Self.DirectoryField.Text);
end;

{$R *.lfm}

end.
