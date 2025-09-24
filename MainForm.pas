unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, Observer, MQTTClient,OverbyteIcsMQTT;

type
  TMainForm = class(TForm, IObserver)
    MainPanel: TPanel;
    MainGridPanel: TGridPanel;
    ConfigGroupBox: TGroupBox;
    MessagesStringGrid: TStringGrid;
    HostLabel: TLabel;
    HostEdit: TEdit;
    TopicLabel: TLabel;
    TopicEdit: TEdit;
    ConnectButton: TButton;
    PortLabel: TLabel;
    PortEdit: TEdit;
    ClientIDLabel: TLabel;
    ClientIDEdit: TEdit;
    StatusLabel: TLabel;
    MainTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure OnTimer(Sender: TObject);
  private
    FMQTTCl : TMQTTClient;

    procedure initGUI();
    procedure init();
  public
    procedure HandleMsg(aTopic: UTF8String; const aMessage: AnsiString);
    property MQTTCl: TMQTTClient read FMQTTCl write FMQTTCl;
  end;



implementation


/// <summary>
///
/// </summary>
procedure TMainForm.initGUI();
begin

// MessagesStringGrid
MessagesStringGrid.ColCount := 3;
MessagesStringGrid.ColWidths[0] := 64;
MessagesStringGrid.ColWidths[1] := 130;
MessagesStringGrid.Cells[0, 0] := '#';
MessagesStringGrid.Cells[1, 0] := 'Time';
MessagesStringGrid.Cells[2, 0] := 'Message';

//ConnectButton
ConnectButton.Tag:=0;

// HostEdit
HostEdit.Text := '127.0.0.1';

// PortEdit
PortEdit.Text := '1883';

// TopicEdit
TopicEdit.Text := 'neurolux/ntemp/1/data';

// ClientIDEdit
ClientIDEdit.Text := 'phenomaster';


end;

/// <summary>
///
/// </summary>
procedure TMainForm.init();
begin

end;

{$R *.dfm}

/// <summary>
///
/// </summary>
/// <param name="Sender"></param>
procedure TMainForm.ConnectButtonClick(Sender: TObject);
var Host : AnsiString; Topic: AnsiString;ClientID:AnsiString;Port:Integer;
begin

if(ConnectButton.Tag = 1) then
begin
  ConnectButton.Tag:= 0;
  MQTTCl.Disconnect;
  ConnectButton.Caption:= 'Connect';
  MessagesStringGrid.RowCount:=1;
  Exit;

end;

try
  Host := Trim(HostEdit.Text);
  Topic := Trim(TopicEdit.Text);
  ClientID := Trim(ClientIDEdit.Text);

  if Host = '' then
  begin
    ShowMessage('Invalid Host');
    Exit;
  end;

  if not TryStrToInt(PortEdit.Text, Port) then
  begin
     ShowMessage('Invalid Port');
     Exit;
  end;

  if Topic = '' then
  begin
     ShowMessage('Invalid Topic');
     Exit;
  end;

  if ClientID = '' then
  begin
     ShowMessage('Invalid ClientID');
     Exit;
  end;

  ConnectButton.Tag:= 1;
  ConnectButton.Caption:= 'Disconnect';
  MQTTCl.Disconnect;
  MQTTCl.Connect(Host,Port,'',Topic);
  //MQTTCl.Subscribe(Topic);
except
   on E: Exception do
        ShowMessage('Error Occured ' + E.ClassName + sLineBreak + E.Message);

end;

end;

/// <summary>
///
/// </summary>
/// <param name="Sender"></param>
procedure TMainForm.FormCreate(Sender: TObject);
begin

  initGUI();
  init();

end;

/// <summary>
///
/// </summary>
/// <param name="Sender"></param>
procedure TMainForm.FormResize(Sender: TObject);
begin
  MessagesStringGrid.ColWidths[0] := 64;
  MessagesStringGrid.ColWidths[0] := 100;

  if MessagesStringGrid.ColCount >= 2 then
    MessagesStringGrid.ColWidths[2] := Self.Width -  (MessagesStringGrid.ColWidths[0] + MessagesStringGrid.ColWidths[1] ) - 10;
end;

/// <summary>
///
/// </summary>
/// <param name="aTopic"></param>
/// <param name="aMessage"></param>
procedure TMainForm.HandleMsg(aTopic: UTF8String; const aMessage: AnsiString);
var NewRow: Integer;i :Integer;
begin
  NewRow := MessagesStringGrid.RowCount;
  MessagesStringGrid.RowCount := NewRow + 1;


 MessagesStringGrid.Cells[0, NewRow] := IntToStr(NewRow);
 MessagesStringGrid.Cells[1, NewRow] := DateTimeToStr(Now);
 MessagesStringGrid.Cells[2, NewRow] := aMessage;


end;

/// <summary>
///
/// </summary>
/// <param name=""></param>
/// <param name=""></param>
procedure TMainForm.OnTimer(Sender: TObject);
begin
  if (FMQTTCl <> nil) and (FMQTTCl.Online) then
  begin
    StatusLabel.Caption:='Online';
    if(Trim(TopicEdit.Text) = 'ntemptest' )then
    begin
     FMQTTCl.Publish('ntemptest', 'Hello from Phenomaster.',qtAT_MOST_ONCE ,false);
    end
  end
  else
     StatusLabel.Caption:='Offline';
  begin

  end;
end;

end.
