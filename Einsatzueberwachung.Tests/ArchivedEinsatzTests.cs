using Einsatzueberwachung.Domain.Models;
using FluentAssertions;
using Xunit;

namespace Einsatzueberwachung.Tests;

public class ArchivedEinsatzTests
{
    [Fact]
    public void FromEinsatzData_ShouldPersistUniqueResourceListsAndCounts()
    {
        // Arrange
        var data = new EinsatzData
        {
            Einsatzleiter = "Leiter A",
            Einsatzort = "Testort",
            EinsatzNummer = "E-123",
            Teams = new List<Team>
            {
                new()
                {
                    TeamName = "Team 1",
                    HundefuehrerName = "Max Mustermann",
                    HelferName = "Eva Beispiel",
                    DogName = "Rex"
                },
                new()
                {
                    TeamName = "Team 2",
                    HundefuehrerName = "Max Mustermann",
                    IsDroneTeam = true,
                    DroneType = "DJI Mavic 3"
                }
            }
        };

        // Act
        var archived = ArchivedEinsatz.FromEinsatzData(data, "Suche erfolgreich", "Alle Ressourcen dokumentiert");

        // Assert
        archived.AnzahlTeams.Should().Be(2);
        archived.PersonalNamen.Should().BeEquivalentTo(new[] { "Eva Beispiel", "Max Mustermann" });
        archived.HundeNamen.Should().BeEquivalentTo(new[] { "Rex" });
        archived.DrohnenNamen.Should().BeEquivalentTo(new[] { "DJI Mavic 3" });

        archived.AnzahlPersonal.Should().Be(2);
        archived.AnzahlHunde.Should().Be(1);
        archived.AnzahlDrohnen.Should().Be(1);
        archived.AnzahlRessourcen.Should().Be(4);
    }
}
