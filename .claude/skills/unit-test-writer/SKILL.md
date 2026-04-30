---
name: unit-test-writer
description: Generates xUnit unit tests with Shouldly assertions and NSubstitute mocks, following the Given/When/Then structure and this repository's naming conventions.

## When to use this skill
Use this skill when the user asks to:
- "write tests for X"
- "add unit tests"
- "test this method/class"
- "generate xUnit tests"
- "cover this with tests"
- Any request to create or scaffold unit tests for a C# class or method
---

# unit-test-writer

You generate xUnit unit tests for C# classes following this repository's test conventions.

## How to invoke this skill

1. **Identify the target**: The user names a class or file. If not specified, ask which class to test.
2. **Read the source file**: Read the production class to understand public methods, constructor dependencies, and behavior.
3. **Locate or determine the test project**: Tests go in `{Project}.Tests/`, mirroring the production folder structure:
   - `FileNameSanitizer/Normalizer/FileNameNormalizer.cs` → `FilenameSanitizer.Tests/Normalizer/FileNameNormalizerTests.cs`
   - `OllamaTranslatorApi/Services/OllamaTranslator.cs` → `OllamaTranslatorApi.Tests/Services/OllamaTranslatorTests.cs`
   - `TranslationTools/SomeClass.cs` → `TranslationTools.Tests/SomeClassTests.cs`
4. **Generate the test file**: Name it `<ClassName>Tests.cs`, place it in the mirrored folder.
5. **Do NOT run the tests** unless the user explicitly asks to run them.

## Conventions

### Frameworks and libraries

| Concern | Library |
|---------|---------|
| Test framework | xUnit |
| Assertions | **Shouldly** — `.ShouldBe()`, `.ShouldNotBeNull()`, `Should.ThrowAsync<T>()`. |
| Mocking | **NSubstitute** — `Substitute.For<IFoo>()`. NEVER use Moq (banned due to security concerns). |
| Test fakes | Hand-written fake classes (implementing the real interface) are preferred over mocks when behavior must be deterministic across many tests. |

### Test class documentation

Always add XML documentation to test classes that reveals:
- **What** is being verified (the system under test)
- **Scope** of the test suite (what aspects are covered)

```csharp
/// <summary>
/// Tests for <see cref="FileNameNormalizer"/> rename behavior.
/// Verifies sanitization, OS-limit trimming, and collision handling under various inputs.
/// </summary>
public class FileNameNormalizerTests
{
    // ...
}
```

**Do NOT add XML documentation to test methods** — the descriptive method name (`MethodName_StateUnderTest_ExpectedBehavior`) and Given/When/Then comments already reveal the intent.

### Test naming

```
MethodName_StateUnderTest_ExpectedBehavior
```

Examples:
- `SanitizeFileName_WithNull_ShouldReturnEmpty`
- `RenameFiles_AlreadySanitized_ShouldNotRename`
- `Translate_UnknownText_ThrowsNotSupportedException`

Note: async methods do NOT use an `Async` suffix, so test names follow suit.

### Test body structure

Always use Given/When/Then comment sections with descriptive text, separated by blank lines:

```csharp
[Fact]
public async Task Translate_KnownText_ReturnsExpectedTranslation()
{
    // Given: A translator configured with known text

    // When: Translating the known text

    // Then: The expected translation is returned
}
```

**Comment format:**
- `// Given: <State or condition>` — describes the test setup/preconditions
- `// When: <Action or process>` — describes what action is being performed
- `// Then: <Expected outcome or behaviour>` — describes what should happen

Use `[Theory]` + `[InlineData(...)]` for parameterized cases.

### Variable naming

