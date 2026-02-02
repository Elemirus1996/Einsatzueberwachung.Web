[Setup]
AppName=Einsatzüberwachung
AppVersion=3.2
AppPublisher=Rettungshunde-Einsatz-Koordination
AppPublisherURL=https://github.com/Elemirus1996/Einsatzueberwachung.Web
DefaultDirName={userpf}\Einsatzueberwachung
DefaultGroupName=Einsatzüberwachung
OutputBaseFilename=EinsatzueberwachungSetup
Compression=lzma2/max
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=lowest
WizardStyle=modern
DisableProgramGroupPage=yes

[Languages]
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "Desktop-Verknüpfung erstellen"; GroupDescription: "Zusätzliche Symbole:"; Flags: unchecked

[Files]
; Solution file
Source: "..\Einsatzueberwachung.Web.sln"; DestDir: "{app}"; Flags: ignoreversion
; Hauptprojekt Dateien (ohne bin/obj)
Source: "..\Einsatzueberwachung.Web\*"; DestDir: "{app}\Einsatzueberwachung.Web"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "bin,obj,*.user"
Source: "..\Einsatzueberwachung.Web.Client\*"; DestDir: "{app}\Einsatzueberwachung.Web.Client"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "bin,obj,*.user"
Source: "..\Einsatzueberwachung.Domain\*"; DestDir: "{app}\Einsatzueberwachung.Domain"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "bin,obj,*.user"
Source: "Einsatzueberwachung-Starter.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "Einsatzueberwachung-Starter.bat"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\Einsatzüberwachung"; Filename: "{app}\Einsatzueberwachung-Starter.bat"
Name: "{autodesktop}\Einsatzüberwachung"; Filename: "{app}\Einsatzueberwachung-Starter.bat"; Tasks: desktopicon

[Run]
Filename: "{app}\Einsatzueberwachung-Starter.bat"; Description: "Einsatzüberwachung jetzt starten"; Flags: postinstall nowait skipifsilent

[Code]
function IsDotNetInstalled: Boolean;
var
  ResultCode: Integer;
begin
  Result := Exec('dotnet', '--version', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) and (ResultCode = 0);
end;

function InitializeSetup(): Boolean;
begin
  Result := True;
  
  if not IsDotNetInstalled then
  begin
    if MsgBox('.NET 8 SDK ist nicht installiert.' + #13#10 + #13#10 +
              'Die Anwendung benötigt .NET 8 SDK zum Ausführen.' + #13#10 +
              'Möchten Sie die Installation trotzdem fortsetzen?' + #13#10 + #13#10 +
              'Sie können .NET 8 SDK später von dieser Adresse herunterladen:' + #13#10 +
              'https://dotnet.microsoft.com/download/dotnet/8.0', 
              mbConfirmation, MB_YESNO) = IDYES then
      Result := True
    else
      Result := False;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    // Restore NuGet packages
    if IsDotNetInstalled then
    begin
      Exec('dotnet', 'restore "' + ExpandConstant('{app}\Einsatzueberwachung.Web.sln') + '"', 
           ExpandConstant('{app}'), SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
  end;
end;
