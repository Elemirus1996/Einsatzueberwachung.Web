using Einsatzueberwachung.Domain.Models;
using Einsatzueberwachung.Domain.Services;
using FluentAssertions;
using Xunit;

namespace Einsatzueberwachung.Tests;

public class EinsatzServiceTests
{
    private readonly EinsatzService _sut;

    public EinsatzServiceTests()
    {
        _sut = new EinsatzService();
    }

    [Fact]
    public async Task StartEinsatzAsync_ShouldSetCurrentEinsatz()
    {
        // Arrange
        var einsatzData = new EinsatzData
        {
            EinsatzNummer = "E-2026-001",
            IstEinsatz = true,
            Einsatzort = "Teststadt"
        };

        // Act
        await _sut.StartEinsatzAsync(einsatzData);

        // Assert
        _sut.CurrentEinsatz.Should().NotBeNull();
        _sut.CurrentEinsatz.EinsatzNummer.Should().Be("E-2026-001");
    }

    [Fact]
    public async Task StartEinsatzAsync_ShouldClearExistingTeams()
    {
        // Arrange
        await _sut.StartEinsatzAsync(new EinsatzData { EinsatzNummer = "E-001" });
        await _sut.AddTeamAsync(new Team { TeamId = "T1", TeamName = "Team 1" });

        // Act
        await _sut.StartEinsatzAsync(new EinsatzData { EinsatzNummer = "E-002" });

        // Assert
        _sut.Teams.Should().BeEmpty();
    }

    [Fact]
    public async Task AddTeamAsync_ShouldAddTeamToList()
    {
        // Arrange
        await _sut.StartEinsatzAsync(new EinsatzData { EinsatzNummer = "E-001" });
        var team = new Team 
        { 
            TeamId = "T1", 
            TeamName = "Hunde-Team 1",
            FirstWarningMinutes = 20,
            SecondWarningMinutes = 30
        };

        // Act
        await _sut.AddTeamAsync(team);

        // Assert
        _sut.Teams.Should().HaveCount(1);
        _sut.Teams[0].TeamName.Should().Be("Hunde-Team 1");
    }

    [Fact]
    public async Task RemoveTeamAsync_ShouldRemoveTeam()
    {
        // Arrange
        await _sut.StartEinsatzAsync(new EinsatzData { EinsatzNummer = "E-001" });
        var team = await _sut.AddTeamAsync(new Team { TeamId = "T1", TeamName = "Team 1" });

        // Act
        await _sut.RemoveTeamAsync(team.TeamId);

        // Assert
        _sut.Teams.Should().BeEmpty();
    }

    [Fact]
    public async Task GetTeamByIdAsync_ShouldReturnCorrectTeam()
    {
        // Arrange
        await _sut.StartEinsatzAsync(new EinsatzData { EinsatzNummer = "E-001" });
        await _sut.AddTeamAsync(new Team { TeamId = "T1", TeamName = "Team 1" });
        await _sut.AddTeamAsync(new Team { TeamId = "T2", TeamName = "Team 2" });

        // Act
        var result = await _sut.GetTeamByIdAsync("T2");

        // Assert
        result.Should().NotBeNull();
        result!.TeamName.Should().Be("Team 2");
    }

    [Fact]
    public async Task UpdateTeamAsync_ShouldUpdateExistingTeam()
    {
        // Arrange
        await _sut.StartEinsatzAsync(new EinsatzData { EinsatzNummer = "E-001" });
        var team = await _sut.AddTeamAsync(new Team { TeamId = "T1", TeamName = "Old Name" });
        
        // Act
        team.TeamName = "New Name";
        await _sut.UpdateTeamAsync(team);

        // Assert
        var updated = await _sut.GetTeamByIdAsync("T1");
        updated!.TeamName.Should().Be("New Name");
    }

    [Fact]
    public async Task EndEinsatzAsync_ShouldClearAllData()
    {
        // Arrange
        await _sut.StartEinsatzAsync(new EinsatzData { EinsatzNummer = "E-001" });
        await _sut.AddTeamAsync(new Team { TeamId = "T1", TeamName = "Team 1" });

        // Act
        await _sut.EndEinsatzAsync();

        // Assert
        _sut.Teams.Should().BeEmpty();
    }
}