- Name the test subject `sut` (System Under Test) — returned from a helper, never as a field
- Do NOT prefix mocks with `mock` — use descriptive names like `fileSystem`, `patternLoader`, `translationService`
- **Use `expected` and `actual` variables** when applicable, to make assertions clear and intention-revealing:
  ```csharp
  // CORRECT — intention is clear
  var expected = "sanitized_name.txt";
  var actual = sut.SanitizeFileName("sanitized name.txt");
  actual.ShouldBe(expected);

  // ACCEPTABLE — when the expected value is obvious
  result.ShouldBe("sanitized_name.txt");
  ```
- Never mock the SUT — always use real implementation

### Assertions (Shouldly)

```csharp
// Equality
actual.ShouldBe(expected);

// Null checks
result.ShouldNotBeNull();
result.ShouldBeNull();

// Boolean
flag.ShouldBeTrue();
flag.ShouldBeFalse();

// Collections
list.ShouldContain(x => x.Name == "foo");
list.Count.ShouldBe(3);

// Exceptions
await Should.ThrowAsync<NotSupportedException>(
    async () => await sut.Translate(unknownText, CancellationToken.None));
```

### Mock behavior, not calls

Test outcomes and state changes, not that methods were called:

```csharp
// CORRECT — test the outcome via captured argument
[Fact]
public void SanitizeAndRename_ValidFile_WritesRenamedFile()
{
    // Given: A file with a name that needs sanitization
    string? renamedTo = null;
    _fileSystem
        .When(x => x.MoveFile(Arg.Any<string>(), Arg.Any<string>()))
        .Do(call => renamedTo = call.ArgAt<string>(1));
    var sut = CreateSanitizerWithFile("bad name.txt");

    // When: Sanitizing and renaming
    sut.RenameFilesToMeetOsRequirements();

    // Then: File was renamed to the sanitized form
    renamedTo.ShouldNotBeNull();
    renamedTo.ShouldBe("bad_name.txt");
}

// WRONG — don't use Received() to verify calls unless testing error-handling paths
```

### Hand-written test fakes

When many tests share the same deterministic behavior, prefer a hand-written fake over repeated NSubstitute setup:

```csharp
// Fake implements the real interface with canned responses
internal sealed class TestTranslationService : ITranslationService
{
    private static readonly Dictionary<string, string> s_known = new()
    {
        ["Hello"] = "Hallo",
        ["World"] = "Welt",
    };

    public Task<string> TranslateAsync(string text, CancellationToken ct)
    {
        if (s_known.TryGetValue(text, out var result))
            return Task.FromResult(result);
        throw new NotSupportedException($"No canned translation for: {text}");
    }
}
```

Use a fake when: the interface has complex or stateful behavior that is hard to stub per-test.

### Setup and helpers

**CRITICAL: Keep Given blocks ≤5 lines by extracting setup to well-named helper methods.**

#### Helper method patterns

**DO NOT** create a single helper with many optional parameters:
```csharp
// WRONG — too many parameters, impossible to read
private FileNameNormalizer CreateNormalizer(
    List<string> patterns,
    bool patternsExist,
    int maxLength = 255,
    bool fileSystemThrows = false) { ... }
```

**DO** create specialized factory/Given methods for each test scenario:
```csharp
// CORRECT — each method has a clear purpose
private FileNameNormalizer CreateNormalizerWithPatterns() { ... }
private FileNameNormalizer CreateNormalizerWithNoPatterns() { ... }
private void GivenSingleFile(string originalName, string expectedName) { ... }
private void GivenFileAlreadySanitized(string fileName) { ... }
```

**Helper method guidelines:**
- **Name reveals intent**: `CreateNormalizerWithNoPatterns()`, not `CreateNormalizer(patternsExist: false)`
- **≤3 parameters**: If you need more, create a new specialized helper
- **Single responsibility**: Each helper sets up one specific test scenario
- **No boolean flags**: `CreateHandlerWithValidInput()` + `CreateHandlerWithInvalidInput()`, not `CreateHandler(bool valid)`
- Prefix with `Given` when the helper configures mock state; prefix with `Create` when it returns a new SUT instance

