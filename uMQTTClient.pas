unit uMQTTClient;

interface

uses
  System.SysUtils, System.Classes,
  OverbyteIcsMQTT, uNTempData;  // ICS 9.5

type
  TOnDeviceData = procedure(Sender: TObject; Data: TNTempData) of object;

  TMqttClient = class
  private
    FMqtt: TIcsMQTTClient;
    FOnDeviceData: TOnDeviceData;
    procedure HandleOnline(Sender: TObject);
    procedure HandleOffline(Sender: TObject; Graceful: Boolean);
    procedure HandleMsg(Sender: TObject; aTopic: UTF8String; const aMessage: AnsiString; aQos: TMQTTQOSType; aRetained: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect(const AHost: string; APort: Integer; const AClientID: string = '');
    procedure Subscribe(const ATopic: string);
    procedure Disconnect;
    property OnDeviceData: TOnDeviceData read FOnDeviceData write FOnDeviceData;
  end;


//
// IMPLEMENTAION SCOPE
//

implementation

{ TMqttClient }

constructor TMqttClient.Create;
begin
  inherited;
  FMqtt := TIcsMQTTClient.Create(nil);

  FMqtt.OnOnline := HandleOnline;
  FMqtt.OnOffline := HandleOffline;
  FMqtt.OnMsg := HandleMsg;

  FMqtt.KeepAlive := 60;
  FMqtt.Clean := True;
end;


{
  Procedure: Destroy
  Description:
  Parameters:
  Returns: Nothing
}
destructor TMqttClient.Destroy;
begin
  FMqtt.Free;
  inherited;
end;

{
  Procedure: Connect
  Description: Connects to MQTT broker
  Parameters:
  Returns: Nothing
}
procedure TMqttClient.Connect(const AHost: string; APort: Integer; const AClientID: string);
begin
  FMqtt.Host := AHost;
  FMqtt.Port := APort;
  if AClientID <> '' then
    FMqtt.ClientID := UTF8String(AClientID);

  FMqtt.Activate(True);  // start connection
end;

{
  Procedure: Disconnect
  Description: Disconnects to MQTT broker
  Parameters:
  Returns: Nothing
}
procedure TMqttClient.Disconnect;
begin
  FMqtt.Activate(False);
end;

{
  Procedure: HandleOnline
  Description:
  Parameters:
  Returns: Nothing
}
procedure TMqttClient.HandleOnline(Sender: TObject);
begin
  Writeln('MQTT Connected');
end;

{
  Procedure: HandleOffline
  Description:
  Parameters:
  Returns: Nothing
}
procedure TMqttClient.HandleOffline(Sender: TObject; Graceful: Boolean);
begin
  if Graceful then
    Writeln('MQTT disconnected gracefully.')
  else
    Writeln('MQTT disconnected unexpectedly!');
end;


{
  Procedure: HandleMsg
  Description:
  Parameters:
  Returns: Nothing
}
procedure TMqttClient.HandleMsg(Sender: TObject; aTopic: UTF8String; const aMessage: AnsiString;
  aQos: TMQTTQOSType; aRetained: Boolean);
begin
  Writeln('Topic: ' + string(aTopic));
  Writeln('Message: ' + string(aMessage));
  Writeln('QoS: ' + Ord(aQos).ToString);
  Writeln('Retained: ' + BoolToStr(aRetained, True));
end;


{
  Procedure: Subscribe
  Description:
  Parameters:
  Returns: Nothing
}
procedure TMqttClient.Subscribe(const ATopic: string);
begin
  FMqtt.Subscribe(UTF8String(ATopic), qtAT_MOST_ONCE);
end;

end.
