unit uPicProcess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ToolWin, ComCtrls, DBCtrls, DB,
  ADODB, ieview, imageenview, dbimageen, jpeg ,uLoadSaveImg, frxClass,
  ievect, dbimageenvect, imageen, Menus;

type
  TfrmCarDetail = class(TForm)
    pnlBottom: TPanel;
    pnlMain: TPanel;
    pnlLeft: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    sctSN: TStaticText;
    sctCarNum: TStaticText;
    sctCarM: TStaticText;
    sctPastTime: TStaticText;
    btnPrintPic: TButton;
    btnBadCarFlag: TButton;
    pnlPicMain: TPanel;
    Timer1: TTimer;
    ADOCommand1: TADOCommand;
    sctBadCar: TStaticText;
    Label5: TLabel;
    ADODataSet1readPic: TADODataSet;
    DataSource1: TDataSource;
    pnlPicHint: TPanel;
    Label_point: TLabel;
    ADOQueryJPEG2BMP: TADOQuery;
    ADOQueryJPEG2BMPpic_jpg: TBlobField;
    Image1: TImage;
    frxReport1: TfrxReport;
    ImageMain: TImageEnDBView;
    Image2: TImage;
    pnlPicControl: TPanel;
    btnCut2paste: TButton;
    btnClip: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintPicClick(Sender: TObject);
    procedure btnBadCarFlagClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCut2pasteClick(Sender: TObject);
    procedure btnClipClick(Sender: TObject);
  private
    int22,int11,int12,int13:Integer;
    //
    clipFlag:Boolean;
    { Private declarations }
  public
    tempPathA:Pchar;
    tempFileA,tempFileB:WideString;
    function findPicRec(seriaryNumberStrA,pastTimeStrA:WideString):Integer;
    function viewPicJPEG:Boolean;
    { Public declarations }
  end;

var
  frmCarDetail: TfrmCarDetail;

implementation
  uses
    Udispatch;
{$R *.dfm}

procedure TfrmCarDetail.Timer1Timer(Sender: TObject);
begin
  if ImageMain.Visible then
  begin
    Timer1.Interval:=0;
    pnlPicHint.Visible:=False;
    BorderIcons:=[biSystemMenu, biMaximize];
    Exit;
  end;
  
  int22:=int11+int12+int13;
  case int22 of
  
    5:
    begin
      Label_point.Caption:='.';
      int11:=2;
      int12:=0;
      int13:=0;
      //
      if sctPastTime.Caption='' then
                Application.MessageBox('没有过车时间，车号信息不完整！不能读取车号图片。',
                        'hint',MB_OK);
      //
      Exit;
    end;
    2:
    begin
      Label_point.Caption:='..';
      int11:=0;
      int12:=3;
      int13:=0;
      //      
      Exit;
    end;
    3:
    begin
      Label_point.Caption:='...';
      int11:=0;
      int12:=0;
      int13:=5;
      //      
      Exit;
    end;

  end;
end;

function TfrmCarDetail.findPicRec(seriaryNumberStrA,pastTimeStrA:WideString):Integer;
begin
  ADODataSet1readPic.Close;
  ADODataSet1readPic.CommandText:='select pic_jpg from photoTable where past_time='
                                        +''''+pastTimeStrA+''''
                                        +' and seriary_number='
                                        +''''+seriaryNumberStrA+'''';
  ADODataSet1readPic.Open;

  Result:=ADODataSet1readPic.RecordCount;
end;

procedure TfrmCarDetail.FormShow(Sender: TObject);
begin
  //
  int11:=0;
  int12:=0;
  int13:=5;
  //
  viewPicJPEG;
end;

procedure TfrmCarDetail.FormCreate(Sender: TObject);
begin
  //
  BorderIcons:=[biSystemMenu];
end;

procedure TfrmCarDetail.btnPrintPicClick(Sender: TObject);
var
  MemoSN,MemoCarNum,MemoCarMarque:TfrxMemoView;
  MemoPastTime,MemoCarCondition:TfrxMemoView;
  MemoUserName,MemoPrintTime:TfrxMemoView;
  //
  PictureCar:TfrxPictureView;
  PictureBadPoint:TfrxPictureView;
  //
  jpeg:TJPEGImage;
