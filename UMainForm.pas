unit UMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uMQTTClient, uNTempData,
  Vcl.ExtCtrls, Vcl.Grids;


type
  TMainForm = class(TForm)

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MainEditChange(Sender: TObject);


  public
    procedure AddMessage(AMsg: string);

  private
    MainPanel: TPanel;
    MemoLog : TMemo;
    ConfigGroupBox: TGroupBox;
    MessagesGroupBox: TGroupBox;
    GridPanel: TGridPanel;
    MessageStringGrid : TStringGrid;
    FMQTT: TMqttClient;
    AMsgId : Integer;
    procedure OnDeviceData(Sender: TObject; Data: TNTempData);
    procedure FormShow(Sender: TObject);
    procedure initGUI();
    procedure init();
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin

  initGUI();
  init();

end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMainForm.init;
begin
  AMsgId := 0;

  FMQTT := TMqttClient.Create();
  FMQTT.OnDeviceData := OnDeviceData;

  FMQTT.Connect('broker.hivemq.com', 1883, 'DelphiClient1');
  FMQTT.Subscribe('neurolux/ntemp/+/data');  // GUID yerine + wildcard

end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMainForm.initGUI;
var   button : TButton;
begin

  Self.Width := 800;
  Self.Height := 600;
  Self.Color:= clRed;

  // MainPanel
  MainPanel := TPanel.Create(Self);
  MainPanel.Parent := Self;
  MainPanel.Align := alClient;
  MainPanel.Color := clYellow;
  MainPanel.BringToFront;
  MainPanel.Width:= 500;
  MainPanel.Height:= 500;


  button :=  TButton.Create(Self);
  button.Parent := MainPanel;


  // GridPanel
  GridPanel := TGridPanel.Create(MainPanel);
  GridPanel.Parent := MainPanel;
  GridPanel.Align := alClient;
  GridPanel.ColumnCollection.Add; // add col
  GridPanel.RowCollection.Add;    // add row
  GridPanel.RowCollection.Add;    // add row
  GridPanel.Color := clPurple;


  // Configuration
  ConfigGroupBox := TGroupBox.Create(GridPanel);
  ConfigGroupBox.Parent := GridPanel;
  //ConfigGroupBox.Align := alClient;
  ConfigGroupBox.Caption := 'Configuration';
  ConfigGroupBox.Color := clGreen;
  GridPanel.ControlCollection.AddControl(ConfigGroupBox, 0, 0);

  // Messages Grid
  MessageStringGrid := TStringGrid.Create(GridPanel);
  MessageStringGrid.Parent := GridPanel;
  //MessageStringGrid.Align := alClient;
  MessageStringGrid.ColCount := 2;
  MessageStringGrid.RowCount := 1; // initial one
  MessageStringGrid.Color := clYellow;
  // Header
  MessageStringGrid.Cells[0, 0] := 'ID';
  MessageStringGrid.Cells[1, 0] := 'Message';
  GridPanel.ControlCollection.AddControl(MessageStringGrid, 0, 1);



  //Button1 := TButton.Create(GridPanel);
  //Button1.Parent := GridPanel;
  //GridPanel.ControlCollection.AddControl(Button1, 0, 0);
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMainForm.FormShow(Sender: TObject);
begin

end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FMQTT.Free;
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMainForm.MainEditChange(Sender: TObject);
begin
    (Sender as TEdit).Text := 'Clicked';

end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMainForm.OnDeviceData(Sender: TObject; Data: TNTempData);
begin
  MemoLog.Lines.Add(Format(
    '[%s] DevID=%s Temp=%.2f ExtTemp=%.2f Battery=%d%% Connected=%s',
    [DateTimeToStr(Data.Timestamp), Data.DevID, Data.Temp, Data.ExtTemp,
     Data.Battery.Level, BoolToStr(Data.Connected, True)]
  ));
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMainForm.AddMessage(AMsg: string);
var NewRow : Integer;
begin
  NewRow := MessageStringGrid.RowCount;
  MessageStringGrid.RowCount := NewRow + 1;

  MessageStringGrid.Cells[0, NewRow] := IntToStr(AMsgId);
  MessageStringGrid.Cells[1, NewRow] := AMsg;
end;

end.

