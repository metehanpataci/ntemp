unit Observer;

interface

type
  IObserver = interface
    ['{8A2F4D92-9F6B-4A5C-AB45-2E2E3F3F2A91}']
    // GUID
    procedure HandleMsg(aTopic: UTF8String; const aMessage: AnsiString);

  end;

implementation

end.
