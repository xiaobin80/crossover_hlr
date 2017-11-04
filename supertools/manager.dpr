program manager;

uses
  Forms,
  windows,
  SysUtils,
  Ulogin in 'Ulogin.pas' {frm_login},
  Usupermanager in 'Usupermanager.pas' {frm_supermanager};

{$R *.res}
Var
  hMutex:HWND;
  Ret:Integer;

begin
  hMutex:=CreateMutex(nil,False,'超级管理员管理工具');
  Ret:=GetLastError;
  If Ret<>ERROR_ALREADY_EXISTS Then
  begin
    Application.Initialize;
    Application.Title := '超级管理员管理工具';
  try
      frm_login :=Tfrm_login.Create(nil);
      frm_login.ShowModal;
    finally
      frm_login.Free;
    end;
    if handlers<>'' then
    begin
      application.MessageBox('没有正确登录，不能使用本软件!','提示',mb_ok);
      exit ;
    end ;

    Application.CreateForm(Tfrm_supermanager, frm_supermanager);
  Application.Run;
  end
  else
  begin
    Application.MessageBox('程序已经在运行！','提示',MB_OK+MB_ICONHAND);
    Exit;
  end;
end.
