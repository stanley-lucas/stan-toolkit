# ARCHITECTURE.md — [Project Name]

> Living document. Update when architecture decisions change.

## Overview

<!-- 1-2 paragraphs: what this system does and its high-level design -->

## System Diagram

```
<!-- ASCII or description of main components and data flow -->

[Client] → [API] → [Database]
              ↕
         [Worker / Queue]
```

## Components

### [Component Name]

**Responsibility**: <!-- what it does -->
**Tech**: <!-- language, framework, key libraries -->
**Entry point**: <!-- file or command to start it -->

<!-- Repeat for each component -->

## Data Model

<!-- Key entities and their relationships.
     Link to migration files or schema for details. -->

## Key Design Decisions

<!-- Reference ADRs for each significant decision.
     Keep it brief here — details are in docs/adr/. -->

- [ADR-001](docs/adr/001-*.md): <!-- decision title -->

## External Dependencies

| Service | Purpose | Credentials |
|---------|---------|-------------|
| <!-- TODO --> | | |

## Development vs Production

<!-- What's different between environments?
     How does local development approximate production? -->

## Performance Considerations

<!-- Bottlenecks, caching strategies, limits to be aware of -->

## Security Boundaries

<!-- Auth, data isolation, what's exposed publicly vs privately -->
