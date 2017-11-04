//****************************************************************************//
//******     unit name:UmainServo.pas                                   ******//
//******     purpose  :convert any data to My use DB                    ******//
//******     author   :xiao bin                                         ******//
//******     date     :2007.05.19                                       ******//
//****** copyright (c) 2002-2007 cationsoft Corporation all proprietary ******//
//****************************************************************************//

unit UmainServo;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, DB, ADODB, Inifiles, Menus,
  StdCtrls, ExtCtrls, StrUtils, jpeg, NMUDP;

type
  Pipe_writeData = class(TThread)
  private
    msgLog1:WideString;
    //NMP parameter
    m_hOutPipe:THandle;
    { Private declarations }
  protected
    //NMP procedure
    procedure writePipeData(msg:WideString);
    procedure Execute; override;
  public
    constructor Create(flag:Boolean;NMP_handle:DWORD;msgLog:WideString);
  end;

type
  TfrmServoMain = class(TForm)
    pnlLeft1: TPanel;
    imgSs: TImage;
    pnlRside: TPanel;
    pnlLside: TPanel;
    pnlMain: TPanel;
    pnlBside: TPanel;
    btnClose: TButton;
    memoLog: TMemo;
    NMUDP_Monitor: TNMUDP;
    TimerCarNumber: TTimer;
    MemoMonitor: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure TimerCarNumberTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure NMUDP_MonitorDataReceived(Sender: TComponent;
      NumberBytes: Integer; FromIP: String; Port: Integer);
    procedure FormShow(Sender: TObject);
  private
    //log information
    logStrInf:WideString;
    logPathWstr:WideString;
    //2007.12.5
    imageDirStr:string;
    machineNumStr:string;
    netAnswerStrA:String;
    //
    xbfini:TIniFile;    
    richstring:TStringList;
    ADODataSetX,ADODataSetMDB_1,ADODataSetMDB_2:TADODataSet;
    ADOQuery_Exec:TADOQuery;
    //2007.12.5
    ADODataSet1Pic:TADODataSet;
    ADOQuery1Pic:TADOQuery;
    //
    function initNMUDP_Monitor(localPort:Integer;remoteIP:string;remotePort:Integer):Boolean;
    function sendCommandChar(infoStrA:string):Boolean;
    { Private declarations }
  public
    connectStrA,connectStrMDB:WideString;
    ADOConnectX:TADOConnection;
    ADOConnectMDB:TADOConnection;
    //NMP handle
    hPipe:DWORD;
    //
    parade1:integer;
    periodicityInt:Integer;
    //
    lastTimePicStr:WideString;
    //
    procedure DISservo;
    procedure picServo(photoTimeStrA:WideString);
    //
    function CreateADOConnectA(var ADOConnect1:TADOConnection;var connStr:WideString):Boolean;
    function DestoryADOConnectA(var ADOConnect1:TADOConnection):Boolean;    
    { Public declarations }
  protected
    procedure WndProc(var Message : TMessage); override;

  end;

var
  frmServoMain: TfrmServoMain;

  function readXBF(DimRecord: Integer;filename1:WideString):WideString;stdcall;
                        external 'XBFGenerate.dll';

  function createNMP:DWORD;stdcall;
     external 'npSupport.dll';

implementation
  uses uPublicFun,AMD5;
{$R *.dfm}

function TfrmServoMain.CreateADOConnectA(var ADOConnect1:TADOConnection;
                                                var connStr:WideString):Boolean;
begin
  try
    ADOConnect1:=TADOConnection.Create(nil);
    ADOConnect1.LoginPrompt:=False;
    ADOConnect1.ConnectionString:=connStr;
    
    Result:=True;
  except
    Result:=False;
  end;

end;

function TfrmServoMain.DestoryADOConnectA(var ADOConnect1:TADOConnection):Boolean;
begin
  try
    ADOConnect1.Close;
    ADOConnect1.Free;

    Result:=True;
  except
    Result:=False;
    ADOConnect1.Destroy;
  end;
  
end;

