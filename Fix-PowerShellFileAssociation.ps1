# PowerShell-Dateityp-Zuordnung reparieren
# Starten Sie dieses Skript mit erhöhten Rechten (Als Administrator ausführen)

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Prüfe auf Administrator-Rechte
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ Dieses Skript muss mit Administratorrechten ausgeführt werden!" -ForegroundColor Red
    Write-Host "   Bitte klicken Sie mit rechts auf 'Fix-PowerShellFileAssociation.ps1' und wählen 'Als Administrator ausführen'."
    exit 1
}

Write-Host "🔧 Repariere PowerShell-Dateityp-Zuordnung..." -ForegroundColor Green

try {
    # Registry-Pfade
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ps1\UserChoice"
    
    # Versuche, die UserChoice zu löschen (diese blockiert die Zuordnung)
    if (Test-Path $regPath) {
        Write-Host "  Entferne alte Zuordnung..."
        Remove-Item $regPath -Force -ErrorAction SilentlyContinue
    }
    
    # Setze PowerShell als Standard
    $regProgid = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ps1\ProgId"
    New-Item -Path $regProgid -Force | Out-Null
    Set-ItemProperty -Path $regProgid -Name "(Default)" -Value "Microsoft.PowerShellScript.1" -Force
    
    # Assoc-Befehl
    cmd /c "assoc .ps1=Microsoft.PowerShellScript.1" | Out-Null
    
    # Ftype-Befehl
    cmd /c 'ftype Microsoft.PowerShellScript.1="C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -NoExit -File "%%1"' | Out-Null
    
    Write-Host "✅ PowerShell-Dateityp-Zuordnung erfolgreich repariert!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Sie können nun .ps1-Dateien direkt doppelklicken, um sie mit PowerShell auszuführen."
    
} catch {
    Write-Host "❌ Fehler beim Reparieren der Dateityp-Zuordnung:" -ForegroundColor Red
    Write-Host "   $_"
    exit 1
}
