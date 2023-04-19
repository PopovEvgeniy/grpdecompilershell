unit grpdecompilershellcode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, LazFileUtils;

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
var messages:array[0..4] of string=('Operation successfully complete','Cant open input file','Cant create output file','Cant allocate memory','Invalid format');
var status:Integer;
begin
 message:='Can not execute a external program';
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
 Form1.Caption:='GRP DECOMPILER SHELL 1.1.6';
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
 window_setup();
 interface_setup();
 dialog_setup();
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
 if Form1.SelectDirectoryDialog1.Execute()=True then
 begin
  Form1.LabeledEdit2.Text:=correct_path(Form1.SelectDirectoryDialog1.FileName);
 end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 Form1.StatusBar1.SimpleText:=decompile_grp(Form1.LabeledEdit1.Text,Form1.LabeledEdit2.Text);
end;

{$R *.lfm}

end.
