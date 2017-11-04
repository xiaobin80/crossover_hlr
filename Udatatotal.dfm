object frm_sa: Tfrm_sa
  Left = 175
  Top = 134
  BorderStyle = bsSingle
  Caption = #25968#25454#27719#24635
  ClientHeight = 521
  ClientWidth = 866
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 866
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Caption = #25968#25454#27719#24635
    Color = clBtnShadow
    Font.Charset = GB2312_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 40
    Width = 866
    Height = 462
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 249
      Height = 462
      Align = alLeft
      Caption = #25628#32034#26465#20214
      TabOrder = 0
      object Label1: TLabel
        Left = 24
        Top = 232
        Width = 52
        Height = 13
        Caption = #30772#25439#36710#65306
      end
      object Label2: TLabel
        Left = 24
        Top = 280
        Width = 39
        Height = 13
        AutoSize = False
        Caption = #36710#21495#65306
      end
      object GroupBox2: TGroupBox
        Left = 24
        Top = 32
        Width = 201
        Height = 161
        Caption = #26085#26399#21306#38388
        TabOrder = 0
        object Label5: TLabel
          Left = 8
          Top = 80
          Width = 13
          Height = 13
          Caption = #33267
        end
        object DateTimePicker1: TDateTimePicker
          Left = 7
          Top = 24
          Width = 186
          Height = 21
          CalAlignment = dtaLeft
          Date = 38776.3856335995
          Time = 38776.3856335995
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkDate
          ParseInput = False
          TabOrder = 0
        end
        object DateTimePicker2: TDateTimePicker
          Left = 7
          Top = 104
          Width = 186
          Height = 21
          CalAlignment = dtaLeft
          Date = 38776.3857612153
          Time = 38776.3857612153
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkDate
          ParseInput = False
          TabOrder = 1
        end
        object DTP_sTime: TDateTimePicker
          Left = 6
          Top = 48
          Width = 186
          Height = 21
          CalAlignment = dtaLeft
          Date = 39147.25
          Time = 39147.25
          Color = clBtnFace
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Kind = dtkTime
          ParseInput = False
          TabOrder = 2
        end
        object DTP_oTime: TDateTimePicker
          Left = 6
          Top = 128
          Width = 186
          Height = 21
          CalAlignment = dtaLeft
          Date = 39147.75
          Time = 39147.75
          Color = clBtnFace
          DateFormat = dfShort
          DateMode = dmComboBox
          Enabled = False
          Kind = dtkTime
          ParseInput = False
          TabOrder = 3
        end
      end
      object pnl_btn: TPanel
        Left = 2
        Top = 419
        Width = 245
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object btn_find: TButton
          Left = 24
          Top = 8
          Width = 75
          Height = 25
          Caption = #25628#32034'(&F)'
          TabOrder = 0
          OnClick = btn_findClick
        end
        object btn_print2: TButton
          Left = 148
          Top = 8
          Width = 75
          Height = 25
          Caption = #25171#21360'(&P)'
          TabOrder = 1
          OnClick = btn_print2Click
        end
      end
      object cmb_badCar: TComboBox
        Left = 80
        Top = 232
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        Items.Strings = (
          #26159
          #21542)
      end
      object edtCarNum: TEdit
        Left = 80
        Top = 280
        Width = 145
        Height = 21
        TabOrder = 3
      end
    end
    object DBGrid2: TDBGrid
      Left = 249
      Top = 0
      Width = 617
      Height = 462
      Align = alClient
      DataSource = DataSource1
      TabOrder = 1
      TitleFont.Charset = GB2312_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'seriary_number'
          Title.Alignment = taCenter
          Title.Caption = #36742#24207
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'car_number'
          Title.Alignment = taCenter
          Title.Caption = #36710#21495
          Width = 128
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'car_marque'
          Title.Alignment = taCenter
          Title.Caption = #36710#22411
          Width = 90
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'carry_weight1'
          Title.Alignment = taCenter
          Title.Caption = #26631#37325
          Width = 90
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'self_weight1'
          Title.Alignment = taCenter
          Title.Caption = #33258#37325
          Width = 90
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'past_time'
          Title.Alignment = taCenter
          Title.Caption = #36807#36710#26102#38388
          Width = 120
          Visible = True
        end>
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 502
    Width = 866
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object DataSource1: TDataSource
    DataSet = ADODataSet1
    Left = 440
    Top = 104
  end
  object ADODataSet1: TADODataSet
    Connection = ADOConnection1
    CursorType = ctStatic
    CommandText = 'select * from trainOrder'
    Parameters = <>
    Left = 400
    Top = 104
    object ADODataSet1train_number: TIntegerField
      FieldName = 'train_number'
    end
    object ADODataSet1seriary_number: TIntegerField
      FieldName = 'seriary_number'
    end
    object ADODataSet1car_number: TStringField
      FieldName = 'car_number'
      Size = 30
    end
    object ADODataSet1car_marque: TStringField
      FieldName = 'car_marque'
      Size = 30
    end
    object ADODataSet1carry_weight1: TBCDField
      FieldName = 'carry_weight1'
      Precision = 9
      Size = 3
    end
    object ADODataSet1self_weight1: TBCDField
      FieldName = 'self_weight1'
      Precision = 9
      Size = 3
    end
    object ADODataSet1past_time: TWideStringField
      FieldName = 'past_time'
      Size = 50
    end
    object ADODataSet1outFlag: TWideStringField
      FieldName = 'outFlag'
      Size = 50
    end
    object ADODataSet1badFlag: TBooleanField
      FieldName = 'badFlag'
    end
    object ADODataSet1sn: TAutoIncField
      FieldName = 'sn'
      ReadOnly = True
    end
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Left = 248
    Top = 8
  end
  object FindData: TADODataSet
    Connection = ADOConnection1
    Parameters = <>
    Left = 472
    Top = 40
  end
end
