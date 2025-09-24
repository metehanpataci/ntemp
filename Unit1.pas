unit Unit1;


interface


uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uMQTTClient, uNTempData,
  Vcl.ExtCtrls, Vcl.Grids;

type
  TTestForm = class(TForm)




  public
      constructor Create(AOwner: TComponent); override;

  private

    MainPanel: TPanel;
    MemoLog : TMemo;
    ConfigGroupBox: TGroupBox;
    MessagesGroupBox: TGroupBox;
    GridPanel: TGridPanel;
    MessageStringGrid : TStringGrid;
    FMQTT: TMqttClient;
    AMsgId : Integer;
  end;

var
  TestForm: TTestForm;

implementation


constructor TTestForm.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
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

end;


end.

