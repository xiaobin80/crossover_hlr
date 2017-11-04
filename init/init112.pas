//****************************************************************************//
//用途：宝日希勒煤业有限责任公司
//日期：2008.1.2
//****************************************************************************//
unit init112;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Gauges, IniFiles;

type
  Tfrm_init = class(TForm)
    ADOConnection_init: TADOConnection;
    Gauge1: TGauge;
    btn_star: TButton;
    btn_stop: TButton;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edt_dbpass: TEdit;
    edt_dbname: TEdit;
    edt_db: TEdit;
    edt_srv: TEdit;
    ADOCommand1: TADOCommand;
    procedure FormCreate(Sender: TObject);
    procedure btn_starClick(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
  private
    { Private declarations }
  public
    xbf:WideString;
    function getComputerNameM1:WideString;
    { Public declarations }
  end;

//
  type
  TreadXBF=function(DimRecord: Integer;filename1:WideString):WideString;stdcall;
  //

var
  frm_init: Tfrm_init;
  connstring:TreadXBF;
implementation

{$R *.dfm}

function readXBF(DimRecord: Integer;filename1:WideString):WideString;stdcall;
                                external 'XBFGenerate.dll';


function Tfrm_init.getComputerNameM1:WideString;
var
  CNameBuffer : PChar;
  fl_loaded : Boolean;
  CLen : ^DWord;
  computerName:WideString;
begin
  GetMem(CNameBuffer,255);
  New(CLen);
  CLen^:= 255;
  fl_loaded := GetComputerName(CNameBuffer,CLen^);
  if fl_loaded then
    ComputerName := StrPas(CNameBuffer)
  else
    ComputerName := 'Unkown';
  //
  FreeMem(CNameBuffer,255);
  Dispose(CLen);
  //
  Result:=computerName;
end;

procedure Tfrm_init.FormCreate(Sender: TObject);
var
  iniConf:TIniFile;
  iniPathStr:WideString;
begin
  frm_init.Caption:='初始化程序';
  iniPathStr:=ExtractFilePath(ParamStr(0))+'CDPconfig.ini';
  iniConf:=TIniFile.Create(iniPathStr);
  xbf:=iniConf.ReadString('file name','1','zlnr1.xbf');
  edt_srv.Text:=getComputerNameM1;
end;

procedure Tfrm_init.btn_starClick(Sender: TObject);
var
  h1:THandle;
begin
  if btn_stop.Enabled=false then
  begin
    Exit;
  end;
  try
     h1:=0;
     try
      h1:=LoadLibrary('XBFGenerate.dll');
    
      if h1<>0 then
        @connstring:=GetprocAddress(h1,'readXBF');
      if (@connstring<>nil)then
          ADOConnection_init.Close;
          ADOConnection_init.ConnectionString:=connstring(-1,xbf);
          ADOConnection_init.Open;
     finally
       FreeLibrary(h1);
     end;
  except
    Application.MessageBox('配置错误，请重新填写各个值！','提示',MB_OK);
    Exit;
  end;
  Gauge1.Visible:=True;
  try
    ADOCommand1.CommandText:='CREATE TABLE [dbo].[trainOrder] ('+#13+
                             '[train_number] [int] NULL ,'+#13+
                             '[seriary_number] [int] NULL ,'+#13+
                             '[car_number] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                             '[car_marque] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                             '[carry_weight1] [numeric](9, 3) NULL ,'+#13+
                             '[self_weight1] [numeric](9, 3) NULL ,'+#13+
                             '[past_time] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                             '[outFlag] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                             '[badFlag] [bit] DEFAULT (1) NOT NULL ,'+#13+
                             '[year_level2] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                             '[month_level3] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                             '[sn] [int] IDENTITY (1001, 1) NOT NULL'+#13+
                             ') ON [PRIMARY]';

    ADOCommand1.Execute;
    Gauge1.Progress:=25;
    //

    ADOCommand1.CommandText:='CREATE TABLE [dbo].[car_number] ('+#13+
                              '[train_number] [int] NOT NULL ,'+#13+
                              '[seriary_number] [int] NOT NULL ,'+#13+
                              '[car_number] [nvarchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                              '[past_time] [nvarchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                              '[car_marque] [nvarchar] (30) COLLATE Chinese_PRC_CI_AS NULL'+#13+
                              ') ON [PRIMARY]';
    ADOCommand1.Execute;
    Gauge1.Progress:=50;
     //
    ADOCommand1.CommandText:='CREATE TABLE [dbo].[photoTable] ('+#13+
                              '[train_number] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                              '[seriary_number] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                              '[past_time] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                              '[pic_jpg] [image] NULL ,'+#13+
                              '[pic_bmp] [image] NULL ,'+#13+
                              '[photo_time] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,'+#13+
                              '[photoFlag] [bit] DEFAULT 1 NULL'+#13+
                              ') ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]';
    ADOCommand1.Execute;
     //
    Gauge1.Progress:=61;
    //
    Sleep(1000);
    Gauge1.Progress:=100;
    //
    Application.MessageBox('初始化完成！','提示',MB_OK);
    btn_stop.Enabled:=False;
  except

  end;
end;

procedure Tfrm_init.btn_stopClick(Sender: TObject);
var
  h1:THandle;
begin
  try
     h1:=0;
     try
      h1:=LoadLibrary('XBFGenerate.dll');
    
      if h1<>0 then
        @connstring:=GetprocAddress(h1,'readXBF');
      if (@connstring<>nil)then
          ADOConnection_init.Close;
          ADOConnection_init.ConnectionString:=connstring(-1,xbf);
          ADOConnection_init.Open;
     finally
       FreeLibrary(h1);
     end;
  except
    Application.MessageBox('配置错误，请重新填写各个值！','提示',MB_OK);
    Exit;
  end;
  //
  try
    ADOCommand1.CommandText:='drop table trainOrder';
    ADOCommand1.Execute;
    //
    ADOCommand1.CommandText:='drop table car_number';
    ADOCommand1.Execute;
    //
    ADOCommand1.CommandText:='drop table photoTable';
    ADOCommand1.Execute;
    //
  except

  end;

  //
  btn_star.Enabled:=True;
  Application.MessageBox('预处理完成！','提示',MB_OK);
end;


end.
