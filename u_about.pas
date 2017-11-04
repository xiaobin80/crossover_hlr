unit u_about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls, ShellApi;

type
  Tfrm_about = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Bevel1: TBevel;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    sctVersion: TStaticText;
    StaticText7: TStaticText;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    verStr:string;
    { Public declarations }
  end;

var
  frm_about: Tfrm_about;

implementation
  uses
    uPublicFuncMain;
{$R *.dfm}

procedure Tfrm_about.FormShow(Sender: TObject);
var
  szExePathname:array [0..255]of char;
  hMoudleA:DWORD;
begin
  hMoudleA:=GetModuleHandle(nil);
  GetModuleFileName(hMoudleA,szExePathname,MAX_PATH);
  verStr:=GetCDPFileVersion(string(szExePathname));
  sctVersion.Caption:='�汾:'+verStr;
end;

end.
