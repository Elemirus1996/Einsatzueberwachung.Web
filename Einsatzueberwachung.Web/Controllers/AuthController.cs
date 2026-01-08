// REST API Controller für Authentifizierung
// JWT Token-basierte Authentifizierung für mobilen Zugriff

using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Einsatzueberwachung.Web.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    public class AuthController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly ILogger<AuthController> _logger;

        public AuthController(IConfiguration configuration, ILogger<AuthController> logger)
        {
            _configuration = configuration;
            _logger = logger;
        }

        /// <summary>
        /// Login-Endpunkt für mobile Clients
        /// HINWEIS: Vereinfachte Implementierung für Phase 1 (lokales Netzwerk)
        /// Für Produktionsumgebung sollte eine vollständige User-Datenbank verwendet werden
        /// </summary>
        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginRequest request)
        {
            try
            {
                // PHASE 1: Einfache Validierung gegen konfigurierte Credentials
                // TODO: Für Production - User-Datenbank mit gehashten Passwörtern implementieren
                var configuredUsername = _configuration["Auth:Username"] ?? "einsatzleiter";
                var configuredPassword = _configuration["Auth:Password"] ?? "einsatz2024";

                if (request.Username != configuredUsername || request.Password != configuredPassword)
                {
                    _logger.LogWarning("Fehlgeschlagener Login-Versuch: {Username}", request.Username);
                    return Unauthorized(new { Error = "Ungültige Anmeldedaten" });
                }

                // JWT Token erstellen
                var token = GenerateJwtToken(request.Username);
                
                _logger.LogInformation("Erfolgreicher Login: {Username}", request.Username);

                return Ok(new
                {
                    Token = token,
                    Username = request.Username,
                    Role = "Einsatzleiter",
                    ExpiresIn = 3600 // 1 Stunde in Sekunden
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Login");
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        /// <summary>
        /// Token-Refresh-Endpunkt
        /// </summary>
        [HttpPost("refresh")]
        public IActionResult RefreshToken([FromBody] RefreshTokenRequest request)
        {
            try
            {
                // Token validieren und neuen Token erstellen
                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.UTF8.GetBytes(_configuration["Jwt:Key"] ?? "EinsatzueberwachungSecretKey2024!");

                var validationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = true,
                    ValidIssuer = _configuration["Jwt:Issuer"] ?? "Einsatzueberwachung",
                    ValidateAudience = true,
                    ValidAudience = _configuration["Jwt:Audience"] ?? "EinsatzueberwachungMobile",
                    ValidateLifetime = false // Erlaube abgelaufene Tokens für Refresh
                };

                var principal = tokenHandler.ValidateToken(request.Token, validationParameters, out var validatedToken);
                var username = principal.Identity?.Name;

                if (string.IsNullOrEmpty(username))
                {
                    return Unauthorized(new { Error = "Ungültiger Token" });
                }

                // Neuen Token erstellen
                var newToken = GenerateJwtToken(username);

                _logger.LogInformation("Token erneuert für: {Username}", username);

                return Ok(new
                {
                    Token = newToken,
                    Username = username,
                    ExpiresIn = 3600
                });
            }
            catch (SecurityTokenException)
            {
                return Unauthorized(new { Error = "Ungültiger Token" });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Fehler beim Token-Refresh");
                return StatusCode(500, new { Error = "Interner Serverfehler" });
            }
        }

        private string GenerateJwtToken(string username)
        {
            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(_configuration["Jwt:Key"] ?? "EinsatzueberwachungSecretKey2024!")
            );
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(ClaimTypes.Name, username),
                new Claim(ClaimTypes.Role, "Einsatzleiter"),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(JwtRegisteredClaimNames.Iat, DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString())
            };

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"] ?? "Einsatzueberwachung",
                audience: _configuration["Jwt:Audience"] ?? "EinsatzueberwachungMobile",
                claims: claims,
                expires: DateTime.UtcNow.AddHours(1),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }

    // DTOs
    public class LoginRequest
    {
        public required string Username { get; set; }
        public required string Password { get; set; }
    }

    public class RefreshTokenRequest
    {
        public required string Token { get; set; }
    }
}
