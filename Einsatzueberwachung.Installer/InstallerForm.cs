using System;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Einsatzueberwachung.Installer
{
    public partial class InstallerForm : Form
    {
        private readonly SystemChecker _systemChecker;
        private bool _isInstalling = false;

        public InstallerForm()
        {
            InitializeComponent();
            _systemChecker = new SystemChecker();
            this.Text = "Einsatzüberwachung Setup";
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Size = new System.Drawing.Size(600, 500);
        }

        private async void InstallerForm_Load(object sender, EventArgs e)
        {
            await PerformInitialChecks();
        }

        private async Task PerformInitialChecks()
        {
            try
            {
                // .NET 8 Prüfung
                var dotnetResult = await _systemChecker.CheckDotNetInstallationAsync();
                
                if (!dotnetResult.IsInstalled)
                {
                    ShowError(
                        ".NET 8 SDK nicht installiert\n\n" +
                        "Bitte installieren Sie .NET 8 SDK von:\n" +
                        "https://dotnet.microsoft.com/download/dotnet/8.0\n\n" +
                        "Nach der Installation bitte diesen Installer neu starten."
                    );
                    this.Close();
                    return;
                }

                if (!dotnetResult.IsSuitable)
                {
                    ShowError(
                        $"Falsche .NET Version: {dotnetResult.Version}\n\n" +
                        "Benötigt: .NET 8.x\n" +
                        "Bitte installieren Sie die richtige Version von:\n" +
                        "https://dotnet.microsoft.com/download/dotnet/8.0"
                    );
                    this.Close();
                    return;
                }

                ShowInfo($"✓ .NET 8 SDK gefunden: {dotnetResult.Version}");
            }
            catch (Exception ex)
            {
                ShowError($"Fehler beim Systemcheck:\n{ex.Message}");
                this.Close();
            }
        }

        private void ShowInfo(string message)
        {
            MessageBox.Show(message, "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void ShowError(string message)
        {
            MessageBox.Show(message, "Fehler", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }

        private void InitializeComponent()
        {
            var panel = new Panel
            {
                Dock = DockStyle.Fill,
                Padding = new Padding(20)
            };

            var titleLabel = new Label
            {
                Text = "Einsatzüberwachung Setup",
                Font = new System.Drawing.Font("Segoe UI", 18, System.Drawing.FontStyle.Bold),
                AutoSize = true
            };

            var descLabel = new Label
            {
                Text = "Willkommen bei der Installation von Einsatzüberwachung!\n\nDieser Installer wird die Anwendung auf Ihrem Computer einrichten.",
                AutoSize = true,
                MaximumSize = new System.Drawing.Size(500, 0),
                Margin = new Padding(0, 20, 0, 0)
            };

            var installPathLabel = new Label
            {
                Text = "Installationsort:",
                AutoSize = true,
                Margin = new Padding(0, 20, 0, 5)
            };

            var installPathTextBox = new TextBox
            {
                Text = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), "Einsatzueberwachung"),
                ReadOnly = false,
                Width = 500,
                Margin = new Padding(0, 0, 0, 20)
            };

            var desktopShortcutCheckBox = new CheckBox
            {
                Text = "Desktop-Verknüpfung erstellen",
                Checked = true,
                AutoSize = true,
                Margin = new Padding(0, 0, 0, 20)
            };

            var autoStartCheckBox = new CheckBox
            {
                Text = "Nach Installation starten",
                Checked = true,
                AutoSize = true,
                Margin = new Padding(0, 0, 0, 20)
            };

            var installButton = new Button
            {
                Text = "Installieren",
                Width = 150,
                Height = 40,
                BackColor = System.Drawing.Color.Green,
                ForeColor = System.Drawing.Color.White,
                Font = new System.Drawing.Font("Segoe UI", 12, System.Drawing.FontStyle.Bold),
                Margin = new Padding(0, 20, 10, 0)
            };

            var cancelButton = new Button
            {
                Text = "Abbrechen",
                Width = 150,
                Height = 40,
                Margin = new Padding(0, 20, 0, 0)
            };

            installButton.Click += async (s, e) => await InstallAsync(installPathTextBox.Text, desktopShortcutCheckBox.Checked, autoStartCheckBox.Checked, installButton, cancelButton);
            cancelButton.Click += (s, e) => this.Close();

            var buttonPanel = new FlowLayoutPanel
            {
                AutoSize = true,
                FlowDirection = FlowDirection.LeftToRight,
                Margin = new Padding(0, 20, 0, 0)
            };
            buttonPanel.Controls.Add(installButton);
            buttonPanel.Controls.Add(cancelButton);

            panel.Controls.AddRange(new Control[] {
                titleLabel,
                descLabel,
                installPathLabel,
                installPathTextBox,
                desktopShortcutCheckBox,
                autoStartCheckBox,
                buttonPanel
            });

            this.Controls.Add(panel);
            this.FormClosing += (s, e) => { if (_isInstalling) e.Cancel = true; };
        }

        private async Task InstallAsync(string installPath, bool createShortcut, bool autoStart, Button installButton, Button cancelButton)
        {
            if (_isInstalling)
                return;

            _isInstalling = true;
            installButton.Enabled = false;
            cancelButton.Enabled = false;

            try
            {
                installButton.Text = "Wird installiert...";

                // Überprüfe ob Pfad bereits existiert
                if (Directory.Exists(installPath))
                {
                    if (MessageBox.Show(
                        "Verzeichnis existiert bereits. Überschreiben?",
                        "Bestätigung",
                        MessageBoxButtons.YesNo,
                        MessageBoxIcon.Question) == DialogResult.No)
                    {
                        return;
                    }
                }
                else
                {
                    Directory.CreateDirectory(installPath);
                }

                // Git Clone
                if (!Directory.Exists(Path.Combine(installPath, ".git")))
                {
                    ShowInfo("Downloade Anwendung von GitHub...");
                    var downloaded = await _systemChecker.DownloadRepositoryAsync(installPath);
                    
                    if (!downloaded)
                    {
                        ShowError("Download fehlgeschlagen. Prüfen Sie Ihre Internetverbindung.");
                        return;
                    }
                }

                // Desktop Shortcut
                if (createShortcut)
                {
                    var shortcutCreated = await _systemChecker.CreateDesktopShortcutAsync(installPath);
                    if (shortcutCreated)
                        ShowInfo("✓ Desktop-Verknüpfung erstellt");
                }

                ShowInfo("✓ Installation erfolgreich abgeschlossen!");

                if (autoStart)
                {
                    // Starte die Anwendung
                    var batPath = Path.Combine(installPath, "Einsatzueberwachung-Starten.bat");
                    if (File.Exists(batPath))
                    {
                        Process.Start(new ProcessStartInfo
                        {
                            FileName = batPath,
                            WorkingDirectory = installPath,
                            UseShellExecute = true
                        });
                    }
                }

                this.Close();
            }
            catch (Exception ex)
            {
                ShowError($"Fehler bei der Installation:\n{ex.Message}");
            }
            finally
            {
                _isInstalling = false;
                installButton.Enabled = true;
                cancelButton.Enabled = true;
                installButton.Text = "Installieren";
            }
        }
    }

    static class Program
    {
        [STAThread]
        static void Main()
        {
            ApplicationConfiguration.Initialize();
            Application.Run(new InstallerForm());
        }
    }
}
