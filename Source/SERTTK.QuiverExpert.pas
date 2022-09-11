unit SERTTK.QuiverExpert;

interface

const
  MAJ_VER = 2022; // Major version nr.
  MIN_VER = 9; // Minor version nr.
  REL_VER = 16; // Release nr.
  BLD_VER = 0; // Build nr.
  KASTRI_COMMIT = 'fa453cd';
  KASTRI_URL = 'https://github.com/DelphiWorlds/Kastri/commit/fa453cd2afaa47739f01133a5f22cf4dc391fc84';
  TOTAL_COMMIT = '2ec8360';
  TOTAL_URL = 'https://github.com/DelphiWorlds/TOTAL/commit/2ec8360328bab72b0ade817f1ffd168210f2098e';

  { Built with TOTAL & KASTRI versions:
    KASTRI : fa453cd : https://github.com/DelphiWorlds/Kastri/commit/fa453cd2afaa47739f01133a5f22cf4dc391fc84
    TOTAL : 2ec8360 : https://github.com/DelphiWorlds/TOTAL/commit/2ec8360328bab72b0ade817f1ffd168210f2098e
  }

  // Version history
  // v2022.9.16.0 : First Release

  { ******************************************************************** }
  { written by swiftexpat }
  { copyright  ©  2022 }
  { Email : support@swiftexpat.com }
  { Web : https://swiftexpat.com }
  { }
  { The source code is given as is. The author is not responsible }
  { for any possible damage done due to the use of this code. }
  { The complete source code remains property of the author and may }
  { not be distributed, published, given or sold in any form as such. }
  { No parts of the source code can be included in any other component }
  { or application without written authorization of the author. }
  { ******************************************************************** }

implementation

uses System.Classes, ToolsAPI, VCL.Dialogs, System.SysUtils, System.TypInfo, Winapi.Windows, Winapi.TlHelp32,
  System.IOUtils, Generics.Collections, System.DateUtils, System.JSON,
  VCL.Forms, VCL.Menus, System.Win.Registry, ShellApi, VCL.Controls,
  DW.OTA.Wizard, DW.OTA.IDENotifierOTAWizard, DW.OTA.Helpers, DW.Menus.Helpers, DW.OTA.ProjectManagerMenu,
  DW.OTA.Notifiers, SERTTK.QuiverTypes, frmQuiverOptionsInstance;

Type

  TSERTTKQuiverWizard = class(TIDENotifierOTAWizard)
  const
    nag_interval = 10;
    nm_tools_menu = 'SE Deputy';
    nm_tools_menuitem = 'miSEDeputyRoot';
    nm_message_group = 'SE Deputy';
    nm_mi_procmgr = 'procmgritem';
    nm_mi_run_caddie = 'caddierunitem';
    nm_mi_run_vcldemo = 'demovclrunitem';
    nm_mi_run_fmxdemo = 'demofmxrunitem';
    nm_mi_show_website = 'showwebsiteitem';
    nm_mi_update_status = 'updatestatusitem';
    nm_mi_show_options = 'showoptionsitem';
    nm_wizard_id = 'com.swiftexpat.deputy';
    nm_wizard_display = 'RunTime ToolKit - Deputy';
  strict private
    FIDEStarted: boolean;
    // FDeputyUpdates: TDeputyUpdates;
    FToolsMenuRootItem: TMenuItem;
    FSettings: TSERTTKQuiverSettings;
    // FRTTKAppUpdate: TSERTTKAppVersionUpdate;
    // FWizardInfo: TSERTTKWizardInfo;
    FMenuItems: TDictionary<string, TMenuItem>;
    // FNagCounter: TSERTTKNagCounter;
    FIdeOptions: INTAAddInOptions;
    function MenuItemByName(const AItemName: string): TMenuItem;
    procedure OnClickQuiverUpdates(Sender: TObject);
    procedure OnClickShowOptions(Sender: TObject);
  private
    procedure InitToolsMenu;
    procedure AssignUpdateMenuItems;
    function FindMenuItemFirstLine(const AMenuItem: TMenuItem): integer;
    // procedure MessagesAdd(const AMessage: string);
    procedure OnClickShowWebsite(Sender: TObject);
  protected
    function GetIDString: string; override;
    function GetName: string; override;
    function GetWizardDescription: string; override;
    property Settings: TSERTTKQuiverSettings read FSettings;
    procedure IDEStarted; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetState: TWizardState;
    class function GetWizardName: string; override;
    class function GetWizardLicense: string; override;
  end;

  // Invokes TOTAWizard.InitializeWizard, which in turn creates an instance of the add-in, and registers it with the IDE
function Initialize(const Services: IBorlandIDEServices; RegisterProc: TWizardRegisterProc;
  var TerminateProc: TWizardTerminateProc): boolean; stdcall;
begin
  result := TOTAWizard.InitializeWizard(Services, RegisterProc, TerminateProc, TSERTTKQuiverWizard);
end;

exports
// Provides a function named WizardEntryPoint that is required by the IDE when loading a DLL-based add-in
  Initialize name WizardEntryPoint;

{ TSERTTKQuiverWizard }

{$REGION 'Create / Destroy / Started'}

constructor TSERTTKQuiverWizard.Create;
begin
  inherited;
  FMenuItems := TDictionary<string, TMenuItem>.Create;
  FSettings := TSERTTKQuiverSettings.Create(TSERTTKQuiverSettings.nm_settings_regkey);
  InitToolsMenu;
  // options main menu
  FIdeOptions := TSERTTKQuiverIDEOptionsInterface.Create;
  TSERTTKQuiverIDEOptionsInterface(FIdeOptions).QuiverSettings := FSettings;
  (BorlandIDEServices As INTAEnvironmentOptionsServices).RegisterAddInOptions(FIdeOptions);
end;

destructor TSERTTKQuiverWizard.Destroy;
begin
  (BorlandIDEServices As INTAEnvironmentOptionsServices).UnregisterAddInOptions(FIdeOptions);
  FIdeOptions := nil;
  FMenuItems.Free;
  FSettings.Free;
  inherited;
end;

procedure TSERTTKQuiverWizard.IDEStarted;
begin
  inherited;
  FIDEStarted := true;
end;

{$ENDREGION}
{$REGION 'Menu Item Helpers'}

procedure TSERTTKQuiverWizard.AssignUpdateMenuItems;
begin

end;

function TSERTTKQuiverWizard.MenuItemByName(const AItemName: string): TMenuItem;
begin
  if FMenuItems.TryGetValue(AItemName, result) then
    exit(result)
  else
  begin
    result := TMenuItem.Create(nil);
    result.Name := AItemName;
    FMenuItems.Add(AItemName, result)
  end;
end;

function TSERTTKQuiverWizard.FindMenuItemFirstLine(const AMenuItem: TMenuItem): integer;
var
  mi: TMenuItem;
  i: integer;
begin
  for i := 0 to AMenuItem.Count - 1 do
  begin
    mi := AMenuItem.Items[i];
    if mi.IsLine then
      exit(i);
  end;
  result := 0;
end;
{$ENDREGION}
{$REGION 'Plugin Display values'}

function TSERTTKQuiverWizard.GetIDString: string;
begin
  result := nm_wizard_id;
end;

function TSERTTKQuiverWizard.GetName: string;
begin
  result := nm_wizard_display;
end;

function TSERTTKQuiverWizard.GetState: TWizardState;
begin
  result := [wsEnabled]
end;

function TSERTTKQuiverWizard.GetWizardDescription: string;
begin
  result := 'Expert provided by SwiftExpat.com .' + #13 + '  Deputy works with RunTime ToolKit';
end;

class function TSERTTKQuiverWizard.GetWizardLicense: string;
begin
  result := 'GPL V3'
end;

class function TSERTTKQuiverWizard.GetWizardName: string;
begin
  result := nm_wizard_display;
end;

{$ENDREGION}

procedure TSERTTKQuiverWizard.InitToolsMenu;
begin

end;

procedure TSERTTKQuiverWizard.OnClickQuiverUpdates(Sender: TObject);
begin

end;

procedure TSERTTKQuiverWizard.OnClickShowOptions(Sender: TObject);
begin
  (BorlandIDEServices As IOTAServices).GetEnvironmentOptions.EditOptions('', caption_options_label);
end;

procedure TSERTTKQuiverWizard.OnClickShowWebsite(Sender: TObject);
begin
  // FDeputyUtils.ShowWebsite;
end;

end.
