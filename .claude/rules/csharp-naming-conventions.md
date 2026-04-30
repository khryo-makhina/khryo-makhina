## C# Naming Conventions

**IDE0049 - CLR Type Names**: Prefer CLR type names over built-in keywords for static member access.

**Correct**:
- `String.IsNullOrEmpty(value)`
- `Int32.Parse(input)`
- `Boolean.TryParse(input, out var result)`

**Wrong**:
- `string.IsNullOrEmpty(value)`
- `int.Parse(input)`
- `bool.TryParse(input, out var result)`

**Async Methods**: Never suffix method names with `Async` — use plain method names.

**Correct**:
```csharp
public async Task<User> GetUser(int id)
public async Task SaveChanges()
```

**Wrong**:
```csharp
public async Task<User> GetUserAsync(int id)
public async Task SaveChangesAsync()
```

**Context**: Follows project's `.editorconfig` rule `dotnet_style_predefined_type_for_member_access = false`.