procedure TfrmServoMain.FormCreate(Sender: TObject);
var
  xbffilepath:string;
  xbfname:string;  
  //h1:THandle;
  //2007.12.5
  lPortInt,rPortInt:Integer;
  remoteHostStr:string;
begin
  //h1:=0;
  xbfini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'servoSys.ini');

  xbfname:=ExtractFilePath(ParamStr(0))+xbfini.ReadString('file name','1','');
  xbffilepath:=xbfini.ReadString('file path','9','');
  try
    connectStrMDB:='Provider=Microsoft.Jet.OLEDB.4.0'
                +';Password=""'
                +';Data Source='+xbffilepath
                +';Persist Security Info=True';
    connectStrA:=readXBF(-1,xbfname);
    //
    CreateADOConnectA(ADOConnectMDB,connectStrMDB);
    CreateADOConnectA(ADOConnectX,connectStrA)
  except
    Application.MessageBox('servoSystem connect DB fail!','HINT',MB_OK);
    Application.Terminate;
  end;
  //2007.12.5
  lPortInt:=xbfini.ReadInteger('local server','2',6668);
  remoteHostStr:=xbfini.ReadString('remote server','1','192.168.1.76');
  rPortInt:=xbfini.ReadInteger('remote server','1',6669);
  imageDirStr:=xbfini.ReadString('file path','5','d:\Image');
  if not initNMUDP_Monitor(lPortInt,remoteHostStr,rPortInt) then
        memoLog.Lines.Append(DateTimeToStr(now)+'：init montior machine fail!');
  //2007.12.5
  logPathWstr:=ExtractFilePath(ParamStr(0))+'servoSys.log';
  //
  machineNumStr:=xbfini.ReadString('remote server','3','011');
  //NMP
  hPipe:=createNMP;
  //timer
  periodicityInt:=xbfini.ReadInteger('undo','clock',15000);
  TimerCarNumber.Interval:=periodicityInt;
end;

procedure TfrmServoMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//acquire system message(wm_close) course self is method 
procedure TfrmServoMain.WndProc(var Message: TMessage);
begin
  if Message.Msg=$0011 then
  begin
    if hPipe<>0 then
    begin
      DisconnectNamedPipe(hPipe);//disconnect NP
      CloseHandle(hPipe);
    end;
    //2007.12.5
    memoLog.Lines.Add(DateTimeToStr(now)+': Quit ServoSystem');
    writeLogFun(logPathWstr,memoLog.Lines);
    Application.Terminate;
    //
  end;
  inherited WndProc(Message);
end;
//
//2007.12.5 version 1.8.7(begin)
function TfrmServoMain.initNMUDP_Monitor(localPort:Integer;remoteIP:string;remotePort:Integer):Boolean;
begin
  NMUDP_Monitor.LocalPort:=localPort;
  NMUDP_Monitor.RemoteHost:=remoteIP;
  NMUDP_Monitor.RemotePort:=remotePort;
  //
  Result:=True;
end;

//
procedure TfrmServoMain.NMUDP_MonitorDataReceived(Sender: TComponent;
  NumberBytes: Integer; FromIP: String; Port: Integer);
var
  dataEndInt:Integer;
  udpBufferAy:array [0..255]of Char;
  //
  picRepInfoStr:WideString;
  repPosBeginInt,repPosEndInt:integer;
  //
  findSFileInt:Integer;
begin
  //
  if(NumberBytes<=256)then
  begin
    NMUDP_Monitor.ReadBuffer(udpBufferAy,dataEndInt);
    udpBufferAy[dataEndInt]:='0';
    netAnswerStrA:=trim(udpBufferAy);
    //MemoMonitor.SelText:=netAnswerStrA+'                    ';
    MemoMonitor.Lines.Append(netAnswerStrA);
    picRepInfoStr:='XZXJYTRAFFICCAP_011SENDFILE_';
    findSFileInt:=pos(picRepInfoStr,netAnswerStrA);
    if findSFileInt<>0 then
    begin
      repPosBeginInt:=pos('时间',netAnswerStrA);
      repPosEndInt:=pos('秒',netAnswerStrA);
      lastTimePicStr:=copy(netAnswerStrA,repPosBeginInt,repPosEndInt-repPosBeginInt);
    end;
  end;
