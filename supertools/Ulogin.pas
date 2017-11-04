unit Ulogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, ADODB;

type
  Tfrm_login = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edit_pass: TEdit;
    btn_login: TButton;
    btn_cancel: TButton;
    img_user: TImage;
    img_pass: TImage;
    edit_user: TComboBox;
    procedure btn_loginClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edit_passKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_login: Tfrm_login;

  superman:string;
implementation

uses Usupermanager;


{$R *.dfm}

procedure Tfrm_login.btn_loginClick(Sender: TObject);
begin
  handlers:='';
  if edit_pass.Text='' then
  begin
    Application.MessageBox('请输入密码!','提示',MB_OK);
    Exit;
  end;
  superman:=edit_user.Text;
  //
  if edit_pass.Text='zcchtk' then
  begin
    Close;
  end
  else
  begin
    Application.MessageBox('你输入的密码不正确！','提示',MB_OK+MB_ICONINFORMATION);
    Exit;
  end;
end;

procedure Tfrm_login.btn_cancelClick(Sender: TObject);
begin
  Close;
  handlers:='123';
end;

procedure Tfrm_login.FormShow(Sender: TObject);
var
  i:integer;
  user1:string;
begin
  edit_user.ItemIndex:=0;
  edit_user.Items.Add('9999');
  
end;

procedure Tfrm_login.edit_passKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    btn_loginClick(nil);
  end;
end;

procedure Tfrm_login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

end.
