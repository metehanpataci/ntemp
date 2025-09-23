object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 461
  ClientWidth = 624
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object MainEdit: TEdit
    Left = 0
    Top = 16
    Width = 369
    Height = 353
    TabOrder = 0
    Text = 
      'This is test message. This is test message. This is test message' +
      '. This is test message. This is test message. This is test messa' +
      'ge. This is test message. This is test message. This is test mes' +
      'sage. This is test message. This is test message. This is test m' +
      'essage. This is test message. This is test message. This is test' +
      ' message. This is test message. This is test message. This is te' +
      'st message. This is test message. This is test message. This is ' +
      'test message. This is test message. This is test message. This i' +
      's test message. This is test message. This is test message. This' +
      ' is test message. This is test message. This is test message. Th' +
      'is is test message. This is test message. This is test message. ' +
      'This is test message. '
    OnChange = MainEditChange
  end
end
