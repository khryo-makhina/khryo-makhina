---
name: spike
description: 'Create a technical spike (time-boxed research) analyzing code patterns, architecture, performance, or best practices — saved to temp_user_files.'
argument-hint: '[topic, feature, or area to research] (required)'
user-invocable: true
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Write
  - Agent
---

# Spike (Technical Research)

Time-boxed technical research analyzing code, architecture, patterns, or implementation approaches.

## Input

- Argument (`$ARGUMENTS`): Research topic (e.g., "event sourcing", "batch processing performance")
- No argument: Ask user for topic

## Workflow

### 1. Scope Definition
- Parse topic: what aspect (architecture/performance/patterns), scope (feature/subsystem), key questions
- Clarify if ambiguous

### 2. Research (via Agent tool, parallel subagents)
- Code search: implementations, patterns, examples
- Architecture mapping: components, dependencies, flows
- Pattern detection: design patterns, anti-patterns
- Historical context: git history, evolution

### 3. Analysis
- **Current State**: How implemented, patterns used, key components
- **Design Rationale**: Why this approach, alternatives, tradeoffs
- **Strengths & Weaknesses**: What works, pain points, technical debt
- **Best Practices**: Industry alignment, improvement opportunities

### 4. Document
- **Filename**: `YYYY-MM-DD_spike_<topic-kebab-case>.md`
- **Location**: `temp_user_files/`
- Create directory: `mkdir -p temp_user_files`

### 5. Summary
Report to user: file path, key findings (2-3 sentences), top 1-2 recommendations. Remind: saved to `temp_user_files` (not committed).

## Document Template

```markdown
# Spike: <Title>

**Date**: <YYYY-MM-DD>
**Author**: Claude
**Topic**: <research topic>

## Executive Summary
<2-4 sentences: what studied, key findings, main recommendations>

## Current Implementation
### Architecture
### Key Components
### Design Patterns

## Analysis
### Strengths
### Challenges
### Tradeoffs

## Best Practices Assessment
<How current implementation compares to industry best practices>

## Recommendations
### Quick Wins
<Low-effort improvements>
### Strategic
<Medium-term improvements>
### Transformational
<Major changes if warranted>

## Related Resources
<File paths with line numbers, commits, external references>
```

## Guidelines
- Include file paths and line numbers for all code references
- Use tables/diagrams for clarity
- Focus on actionable insights
- If insufficient information, say so explicitly
- Do NOT make code changes — analysis only
