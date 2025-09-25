unit Observable;

interface

uses Observer;

type
  IObservable = interface
    ['{8A2F4D92-9F6B-4A5C-AB46-2E2E3F3F2A91}']
    // GUID
    procedure SubscribeObserver(obs: IObserver);
  end;

implementation

end.
