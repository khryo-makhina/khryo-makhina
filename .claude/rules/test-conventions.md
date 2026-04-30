## Test Conventions

> **Detailed guidelines**: See `.claude/skills/unit-test-writer/SKILL.md` for comprehensive xUnit test generation patterns.

**System Under Test**: Name the test subject variable as `sut` (System Under Test).

**Test Structure**: Use Given/When/Then comment sections with blank line separation:

```csharp
[Fact]
public async Task Handle_ValidRequest_SavesPatientData()
{
    // Given: Valid patient request with captured save operation
    var sut = CreateHandlerWithValidPatient();
    var request = new SavePatientRequest { Name = "John Doe" };
    Patient? savedPatient = null;
    _repository
        .When(x => x.Save(Arg.Any<Patient>(), Arg.Any<CancellationToken>()))
        .Do(call => savedPatient = call.Arg<Patient>());

    // When: Handling the request
    await sut.Handle(request, CancellationToken.None);

    // Then: Patient is saved with updated name
    savedPatient.ShouldNotBeNull();
    savedPatient!.Name.ShouldBe("John Doe");
}
```

**Comment Format**:
- `// Given: <State or condition>` — describes setup/preconditions
- `// When: <Action or process>` — describes the action being performed
- `// Then: <Expected outcome>` — describes what should happen

**Variable Naming**:
- Test subject: `sut` (never as field, always from helper)
- Assertions: Use `expected` and `actual` for clarity
- Mocks: Descriptive names (`_repository`, `_logger`), not `_mockRepository`

**Helper Methods**: Create specialized factories per scenario (≤3 params), not one helper with 10+ optional params.

```csharp
// Correct — scenario-specific helpers
private Handler CreateHandlerWithValidUser() { ... }
private Handler CreateHandlerWithInvalidUser() { ... }

// Wrong — generic helper with boolean flags
private Handler CreateHandler(bool userValid = true) { ... }
```

**Naming**: `MethodName_StateUnderTest_ExpectedBehavior`

**XML Doc — mandatory**: Every `[Fact]`, `[Theory]`, test class, and constructor MUST have a `/// <summary>` block. When adding tests to a file that lacks XML doc, retrofit the entire file as part of the same change.

**Namespace style**: Always use file-scoped namespaces (`namespace Foo.Bar;`) — never block-scoped. When modifying an existing test file that uses block-scoped namespaces, convert it as part of the same change.

**Skill trigger**: When writing or adding unit tests to C# files, ALWAYS invoke the `unit-test-writer` skill first via `Skill({"skill": "unit-test-writer"})` before writing any code.

**Frameworks**: xUnit + Shouldly + NSubstitute (never Moq)
