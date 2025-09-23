# Mermaid Test File

This file contains various Mermaid diagram examples to test the rendering functionality.

## Flowchart Example

```mermaid
graph TD
    A[Start] --> B{Is it working?}
    B -->|Yes| C[Great!]
    B -->|No| D[Debug]
    D --> E[Fix issue]
    E --> B
    C --> F[End]
```

## Sequence Diagram

```mermaid
sequenceDiagram
    participant User
    participant Neovim
    participant Mermaid

    User->>Neovim: Open markdown file
    Neovim->>Mermaid: Parse diagram code
    Mermaid->>Neovim: Render diagram
    Neovim->>User: Display diagram
```

## Class Diagram

```mermaid
classDiagram
    class User {
        +String name
        +String email
        +login()
        +logout()
    }

    class Admin {
        +String permissions
        +manageUsers()
    }

    User <|-- Admin
```

## Git Graph

```mermaid
gitgraph
    commit id: "Initial commit"
    branch feature
    checkout feature
    commit id: "Add feature"
    commit id: "Fix bug"
    checkout main
    merge feature
    commit id: "Release"
```

## Pie Chart

```mermaid
pie title Languages Used
    "Lua" : 45
    "JavaScript" : 25
    "Python" : 20
    "Other" : 10
```

## Instructions

### Browser Preview (Recommended)
1. Open this file in Neovim
2. Press `<leader>mp` to toggle browser preview with Mermaid rendering
3. Diagrams will be rendered in the browser automatically

### Export Diagrams
1. Run `:MermaidInstall` to install Mermaid CLI (if not already installed)
2. Use `:MermaidExport` to export all diagrams to PNG files

### Features
- **Syntax highlighting** for mermaid code blocks
- **Browser preview** with live Mermaid rendering
- **Export to PNG** using Mermaid CLI
- **Simplified setup** without complex terminal dependencies

No complex terminal image rendering needed - just use the browser preview!