object frm_init: Tfrm_init
  Left = 292
  Top = 219
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frm_init'
  ClientHeight = 213
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Gauge1: TGauge
    Left = 8
    Top = 104
    Width = 353
    Height = 25
    ForeColor = clRed
    Progress = 22
    Visible = False
  end
  object Label2: TLabel
    Left = 33
    Top = 144
    Width = 72
    Height = 13
    Caption = #25968#25454#24211#21517#31216#65306
    Visible = False
  end
  object Label1: TLabel
    Left = 33
    Top = 60
    Width = 72
    Height = 13
    Caption = #26381#21153#22120#21517#31216#65306
  end
  object Label3: TLabel
    Left = 33
    Top = 140
    Width = 84
    Height = 13
    Caption = #25968#25454#24211#31649#29702#21592#65306
    Visible = False
  end
  object Label4: TLabel
    Left = 33
    Top = 144
    Width = 72
    Height = 13
    Caption = #31649#29702#21592#23494#30721#65306
    Visible = False
  end
  object btn_star: TButton
    Left = 24
    Top = 136
    Width = 75
    Height = 25
    Caption = #24320#22987'(&B)'
    Enabled = False
    TabOrder = 0
    OnClick = btn_starClick
  end
  object edt_dbpass: TEdit
    Left = 136
    Top = 142
    Width = 169
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    Visible = False
  end
  object edt_dbname: TEdit
    Left = 136
    Top = 137
    Width = 169
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
    Visible = False
  end
  object edt_db: TEdit
    Left = 136
    Top = 140
    Width = 169
    Height = 21
    TabOrder = 4
    Visible = False
  end
  object edt_srv: TEdit
    Left = 136
    Top = 56
    Width = 169
    Height = 21
    ReadOnly = True
    TabOrder = 5
    Text = 'ZLNR1SERVER'
  end
  object btn_stop: TButton
    Left = 272
    Top = 136
    Width = 75
    Height = 25
    Caption = #39044#22788#29702'(&P)'
    TabOrder = 1
    OnClick = btn_stopClick
  end
  object ADOConnection_init: TADOConnection
    LoginPrompt = False
  end
  object ADOCommand1: TADOCommand
    Connection = ADOConnection_init
    Parameters = <>
    Left = 40
  end
end
