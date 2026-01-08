// Controller für QR-Code-Generierung und Netzwerk-Info
// Ermöglicht einfachen Zugriff auf Mobile Dashboard via QR-Code

using Microsoft.AspNetCore.Mvc;
using QRCoder;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;

namespace Einsatzueberwachung.Web.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NetworkController : ControllerBase
    {
        private readonly ILogger<NetworkController> _logger;
        private readonly IConfiguration _configuration;

        public NetworkController(ILogger<NetworkController> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
        }

        /// <summary>
        /// Gibt die aktuelle Server-IP-Adresse und URLs zurück
        /// </summary>
        [HttpGet("info")]
        public IActionResult GetNetworkInfo()
        {
            try
            {
                var ipAddresses = GetLocalIPAddresses();
                var port = _configuration["Urls"]?.Contains("5000") == true ? 5000 : 5000;
                var httpsPort = _configuration["Urls"]?.Contains("5001") == true ? 5001 : 5001;

                var urls = ipAddresses.Select(ip => new
                {
                    IP = ip,
                    HttpUrl = $"http://{ip}:{port}",
                    HttpsUrl = $"https://{ip}:{httpsPort}",
                    MobileUrl = $"http://{ip}:{port}/mobile",
                    MobileHttpsUrl = $"https://{ip}:{httpsPort}/mobile"
                }).ToList();

                return Ok(new
                {
                    ServerIPs = ipAddresses,
                    Port = port,
                    HttpsPort = httpsPort,
                    AccessUrls = urls,
                    HostName = Dns.GetHostName(),
                    Timestamp = DateTime.Now
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Abrufen der Netzwerk-Informationen");
                return StatusCode(500, new { Error = "Fehler beim Abrufen der Netzwerk-Informationen" });
            }
        }

        /// <summary>
        /// Generiert einen QR-Code für den Zugriff auf das Mobile Dashboard
        /// </summary>
        [HttpGet("qrcode")]
        public IActionResult GetQRCode([FromQuery] string? url = null, [FromQuery] int size = 300)
        {
            try
            {
                // Wenn keine URL angegeben, verwende erste verfügbare IP
                if (string.IsNullOrEmpty(url))
                {
                    var ipAddresses = GetLocalIPAddresses();
                    if (!ipAddresses.Any())
                    {
                        return BadRequest(new { Error = "Keine Netzwerk-IP gefunden" });
                    }

                    var primaryIP = ipAddresses.First();
                    var port = _configuration["Urls"]?.Contains("5000") == true ? 5000 : 5000;
                    url = $"http://{primaryIP}:{port}/mobile";
                }

                // QR-Code generieren (PNG-Bytes)
                using var qrGenerator = new QRCodeGenerator();
                using var qrCodeData = qrGenerator.CreateQrCode(url, QRCodeGenerator.ECCLevel.Q);
                var qrCode = new PngByteQRCode(qrCodeData);
                var qrCodeBytes = qrCode.GetGraphic(20);

                _logger.LogInformation("QR-Code generiert für URL: {Url}", url);

                return File(qrCodeBytes, "image/png");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Generieren des QR-Codes");
                return StatusCode(500, new { Error = "Fehler beim Generieren des QR-Codes" });
            }
        }

        /// <summary>
        /// Gibt alle verfügbaren QR-Codes für verschiedene IPs zurück (als Base64)
        /// </summary>
        [HttpGet("qrcodes")]
        public IActionResult GetAllQRCodes([FromQuery] int size = 300)
        {
            try
            {
                var ipAddresses = GetLocalIPAddresses();
                var port = _configuration["Urls"]?.Contains("5000") == true ? 5000 : 5000;
                var qrCodes = new List<object>();

                foreach (var ip in ipAddresses)
                {
                    var url = $"http://{ip}:{port}/mobile";

                    using var qrGenerator = new QRCodeGenerator();
                    using var qrCodeData = qrGenerator.CreateQrCode(url, QRCodeGenerator.ECCLevel.Q);
                    var qrCode = new PngByteQRCode(qrCodeData);
                    var qrCodeBytes = qrCode.GetGraphic(20);
                    var base64 = Convert.ToBase64String(qrCodeBytes);

                    qrCodes.Add(new
                    {
                        IP = ip,
                        Url = url,
                        QRCodeBase64 = base64,
                        DataUri = $"data:image/png;base64,{base64}"
                    });
                }

                return Ok(qrCodes);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Generieren der QR-Codes");
                return StatusCode(500, new { Error = "Fehler beim Generieren der QR-Codes" });
            }
        }

        private List<string> GetLocalIPAddresses()
        {
            var ipAddresses = new List<string>();

            try
            {
                var host = Dns.GetHostEntry(Dns.GetHostName());

                foreach (var ip in host.AddressList)
                {
                    // Nur IPv4 und keine Loopback-Adressen
                    if (ip.AddressFamily == AddressFamily.InterNetwork && !IPAddress.IsLoopback(ip))
                    {
                        ipAddresses.Add(ip.ToString());
                    }
                }

                // Fallback: Netzwerk-Interfaces durchsuchen
                if (!ipAddresses.Any())
                {
                    var interfaces = NetworkInterface.GetAllNetworkInterfaces()
                        .Where(ni => ni.OperationalStatus == OperationalStatus.Up &&
                                     ni.NetworkInterfaceType != NetworkInterfaceType.Loopback);

                    foreach (var ni in interfaces)
                    {
                        var properties = ni.GetIPProperties();
                        foreach (var ip in properties.UnicastAddresses)
                        {
                            if (ip.Address.AddressFamily == AddressFamily.InterNetwork)
                            {
                                ipAddresses.Add(ip.Address.ToString());
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Ermitteln der IP-Adressen");
            }

            return ipAddresses.Distinct().ToList();
        }
    }
}
