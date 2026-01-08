using Einsatzueberwachung.Domain.Interfaces;
using Einsatzueberwachung.Domain.Models;
using Einsatzueberwachung.Domain.Services;
using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;

namespace Einsatzueberwachung.Tests;

public class ThemeServiceTests
{
    private readonly Mock<IMasterDataService> _mockMasterDataService;
    private readonly Mock<ILogger<ThemeService>> _mockLogger;
    private readonly ThemeService _sut;

    public ThemeServiceTests()
    {
        _mockMasterDataService = new Mock<IMasterDataService>();
        _mockLogger = new Mock<ILogger<ThemeService>>();
        _sut = new ThemeService(_mockMasterDataService.Object, _mockLogger.Object);
    }

    [Fact]
    public async Task LoadThemeAsync_WithDarkModeEnabled_ShouldSetDarkMode()
    {
        // Arrange
        var sessionData = new SessionData
        {
            AppSettings = new AppSettings { IsDarkMode = true }
        };
        _mockMasterDataService
            .Setup(x => x.LoadSessionDataAsync())
            .ReturnsAsync(sessionData);

        // Act
        await _sut.LoadThemeAsync();

        // Assert
        _sut.IsDarkMode.Should().BeTrue();
        _sut.CurrentTheme.Should().Be("dark");
    }

    [Fact]
    public async Task LoadThemeAsync_WithLightModeEnabled_ShouldSetLightMode()
    {
        // Arrange
        var sessionData = new SessionData
        {
            AppSettings = new AppSettings { IsDarkMode = false }
        };
        _mockMasterDataService
            .Setup(x => x.LoadSessionDataAsync())
            .ReturnsAsync(sessionData);

        // Act
        await _sut.LoadThemeAsync();

        // Assert
        _sut.IsDarkMode.Should().BeFalse();
        _sut.CurrentTheme.Should().Be("light");
    }

    [Fact]
    public async Task LoadThemeAsync_WithNullSettings_ShouldDefaultToLightMode()
    {
        // Arrange
        _mockMasterDataService
            .Setup(x => x.LoadSessionDataAsync())
            .ReturnsAsync(new SessionData());

        // Act
        await _sut.LoadThemeAsync();

        // Assert
        _sut.IsDarkMode.Should().BeFalse();
        _sut.CurrentTheme.Should().Be("light");
    }

    [Fact]
    public async Task SetThemeAsync_ShouldUpdateTheme()
    {
        // Arrange
        var sessionData = new SessionData
        {
            AppSettings = new AppSettings { IsDarkMode = false }
        };
        _mockMasterDataService
            .Setup(x => x.LoadSessionDataAsync())
            .ReturnsAsync(sessionData);

        // Act
        await _sut.SetThemeAsync(true);

        // Assert
        _sut.IsDarkMode.Should().BeTrue();
        _mockMasterDataService.Verify(x => x.SaveSessionDataAsync(It.IsAny<SessionData>()), Times.Once);
    }

    [Fact]
    public async Task SetThemeAsync_WithSameTheme_ShouldNotSave()
    {
        // Arrange
        var sessionData = new SessionData
        {
            AppSettings = new AppSettings { IsDarkMode = true }
        };
        _mockMasterDataService
            .Setup(x => x.LoadSessionDataAsync())
            .ReturnsAsync(sessionData);
        await _sut.LoadThemeAsync();

        // Act
        await _sut.SetThemeAsync(true);

        // Assert
        _mockMasterDataService.Verify(x => x.SaveSessionDataAsync(It.IsAny<SessionData>()), Times.Never);
    }

    [Fact]
    public async Task ToggleThemeAsync_ShouldSwitchTheme()
    {
        // Arrange
        var sessionData = new SessionData
        {
            AppSettings = new AppSettings { IsDarkMode = false }
        };
        _mockMasterDataService
            .Setup(x => x.LoadSessionDataAsync())
            .ReturnsAsync(sessionData);
        await _sut.LoadThemeAsync();

        // Act
        await _sut.ToggleThemeAsync();

        // Assert
        _sut.IsDarkMode.Should().BeTrue();
        _sut.CurrentTheme.Should().Be("dark");
    }

    [Fact]
    public async Task InitializeAsync_ShouldOnlyInitializeOnce()
    {
        // Arrange
        var sessionData = new SessionData
        {
            AppSettings = new AppSettings { IsDarkMode = false }
        };
        _mockMasterDataService
            .Setup(x => x.LoadSessionDataAsync())
            .ReturnsAsync(sessionData);

        // Act
        await _sut.InitializeAsync();
        await _sut.InitializeAsync();
        await _sut.InitializeAsync();

        // Assert
        _mockMasterDataService.Verify(x => x.LoadSessionDataAsync(), Times.Once);
    }

    [Fact]
    public async Task LoadThemeAsync_OnException_ShouldDefaultToLightAndLogError()
    {
        // Arrange
        _mockMasterDataService
            .Setup(x => x.LoadSessionDataAsync())
            .ThrowsAsync(new Exception("Test error"));

        // Act
        await _sut.LoadThemeAsync();

        // Assert
        _sut.IsDarkMode.Should().BeFalse();
        _mockLogger.Verify(
            x => x.Log(
                LogLevel.Error,
                It.IsAny<EventId>(),
                It.IsAny<It.IsAnyType>(),
                It.IsAny<Exception>(),
                It.IsAny<Func<It.IsAnyType, Exception?, string>>()),
            Times.Once);
    }
}
