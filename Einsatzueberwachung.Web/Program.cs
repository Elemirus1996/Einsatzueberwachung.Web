using Einsatzueberwachung.Web.Client.Pages;
using Einsatzueberwachung.Web.Components;
using Einsatzueberwachung.Domain.Interfaces;
using Einsatzueberwachung.Domain.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents()
    .AddInteractiveWebAssemblyComponents();

// Cookie-Policy für HTTPS
builder.Services.Configure<CookiePolicyOptions>(options =>
{
    options.MinimumSameSitePolicy = SameSiteMode.Strict;
    options.Secure = CookieSecurePolicy.Always;
});

// API Controllers für Mobile Support
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// SignalR für Echtzeit-Updates
builder.Services.AddSignalR();

// CORS für mobile Clients (lokales Netzwerk)
builder.Services.AddCors(options =>
{
    options.AddPolicy("MobilePolicy", policy =>
    {
        policy.AllowAnyOrigin() // Für Entwicklung - später einschränken
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// JWT Authentication für zukünftigen externen Zugriff
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

// SignalR Broadcast Service für mobile Updates
builder.Services.AddHostedService<Einsatzueberwachung.Web.Services.SignalRBroadcastService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseWebAssemblyDebugging();
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();
app.UseCookiePolicy();

// CORS muss vor Authentication/Authorization kommen
app.UseCors("MobilePolicy");

app.UseAuthentication();
app.UseAuthorization();

app.UseAntiforgery();

// API Controllers
app.MapControllers();

// SignalR Hub
app.MapHub<Einsatzueberwachung.Web.Hubs.EinsatzHub>("/hubs/einsatz");

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(typeof(Einsatzueberwachung.Web.Client._Imports).Assembly);

app.Run();