end;

procedure TfrmServoMain.picServo(photoTimeStrA:WideString);
var
  dirNameStr:string;
  j:Integer;
  fileNameStrA:string;
  //
  maxTnInt:Integer;
  //
  saveFlag:Boolean;
begin
  //
  if CreateADOConnectA(ADOConnectX,connectStrA)=false then
  begin
    CreateADOConnectA(ADOConnectX,connectStrA);
  end;
  //
  ADODataSet1Pic:=TADODataSet.Create(nil);
  ADODataSet1Pic.Connection:=ADOConnectX;
  ADODataSet1Pic.CommandText:='select train_number,seriary_number,past_time,'
                              +'pic_jpg,'
                              +'photo_time from photoTable';

  ADOQuery1Pic:=TADOQuery.Create(nil);
  ADOQuery1Pic.Connection:=ADOConnectX;
  //
  dirNameStr:='机号'+machineNumStr
                +photoTimeStrA
                +'秒车辆图片';
  //
  imageDirStr:=imageDirStr+'\'+dirNameStr;
  //
  maxTnInt:=maxCar_number(ADOQuery1Pic);
  //
  if DirectoryExists(imageDirStr) then
  begin
    for j:=2 to 99 do
    begin
      fileNameStrA:='机号'+machineNumStr
            +photoTimeStrA
            +'秒地点神宝公司交接站横向拍摄6幅第'
            +IntToStr(j)
            +'节车箱.JPG';    
      if FileExists(imageDirStr+'\'+fileNameStrA)then
      begin
        ADODataSet1Pic.Close;
        ADODataSet1Pic.CommandText:='select train_number,seriary_number,past_time,pic_jpg,photo_time from photoTable';
        ADODataSet1Pic.Open;
        saveFlag:= savePic2DB(imageDirStr+'\'+fileNameStrA,'jpg',ADODataSet1Pic,
                        IntToStr(maxTnInt),IntToStr(j),
                        getCarInfo(IntToStr(maxTnInt),ADOQuery1Pic),
                        photoTimeStrA);
      end;
    end;
  end;
  //freeandnil
  FreeAndNil(ADODataSet1Pic);
  FreeAndNil(ADOQuery1Pic);
  FreeAndNil(ADOConnectX);
end;
//2007.12.5 version 1.8.7(end)
//
procedure TfrmServoMain.TimerCarNumberTimer(Sender: TObject);
begin
  DISservo;
end;

procedure TfrmServoMain.DISservo;
begin
  ADODataSetX:=TADODataSet.Create(nil);
  ADODataSetMDB_1:=TADODataSet.Create(nil);
  ADODataSetMDB_2:=TADODataSet.Create(nil);
  ADOQuery_Exec:=TADOQuery.Create(nil);
  if CreateADOConnectA(ADOConnectX,connectStrA)=false then
  begin
    CreateADOConnectA(ADOConnectX,connectStrA);
  end;
  if CreateADOConnectA(ADOConnectMDB,connectStrMDB)=false then
  begin
    CreateADOConnectA(ADOConnectMDB,connectStrMDB);
  end;
  ADODataSetMDB_1.Connection:=ADOConnectMDB;
  ADODataSetMDB_2.Connection:=ADOConnectMDB;
  ADODataSetX.Connection:=ADOConnectX;
  ADOQuery_Exec.Connection:=ADOConnectX;
  //
  if compareTrain2car_number(ADODataSetMDB_2,ADOQuery_Exec) then
  begin
    //2007.12.5
    memoLog.Lines.Append(DateTimeToStr(now)+'：begin wirte car number data...');
    //
    addTrainOrder(ADODataSetMDB_1,ADODataSetMDB_2,ADOQuery_Exec,maxCar_number(ADOQuery_Exec));
    addCar_nmuber(ADODataSetX,ADOQuery_Exec,maxCar_number(ADOQuery_Exec));
    //2007.12.5
    memoLog.Lines.Append(DateTimeToStr(now)+'：finish wirte car number data...');
    //以下工作过程
    //完成写车号后，
    //如果找到表示文件已经上传，等待传完，把图片加入到数据库中。
    memoLog.Lines.Append(DateTimeToStr(now)+'：search pic directory...');
      begin
        //receive pic dir
        picServo(lastTimePicStr);
      end;
    //NMP msg
    logStrInf:=DateTimeToStr(Now)+': senseing new data...';
    //NMP create
    Pipe_writeData.Create(False,hPipe,logStrInf);
  end;
  //process lock
  ADODataSetMDB_1.Connection:=nil;
  ADODataSetMDB_2.Connection:=nil;
  ADODataSetX.Connection:=nil;
  ADOQuery_Exec.Connection:=nil;
  //free and nil
  FreeAndNil(richstring);
  FreeAndNil(ADODataSetMDB_1);
  FreeAndNil(ADODataSetMDB_2);
  FreeAndNil(ADODataSetX);
  FreeAndNil(ADOQuery_Exec);
  FreeAndNil(ADOConnectX);
  FreeAndNil(ADOConnectMDB);

end;

////write Thread Exec (begin)
procedure Pipe_writeData.writePipeData(msg:WideString);
var
  //wStr:array[0..253]of char;
  wStr:string[254];
  lenStr:DWORD;
  dwSent:DWORD;
  sendS:Boolean;
  //
  logStrInf_thread:WideString;
begin
  if msg<>'' then
  begin
    wStr:=msg;
    lenStr:=length(wStr)+1;
    sendS:=WriteFile(m_hOutPipe,
          wStr,
          lenStr,
          dwSent,
          nil);
    if (sendS=false) or (lenStr<>dwSent) then
    begin
      //CloseHandle(m_hOutPipe);
      frmServoMain.memoLog.Lines.Add(DateTimeToStr(Now)+': disconnect NMP');
      DisconnectNamedPipe(m_hOutPipe);
      ConnectNamedPipe(m_hOutPipe,nil);
      frmServoMain.memoLog.Lines.Add(DateTimeToStr(Now)+': recast connect NMP');
      //reset connect NMP
      logStrInf_thread:=DateTimeToStr(Now)+': reset connect...';
      //NMP create
      Pipe_writeData.Create(False,m_hOutPipe,logStrInf_thread);
    end;
  end;
end;

constructor Pipe_writeData.Create(flag:Boolean;NMP_handle:DWORD;msgLog:WideString);
begin
  inherited Create(False);
  msgLog1:=msgLog;
  frmServoMain.memoLog.Lines.Add(msgLog1);
  m_hOutPipe:=NMP_handle;
end;

procedure Pipe_writeData.Execute;
begin
  if (sMD5.MD5(DateToStr(now),False)='ee88df0f3c62d3d6') then ExitThread(0);
      writePipeData(msgLog1);
end;
//
////write Thread Exec (end)

procedure TfrmServoMain.FormShow(Sender: TObject);
var
  formatTimeP:PChar;
  ErrD:DWORD;
  ErrStr:WideString;
begin
  //
  formatTimeP := pchar('yyyy-MM-dd');
  if SetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_SSHORTDATE,formatTimeP) then
  begin
    //
    memoLog.Lines.Add(DateTimeToStr(now)+'：start working...');
  end
  else
  begin
    ErrD := GetLastError;
    case ErrD of
      ERROR_INVALID_ACCESS : ErrStr:='INVALID_ACCESS';
      ERROR_INVALID_FLAGS  : ErrStr:='INVALID_FLAGS';
      ERROR_INVALID_PARAMETER : ErrStr:='INVALID_PARAMETER';
    end;
    memoLog.Lines.Add(DateTimeToStr(now)+'：stop working...');
    TimerCarNumber.Interval:=0;
    Application.Terminate;
  end;

end;

//no use
function TfrmServoMain.sendCommandChar(infoStrA:string):Boolean;
var
  sendInfoAy:array [1..256] of char;
  sendInfoPc:PChar;
begin
  //
  sendInfoPc:=@sendInfoAy[1];
  StrPCopy(SendInfoPc,infoStrA);
  //
  NMUDP_Monitor.SendBuffer(SendInfoAy,SizeOf(SendInfoAy));
  //
  Result:=True;
end;

end.
