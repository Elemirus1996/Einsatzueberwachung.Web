# Einsatzüberwachung - Quick Setup for Developers

## For End Users
If you just want to use the application, see [QUICK_START.md](QUICK_START.md)

## For Developers

### Prerequisites
- .NET 8 SDK
- Visual Studio 2022 or Visual Studio Code
- Git

### Clone & Build

```bash
git clone https://github.com/YOUR-USERNAME/Einsatzueberwachung.git
cd Einsatzueberwachung
dotnet restore
dotnet build
```

### Run Development Server

```bash
cd Einsatzueberwachung.Web
dotnet run
```

Or press F5 in Visual Studio.

### Project Structure

- **Einsatzueberwachung.Web** - Blazor Server/WebAssembly Host
- **Einsatzueberwachung.Web.Client** - Blazor WebAssembly Client
- **Einsatzueberwachung.Domain** - Business Logic & Services

### Technologies Used

- .NET 8
- Blazor WebAssembly
- Bootstrap 5
- Leaflet.js (Maps)
- QuestPDF (PDF Export)
- LocalStorage/IndexedDB for data persistence

### Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

### Running Tests

```bash
dotnet test
```

### Publish

```bash
dotnet publish Einsatzueberwachung.Web\Einsatzueberwachung.Web.csproj -c Release -o publish
```

The published files will be in the `publish` folder.
