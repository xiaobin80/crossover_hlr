object frmCarDetail: TfrmCarDetail
  Left = 299
  Top = 136
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = #36710#36742#35814#32454#20449#24687
  ClientHeight = 473
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 416
    Width = 800
    Height = 57
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnPrintPic: TButton
      Left = 8
      Top = 16
      Width = 75
      Height = 25
      Caption = #25171#21360
      TabOrder = 0
      OnClick = btnPrintPicClick
    end
    object btnBadCarFlag: TButton
      Left = 96
      Top = 16
      Width = 75
      Height = 25
      Caption = #26631#35760#22351#36710
      TabOrder = 1
      OnClick = btnBadCarFlagClick
    end
    object pnlPicControl: TPanel
      Left = 504
      Top = 0
      Width = 296
      Height = 57
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      DesignSize = (
        296
        57)
      object btnCut2paste: TButton
        Left = 200
        Top = 16
        Width = 89
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #21098#20999#24182#31896#36148'(&P)'
        Enabled = False
        TabOrder = 0
        OnClick = btnCut2pasteClick
      end
      object btnClip: TButton
        Left = 95
        Top = 16
        Width = 89
        Height = 25
        Anchors = [akTop, akRight]
        Caption = #20351#29992#21098#22270'(&C)'
        TabOrder = 1
        OnClick = btnClipClick
      end
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 416
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlMain'
    TabOrder = 1
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 177
      Height = 416
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 12
        Top = 38
        Width = 39
        Height = 13
        Caption = #36742#24207#65306
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 12
        Top = 82
        Width = 39
        Height = 13
        Caption = #36710#21495#65306
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 12
        Top = 127
        Width = 39
        Height = 13
        Caption = #36710#22411#65306
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 12
        Top = 171
        Width = 39
        Height = 13
        Caption = #26102#38388#65306
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 12
        Top = 216
        Width = 39
        Height = 13
        Caption = #29366#20917#65306
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Image1: TImage
        Left = 8
        Top = 240
        Width = 153
        Height = 145
        Visible = False
      end
      object sctSN: TStaticText
        Left = 50
        Top = 38
        Width = 121
        Height = 17
        AutoSize = False
        Caption = '38'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object sctCarNum: TStaticText
        Left = 50
        Top = 82
        Width = 121
        Height = 17
        AutoSize = False
        Caption = '4846798'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object sctCarM: TStaticText
        Left = 50
        Top = 127
        Width = 121
        Height = 17
        AutoSize = False
        Caption = 'C64K'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object sctPastTime: TStaticText
        Left = 50
        Top = 171
        Width = 121
        Height = 17
        AutoSize = False
        Caption = '2007-12-15 10:30'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object sctBadCar: TStaticText
        Left = 50
        Top = 216
        Width = 113
        Height = 17
        AutoSize = False
        Font.Charset = GB2312_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
    end
    object pnlPicMain: TPanel
      Left = 177
      Top = 0
      Width = 623
      Height = 416
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
      object Image2: TImage
        Left = 1
        Top = 240
        Width = 621
        Height = 175
        Align = alBottom
      end
      object pnlPicHint: TPanel
        Left = 176
        Top = 208
        Width = 249
        Height = 41
        Caption = #27491#22312#35835#21462#22270#29255#65292#35831#31245#20505
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label_point: TLabel
          Left = 192
          Top = 16
          Width = 55
          Height = 13
          AutoSize = False
        end
      end
      object ImageMain: TImageEnDBView
        Left = 1
        Top = 1
        Width = 621
        Height = 239
        ParentCtl3D = False
        MouseInteract = [miZoom, miScroll]
        ImageEnVersion = '2.1.9'
        Align = alClient
        TabOrder = 1
        DataField = 'pic_jpg'
        DataSource = DataSource1
        DataFieldImageFormat = ifJpeg
        PreviewFont.Charset = DEFAULT_CHARSET
        PreviewFont.Color = clWindowText
        PreviewFont.Height = -11
        PreviewFont.Name = 'MS Sans Serif'
        PreviewFont.Style = []
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 560
    Top = 184
  end
  object ADOCommand1: TADOCommand
    Connection = frm_main.ADOConnection1
    Parameters = <>
    Left = 128
    Top = 400
  end
  object ADODataSet1readPic: TADODataSet
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=123456;Persist Security Info=True;U' +
      'ser ID=sa;Initial Catalog=pubs;Data Source=.'
    CommandText = 'select * from photoTable'
    Parameters = <>
    Left = 376
    Top = 224
  end
  object DataSource1: TDataSource
    DataSet = ADODataSet1readPic
    Left = 376
    Top = 256
  end
  object ADOQueryJPEG2BMP: TADOQuery
    Connection = frm_main.ADOConnection1
    Parameters = <>
    SQL.Strings = (
      'select pic_jpg from photoTable')
    Left = 16
    Top = 400
    object ADOQueryJPEG2BMPpic_jpg: TBlobField
      FieldName = 'pic_jpg'
    end
  end
  object frxReport1: TfrxReport
    Version = '4.4.47'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 39423.9469873032
    ReportOptions.LastChange = 39424.0652640278
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 136
    Top = 16
    Datasets = <>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000
      Width = 1000
    end
    object Page1: TfrxReportPage
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      Orientation = poLandscape
      PaperWidth = 297
      PaperHeight = 210
      PaperSize = 9
      object ReportTitle1: TfrxReportTitle
        Height = 241.88992
        Top = 18.89765
        Width = 1122.52041
        object Memo1: TfrxMemoView
          Align = baCenter
          Left = 427.08689
          Top = 7.55906
          Width = 268.34663
          Height = 37.7953
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -21
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8 = (
            #26462#65089#32224#29831#65086#31887#28103#8451#20229)
          ParentFont = False
          VAlign = vaCenter
        end
        object MemoSN: TfrxMemoView
          Left = 34.01577
          Top = 56.69295
          Width = 204.09462
          Height = 18.89765
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          Memo.UTF8 = (
            '38')
          ParentFont = False
          VAlign = vaCenter
        end
        object MemoCarNum: TfrxMemoView
          Left = 34.01577
          Top = 90.70872
          Width = 204.09462
          Height = 18.89765
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          Memo.UTF8 = (
            '4846798')
          ParentFont = False
          VAlign = vaCenter
        end
        object MemoCarMarque: TfrxMemoView
          Left = 34.01577
          Top = 128.50402
          Width = 204.09462
          Height = 18.89765
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          Memo.UTF8 = (
            'C64K')
          ParentFont = False
          VAlign = vaCenter
        end
        object MemoPastTime: TfrxMemoView
          Left = 34.01577
          Top = 162.51979
          Width = 204.09462
          Height = 18.89765
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          Memo.UTF8 = (
            '2007-12-15 10:30')
          ParentFont = False
          VAlign = vaCenter
        end
        object MemoCarCondition: TfrxMemoView
          Left = 899.52814
          Top = 162.51979
          Width = 192.75603
          Height = 18.89765
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          Memo.UTF8 = (
            #26462#65089#32224#37912#36346#21900':'#26462#65089#32224#38009#57882#12477)
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object PageFooter1: TfrxPageFooter
        Height = 45.35436
        Top = 748.34694
        Width = 1122.52041
        object MemoPrintTime: TfrxMemoView
          Left = 907.0872
          Top = 15.11812
          Width = 204.09462
          Height = 18.89765
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          Memo.UTF8 = (
            '2007-12-15 10:30')
          ParentFont = False
          VAlign = vaCenter
        end
        object MemoUserName: TfrxMemoView
          Left = 695.43352
          Top = 15.11812
          Width = 79.37013
          Height = 18.89765
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = #23435#20307
          Font.Style = []
          Memo.UTF8 = (
            '')
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object ReportSummary1: TfrxReportSummary
        Height = 404.40971
        Top = 321.26005
        Width = 1122.52041
        object PictureCar: TfrxPictureView
          Width = 1122.52041
          Height = 234.33086
          HightQuality = False
        end
        object PictureBadPoint: TfrxPictureView
          Align = baBottom
          Top = 238.11039
          Width = 1122.52041
          Height = 166.29932
          Center = True
          HightQuality = False
        end
      end
    end
  end
end
