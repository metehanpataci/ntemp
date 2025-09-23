unit uNTempData;

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

{ TNTempData }

constructor TNTempData.Create;
begin
  FBattery := TBattery.Create;
end;

destructor TNTempData.Destroy;
begin
  FBattery.Free;
  inherited;
end;

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

end.

