---
name: unit-test-generator
description: Generates xUnit unit tests with Shouldly and NSubstitute mocks, following the Given/When/Then structure.

## When to use
Use when user asks to write tests, add unit tests, or generate xUnit tests for C# classes.
---

# unit-test-generator

Generate xUnit unit tests for C# classes.

**Process:**
1. Read production class to understand methods/dependencies
2. Create `<ClassName>Tests.cs` in mirrored test structure
3. Generate tests with Given/When/Then structure

**Frameworks:**
- xUnit for tests
- Shouldly for assertions
- NSubstitute for mocking

**Test Structure:**
```csharp
[Fact]
public async Task MethodName_StateUnderTest_ExpectedBehavior()
{
    // Given: <setup description>

    // When: <action description>

    // Then: <expected outcome>
}
```

**Naming:** `MethodName_StateUnderTest_ExpectedBehavior`

**Variables:**
- `sut` for System Under Test
- `expected`/`actual` for assertions
- No `mock` prefixes on dependencies

**Setup:**
- Constructor for shared mocks
- Helper methods for SUT creation (≤3 params, descriptive names)
- Keep Given blocks ≤5 lines

**Example:**
```csharp
using Shouldly;
using NSubstitute;
using CsvTranslations.Core.Services;

namespace CsvTranslations.Tests.Core.Services;

public sealed class TranslationServiceTests
{
    private readonly IFileSystem _fileSystem;
    private readonly ILogger<TranslationService> _logger;

    public TranslationServiceTests()
    {
        _fileSystem = Substitute.For<IFileSystem>();
        _logger = Substitute.For<ILogger<TranslationService>>();
    }

    [Fact]
    public async Task LoadTranslations_ValidCsvFile_ReturnsTranslationDictionary()
    {
        // Given: Valid CSV file with translation data
        var sut = CreateServiceWithValidCsvContent();
        var filePath = "translations.csv";

        // When: Loading translations
        var actual = await sut.LoadTranslations(filePath);

        // Then: Returns dictionary with expected translations
        var expected = new Dictionary<string, string>
        {
            ["hello"] = "hola",
            ["world"] = "mundo"
        };
        actual.ShouldBe(expected);
    }

    [Fact]
    public async Task LoadTranslations_FileNotFound_ThrowsFileNotFoundException()
    {
        // Given: File that doesn't exist
        var sut = CreateServiceWithFileNotFound();
        var filePath = "missing.csv";

        // When: Loading translations
        await Should.ThrowAsync<FileNotFoundException>(
            async () => await sut.LoadTranslations(filePath));
    }

    private TranslationService CreateService() =>
        new TranslationService(_fileSystem, _logger);

    private TranslationService CreateServiceWithValidCsvContent()
    {
        var csvContent = "key,value\nhello,hola\nworld,mundo";
        _fileSystem.ReadAllTextAsync(Arg.Any<string>()).Returns(csvContent);
        return new TranslationService(_fileSystem, _logger);
    }

    private TranslationService CreateServiceWithFileNotFound()
    {
        _fileSystem.ReadAllTextAsync(Arg.Any<string>()).Returns(Task.FromException<string>(new FileNotFoundException()));
        return new TranslationService(_fileSystem, _logger);
    }
}
