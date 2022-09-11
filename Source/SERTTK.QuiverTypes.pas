unit SERTTK.QuiverTypes;

interface

uses System.Win.Registry;

type

  TSERTTKQuiverSettings = class(TRegistryIniFile)
  const
    nm_section_updates = 'Updates';
    nm_updates_lastupdate = 'LastUpdateCheckDate';
    nm_updates_urlcachejson = 'UrlCacheJson';
    nm_section_killprocess = 'KillProcess';
    nm_killprocess_enabled = 'Enabled';
    nm_killprocess_closeleak = 'CloseLeakWindow';
    nm_killprocess_copyleak = 'CopyLeakWindow';
    nm_killprocess_stopcommand = 'StopCommand';
    nm_section_idedetect = 'IdeDetect';
    nm_idedetect_detectsecond = 'DetectSecond';
    nm_settings_regkey = 'SOFTWARE\SwiftExpat\Quiver';
  strict private
    // function KillProcActiveGet: boolean;
    // procedure KillProcActiveSet(const Value: boolean);
    // function LastUpdateCheckGet: TDateTime;
    // procedure LastUpdateCheckSet(const Value: TDateTime);
    function UrlCacheJsonGet: string;
    procedure UrlCacheJsonSet(const Value: string);
  private
    // function StopCommandGet: integer;
    // procedure StopCommandSet(const Value: integer);
    // function CloseLeakWindowGet: boolean;
    // procedure CloseLeakWindowSet(const Value: boolean);
    // function CopyLeakMessageGet: boolean;
    // procedure CopyLeakMessageSet(const Value: boolean);
  public
    // property KillProcActive: boolean read KillProcActiveGet write KillProcActiveSet;
    // property LastUpdateCheck: TDateTime read LastUpdateCheckGet write LastUpdateCheckSet;
    // property StopCommand: integer read StopCommandGet write StopCommandSet;
    // property CloseLeakWindow: boolean read CloseLeakWindowGet write CloseLeakWindowSet;
    // property CopyLeakMessage: boolean read CopyLeakMessageGet write CopyLeakMessageSet;
    property UrlCacheJson: string read UrlCacheJsonGet write UrlCacheJsonSet;
  end;

implementation

{ TSERTTKQuiverSettings }

function TSERTTKQuiverSettings.UrlCacheJsonGet: string;
begin
  result := self.ReadString(nm_section_updates, nm_updates_urlcachejson, '')
end;

procedure TSERTTKQuiverSettings.UrlCacheJsonSet(const Value: string);
begin
  self.WriteString(nm_section_updates, nm_updates_urlcachejson, Value)
end;

end.
