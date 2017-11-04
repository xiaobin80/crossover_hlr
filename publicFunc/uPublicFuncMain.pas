unit uPublicFuncMain;

interface

uses
  Windows, DB, DBGrids, Printers, Forms,Classes, SysUtils;

  function RegisterOleFile(strOleFileName:WideString;OleAction:Byte):Boolean;
  function GridPrintA(dataSetA:TDataSet;DBGridA:TDBGrid):Boolean;
  //
  procedure normGridColWidth(dbgridX:TDBGrid;widthInt:integer);
  function GetCDPFileVersion(FileName:String):String;

implementation

function RegisterOleFile(strOleFileName:WideString;OleAction:Byte):Boolean;
type
  TOleRegisterFunction = function : HResult;//注册或卸载函数的原型
var
  hLibraryHandle : THandle;
  hFunctionAddress: TFarProc;//DLL或OCX中的函数句柄，由GetProcAddress返回
  RegFunction : TOleRegisterFunction;//注册或卸载函数指针
begin
  //注册 1
  //卸载 0
  Result :=False;
  hLibraryHandle := LoadLibrary(PCHAR(strOleFileName));
  if (hLibraryHandle > 0) then//DLL或OCX句柄正确
  begin
    try
      //返回注册或卸载函数的指针
      if (OleAction = 1) then//返回注册函数的指针
        hFunctionAddress := GetProcAddress(hLibraryHandle,
                                                pchar('DllRegisterServer'))
      else//返回卸载函数的指针
        hFunctionAddress := GetProcAddress(hLibraryHandle,
                                                pchar('DllUnregisterServer'));
      if (hFunctionAddress <> NIL) then//注册或卸载函数存在
      begin
        RegFunction := TOleRegisterFunction(hFunctionAddress);//获取操作函数的指针
        if RegFunction >= 0 then //执行注册或卸载操作，返回值>=0表示执行成功
        result :=True;
      end;

    finally
      FreeLibrary(hLibraryHandle);
    end;
  end;

end;

function GridPrintA(dataSetA:TDataSet;DBGridA:TDBGrid):Boolean;
const
  LeftBlank=1;
  RightBlank=1;
  TopBlank=1;
  BottomBlank=1;
var
  PointX,PointY:integer;
  PointScale,PrintStep:integer;
  s:string;
  x,y:integer;
  i:integer;
begin

  PointX:=Trunc(GetDeviceCaps(Printer.Handle,LOGPIXELSX)/2.54);
  PointY:=Trunc(GetDeviceCaps(Printer.Handle,LOGPIXELSY)/2.54);

  PointScale:=Trunc(GetDeviceCaps(Printer.Handle,LOGPIXELSY)/Screen.PixelsPerInch+0.5);
  printer.Orientation:=poPortrait;



  printer.Canvas.Font.Name:='宋体';
  printer.canvas.Font.Size:=10;

  s:='xiaobin';
  PrintStep:=printer.canvas.TextHeight(s)+16;

  x:=PointX*LeftBlank;
  y:=PointY*TopBlank;

  if (dataSetA.Active=true) and (dataSetA.RecordCount>0) then
  begin
    printer.BeginDoc;
    dataSetA.First;
    
    while not dataSetA.Eof do
    begin 
      for i:=0 to DBGridA.FieldCount-1 do
      begin
    
        if (x+DBGridA.Columns.Items[i].Width*PointScale)<=(Printer.PageWidth-PointX*RightBlank) then
        begin

          Printer.Canvas.Rectangle(x,y,x+DBGridA.Columns.Items[i].Width*PointScale,y+PrintStep);
          if y=PointY*TopBlank then
            Printer.Canvas.TextOut(x+8,y+8,DBGridA.Columns[i].Title.Caption)
          else
            Printer.Canvas.TextOut(x+8,y+8,DBGridA.Fields[i].asString);
        end;
        x:=x+DBGridA.Columns.Items[i].Width*PointScale;
      end;
      if not (y=PointY*TopBlank) then
        dataSetA.next;
        x:=PointX*LeftBlank;
        y:=y+PrintStep;
      if (y+PrintStep)>(Printer.PageHeight-PointY*BottomBlank) then
      begin
        Printer.NewPage;
        y:=PointY*TopBlank;
      end;
    end;//whil end

    printer.EndDoc;
    dataSetA.First;
  end;//if end

  Result:=True;
end;

//
procedure normGridColWidth(dbgridX:TDBGrid;widthInt:integer);
var
  i1:integer;
begin
  for i1:=0 to dbgridX.Columns.Count-1 do
  begin
    dbgridX.Columns[i1].Title.Alignment:=taCenter;
    dbgridX.Columns[i1].Alignment:=taCenter;
    dbgridX.Columns[i1].Width:=widthInt;
  end;

end;

function GetCDPFileVersion(FileName:String):String;
var
  InfoSize,Wnd:DWORD;
  VerBuf:Pointer;
  VerInfo:^VS_FIXEDFILEINFO;
begin
    Result:='1.0.0.0';
    InfoSize:=GetFileVersionInfoSize(PChar(FileName),Wnd);
    if InfoSize<>0 then
    begin
      GetMem(VerBuf,InfoSize);
      try
        if GetFileVersionInfo(PChar(FileName),Wnd,InfoSize,VerBuf) then
        begin
          VerInfo:=nil;
          VerQueryValue(VerBuf,'\',Pointer(VerInfo),Wnd);
          if VerInfo<>nil then Result:=Format('%d.%d.%d.%d',[VerInfo^.dwFileVersionMS shr 16,
                                                             VerInfo^.dwFileVersionMS and $0000ffff,
                                                             VerInfo^.dwFileVersionLS shr 16,
                                                             VerInfo^.dwFileVersionLS and $0000ffff]);
        end;
      finally
        FreeMem(VerBuf,InfoSize);
      end;

    end;
end;

end.
