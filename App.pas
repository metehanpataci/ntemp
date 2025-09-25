unit App;

interface

uses
  Vcl.Forms, MainForm, MQTTClient;

procedure Main;

implementation

/// <summary>
/// Does something important.
/// </summary>
/// <param name="Value">Some integer value.</param>
procedure Main;
var
  MasterForm: TMainForm;
  MqttCl: TMqttClient;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  // Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainForm, MasterForm);

  MqttCl := TMqttClient.Create;
  MasterForm.MqttCl := MqttCl;
  MqttCl.SubscribeObserver(MasterForm);

  // MyForm.Show;
  Application.Run;
end;

end.
