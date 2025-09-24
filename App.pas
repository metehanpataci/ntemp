unit App;

interface

uses
  Vcl.Forms, Unit1;

  //UMainForm

procedure Main;

implementation

/// <summary>
///   Does something important.
/// </summary>
/// <param name="Value">Some integer value.</param>
procedure Main;
var
  MyForm: TTestForm;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //Application.CreateForm(TMainForm, MainForm);
MyForm := TTestForm.Create(nil);
MyForm.Show;
Application.Run;
end;

end.