#### Constructor vs. helper method setup

- **Constructor**: Shared dependencies that are the same for ALL tests (mocks created via `Substitute.For<T>()`)
- **Helper methods**: Setup that varies per test scenario (SUT creation, test-specific mock behavior)

## Output format

Produce a single `.cs` file with:
1. `using` directives (always add `using Shouldly;` and `using NSubstitute;` as needed)
2. File-scoped namespace matching the test project: `namespace {Project}.Tests.{Folder};`
3. One `public sealed class <ClassName>Tests` containing all test methods
4. Private fields for dependencies (mocks), NOT for SUT
5. A constructor for shared dependency setup
6. Specialized helper methods for SUT creation (one per test scenario)
7. Test scenario should have its XML Doc stating the testing scope.

## Example
using NSubstitute;
using Shouldly;

namespace FilenameSanitizer.Tests.Normalizer;

/// <summary>
/// Tests for <see cref="FileNameNormalizer"/> rename behavior.
/// Verifies sanitization application, already-clean file handling, and OS path constraints.
/// </summary>
public sealed class FileNameNormalizerTests
{
    private readonly IFileSystem _fileSystem;
    private readonly ISanitizer _sanitizer;

    public FileNameNormalizerTests()
    {
        _fileSystem = Substitute.For<IFileSystem>();
        _sanitizer = Substitute.For<ISanitizer>();
    }

    [Fact]
    public void RenameFiles_DirtyFileName_RenamesFile()
    {
        // Given: A file whose name requires sanitization
        GivenSingleFile(originalName: "bad name.txt", sanitizedName: "bad_name.txt");
        var sut = CreateNormalizerWithPatterns();
        string? renamedTo = null;
        _fileSystem
            .When(x => x.MoveFile(Arg.Any<string>(), Arg.Any<string>()))
            .Do(call => renamedTo = call.ArgAt<string>(1));

        // When: Running the renamer
        sut.RenameFilesToMeetOsRequirements();

        // Then: The file was renamed to the sanitized form
        renamedTo.ShouldNotBeNull();
        renamedTo.ShouldBe("bad_name.txt");
    }

    [Fact]
    public void RenameFiles_AlreadySanitized_DoesNotRenameFile()
    {
        // Given: A file whose name is already clean
        GivenSingleFile(originalName: "clean_name.txt", sanitizedName: "clean_name.txt");
        var sut = CreateNormalizerWithPatterns();

        // When: Running the renamer
        sut.RenameFilesToMeetOsRequirements();

        // Then: No rename occurred
        _fileSystem.DidNotReceive().MoveFile(Arg.Any<string>(), Arg.Any<string>());
    }

    [Theory]
    [InlineData("")]
    [InlineData(null)]
    public void RenameFiles_EmptyOrNullFileName_ReturnsEmpty(string? input)
    {
        // Given: An invalid file name
        _sanitizer.Sanitize(input!).Returns(string.Empty);
        var sut = CreateNormalizerWithPatterns();

        // When: Sanitizing
        var actual = sut.Sanitize(input!);

        // Then: Result is empty
        actual.ShouldBe(string.Empty);
    }

    private FileNameNormalizer CreateNormalizerWithPatterns()
    {
        _sanitizer.GetPatterns().Returns(new[] { "pattern1" });
        return new FileNameNormalizer(_fileSystem, _sanitizer);
    }

    private FileNameNormalizer CreateNormalizerWithNoPatterns()
    {
        _sanitizer.GetPatterns().Returns(Array.Empty<string>());
        return new FileNameNormalizer(_fileSystem, _sanitizer);
    }

    private void GivenSingleFile(string originalName, string sanitizedName)
    {
        _fileSystem.GetFiles(Arg.Any<string>()).Returns(new[] { originalName });
        _sanitizer.Sanitize(originalName).Returns(sanitizedName);
    }
}
```
