# Test Helper Method Patterns

## Anti-Pattern: Generic Helper with Many Parameters

**DON'T** create a single helper with 10+ optional parameters:

```csharp
// WRONG — impossible to read at call site
private BatchConsumer CreateBatchConsumer(
    BatchConsumerConfiguration config,
    List<IConsumerMessage> messages,
    bool canConsume,
    int consumeDelayMs = 0,
    bool consumeThrows = false,
    bool deleteThrows = false,
    Action<CallInfo>? onGetMessages = null,
    Action<CallInfo>? onCanConsume = null,
    Action<CallInfo>? onConsume = null,
    Action<CallInfo>? onDelete = null) { ... }
```

## Pattern: Scenario-Specific Factories

**DO** create specialized factory methods per scenario (≤3 params):

```csharp
// CORRECT — each factory has a clear purpose
private BatchConsumer CreateBatchConsumerWithMessages(Action<CallInfo>? onDelete = null) { ... }
private BatchConsumer CreateBatchConsumerWithNoMessages(Action<CallInfo>? onGetMessages = null) { ... }
private BatchConsumer CreateBatchConsumerWithSlowProcessing(int thresholdSeconds, int delayMs, Action<CallInfo>? onDelete = null) { ... }
private BatchConsumer CreateBatchConsumerWithDeleteFailure(Action<CallInfo>? onDelete = null) { ... }
private BatchConsumer CreateBatchConsumerWithConsumeFailure(Action<CallInfo>? onConsume = null) { ... }
```

## Guidelines

- **Name reveals intent**: `CreateHandlerWithInvalidUser()`, not `CreateHandler(userValid: false)`
- **≤3 parameters**: If you need more, create a new specialized helper
- **Single responsibility**: Each helper sets up one specific test scenario
- **Optional callbacks only**: Use `Action<CallInfo>?` parameters ONLY for test lifecycle hooks
- **No boolean flags**: Create separate methods instead of `CreateHandler(bool valid)`
