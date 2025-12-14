using Einsatzueberwachung.Web.Client.Pages;
using Einsatzueberwachung.Web.Components;
using Einsatzueberwachung.Domain.Interfaces;
using Einsatzueberwachung.Domain.Services;

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

// Registriere Domain-Services als Singletons (für den laufenden Einsatz)
builder.Services.AddSingleton<IMasterDataService, MasterDataService>();
builder.Services.AddSingleton<IEinsatzService, EinsatzService>();
builder.Services.AddSingleton<ISettingsService, SettingsService>();
builder.Services.AddSingleton<IPdfExportService, PdfExportService>();
builder.Services.AddSingleton<ToastService>();
builder.Services.AddSingleton<ThemeService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseWebAssemblyDebugging();
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
app.UseAntiforgery();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(typeof(Einsatzueberwachung.Web.Client._Imports).Assembly);

app.Run();