begin
  GetMem(tempPathA,255);
  GetTempPath(255,tempPathA);
  tempFileA:=tempPathA+'printTemp01.jpg';
  tempFileB:=tempPathA+'printTemp02.jpg';
  Image1.Picture.SaveToFile(tempFileA);
  //bmp2jpg
  try
    jpeg := Tjpegimage.Create;// 动态创建Tjpegimage对象
    jpeg.Assign(image2.Picture.Bitmap);
    jpeg.SaveToFile(ChangeFileExt(tempFileB,'.jpg'));// 保存jpeg
  finally
    jpeg.Free;
    // 释放jpeg
  end;
  //evaluation(begin)
  MemoSN:= frxReport1.FindObject('MemoSN') as TfrxMemoView;
  MemoSN.Memo.Clear;
  MemoSN.Memo.Add('辆    序：'+sctSN.Caption);

  //
  MemoCarNum:= frxReport1.FindObject('MemoCarNum') as TfrxMemoView;
  MemoCarNum.Memo.Clear;
  MemoCarNum.Memo.Add('车    号：'+sctCarNum.Caption);

  //
  MemoCarMarque:= frxReport1.FindObject('MemoCarMarque') as TfrxMemoView;
  MemoCarMarque.Memo.Clear;
  MemoCarMarque.Memo.Add('车    型：'+sctCarM.Caption);

  //
  MemoPastTime:= frxReport1.FindObject('MemoPastTime') as TfrxMemoView;
  MemoPastTime.Memo.Clear;
  MemoPastTime.Memo.Add('过车时间：'+sctPastTime.Caption);

  //MemoCarCondition
  if sctBadCar.Caption<>'' then
  begin
    MemoCarCondition:= frxReport1.FindObject('MemoCarCondition') as TfrxMemoView;
    MemoCarCondition.Memo.Clear;
    MemoCarCondition.Memo.Add('车辆状况：'+sctBadCar.Caption);
  end;

  //MemoUserName
  MemoUserName:= frxReport1.FindObject('MemoUserName') as TfrxMemoView;
  MemoUserName.Memo.Clear;
  MemoUserName.Memo.Add('值班员：'+pnlMain.Caption);

  //MemoPrintTime
  MemoPrintTime:= frxReport1.FindObject('MemoPrintTime') as TfrxMemoView;
  MemoPrintTime.Memo.Clear;
  MemoPrintTime.Memo.Add('打印时间：'+DateTimeToStr(now));
  //car view
  PictureCar:=frxReport1.FindObject('PictureCar') as TfrxPictureView;
  PictureCar.Picture.LoadFromFile(tempFileA);
  //bad point view
  PictureBadPoint:=frxReport1.FindObject('PictureBadPoint') as TfrxPictureView;
  PictureBadPoint.Picture.LoadFromFile(tempFileB);  
  //evaluation(end)

  frxReport1.ShowReport(False);
end;

procedure TfrmCarDetail.btnBadCarFlagClick(Sender: TObject);
begin
  //
  try
    ADOCommand1.CommandText:='update trainOrder set badFlag=0 where sn='
                                  +pnlPicMain.Caption;
    ADOCommand1.Execute;
    //
    sctBadCar.Caption:='破损车';
  except
    Application.MessageBox('标记失败，请确认没有其他数据操作！','hint',MB_OK);
    Exit;
  end;
end;

function TfrmCarDetail.viewPicJPEG:Boolean;
var
  TS: TMemoryStream;
  LSI: TLSImg;
begin
  with ADODataSet1readPic do
  begin
    if not Eof then
    begin
      LSI := TLSImg.Create;
      TS := TMemoryStream.Create;
      (FieldByName('pic_jpg') as TBlobField).SaveToStream(TS);
      LSI.LoadFromStream(TS);
      Image1.Picture := LSI.Picture;
      TS.Free;
      LSI.Free;
    end;
  end;
  //
  Result:=True;
end;

procedure TfrmCarDetail.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //
  if FileExists(tempFileA) or FileExists(tempFileB) then
  begin
    if not DeleteFile(tempFileA) or not DeleteFile(tempFileB) then Action:=caNone;
  end;
end;

procedure TfrmCarDetail.btnCut2pasteClick(Sender: TObject);
begin
  //
  ImageMain.CopySelectionToBitmap(Image2.Picture.Bitmap);
  //Image2.Picture.Bitmap.SaveToFile('c:\t111.bmp');
end;

procedure TfrmCarDetail.btnClipClick(Sender: TObject);
begin
  //
  if clipFlag then
  begin
    ImageMain.MouseInteract:=[miZoom,miScroll];
    btnClip.Caption:='使用剪图(&C)';
  end
  else
  begin
  //
    ImageMain.MouseInteract:=[miZoom,miSelectLasso];
    btnClip.Caption:='不使用剪图(&C)';
    btnCut2paste.Enabled:=True;
    clipFlag:=True;
  end;
end;

end.
