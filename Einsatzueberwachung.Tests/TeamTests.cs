using Einsatzueberwachung.Domain.Models;
using Einsatzueberwachung.Domain.Models.Enums;
using FluentAssertions;
using Xunit;

namespace Einsatzueberwachung.Tests;

public class TeamTests
{
    [Fact]
    public void Team_ShouldStartWithTimerStopped()
    {
        // Arrange & Act
        var team = new Team
        {
            TeamId = "T1",
            TeamName = "Test Team",
            FirstWarningMinutes = 20,
            SecondWarningMinutes = 30
        };

        // Assert
        team.IsRunning.Should().BeFalse();
        team.ElapsedTime.Should().Be(TimeSpan.Zero);
    }

    [Fact]
    public void StartTimer_ShouldSetTimerRunning()
    {
        // Arrange
        var team = new Team
        {
            TeamId = "T1",
            TeamName = "Test Team",
            FirstWarningMinutes = 20,
            SecondWarningMinutes = 30
        };

        // Act
        team.StartTimer();

        // Assert
        team.IsRunning.Should().BeTrue();
    }

    [Fact]
    public void StopTimer_ShouldStopTimer()
    {
        // Arrange
        var team = new Team
        {
            TeamId = "T1",
            TeamName = "Test Team",
            FirstWarningMinutes = 20,
            SecondWarningMinutes = 30
        };
        team.StartTimer();

        // Act
        team.StopTimer();

        // Assert
        team.IsRunning.Should().BeFalse();
    }

    [Fact]
    public void ResetTimer_ShouldResetElapsedTime()
    {
        // Arrange
        var team = new Team
        {
            TeamId = "T1",
            TeamName = "Test Team",
            FirstWarningMinutes = 20,
            SecondWarningMinutes = 30
        };
        team.StartTimer();
        Thread.Sleep(100); // Simulate some time passing

        // Act
        team.ResetTimer();

        // Assert
        team.ElapsedTime.Should().Be(TimeSpan.Zero);
        team.IsRunning.Should().BeFalse();
    }

    [Theory]
    [InlineData(DogSpecialization.Flaechensuche, "#FF5722")]
    [InlineData(DogSpecialization.Mantrailing, "#9C27B0")]
    [InlineData(DogSpecialization.Truemmersuche, "#FF9800")]
    [InlineData(DogSpecialization.Lawinensuche, "#2196F3")]
    [InlineData(DogSpecialization.Wasserortung, "#00BCD4")]
    public void DogSpecialization_ShouldReturnCorrectColor(DogSpecialization specialization, string expectedColor)
    {
        // Act
        var color = specialization.GetColorHex();

        // Assert
        color.Should().Be(expectedColor);
    }

    [Fact]
    public void TeamWithDrone_ShouldBeIdentifiedCorrectly()
    {
        // Arrange & Act
        var team = new Team
        {
            TeamId = "T1",
            TeamName = "Drohnen-Team",
            IsDroneTeam = true,
            FirstWarningMinutes = 20,
            SecondWarningMinutes = 30
        };

        // Assert
        team.IsDroneTeam.Should().BeTrue();
    }

    [Fact]
    public void Dispose_ShouldStopTimer()
    {
        // Arrange
        var team = new Team
        {
            TeamId = "T1",
            TeamName = "Test Team",
            FirstWarningMinutes = 20,
            SecondWarningMinutes = 30
        };
        team.StartTimer();

        // Act
        team.Dispose();

        // Assert
        team.IsRunning.Should().BeFalse();
    }
}
