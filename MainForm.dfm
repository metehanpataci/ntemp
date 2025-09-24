object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Phenomaster Demo'
  ClientHeight = 705
  ClientWidth = 1112
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 1112
    Height = 705
    Align = alClient
    TabOrder = 0
    object MainGridPanel: TGridPanel
      Left = 1
      Top = 1
      Width = 1110
      Height = 703
      Align = alClient
      ColumnCollection = <
        item
          Value = 100.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = ConfigGroupBox
          Row = 0
        end
        item
          Column = 0
          Control = MessagesStringGrid
          Row = 1
        end
        item
          Column = 0
          Control = StatusLabel
          Row = 2
        end>
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 65.000000000000000000
        end
        item
          Value = 100.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 24.000000000000000000
        end
        item
          SizeStyle = ssAuto
        end>
      TabOrder = 0
      object ConfigGroupBox: TGroupBox
        AlignWithMargins = True
        Left = 4
        Top = 13
        Width = 1102
        Height = 50
        Margins.Top = 12
        Align = alBottom
        Caption = 'Configuration'
        TabOrder = 0
        object HostLabel: TLabel
          Left = 2
          Top = 17
          Width = 31
          Height = 26
          Align = alLeft
          Caption = 'Host: '
          Constraints.MaxHeight = 26
          Layout = tlCenter
          ExplicitHeight = 15
        end
        object TopicLabel: TLabel
          AlignWithMargins = True
          Left = 346
          Top = 20
          Width = 32
          Height = 25
          Align = alLeft
          Caption = 'Topic '
          Constraints.MaxHeight = 26
          Layout = tlCenter
          ExplicitLeft = 364
          ExplicitHeight = 15
        end
        object PortLabel: TLabel
          AlignWithMargins = True
          Left = 260
          Top = 20
          Width = 22
          Height = 25
          Align = alLeft
          Caption = 'Port'
          Constraints.MaxHeight = 26
          Layout = tlCenter
          ExplicitHeight = 15
        end
        object ClientIDLabel: TLabel
          AlignWithMargins = True
          Left = 570
          Top = 20
          Width = 45
          Height = 25
          Align = alLeft
          Caption = 'Client ID'
          Constraints.MaxHeight = 26
          Layout = tlCenter
          ExplicitLeft = 588
          ExplicitHeight = 15
        end
        object HostEdit: TEdit
          Left = 33
          Top = 17
          Width = 224
          Height = 26
          Align = alLeft
          Constraints.MaxHeight = 26
          TabOrder = 0
          ExplicitHeight = 23
        end
        object TopicEdit: TEdit
          Left = 381
          Top = 17
          Width = 186
          Height = 26
          Align = alLeft
          Constraints.MaxHeight = 26
          TabOrder = 1
          ExplicitHeight = 23
        end
        object ConnectButton: TButton
          Left = 1003
          Top = 17
          Width = 97
          Height = 31
          Align = alRight
          Caption = 'Connect'
          Constraints.MaxHeight = 31
          TabOrder = 2
          OnClick = ConnectButtonClick
        end
        object PortEdit: TEdit
          Left = 285
          Top = 17
          Width = 58
          Height = 26
          Align = alLeft
          Constraints.MaxHeight = 26
          TabOrder = 3
          ExplicitHeight = 23
        end
        object ClientIDEdit: TEdit
          Left = 618
          Top = 17
          Width = 121
          Height = 26
          Align = alLeft
          Constraints.MaxHeight = 26
          TabOrder = 4
          ExplicitHeight = 23
        end
      end
      object MessagesStringGrid: TStringGrid
        Left = 1
        Top = 66
        Width = 1108
        Height = 612
        Align = alClient
        ColCount = 3
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        TabOrder = 1
        ColWidths = (
          107
          997
          64)
      end
      object StatusLabel: TLabel
        Left = 1
        Top = 678
        Width = 3
        Height = 24
        Align = alLeft
        Layout = tlCenter
        ExplicitHeight = 15
      end
    end
  end
  object MainTimer: TTimer
    OnTimer = OnTimer
    Left = 993
    Top = 529
  end
end
