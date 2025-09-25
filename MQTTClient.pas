unit MQTTClient;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.IOUtils,
  System.SyncObjs,
  OverbyteIcsMQTT, NTempData, Observable, Observer; // ICS 9.5

type
  TOnDeviceData = procedure(Sender: TObject; Data: TNTempData) of object;

  TMqttClient = class(TInterfacedObject, IObservable)
  private
    FTopic: string;
    FCritical: TCriticalSection;
  private
    Observers: TList<IObserver>;
    LogPath:string;
    FMqtt: TIcsMQTTClient;
    FOnDeviceData: TOnDeviceData;
    procedure HandleOnline(Sender: TObject);
    procedure HandleOffline(Sender: TObject; Graceful: Boolean);
    procedure HandleMsg(Sender: TObject; aTopic: UTF8String;
      const aMessage: AnsiString; aQos: TMQTTQOSType; aRetained: Boolean);
    procedure LogMessage(const Msg: string);
    const LOG_ENABLE:Boolean = false;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect(const AHost: string; APort: Integer;
      const AClientID: string = ''; aTopic: string = '');
    procedure Subscribe(const aTopic: string);
    procedure Publish(const aTopic, aMessage: string;
      aQos: TMQTTQOSType = qtAT_MOST_ONCE; aRetained: Boolean = False);
    procedure Disconnect;
    procedure SubscribeObserver(obs: IObserver);

    property OnDeviceData: TOnDeviceData read FOnDeviceData write FOnDeviceData;
    function Online: Boolean;

  end;

implementation

{ TMqttClient }

/// <summary>
///
/// </summary>
/// <param name="AJSON"></param>
constructor TMqttClient.Create;
begin
  inherited;
  FCritical := TCriticalSection.Create;

  Observers := TList<IObserver>.Create();
  FMqtt := TIcsMQTTClient.Create(nil);

  FMqtt.OnOnline := HandleOnline;
  FMqtt.OnOffline := HandleOffline;
  FMqtt.OnMsg := HandleMsg;

  FMqtt.KeepAlive := 60;
  FMqtt.Clean := True;

  LogPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'mqtt.log');
end;

/// <summary>
///
/// </summary>
destructor TMqttClient.Destroy;
begin
  FMqtt.Free;
  Observers.Free;
  FCritical.Free;
  inherited;
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMqttClient.Connect(const AHost: string; APort: Integer;
  const AClientID: string; aTopic: string);
begin
  FTopic := aTopic;
  FMqtt.Host := AHost;
  FMqtt.Port := APort;
  if AClientID <> '' then
    FMqtt.ClientID := UTF8String(AClientID);

  FMqtt.Activate(True); // start connection
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMqttClient.Disconnect;
begin
  FMqtt.Activate(False);
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMqttClient.HandleOnline(Sender: TObject);
begin
  LogMessage('MQTT online');
  FMqtt.Subscribe(FTopic, qtAT_MOST_ONCE); // burada subscribe ediyoruz
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMqttClient.HandleOffline(Sender: TObject; Graceful: Boolean);
begin
  if Graceful then
  begin
    LogMessage('MQTT disconnected gracefully.');
  end
  else
  begin
    LogMessage('MQTT disconnected unexpectedly!');
  end;
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMqttClient.HandleMsg(Sender: TObject; aTopic: UTF8String;
  const aMessage: AnsiString; aQos: TMQTTQOSType; aRetained: Boolean);
var
  i: Integer;
begin

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

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMqttClient.Subscribe(const aTopic: string);
begin
  FMqtt.Subscribe(UTF8String(aTopic), qtAT_MOST_ONCE);
end;

/// <summary>
///
/// </summary>
/// <param name="Sender"></param>
procedure TMqttClient.SubscribeObserver(obs: IObserver);
begin
  Observers.Add(obs);
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMqttClient.Publish(const aTopic, aMessage: string;
aQos: TMQTTQOSType; aRetained: Boolean);
begin
  if FMqtt.Online then
  begin
    FMqtt.Publish(UTF8String(aTopic), UTF8String(aMessage), aQos, aRetained);
    LogMessage('Published: ' + aTopic + ' -> ' + aMessage);
  end
  else
    LogMessage('Cannot publish, MQTT not connected');
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
procedure TMqttClient.LogMessage(const Msg: string);
begin
  if not LOG_ENABLE then
     EXIT;

  TFile.AppendAllText
    (LogPath,
    FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' - ' + Msg + sLineBreak,
    TEncoding.UTF8);
end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
function TMqttClient.Online: Boolean;
begin
  Result := FMqtt.Online;
end;

end.
