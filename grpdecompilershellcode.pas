unit grpdecompilershellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, LazUTF8;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var Form1: TForm1;
function get_path(): string;
function convert_file_name(source:string): string;
function execute_program(executable:string;argument:string):Integer;
procedure window_setup();
procedure dialog_setup();
procedure interface_setup();
procedure common_setup();
procedure language_setup();
procedure setup();

implementation

function get_path(): string;
begin
get_path:=ExtractFilePath(Application.ExeName);
end;

function convert_file_name(source:string): string;
var target:string;
begin
target:=source;
if Pos(' ',source)>0 then
begin
target:='"';
target:=target+source+'"';
end;
convert_file_name:=target;
end;

function execute_program(executable:string;argument:string):Integer;
var code:Integer;
begin
try
code:=ExecuteProcess(UTF8ToWinCp(executable),UTF8ToWinCp(argument),[]);
except
On EOSError do code:=-1;
end;
execute_program:=code;
end;

procedure window_setup();
begin
 Application.Title:='GRP DECOMPILER SHELL';
 Form1.Caption:='GRP DECOMPILER SHELL 1.0.3';
 Form1.BorderStyle:=bsDialog;
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
end;

procedure dialog_setup();
begin
Form1.OpenDialog1.FileName:='*.grp';
Form1.OpenDialog1.DefaultExt:='*.grp';
Form1.OpenDialog1.Filter:='GRP pseudo-archive|*.grp';
end;

procedure interface_setup();
begin
Form1.Button1.ShowHint:=False;
Form1.Button2.ShowHint:=Form1.Button1.ShowHint;
Form1.Button3.ShowHint:=Form1.Button1.ShowHint;
Form1.Button3.Enabled:=False;
Form1.LabeledEdit1.Text:='';
Form1.LabeledEdit2.Text:=Form1.LabeledEdit1.Text;
Form1.LabeledEdit1.LabelPosition:=lpLeft;
Form1.LabeledEdit2.LabelPosition:=Form1.LabeledEdit1.LabelPosition;
Form1.LabeledEdit1.Enabled:=False;
Form1.LabeledEdit2.Enabled:=Form1.LabeledEdit1.Enabled;
end;

procedure common_setup();
begin
window_setup();
interface_setup();
dialog_setup();
end;

procedure language_setup();
begin
Form1.LabeledEdit1.EditLabel.Caption:='File';
Form1.LabeledEdit2.EditLabel.Caption:='Directory';
Form1.Button1.Caption:='Open';
Form1.Button2.Caption:='Browse';
Form1.Button3.Caption:='Extract';
Form1.OpenDialog1.Title:='Open existing file';
Form1.SelectDirectoryDialog1.Title:='Select a directory';
Form1.StatusBar1.SimpleText:='Ready to work';
end;

procedure setup();
begin
common_setup();
language_setup();
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
Form1.Button3.Enabled:=(Form1.LabeledEdit1.Text<>'') and (Form1.LabeledEdit2.Text<>'');
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
Form1.Button3.Enabled:=(Form1.LabeledEdit1.Text<>'') and (Form1.LabeledEdit2.Text<>'');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if Form1.OpenDialog1.Execute()=True then
begin
Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
Form1.LabeledEdit2.Text:=ExtractFilePath(Form1.OpenDialog1.FileName);
end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if Form1.SelectDirectoryDialog1.Execute()=True then Form1.LabeledEdit2.Text:=Form1.SelectDirectoryDialog1.FileName+DirectorySeparator;
end;

procedure TForm1.Button3Click(Sender: TObject);
var host,argument:string;
var message:array[0..3] of string=('Operation successfully complete','Can not allocate memory','File operation error','Invalid format');
var status:Integer;
begin
host:=get_path()+'grpdecompiler';
argument:=convert_file_name(Form1.LabeledEdit1.Text)+' '+convert_file_name(Form1.LabeledEdit2.Text);
status:=execute_program(host,argument);
if status=-1 then
begin
ShowMessage('Can not execute a external program');
end
else
begin
Form1.StatusBar1.SimpleText:=message[status];
end;

end;

{$R *.lfm}

end.
