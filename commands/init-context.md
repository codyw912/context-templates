---
description: Initialize hierarchical context documentation structure for AI-assisted development
allowed-tools: Bash, Write, Read, Glob, Grep
---

Initialize a self-documenting, hierarchical documentation structure designed for AI-assisted development workflows.

**Usage:** `/init-context [directory-name]`
- `$1` - Directory name (default: `context`)

## Instructions

Execute these steps to create the structure:

### 1. Create Directory Structure

```bash
DIR="${1:-context}"
mkdir -p "$DIR/onboarding" "$DIR/architecture" "$DIR/design" "$DIR/requirements" "$DIR/specifications" "$DIR/status/completed" "$DIR/research" "$DIR/roles" "$DIR/reviews" "$DIR/sessions/$(date +%Y-%m)"
```

### 2. Create README.md

Create `$DIR/README.md` with this content:

````markdown
# Project Context Documentation

**Navigation guide for humans and AI agents working on this project.**

## Quick Start

**New to the project?** Start here: [`onboarding/START_HERE.md`](onboarding/START_HERE.md)

**Returning to work?** Check [`status/current-focus.md`](status/current-focus.md) for active work.

## Documentation Structure

```
context/
├── onboarding/          Entry point and quick start guides
├── architecture/        System design and technical decisions
├── design/             Feature and component design documents
├── requirements/       Feature specifications and requirements
├── specifications/     Formal technical specifications for implementation
├── status/             Project roadmap and progress tracking
├── research/           Investigation findings and API research
├── roles/              Agent role definitions and workflows
├── reviews/            Code, architecture, and quality reviews
└── sessions/           Work session logs and notes
```

## Directory Guide

### 📚 `onboarding/` - Getting Started

Entry point documentation for understanding the project quickly.

**When to use:** First time working on the project, or returning after time away.

**Typical files:**
- `START_HERE.md` - Primary entry point with current status and quick context
- `quick-start-guide.md` - How to use the system

---

### 🏗️ `architecture/` - System Architecture

High-level system design, architectural decisions, and rationale.

**When to create:** When making architectural decisions, designing system components, or documenting technical patterns.

**When to read:** Before making structural changes, adding major features, or when understanding system design.

**Typical files:**
- `overview.md` - High-level architecture overview
- `database-design.md` - Database/schema design decisions
- `reviews/` - Periodic architecture reviews and audits

---

### 🎨 `design/` - Feature & Component Design

Design documents for specific features and components.

**When to create:** When designing a new feature or major component before implementation.

**When to read:** Before implementing a feature to understand the design.

---

### 📋 `requirements/` - Feature Requirements

Specifications and requirements for features.

**When to create:** When defining what a feature should do, user stories, acceptance criteria.

**When to read:** Before starting feature work to understand requirements.

---

### 📐 `specifications/` - Formal Technical Specifications

Detailed technical specifications for implementation agents and developers.

**When to create:** After design is approved and before implementation begins.

**When to read:** When implementing a feature - provides exact API contracts, data models, business rules, and validation requirements.

**Typical files:**
- API specifications (endpoints, schemas, error codes)
- Data models (TypeScript, JSON Schema, SQL)
- Interface contracts and state machines
- Business logic rules
- Performance and security specifications

**Flow:** requirements → design → specifications → implementation

---

### 📊 `status/` - Progress & Planning

Current project state, roadmap, and work tracking.

**Typical files:**
- `roadmap.md` - Long-term project roadmap
- `backlog.md` - Backlog of features and improvements
- `current-focus.md` - Current work and immediate next steps
- `completed/` - Archive of completed work

**When to update:**
- Update `current-focus.md` as work progresses
- Move docs to `completed/` when work is merged to main

---

### 🔬 `research/` - Investigation & Research

Research findings, API investigations, and exploratory work.

**When to create:** When investigating APIs, libraries, or approaches before making decisions.

