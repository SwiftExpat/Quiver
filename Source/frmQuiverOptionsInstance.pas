unit frmQuiverOptionsInstance;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ToolsAPI, SERTTK.QuiverTypes;

const
  caption_options_label = 'Deputy';
  MAJ_VER = 1; // Major version nr.
  MIN_VER = 0; // Minor version nr.
  REL_VER = 0; // Release nr.
  BLD_VER = 0; // Build nr.

  // Version history
  // v1.0.0.0 : First Release

  { ******************************************************************** }
  { written by swiftexpat }
  { copyright 2022 }
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

type
  TfrmQuiverOptInstance = class(TFrame)
  private
    FSettings: TSERTTKQuiverSettings;
    // procedure LinkClick(Sender: TObject; const Link: string; LinkType: TSysLinkType);
  public
    property QuiverSettings: TSERTTKQuiverSettings read FSettings write FSettings;
    procedure InitializeFrame;
    procedure FinalizeFrame;
  end;

  TSERTTKQuiverIDEOptionsInterface = Class(TInterfacedObject, INTAAddInOptions)
  Strict Private
    FFrame: TfrmQuiverOptInstance;
    FSettings: TSERTTKQuiverSettings;
  Strict Protected
  Public
    property QuiverSettings: TSERTTKQuiverSettings read FSettings write FSettings;
    Procedure DialogClosed(Accepted: Boolean);
    Procedure FrameCreated(AFrame: TCustomFrame);
    Function GetArea: String;
    Function GetCaption: String;
    Function GetFrameClass: TCustomFrameClass;
    Function GetHelpContext: Integer;
    Function IncludeInIDEInsight: Boolean;
    Function ValidateContents: Boolean;
  End;

implementation

{$R *.dfm}
{ TSERTTKQuiverIDEOptionsInterface }

procedure TSERTTKQuiverIDEOptionsInterface.DialogClosed(Accepted: Boolean);
begin
  if Accepted then
    FFrame.FinalizeFrame;
end;

procedure TSERTTKQuiverIDEOptionsInterface.FrameCreated(AFrame: TCustomFrame);
begin
  If AFrame Is TfrmQuiverOptInstance Then
  Begin
    FFrame := AFrame As TfrmQuiverOptInstance;
    FFrame.QuiverSettings := QuiverSettings;
    FFrame.InitializeFrame;
  End;
end;

function TSERTTKQuiverIDEOptionsInterface.GetArea: String;
begin
  result := '';
end;

function TSERTTKQuiverIDEOptionsInterface.GetCaption: String;
begin
  result := caption_options_label;
end;

function TSERTTKQuiverIDEOptionsInterface.GetFrameClass: TCustomFrameClass;
begin
  result := TfrmQuiverOptInstance;
end;

function TSERTTKQuiverIDEOptionsInterface.GetHelpContext: Integer;
begin
  result := 0;
end;

function TSERTTKQuiverIDEOptionsInterface.IncludeInIDEInsight: Boolean;
begin
  result := true;
end;

function TSERTTKQuiverIDEOptionsInterface.ValidateContents: Boolean;
begin
  result := true;
end;

{ TfrmQuiverOptInstance }

procedure TfrmQuiverOptInstance.FinalizeFrame;
begin

end;

procedure TfrmQuiverOptInstance.InitializeFrame;
begin

end;

end.
