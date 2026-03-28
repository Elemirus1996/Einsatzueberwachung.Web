[Setup]
AppName=Einsatzüberwachung
AppVersion=4.0.0
AppId={{B8C1B81C-2C7F-4D58-9B4F-83A6F3E1C2C5}
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
UsePreviousAppDir=yes
UsePreviousGroup=yes

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
Source: "Einsatzueberwachung-Starter.ps1"; DestDir: "{app}"; Flags: ignoreversion replacesameversion
Source: "Einsatzueberwachung-Starter.bat"; DestDir: "{app}"; Flags: ignoreversion replacesameversion

[Icons]
Name: "{autoprograms}\Einsatzüberwachung"; Filename: "{app}\Einsatzueberwachung-Starter.bat"
Name: "{autodesktop}\Einsatzüberwachung"; Filename: "{app}\Einsatzueberwachung-Starter.bat"; Tasks: desktopicon

[Run]
Filename: "{app}\Einsatzueberwachung-Starter.bat"; Description: "Einsatzüberwachung jetzt starten"; Flags: postinstall nowait skipifsilent

[Code]
const
  AppIdValue = '{B8C1B81C-2C7F-4D58-9B4F-83A6F3E1C2C5}';
  CurrentVersion = '4.0.0';

function IsDotNetInstalled: Boolean;
var
  ResultCode: Integer;
begin
  Result := Exec('dotnet', '--version', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) and (ResultCode = 0);
end;

function GetInstalledVersion: string;
var
  Key: string;
begin
  Key := 'Software\Microsoft\Windows\CurrentVersion\Uninstall\' + AppIdValue + '_is1';
  
  if RegQueryStringValue(HKCU, Key, 'DisplayVersion', Result) then
    exit;
    
  if RegQueryStringValue(HKLM, Key, 'DisplayVersion', Result) then
    exit;
    
  Result := '';
end;

function CompareVersions(V1, V2: string): Integer;
var
  P1, P2: Integer;
  N1, N2: Integer;
begin
  // Vergleicht zwei Versionsstrings (z.B. "3.9.0" vs "3.10.0")
  // Rückgabe: -1 wenn V1 < V2, 0 wenn gleich, 1 wenn V1 > V2
  Result := 0;
  
  while (Length(V1) > 0) or (Length(V2) > 0) do
  begin
    // Nächste Zahl aus V1 extrahieren
    P1 := Pos('.', V1);
    if P1 = 0 then P1 := Length(V1) + 1;
    N1 := StrToIntDef(Copy(V1, 1, P1-1), 0);
    Delete(V1, 1, P1);
    
    // Nächste Zahl aus V2 extrahieren
    P2 := Pos('.', V2);
    if P2 = 0 then P2 := Length(V2) + 1;
    N2 := StrToIntDef(Copy(V2, 1, P2-1), 0);
    Delete(V2, 1, P2);
    
    if N1 < N2 then
    begin
      Result := -1;
      exit;
    end
    else if N1 > N2 then
    begin
      Result := 1;
      exit;
    end;
  end;
end;

function GetUninstallString: string;
var
  Key: string;
begin
  Key := 'Software\Microsoft\Windows\CurrentVersion\Uninstall\' + AppIdValue + '_is1';

  if RegQueryStringValue(HKCU, Key, 'UninstallString', Result) then
    exit;

  if RegQueryStringValue(HKLM, Key, 'UninstallString', Result) then
    exit;

  Result := '';
end;

function UninstallExisting: Boolean;
var
  UninstallCmd: string;
  InstalledVersion: string;
  ResultCode: Integer;
begin
  Result := True;
  UninstallCmd := GetUninstallString;
  InstalledVersion := GetInstalledVersion;

  if UninstallCmd <> '' then
  begin
    // Prüfe ob eine ältere Version installiert ist
    if CompareVersions(InstalledVersion, CurrentVersion) < 0 then
    begin
      MsgBox('Version ' + InstalledVersion + ' wird auf ' + CurrentVersion + ' aktualisiert.', mbInformation, MB_OK);
      if not Exec(RemoveQuotes(UninstallCmd), '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
      begin
        MsgBox('Die ältere Version konnte nicht automatisch deinstalliert werden. Bitte manuell deinstallieren und erneut starten.', mbError, MB_OK);
        Result := False;
      end;
    end
    else if CompareVersions(InstalledVersion, CurrentVersion) = 0 then
    begin
      // Gleiche Version - Neuinstallation/Reparatur
      if MsgBox('Version ' + CurrentVersion + ' ist bereits installiert.' + #13#10 + #13#10 +
                'Möchten Sie die Installation reparieren?', mbConfirmation, MB_YESNO) = IDYES then
      begin
        if not Exec(RemoveQuotes(UninstallCmd), '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
        begin
          MsgBox('Die bestehende Installation konnte nicht entfernt werden.', mbError, MB_OK);
          Result := False;
        end;
      end
      else
        Result := False;
    end
    else
    begin
      // Neuere Version installiert - Downgrade warnen
      if MsgBox('Eine neuere Version (' + InstalledVersion + ') ist bereits installiert.' + #13#10 + #13#10 +
                'Möchten Sie wirklich auf Version ' + CurrentVersion + ' downgraden?', mbConfirmation, MB_YESNO) = IDYES then
      begin
        if not Exec(RemoveQuotes(UninstallCmd), '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
        begin
          MsgBox('Die neuere Version konnte nicht deinstalliert werden.', mbError, MB_OK);
          Result := False;
        end;
      end
      else
        Result := False;
    end;
  end;
end;

function InitializeSetup(): Boolean;
begin
  Result := True;

  if not UninstallExisting then
  begin
    Result := False;
    exit;
  end;
  
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
