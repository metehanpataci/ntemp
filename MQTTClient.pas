unit MQTTClient;

interface

uses
  System.SysUtils, System.Classes,System.Generics.Collections,System.IOUtils,System.SyncObjs,
  OverbyteIcsMQTT, uNTempData, Observable, Observer;  // ICS 9.5

type
  TOnDeviceData = procedure(Sender: TObject; Data: TNTempData) of object;

  TMqttClient = class(TInterfacedObject,IObservable)
  private
    FCritical: TCriticalSection;
    private Observers : TList<IObserver>;
    FMqtt: TIcsMQTTClient;
    FOnDeviceData: TOnDeviceData;
    procedure HandleOnline(Sender: TObject);
    procedure HandleOffline(Sender: TObject; Graceful: Boolean);
    procedure HandleMsg(Sender: TObject; aTopic: UTF8String; const aMessage: AnsiString; aQos: TMQTTQOSType; aRetained: Boolean);
    procedure LogMessage(const Msg: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect(const AHost: string; APort: Integer; const AClientID: string = '');
    procedure Subscribe(const ATopic: string);
    procedure Disconnect;
    procedure SubscribeObserver(obs:IObserver);

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
  FCritical := TCriticalSection.Create;

  observers := TList<IObserver>.Create();
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
  observers.Free;
  FCritical.Free;
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
  //Writeln('MQTT Connected');
  LogMessage('MQTT online');
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
  begin
   LogMessage('MQTT disconnected gracefully.');
    //Writeln('MQTT disconnected gracefully.')
  end
  else
  begin
    LogMessage('MQTT disconnected unexpectedly!');
    //Writeln('MQTT disconnected unexpectedly!');
  end;
end;


{
  Procedure: HandleMsg
  Description:
  Parameters:
  Returns: Nothing
}
procedure TMqttClient.HandleMsg(Sender: TObject; aTopic: UTF8String; const aMessage: AnsiString;
  aQos: TMQTTQOSType; aRetained: Boolean);
var i:Integer;
begin
//Writeln('Topic: ' + string(aTopic));
//Writeln('Message: ' + string(aMessage));
//Writeln('QoS: ' + Ord(aQos).ToString);
//Writeln('Retained: ' + BoolToStr(aRetained, True));
FCritical.Enter;
for i := 0 to Observers.Count - 1 do
begin
  TThread.Queue(nil,
  procedure
  begin
       Observers[i].HandleMsg(aTopic, aMessage);
  end);

end;
FCritical.Leave;
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


/// <summary>
///
/// </summary>
/// <param name="Sender"></param>
procedure TMqttClient.SubscribeObserver(obs:IObserver);
begin


end;

procedure TMqttClient.LogMessage(const Msg: string);
begin
  TFile.AppendAllText('C:\Users\MEP\repositories\projects\DELPHI\neurolux\nTemp\mqtt.log', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ' + Msg + sLineBreak, TEncoding.UTF8);
end;


end.