**When to read:** When evaluating similar technical decisions.

---

### 🔍 `reviews/` - Code & Quality Reviews

Structured review documents from code reviews, architecture reviews, security audits, and test reviews.

**When to create:** After performing a review (code, tests, architecture, security, etc.).

**When to read:** When picking up review findings to implement or address.

**Typical files:**
- `YYYY-MM-DD-test-coverage-auth.md` - Test review findings
- `YYYY-MM-DD-code-review-api.md` - Code review findings
- `YYYY-MM-DD-security-audit.md` - Security review findings
- `YYYY-MM-DD-architecture-review.md` - Architecture review findings

**Structure:** Reviews include:
- Findings categorized by severity (Critical, High, Medium, Low)
- Agent role assignments (who should address each finding)
- Status tracking (Pending, In Progress, Completed)
- Actionable recommendations

**Workflow:**
1. Reviewer agent creates review document
2. Review assigns findings to specific agent roles
3. Agent loads their role and sees pending reviews
4. Agent addresses findings and updates review status

---

### 🎭 `roles/` - Agent Role Definitions

Role definitions for specialized AI agents with tailored workflows and responsibilities.

**When to use:** At the start of a session to assign an agent a specific role (architect, implementer, researcher, etc.).

**Typical files:**
- `README.md` - Guide to using roles
- `role-architect.md` - Software architect role
- `role-implementer.md` - Code implementer role
- `role-researcher.md` - Research specialist role
- Additional custom roles as needed

**How to use:** `"You are the [role]. Read roles/role-[name].md and follow that workflow."`

---

### 📝 `sessions/` - Work Session Logs

Session-by-session work logs organized by month.

**Structure:** `sessions/YYYY-MM/MM-DD-description.md`

**When to create:** At the end of each work session to document what was accomplished.

**Naming convention:** `MM-DD-description.md` where description is a short keyword for the work.

---

## For AI Agents: Session Workflow

### Starting a New Session

1. **Read the entry point:** [`onboarding/START_HERE.md`](onboarding/START_HERE.md)
2. **Check current focus:** [`status/current-focus.md`](status/current-focus.md)
3. **Review relevant design docs** from `architecture/` or `design/`
4. **Understand the goal** for this session from the user

### During a Session

- **Keep notes** of decisions, discoveries, and work completed
- **Update status** in `status/current-focus.md` as major milestones are reached
- **Create design docs** in `design/` if designing something new
- **Reference existing docs** by relative path when explaining decisions

### Ending a Session

**The user will start new sessions**, but you should prepare by documenting your work.

1. **Create a session log** in `sessions/YYYY-MM/MM-DD-description.md` with:
   - What was accomplished
   - Key decisions made
   - Issues encountered
   - Next steps

2. **Update `status/current-focus.md`** with:
   - Completed work
   - Current state
   - Clear next steps for the next session

3. **Archive completed work** if a feature/refactor is done:
   - Move relevant design/status docs to `status/completed/`
   - Update `roadmap.md` or `backlog.md` as needed

### Creating New Documents

| Document Type | Location | Naming |
|--------------|----------|--------|
| Architecture decision | `architecture/` | `kebab-case.md` |
| Feature design | `design/` | `kebab-case.md` |
| Feature requirements | `requirements/` | `kebab-case.md` |
| Research findings | `research/` | `kebab-case.md` |
| Session notes | `sessions/YYYY-MM/` | `MM-DD-description.md` |
| Completed work archive | `status/completed/` | `kebab-case.md` |

**Always use kebab-case** for filenames (lowercase with hyphens).

---

## Document Lifecycle

```
┌─────────────────┐
│ New Feature     │
│ Request         │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────────┐
│ requirements/   │─────▶│ design/          │
│ What to build   │      │ How to build it  │
└─────────────────┘      └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ Implementation   │
                         │ (track in        │
                         │ sessions/)       │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ Merge to main    │
                         └────────┬─────────┘
                                  │
                                  ▼
                         ┌──────────────────┐
                         │ Move to          │
                         │ status/completed/│
                         └──────────────────┘
```

