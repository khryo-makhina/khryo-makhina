---
paths:
  - "**/*.cs"
---

## Naming

**Private fields**: leading underscore + camelCase — `_myField`, not `myField` or `MyField`.
(Defined in `copilot-instructions.md`, not in `.editorconfig` — easy to miss.)

**Record positional parameters**: PascalCase — `public record Foo(string Text, int Count)`.
They generate public properties, so PascalCase is correct. Regular method/constructor parameters use camelCase.

## Expression-bodied members — DISABLED

Do NOT use `=>` for method, constructor, operator, or local-function bodies.
Use block bodies even for trivial one-liners:
```csharp
// WRONG
public string GetName() => _name;

// CORRECT
public string GetName()
{
    return _name;
}
```
Lambda expressions (`x => x.Name`) are still allowed.

## Braces always required (IDE0011 = warning)

Every `if`, `else`, `foreach`, `for`, `while`, `using` block must have braces, even single-line:
```csharp
// WRONG
if (x) return;

// CORRECT
if (x)
{
    return;
}
```

## No `this.` qualifier

Never prefix fields or properties with `this.`. The compiler enforces this as a warning.

## Null checks

Prefer pattern matching over equality operators:
```csharp
// WRONG
if (x == null) ...
if (x != null) ...

// CORRECT
if (x is null) ...
if (x is not null) ...
```

## XML docs

Add `/// <summary>` to all **new or modified** public and internal types and members.
Do not touch existing unchanged members.

## File-scoped namespaces

`namespace My.Project.Sub;` — no braces.

## Simple using statements

`using var stream = File.OpenRead(path);` — not `using (var x = ...) { }`.

## using directive ordering

Always arrange `using` directives in three groups separated by a blank line:

```csharp
// Group 1 — .NET built-ins (System.* and Microsoft.*)
using System;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;

// Group 2 — third-party NuGet packages
using NSubstitute;
using Shouldly;
using Xunit;

// Group 3 — own project namespaces (same repo)
using MyApp.Core;
using MyApp.Data;
```

Rules:
- Within each group, sort alphabetically.
- `System.*` and `Microsoft.*` both belong in group 1.
- When adding a `using` to an existing file, place it in the correct group and keep
  alphabetical order within that group — do not append it at the end of the block.
- `.editorconfig` enforces `dotnet_sort_system_directives_first = true` and
  `dotnet_separate_import_directive_groups = true` (blank line after group 1). The
  3rd-party / own split is a manual convention that tooling cannot enforce automatically.

**Identifying own namespaces**: A namespace belongs in group 3 when it maps to a project
that lives in the same repository. Discover them by scanning `.csproj` files:
the `<RootNamespace>` element (or, if absent, the project directory name) is the
own namespace root. Any `using` whose root segment matches one of those values goes
in group 3.

## Tests: do not use Moq NuGet due to security issues (repository neglecting and SponsorLink issue)

Use **NSubstitute** (`Substitute.For<IFoo>()`) or hand-written test fakes.
