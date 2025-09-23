unit UMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uMQTTClient, uNTempData;


type
  TMainForm = class(TForm)
    MemoLog : TMemo;
    MainEdit: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MainEditChange(Sender: TObject);
  private
    FMQTT: TMqttClient;
    procedure OnDeviceData(Sender: TObject; Data: TNTempData);
    procedure FormShow(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FMQTT := TMqttClient.Create();
  FMQTT.OnDeviceData := OnDeviceData;

  FMQTT.Connect('broker.hivemq.com', 1883, 'DelphiClient1');
  FMQTT.Subscribe('neurolux/ntemp/+/data');  // GUID yerine + wildcard
  MainEdit.Text := 'Dynamic Text';


  MemoLog := TMemo.Create(Self);
  MemoLog.Parent := Self;
  Memolog.Left := 5;
  Memolog.Top := 5;
  Memolog.Height := 200;
  Memolog.Width := 400;

  MainEdit.Left:= 5;
  MainEdit.Top:= Memolog.Height + 10;
  MainEdit.Height:=400;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  MainEdit.Text := 'Dynamic Text';
  MainEdit.Height:=400;

  MainEdit.Text := 'First line' + sLineBreak + 'Second line';
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FMQTT.Free;
end;

procedure TMainForm.MainEditChange(Sender: TObject);
begin
    (Sender as TEdit).Text := 'Clicked';

end;

procedure TMainForm.OnDeviceData(Sender: TObject; Data: TNTempData);
begin
  MemoLog.Lines.Add(Format(
    '[%s] DevID=%s Temp=%.2f ExtTemp=%.2f Battery=%d%% Connected=%s',
    [DateTimeToStr(Data.Timestamp), Data.DevID, Data.Temp, Data.ExtTemp,
     Data.Battery.Level, BoolToStr(Data.Connected, True)]
  ));
end;

end.

