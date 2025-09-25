program PhenomasterMVP;

uses
  Vcl.Forms,
  NTempData in 'NTempData.pas',
  MQTTClient in 'MQTTClient.pas',
  App in 'App.pas',
  MainForm in 'MainForm.pas' {TMainForm},
  Observer in 'Observer.pas',
  Observable in 'Observable.pas';

{$R *.res}

begin
 Main;
end.
