unit NTempData;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.DateUtils;

type
  TBattery = class
  private
    FLevel: Integer;
    FCharging: Boolean;
  public
    property Level: Integer read FLevel write FLevel;
    property Charging: Boolean read FCharging write FCharging;
    function ToJSON: TJSONObject;
  end;

  TNTempData = class
  private
    FTransactionID: string;
    FTimestamp: TDateTime;
    FDevID: string;
    FUserData: string;
    FTemp: Double;
    FExtTemp: Double;
    FBattery: TBattery;
    FConnected: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function FromJSON(AJSON: string): TNTempData;

    function ToJSON: string;
    class function TestInstance: TNTempData; static;

    property TransactionID: string read FTransactionID write FTransactionID;
    property Timestamp: TDateTime read FTimestamp write FTimestamp;
    property DevID: string read FDevID write FDevID;
    property UserData: string read FUserData write FUserData;
    property Temp: Double read FTemp write FTemp;
    property ExtTemp: Double read FExtTemp write FExtTemp;
    property Battery: TBattery read FBattery;
    property Connected: Boolean read FConnected write FConnected;
  end;

implementation

{ TBattery }

/// <summary>
///
/// </summary>
function TBattery.ToJSON: TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair('level', TJSONNumber.Create(FLevel));
  Result.AddPair('charging', TJSONBool.Create(FCharging));
end;

{ TNTempData }

/// <summary>
///
/// </summary>
constructor TNTempData.Create;
begin
  FBattery := TBattery.Create;
end;

/// <summary>
///
/// </summary>
destructor TNTempData.Destroy;
begin
  FBattery.Free;
  inherited;
end;

/// <summary>
///
/// </summary>
function TNTempData.ToJSON: string;
var
  LObj: TJSONObject;
begin
  LObj := TJSONObject.Create;
  try
    LObj.AddPair('transactionID', FTransactionID);
    LObj.AddPair('timestamp', DateToISO8601(FTimestamp, False));
    LObj.AddPair('devID', FDevID);
    LObj.AddPair('userData', FUserData);
    LObj.AddPair('temp', TJSONNumber.Create(FTemp));
    LObj.AddPair('extTemp', TJSONNumber.Create(FExtTemp));
    LObj.AddPair('connected', TJSONBool.Create(FConnected));
    LObj.AddPair('battery', FBattery.ToJSON);

    Result := LObj.ToJSON;
  finally
    LObj.Free;
  end;
end;

/// <summary>
///
/// </summary>
/// <param name="AJSON"></param>
class function TNTempData.FromJSON(AJSON: string): TNTempData;
var
  LObj, LBatt: TJSONObject;
begin
  Result := TNTempData.Create;
  LObj := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  try
    if LObj.TryGetValue('transactionID', Result.FTransactionID) then;
    if LObj.TryGetValue('devID', Result.FDevID) then;
    if LObj.TryGetValue('userData', Result.FUserData) then;
    if LObj.TryGetValue<Double>('temp', Result.FTemp) then;
    if LObj.TryGetValue<Double>('extTemp', Result.FExtTemp) then;
    if LObj.TryGetValue<Boolean>('connected', Result.FConnected) then;

    if LObj.TryGetValue<TJSONObject>('battery', LBatt) then
    begin
      LBatt.TryGetValue<Integer>('level', Result.FBattery.FLevel);
      LBatt.TryGetValue<Boolean>('charging', Result.FBattery.FCharging);
    end;

    // timestamp ISO 8601 parse
    if LObj.GetValue('timestamp') <> nil then
      Result.FTimestamp := ISO8601ToDate(LObj.GetValue('timestamp').Value);
  finally
    LObj.Free;
  end;
end;

/// <summary>
///
/// </summary>
class function TNTempData.TestInstance: TNTempData;
begin
  Result := TNTempData.Create;
  Result.TransactionID := 'fh67d8b0-yh86-88kk-94sd-glyv5c147778';
  Result.Timestamp := Now;
  Result.DevID := '1';
  Result.UserData := 'Animal-1';
  Result.Temp := 36.5;
  Result.ExtTemp := 22.3;
  Result.Connected := True;
  Result.Battery.Level := 85;
  Result.Battery.Charging := True;
end;

end.
