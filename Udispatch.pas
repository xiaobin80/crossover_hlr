unit Udispatch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, StrUtils, Grids, DBGrids, Menus, DB, ADODB,
  Mask, DBCtrls, IniFiles, ShellApi,ComObj, uPublicFuncMain, ActiveX;

type
  Thread_readLog = class(TThread)
  private
    m_hInPipe:THandle;
    { Private declarations }
  protected
    procedure readPipeData;
    procedure Execute; override;
    
  end;

const  
  //跟服务端值一样下面我们注册对象，依这个值向注册表寻找guid值
  Class_CprintSupport: TGUID = '{6D380B4D-1B5C-4246-8587-F64C59158963}';

type
  //com
  Iprinter= interface['{14EC88EC-9F6F-449F-BEAC-3A3BF2837A58}']//这个ID是接口Iprinter
  function checkPrinterStatus(LPTPort:word):Byte;stdcall;//safecall
  function testFunc(inputVal:Integer):integer;stdcall;   //safecall

  end;

type
  Tfrm_main = class(TForm)
    Panel1: TPanel;
    StatusBarMain: TStatusBar;
    Panel2: TPanel;
    Memo_04: TMemo;
    Memo_02: TMemo;
    Memo_07: TMemo;
    Panel3: TPanel;
    pnlDBGrid: TPanel;
    SplitterMain: TSplitter;
    Panel5: TPanel;
    Label1: TLabel;
    Panel6: TPanel;
    btn_print: TButton;
    DataSource1: TDataSource;
    Popup2: TPopupMenu;
    expExcel: TMenuItem;
    N10: TMenuItem;
    N12: TMenuItem;
    Memo_station04: TMemo;
    Memo_station05: TMemo;
    ADOQuery_temp1: TADOQuery;
    ADOQuery_Exec: TADOQuery;
    ADODataSet_carNumber: TADODataSet;
    ADOtrainOrder: TADODataSet;
    DBGrid1: TDBGrid;
    TreeViewMain: TTreeView;
    ADODataSet2: TADODataSet;
    ADODataSet1: TADODataSet;
    ADOtrainOrdertrain_number: TIntegerField;
    ADOtrainOrderseriary_number: TIntegerField;
    ADOtrainOrdercar_number: TStringField;
    ADOtrainOrdercar_marque: TStringField;
    ADOtrainOrdercarry_weight1: TBCDField;
    ADOtrainOrderself_weight1: TBCDField;
    ADOtrainOrderpast_time: TWideStringField;
    ADOtrainOrderoutFlag: TWideStringField;
    ADOtrainOrderbadFlag: TBooleanField;
    ADOtrainOrdersn: TAutoIncField;
    ADOConnection1: TADOConnection;
    btnSearch: TButton;
    procedure N4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_printClick(Sender: TObject);
    procedure TreeViewMainClick(Sender: TObject);
    procedure SplitterMainPaint(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure expExcelClick(Sender: TObject);
  private
    execpath:string;
    xlsPath:string;
    //
    operatorNameStr:WideString;
    printerStatusInt:Integer;
    procedure appAgent(sender:TObject);
    { Private declarations }
  public
    mineCountINT:Integer;
    mineSTR1,mineSTR2,mineSTR3:string;
    //2007.12.2
    date_selected:WideString;
    reference_date:WideString;
    CDP_INI:TIniFile;
    //
    FuncPrinter:Iprinter;
    //2007.3.5
    function GetDest(pTimeStrA:WideString):WideString;
    //function RefreshPastTimeList(comboBoxX:TComboBox):Integer;
    function viewDataTrain(pTimeStrA:WideString):Integer;
    //
    procedure treeDelete;
    function treeCreate:WideString;
    function treeRefresh(yearStrA,monthStrA:WideString;nowNode:TTreeNode):WideString;
    function exportExcel_ord(time_rportStrA:WideString):Boolean;

    { Public declarations }
  end;

type
  Tpro_saveFCN=procedure(saveFile1,CheckFilePath:WideString);stdcall;

const
  rootName='AEI01';
  
var
  frm_main: Tfrm_main;

  saveFCNA:Tpro_saveFCN;
  //
  handlers:string;
  xbf:string;
  //2007.12.3
  myExcelApp:Variant;
  
implementation
uses
  Ulogin,u_about,Udatatotal,uPicProcess;

function readXBF(DimRecord: Integer;filename1:WideString):WideString;stdcall;
                        external 'XBFGenerate.dll';

function connectNMP:DWORD;stdcall;
     external 'npSupport.dll';
     
{$R *.dfm}

//2007.12.2
procedure Tfrm_main.appAgent(sender:TObject);
begin
  StatusBarMain.Panels[0].Text:=Application.Hint;
end;

function Tfrm_main.treeCreate:WideString;
var
  //
  Level2TV,Level3TV:TADOQuery;
  yearStr,monthStr:WideString;
  //
  nowNode,rootNode,lnNode:TTreeNode;
begin
  rootNode:=TreeViewMain.Items.Add(nil,rootName);
  //2008.1.1
  Level2TV:=TADOQuery.Create(Self);
  Level2TV.Connection:=ADOConnection1;
  Level3TV:=TADOQuery.Create(Self);
  Level3TV.Connection:=ADOConnection1;
  //
  Level2TV.Close;
  Level2TV.SQL.Clear;
  Level2TV.SQL.Text:='select DISTINCT year_level2 from trainOrder order by year_level2';
  Level2TV.Open;
  //
  nowNode:=rootNode;
  yearStr:=Level2TV.Fields[0].AsString;
  while not Level2TV.Eof do
  begin
    nowNode:=TreeViewMain.Items.AddChild(nowNode,yearStr);
    //
    lnNode:=nowNode;
    Level3TV.Close;
    Level3TV.SQL.Clear;
    Level3TV.SQL.Text:='select DISTINCT month_level3 from trainOrder where year_level2='
                  +''''+yearStr+''''
                  +' order by month_level3';
    Level3TV.Open;
    //
    monthStr:=Level3TV.Fields[0].AsString;
    while not Level3TV.Eof do
    begin
      lnNode:=TreeViewMain.Items.AddChild(lnNode,monthStr);
      //
      Result:= treeRefresh(yearStr,monthStr,lnNode);
      Level3TV.Next;
    end;
    //
    Level2TV.Next;
  end;
  //freeAndNil
  FreeAndNil(Level2TV);
  FreeAndNil(Level3TV);
  //

end;

procedure Tfrm_main.treeDelete;
var
  rootNode:TTreeNode;
begin
  rootNode:=TreeViewMain.Items.GetFirstNode;
  TreeViewMain.Items.Delete(rootNode);
end;

function Tfrm_main.treeRefresh(yearStrA,monthStrA:WideString;nowNode:TTreeNode):WideString;
var
  iRec:integer;
  nodeCount1:integer;
  //
  RefreshTV:TADOQuery;
  //
  lnNode:TTreeNode;
  //retrun
  retWStr:WideString;
begin
//
  RefreshTV:=TADOQuery.Create(Self);
  RefreshTV.Connection:=ADOConnection1;
  //
  RefreshTV.Close;
  RefreshTV.SQL.Clear;
  RefreshTV.SQL.Text:='select DISTINCT past_time from trainOrder'
                +' where year_level2='
                +''''+yearStrA+''''
                +' and month_level3='
                +''''+monthStrA+''''
                +' order by past_time';
  RefreshTV.Open;

  nodeCount1:=RefreshTV.RecordCount;
  for iRec:=1 to nodeCount1 do
  begin
    retWStr:=RefreshTV.Fields[0].AsString;
    TreeViewMain.Items.AddChild(nowNode,retWStr);
    RefreshTV.Next;
  end;
  //expand node
  lnNode:=TreeViewMain.Items.GetFirstNode;
  while lnNode<>nil do
  begin
    lnNode.Expand(False);
    lnNode:=lnNode.getNextSibling;
  end;
  //
  FreeAndNil(RefreshTV);
  Result:=retWStr;
end;

function Tfrm_main.viewDataTrain(pTimeStrA:WideString):Integer;
var
  recI2:Integer;
begin
  ADODataSet2.Close;
  ADODataSet2.CommandText:='select train_number,seriary_number,car_number,car_marque,'
                        +'carry_weight1,self_weight1,past_time,outFlag,sn'
                        +' from trainOrder where past_time='
                        +''''+pTimeStrA+''''
                        +' order by seriary_number';
  ADODataSet2.Open;

  recI2:=ADODataSet2.RecordCount;
  Result:=recI2;
end;

//

procedure Tfrm_main.FormCreate(Sender: TObject);
var
  configini:string;
  frmCaptionStr:WideString;
begin
  execpath:=ExtractFilePath(ParamStr(0));
  configini:=execpath+'CDPconfig.ini';
  CDP_INI:=TIniFile.Create(configini);
  xlsPath:=execpath+'excelFile\';
  
  if not DirectoryExists(xlsPath)then
  begin
    Application.MessageBox('丢失CDP系统文件,部分功能不能使用！','HINT',MB_OK);
    expExcel.Enabled:=False;
  end;
  //
  frmCaptionStr:=CDP_INI.ReadString('title','1','未知单位');
  frm_main.Caption:=frmCaptionStr;
  //建立com对象实例
  CoCreateInstance(Class_CprintSupport,
                        nil,
                        CLSCTX_INPROC_SERVER,
                        Iprinter,
                        FuncPrinter);


  //
  try
    ADOConnection1.Close;
    ADOConnection1.ConnectionString:=readXBF(-1,xbf);
    ADOConnection1.Open;
   Except
     Application.MessageBox('数据库位置不对！','提示',MB_OK+MB_ICONINFORMATION);
     Exit;
   end;

end;

procedure Tfrm_main.FormShow(Sender: TObject);
begin
  //check printer
  try
    printerStatusInt:= FuncPrinter.checkPrinterStatus(1);
    case printerStatusInt of
      1:
        begin
          StatusBarMain.Panels[4].Text:='打印机-超时';
        end;
      8:
        begin
          StatusBarMain.Panels[4].Text:='打印机-I/O错误';
        end;
      16:
        begin
          StatusBarMain.Panels[4].Text:='打印机未联机';
        end;
      32:
        begin
          StatusBarMain.Panels[4].Text:='打印机缺纸';
        end;
      128:
        begin
          StatusBarMain.Panels[4].Text:='打印机空闲';
        end;
      176:
        begin
          StatusBarMain.Panels[4].Text:='打印机未连接';
        end;
        0:
        begin
          StatusBarMain.Panels[4].Text:='打印机工作正常';
          btn_print.Enabled:=True;
          pnlDBGrid.Caption:='1';
        end;
    end;
  except

  end;
  //
  ADODataSet1.Close;
  ADODataSet1.CommandText:='select OperName from operator where OperID='+opertor;
  ADODataSet1.Open;

  operatorNameStr:=ADODataSet1.Fields[0].AsString;
  StatusBarMain.Panels[2].Text:='货运员:'+operatorNameStr;
  StatusBarMain.Panels[3].Text:='登录时间：'+RightStr(DateTimeToStr(Time),8);
  //application hint
  Application.OnHint:=appAgent;
  //treeview
  reference_date:=treeCreate;
  viewDataTrain(reference_date);
  normGridColWidth(DBGrid1,80);
  //
  exportExcel_ord(reference_date);
  //read thread
  Thread_readLog.Create(False);
end;

function Tfrm_main.GetDest(pTimeStrA:WideString):WideString;
begin
  ADOQuery_Exec.Close;
  ADOQuery_Exec.SQL.Clear;
  ADOQuery_Exec.SQL.Text:='select outFlag from trainOrder where past_time='
                        +''''+pTimeStrA+'''';
  ADOQuery_Exec.Open;

  Result:=ADOQuery_Exec.Fields[0].AsString;
end;

procedure Tfrm_main.TreeViewMainClick(Sender: TObject);
var
  //
  recordcountI:integer;
  destinationStr:WideString;
begin
//
  if TreeViewMain.Selected.Text=rootName then Exit;
  date_selected:=TreeViewMain.Selected.Text;
  recordcountI:=viewDataTrain(date_selected);
  reference_date:=date_selected;
  //
  normGridColWidth(DBGrid1,80);
  StatusBarMain.Panels[0].Text:=IntToStr(recordcountI)+' 条数据';
  //export excel
  exportExcel_ord(date_selected);
  //
  destinationStr:=GetDest(date_selected);
  if destinationStr='up' then
  begin
    StatusBarMain.Panels[1].Text:='过车方向：上行';
  end
  else
  begin
    StatusBarMain.Panels[1].Text:='过车方向：下行';
  end;
end;

//2007.12.2
function Tfrm_main.exportExcel_ord(time_rportStrA:WideString):Boolean;
begin
  ADOtrainOrder.Close;
  ADOtrainOrder.CommandText:='select *'
                        +' from trainOrder where past_time='+''''+time_rportStrA+''''
                        +' order by seriary_number';
  ADOtrainOrder.Open;
  //
  Result:=True;
end;

procedure Tfrm_main.SplitterMainPaint(Sender: TObject);
begin
  if SplitterMain.MinSize<668 then
  begin
    SplitterMain.MinSize:=668;
  end;
end;

procedure Tfrm_main.DBGrid1DblClick(Sender: TObject);
var
  snCarStr,carNumStr,carMarqueStr:WideString;
  idStr:WideString;
begin
  //
  snCarStr:=DBGrid1.Fields[0].AsString;
  carNumStr:=DBGrid1.Fields[1].AsString;
  carMarqueStr:=DBGrid1.Fields[2].AsString;
  idStr:=ADOtrainOrder.fieldByName('sn').AsString;
  //
  frmCarDetail:=TfrmCarDetail.Create(Application);
  frmCarDetail.sctSN.Caption:=snCarStr;
  frmCarDetail.sctCarNum.Caption:=carNumStr;
  frmCarDetail.sctCarM.Caption:=carMarqueStr;
  frmCarDetail.sctPastTime.Caption:=date_selected;

  frmCarDetail.pnlMain.Caption:=operatorNameStr;
  frmCarDetail.pnlPicMain.Caption:=idStr;
  //
  if frmCarDetail.findPicRec(snCarStr,date_selected)=1 then
  begin
    frmCarDetail.pnlPicHint.Visible:=False;
    frmCarDetail.ImageMain.Visible:=True;
  end
  else
  begin
    Application.MessageBox('没有找到车号图片！','hint',MB_OK);
    Exit;
  end;
  //
  //if pnlDBGrid.Caption='0' then frmCarDetail.btnPrintPic.Enabled:=False;
  //
  frmCarDetail.Update;
  frmCarDetail.ShowModal;
end;

procedure Tfrm_main.expExcelClick(Sender: TObject);
var
  i:Integer;
begin
  //
  myExcelApp:=CreateOleObject('Excel.Application');
  myExcelApp.Visible:=True;
  myExcelApp.WorkBooks.Open(execpath+'excelFile\crossBook1.xls');
  //
  myExcelApp.WorkSheets[1].Activate;
  //init
  ADOtrainOrder.First;
  //
  while not ADOtrainOrder.Eof do
  begin
    //past time
    myExcelApp.Cells[6,14].Value:='过车时间：'+reference_date;
    //第一列车号(1~13)
    for  i:=9  to 21 do
    begin
      if ADOtrainOrder.Eof then Exit;
      //
      myExcelApp.Cells[i,2].Value:=ADOtrainOrder.FieldByName('car_number').AsString;
      ADOtrainOrder.Next;
    end;
    //第二列车号(14~26)
    for  i:=9  to 21 do
    begin
      if ADOtrainOrder.Eof then Exit;
      //
      myExcelApp.Cells[i,4].Value:=ADOtrainOrder.FieldByName('car_number').AsString;
      ADOtrainOrder.Next;
    end;
    //第三列车号(27~39)
    for  i:=9  to 21 do
    begin
      if ADOtrainOrder.Eof then Exit;
      //
      myExcelApp.Cells[i,6].Value:=ADOtrainOrder.FieldByName('car_number').AsString;
      ADOtrainOrder.Next;
    end;
    //第四列车号(40~52)
    for  i:=9  to 21 do
    begin
      if ADOtrainOrder.Eof then Exit;
      //    
      myExcelApp.Cells[i,9].Value:=ADOtrainOrder.FieldByName('car_number').AsString;
      ADOtrainOrder.Next;
    end;
    //第五列车号(53~65)
    for  i:=9  to 21 do
    begin
      if ADOtrainOrder.Eof then Exit;
      //    
      myExcelApp.Cells[i,11].Value:=ADOtrainOrder.FieldByName('car_number').AsString;
      ADOtrainOrder.Next;
    end;
    //第六列车号(66~78)
    for  i:=9  to 21 do
    begin
      if ADOtrainOrder.Eof then Exit;
      //      
      myExcelApp.Cells[i,13].Value:=ADOtrainOrder.FieldByName('car_number').AsString;
      ADOtrainOrder.Next;
    end;

  end;//while end; 

end;

procedure Tfrm_main.btn_printClick(Sender: TObject);
begin
  //
  GridPrintA(ADOtrainOrder,DBGrid1);
end;

procedure Tfrm_main.btnSearchClick(Sender: TObject);
begin
  frm_sa:=Tfrm_sa.Create(Application);
  //
  frm_sa.ADOConnection1.ConnectionString:=ADOConnection1.ConnectionString;
  if pnlDBGrid.Caption='0' then frm_sa.btn_print2.Enabled:=False;
  frm_sa.Update;
  frm_sa.ShowModal;
end;

procedure Tfrm_main.N4Click(Sender: TObject);
begin
  frm_about:=Tfrm_about.Create(Application);
  frm_about.Update;
  frm_about.ShowModal;
end;

procedure Tfrm_main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CDP_INI.Destroy;
  ADOQuery_temp1.Close;
  ADOQuery_temp1.SQL.Clear;
  ADOQuery_temp1.SQL.Text:='update operator set preserve1=0 where OperID='+opertor;
  ADOQuery_temp1.ExecSQL;  
end;

///////////////////////////////////////////////////THREAD
procedure Thread_readLog.readPipeData;
var
  readSuccess:Boolean;
  readBuf:array[0..253]of char;
  cbBytesRead:DWORD;
  //msg
  msgStr:WideString;
  msgLen:integer;
begin
  //
  readBuf:='';
  readSuccess:= ReadFile(m_hInPipe,
      readBuf,
      254,
      cbBytesRead,
      nil);
  if readSuccess=true then
  begin
   if readBuf<>'' then
   begin
     msgStr:=readBuf;
     msgLen:=length(msgStr);
     msgStr:=RightStr(msgStr,msgLen-1);
     frm_main.StatusBarMain.Panels[4].Text:=msgStr;
     //refresh tree
     frm_main.treeDelete;
     frm_main.reference_date:=frm_main.treeCreate;
     frm_main.viewDataTrain(frm_main.reference_date);
     normGridColWidth(frm_main.DBGrid1,80);
     frm_main.exportExcel_ord(frm_main.reference_date);
     //frm_main.cmbox_pTime.ItemIndex:=frm_main.RefreshPastTimeList(frm_main.cmbox_pTime);
     //frm_main.currentPtimeStr:=frm_main.cmbox_pTime.Text;
     //frm_main.viewDataTrain(frm_main.currentPtimeStr);
   end;
  end;
end;

procedure Thread_readLog.Execute;
begin
  m_hInPipe:=connectNMP;
  while m_hInPipe<>0 do
  begin
    readPipeData;
  end;
end;


end.