---

## Key Principles

1. **Single source of truth** - Don't duplicate information across documents
2. **Link, don't copy** - Reference other docs with relative links
3. **Keep current** - Update docs as decisions change
4. **Archive completed work** - Move to `completed/` when merged to main
5. **Session-based workflow** - Document work at the end of each session
6. **Self-documenting structure** - The directory structure should guide where things go

---

## Maintenance

**The structure maintains itself when you:**
- Put docs in the right category
- Use consistent naming (kebab-case)
- Archive completed work
- Update status docs as you go
- Create session logs at the end of sessions

**No additional maintenance needed** - the system is designed to be self-sustaining.
````

### 3. Analyze Project Structure

Before creating START_HERE.md, analyze the actual project structure:

```bash
DIR="${1:-context}"

# Get the project structure (excluding common directories to ignore)
tree -L 3 -I 'node_modules|.git|__pycache__|*.pyc|.venv|venv|dist|build|.next|target|.pytest_cache|.mypy_cache' --dirsfirst > /tmp/project_structure.txt 2>/dev/null || \
find . -maxdepth 3 \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -not -path '*/__pycache__/*' \
  -not -path '*/.venv/*' \
  -not -path '*/venv/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' \
  -not -path '*/.next/*' \
  -not -path '*/target/*' \
  -not -path '*/.pytest_cache/*' \
  -not -path '*/.mypy_cache/*' \
  -not -path "*/$DIR/*" \
  -type f -o -type d | sort > /tmp/project_structure.txt
```

### 4. Create START_HERE.md with Actual Project Info

Using the analyzed structure, create `$DIR/onboarding/START_HERE.md`:

**IMPORTANT:** Do not use the template below as-is. You must:
1. Read the project structure from the analysis above
2. Identify key directories and their purposes from actual files present
3. Determine the tech stack by examining package.json, pyproject.toml, Cargo.toml, go.mod, etc.
4. Infer the project name from directory name or package files
5. Populate ALL placeholder sections with real project information

The template structure:

```markdown
# START HERE - [Actual Project Name from files]

👋 **Welcome!** This document tells you everything you need to know to get started.

## Quick Context

[Infer from README.md if present, or examine main source files to understand purpose]

**Key Info:**
- **Tech stack**: [Determine from actual dependency files]
- **Purpose**: [Infer from project files and structure]
- **Status**: [Check for ROADMAP.md, TODO.md, or git history]

## Getting Started

### First Time Setup

[Examine for setup.py, package.json scripts, Makefile, or similar to determine real setup steps]

### Running the Project

\`\`\`bash
[Determine actual run commands from package.json scripts, Makefile, README, etc.]
\`\`\`

## Project Structure

\`\`\`
[Insert ACTUAL structure from analysis above - show 2-3 levels deep with brief descriptions]
\`\`\`

## Read These Documents Next

### Current Status
📄 [\`../status/current-focus.md\`](../status/current-focus.md) - What we're working on now

### Architecture
📄 [\`../architecture/overview.md\`](../architecture/overview.md) - System architecture

### Documentation Guide
📄 [\`../README.md\`](../README.md) - How the docs are organized

---

**Ready to code?** Check [\`status/current-focus.md\`](../status/current-focus.md) for what to work on next! 🚀
```

**Key requirements:**
- Read actual files to determine project info (pyproject.toml, package.json, Cargo.toml, go.mod, etc.)
- Parse the project structure to identify main source directories
- If README.md exists, extract the project description
- Identify the actual commands to run the project
- Replace ALL placeholders with real information

### 5. Create sessions/README.md

Create `$DIR/sessions/README.md` with this content:

