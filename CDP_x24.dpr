program CDP_x24;

uses
  Forms,
  windows,
  SysUtils,
  Udispatch in 'Udispatch.pas' {frm_main},
  u_about in 'u_about.pas' {frm_about},
  Ulogin in 'Ulogin.pas' {frm_login},
  Udatatotal in 'Udatatotal.pas' {frm_sa},
  uPicProcess in 'uPicProcess.pas' {frmCarDetail},
  uLoadSaveImg in 'servoSystem211\uLoadSaveImg.pas',
  uPublicFuncMain in 'publicFunc\uPublicFuncMain.pas';

{$R *.res}
Var
  hMutex:HWND;
  Ret:Integer;
  
begin
  hMutex:=CreateMutex(nil,False,'HLR crossStation');
  Ret:=GetLastError;
  If Ret<>ERROR_ALREADY_EXISTS Then
  begin
    Application.Initialize;
    Application.Title := 'HLR crossStation';
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

    Application.CreateForm(Tfrm_main, frm_main);
  Application.Run;
  end
  else
  begin
    Application.MessageBox('程序已经在运行！','提示',MB_OK+MB_ICONHAND);
    Exit;
  end;
end.
