unit App;

interface

uses
  Vcl.Forms, UMainForm;

procedure Main;

implementation

/// <summary>
///   Does something important.
/// </summary>
/// <param name="Value">Some integer value.</param>
procedure Main;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end;

end.
