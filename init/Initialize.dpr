program Initialize;

uses
  Forms,
  init112 in 'init112.pas' {frm_init};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '≥ı ºªØ';
  Application.CreateForm(Tfrm_init, frm_init);
  Application.Run;
end.