```markdown
# Session Logs

Work session logs organized chronologically by month.

## Structure

```
sessions/
├── 2025-01/
│   ├── 01-15-initial-setup.md
│   └── 01-20-auth-implementation.md
├── 2025-02/
│   └── 02-03-database-migration.md
└── README.md (this file)
```

## Naming Convention

**Format:** `YYYY-MM/MM-DD-description.md`

- `YYYY-MM/` - Month directory
- `MM-DD` - Day of month
- `description` - Short keyword describing the work (kebab-case)

**Examples:**
- `2025-01/01-15-initial-setup.md`
- `2025-02/02-10-api-refactor.md`
- `2025-03/03-05-bug-fixes.md`

## What to Include in Session Logs

Each session log should capture:

1. **What was accomplished** - Concrete deliverables and changes
2. **Key decisions made** - Important choices and their rationale
3. **Issues encountered** - Blockers, bugs, or challenges faced
4. **Next steps** - Clear actions for the next session

## Example Session Log

\`\`\`markdown
# Session: Initial Database Setup - 2025-01-15

## Accomplished
- Created initial database schema with users, posts, and comments tables
- Set up migration system using [tool]
- Implemented connection pooling

## Key Decisions
- Chose PostgreSQL over MySQL for better JSON support
- Used UUID for primary keys to avoid collision in distributed system

## Issues Encountered
- Connection timeout issues with default pool settings
- Resolved by increasing max_connections to 100

## Next Steps
- Add indexes for common query patterns
- Implement database seeding script
- Write integration tests for repository layer
\`\`\`

## Tips

- **Create session logs at the end of each session** while the work is fresh
- **Be specific** about what was done, not just general descriptions
- **Document decisions** with rationale so future you understands why
- **Link to relevant docs** in other directories (design/, architecture/, etc.)
- **Keep it concise** but informative
```

### 6. Fetch Templates from Repository

Automatically fetch role definitions and document templates:

```bash
DIR="${1:-context}"
REPO_URL="https://github.com/codyw912/context-templates"
TARBALL_URL="$REPO_URL/archive/refs/heads/main.tar.gz"

echo "📥 Fetching templates from repository..."

# Create temporary directory for extraction
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and extract tarball
curl -sL "$TARBALL_URL" | tar xz --strip-components=1

# Copy role definitions to roles/ directory
if [ -d "roles" ]; then
  cp -r roles/* "../$DIR/roles/"
  echo "  ✓ Copied role definitions"
fi

# Copy document templates to context root
if [ -d "templates" ]; then
  cp templates/* "../$DIR/"
  echo "  ✓ Copied document templates"
fi

# Clean up
cd ..
rm -rf "$TEMP_DIR"

echo "✅ Templates fetched successfully!"
```

### 7. Final Steps

After creating all files and fetching templates:

1. Verify the structure was created correctly
2. Inform the user:

```
✅ Context documentation structure initialized in $DIR/

Structure created:
- onboarding/ (with START_HERE.md template)
- architecture/, design/, requirements/, specifications/
- status/, research/, roles/, reviews/, sessions/

Templates available:
- roles/ - 12 role definitions for specialized agents
- session-log-template.md, design-doc-template.md, etc.

Next steps:
1. Customize $DIR/onboarding/START_HERE.md with your project info
2. Create $DIR/status/current-focus.md as you start working
3. Copy templates as needed for your workflow

Templates repo: https://github.com/codyw912/context-templates
```

---

## What This Creates

```
$DIR/
├── README.md                      # Navigation guide
├── onboarding/
│   └── START_HERE.md             # Project entry point (customize!)
├── architecture/
├── design/
├── requirements/
├── specifications/                # Formal technical specs
├── status/
│   └── completed/
├── research/
├── roles/                         # Agent role definitions
├── reviews/                       # Review findings and recommendations
└── sessions/
    ├── README.md                 # Session logging guide
    └── $(date +%Y-%m)/           # Current month
```
