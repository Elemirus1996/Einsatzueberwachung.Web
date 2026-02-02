using Einsatzueberwachung.Web.Client.Pages;
using Einsatzueberwachung.Web.Components;
using Einsatzueberwachung.Domain.Interfaces;
using Einsatzueberwachung.Domain.Services;
using Einsatzueberwachung.Web.Middleware;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.AspNetCore.ResponseCompression;
using System.IO.Compression;
using FluentValidation;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents()
    .AddInteractiveWebAssemblyComponents();

// Response Compression fä¼r bessere Performance
builder.Services.AddResponseCompression(options =>
{
    options.EnableForHttps = true;
    options.Providers.Add<BrotliCompressionProvider>();
    options.Providers.Add<GzipCompressionProvider>();
    options.MimeTypes = ResponseCompressionDefaults.MimeTypes.Concat(
        new[] { "application/json", "text/css", "text/javascript", "image/svg+xml" });
});

builder.Services.Configure<BrotliCompressionProviderOptions>(options =>
{
    options.Level = CompressionLevel.Fastest;
});

builder.Services.Configure<GzipCompressionProviderOptions>(options =>
{
    options.Level = CompressionLevel.Optimal;
});

// Response Caching
builder.Services.AddResponseCaching();

// Cookie-Policy fü¿½r HTTPS
builder.Services.Configure<CookiePolicyOptions>(options =>
{
    options.MinimumSameSitePolicy = SameSiteMode.Strict;
    options.Secure = CookieSecurePolicy.Always;
});

// API Controllers fü¿½r Mobile Support
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// HttpClient fü¿½r interne API-Calls
builder.Services.AddHttpClient();

// SignalR fä¼r Echtzeit-Updates mit optimierter Konfiguration
builder.Services.AddSignalR(options =>
{
    options.EnableDetailedErrors = builder.Environment.IsDevelopment();
    options.KeepAliveInterval = TimeSpan.FromSeconds(15);
    options.ClientTimeoutInterval = TimeSpan.FromSeconds(30);
    options.HandshakeTimeout = TimeSpan.FromSeconds(15);
    options.MaximumReceiveMessageSize = 32 * 1024; // 32 KB
    options.StreamBufferCapacity = 10;
});

// CORS fü¿½r mobile Clients (lokales Netzwerk)
builder.Services.AddCors(options =>
{
    options.AddPolicy("MobilePolicy", policy =>
    {
        // Nur lokales Netzwerk erlauben (192.168.x.x, 10.x.x.x, 172.16-31.x.x, localhost)
        policy.WithOrigins(
                  "http://localhost:*",
                  "https://localhost:*",
                  "http://192.168.*.*",
                  "http://10.*.*.*",
                  "http://172.16.*.*",
                  "http://172.17.*.*",
                  "http://172.18.*.*",
                  "http://172.19.*.*",
                  "http://172.20.*.*",
                  "http://172.21.*.*",
                  "http://172.22.*.*",
                  "http://172.23.*.*",
                  "http://172.24.*.*",
                  "http://172.25.*.*",
                  "http://172.26.*.*",
                  "http://172.27.*.*",
                  "http://172.28.*.*",
                  "http://172.29.*.*",
                  "http://172.30.*.*",
                  "http://172.31.*.*")
              .SetIsOriginAllowedToAllowWildcardSubdomains()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// JWT Authentication fü¿½r zukü¿½nftigen externen Zugriff
var jwtKey = builder.Configuration["Jwt:Key"] ?? "EinsatzueberwachungSecretKey2024!";
var jwtIssuer = builder.Configuration["Jwt:Issuer"] ?? "Einsatzueberwachung";
var jwtAudience = builder.Configuration["Jwt:Audience"] ?? "EinsatzueberwachungMobile";

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtIssuer,
            ValidAudience = jwtAudience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey))
        };
        
        // SignalR Token aus Query String
        options.Events = new JwtBearerEvents
        {
            OnMessageReceived = context =>
            {
                var accessToken = context.Request.Query["access_token"];
                var path = context.HttpContext.Request.Path;
                if (!string.IsNullOrEmpty(accessToken) && path.StartsWithSegments("/hubs"))
                {
                    context.Token = accessToken;
                }
                return Task.CompletedTask;
            }
        };
    });

builder.Services.AddAuthorization();

// Registriere Domain-Services als Singletons (für den laufenden Einsatz)
builder.Services.AddSingleton<IMasterDataService, MasterDataService>();
builder.Services.AddSingleton<IEinsatzService, EinsatzService>();
builder.Services.AddSingleton<ISettingsService, SettingsService>();
builder.Services.AddSingleton<IPdfExportService, PdfExportService>();
builder.Services.AddSingleton<ToastService>();
builder.Services.AddSingleton<ThemeService>();

// FluentValidation Validators registrieren
builder.Services.AddValidatorsFromAssembly(typeof(Einsatzueberwachung.Domain.Models.PersonalEntry).Assembly);

// Global Exception Handler
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();
builder.Services.AddProblemDetails();

// Health Checks
builder.Services.AddHealthChecks();

// Update Services für GitHub Auto-Update
builder.Services.AddHttpClient<GitHubUpdateService>();
builder.Services.AddSingleton<GitHubUpdateService>();
builder.Services.AddSingleton<Einsatzueberwachung.Web.Services.UpdateCheckService>();
builder.Services.AddHostedService(sp => sp.GetRequiredService<Einsatzueberwachung.Web.Services.UpdateCheckService>());

// SignalR Broadcast Service für mobile Updates
builder.Services.AddHostedService<Einsatzueberwachung.Web.Services.SignalRBroadcastService>();

var app = builder.Build();

// Response Compression aktivieren
app.UseResponseCompression();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseWebAssemblyDebugging();
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseHsts();
}

// Global Exception Handler (für alle Umgebungen)
app.UseExceptionHandler();

// Static Files BEFORE HTTPS Redirect for better compatibility
app.UseStaticFiles(new StaticFileOptions
{
    OnPrepareResponse = ctx =>
    {
        // Cache static files for 30 days
        ctx.Context.Response.Headers.Append("Cache-Control", "public,max-age=2592000");
    }
});

app.UseHttpsRedirection();

// Response Caching
app.UseResponseCaching();

app.UseCookiePolicy();

// CORS muss vor Authentication/Authorization kommen
app.UseCors("MobilePolicy");

app.UseAuthentication();
app.UseAuthorization();

app.UseAntiforgery();

// API Controllers
app.MapControllers();

// Health Check Endpoint
app.MapHealthChecks("/health");

// SignalR Hub
app.MapHub<Einsatzueberwachung.Web.Hubs.EinsatzHub>("/hubs/einsatz");

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(typeof(Einsatzueberwachung.Web.Client._Imports).Assembly);

app.Run();
