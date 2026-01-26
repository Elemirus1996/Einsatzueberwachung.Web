using System;
using System.Diagnostics;
using System.IO;
using System.Net.Http;
using System.Runtime.InteropServices;
using System.Threading.Tasks;

namespace Einsatzueberwachung.Installer
{
    public class SystemChecker
    {
        public async Task<DotNetCheckResult> CheckDotNetInstallationAsync()
        {
            try
            {
                var processInfo = new ProcessStartInfo
                {
                    FileName = "dotnet",
                    Arguments = "--version",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    CreateNoWindow = true
                };

                using var process = Process.Start(processInfo);
                if (process == null)
                    return new DotNetCheckResult { IsInstalled = false };

                var output = await process.StandardOutput.ReadLineAsync();
                process.WaitForExit();

                if (!string.IsNullOrEmpty(output) && output.StartsWith("8"))
                {
                    return new DotNetCheckResult
                    {
                        IsInstalled = true,
                        Version = output.Trim(),
                        IsSuitable = true
                    };
                }

                return new DotNetCheckResult
                {
                    IsInstalled = true,
                    Version = output?.Trim() ?? "unknown",
                    IsSuitable = false
                };
            }
            catch
            {
                return new DotNetCheckResult { IsInstalled = false };
            }
        }

        public bool RepositoryExists(string path)
        {
            return Directory.Exists(path) && 
                   File.Exists(Path.Combine(path, "Einsatzueberwachung.Web.sln"));
        }

        public async Task<bool> CreateDesktopShortcutAsync(string appPath)
        {
            try
            {
                var shortcutPath = Path.Combine(
                    Environment.GetFolderPath(Environment.SpecialFolder.Desktop),
                    "Einsatzüberwachung.lnk"
                );

                var batPath = Path.Combine(appPath, "Einsatzueberwachung-Starten.bat");
                if (!File.Exists(batPath))
                    return false;

                // WScript.Shell für Shortcut-Erstellung (nur Windows)
                if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                {
                    dynamic shell = Activator.CreateInstance(Type.GetTypeFromProgID("WScript.Shell")!);
                    dynamic link = shell.CreateShortCut(shortcutPath);

                    link.TargetPath = batPath;
                    link.WorkingDirectory = appPath;
                    link.Description = "Einsatzüberwachung - Rettungshunde-Einsatz-Koordination";
                    link.WindowStyle = 1; // Normal window
                    link.Save();

                    return true;
                }
                return false;
            }
            catch
            {
                return false;
            }
        }

        public async Task<bool> DownloadRepositoryAsync(string targetPath)
        {
            try
            {
                // Git Clone durchführen
                var processInfo = new ProcessStartInfo
                {
                    FileName = "git",
                    Arguments = $"clone https://github.com/Elemirus1996/Einsatzueberwachung.Web.git \"{targetPath}\"",
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                };

                using var process = Process.Start(processInfo);
                if (process == null)
                    return false;

                await process.StandardOutput.ReadToEndAsync();
                process.WaitForExit();

                return process.ExitCode == 0;
            }
            catch
            {
                return false;
            }
        }
    }

    public class DotNetCheckResult
    {
        public bool IsInstalled { get; set; }
        public bool IsSuitable { get; set; }
        public string Version { get; set; } = "not installed";
    }
}
