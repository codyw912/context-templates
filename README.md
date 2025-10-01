# Context Documentation Templates

A collection of markdown templates for maintaining consistent project context documentation in AI-assisted development workflows.

## Templates

### 📝 Session Log Template
**File:** `templates/session-log-template.md`
**Use for:** Documenting work done in each development session
**Location:** `sessions/YYYY-MM/MM-DD-description.md`

Captures:
- What was accomplished
- Key decisions made with rationale
- Issues encountered and solutions
- Next steps

### 🎨 Design Document Template
**File:** `templates/design-doc-template.md`
**Use for:** Designing features or major components before implementation
**Location:** `design/feature-name.md`

Includes:
- Problem statement and requirements
- Proposed solution with diagrams
- Alternatives considered
- Implementation plan
- Testing strategy
- Risks and mitigations

### 🏛️ Architecture Decision Record (ADR) Template
**File:** `templates/architecture-decision-record-template.md`
**Use for:** Recording important architectural decisions
**Location:** `architecture/adr-XXX-title.md`

Documents:
- Context and drivers for the decision
- The decision itself with rationale
- Consequences (positive, negative, neutral)
- Alternatives considered
- Implementation notes

ADRs should be:
- **Immutable** once accepted
- **Numbered sequentially** (ADR-001, ADR-002, etc.)
- **Superseded** by new ADRs rather than edited

### 📋 Requirements Template
**File:** `templates/requirements-template.md`
**Use for:** Defining feature requirements and specifications
**Location:** `requirements/feature-name.md`

Covers:
- User stories with acceptance criteria
- Functional and non-functional requirements (prioritized)
- Dependencies and constraints
- Success metrics
- Risks and assumptions

### 📐 Specification Template
**File:** `templates/specification-template.md`
**Use for:** Formal technical specifications for implementation
**Location:** `specifications/component-name.md`

Includes:
- API specifications (endpoints, request/response schemas)
- Data models (TypeScript, JSON Schema, SQL)
- Interfaces and contracts
- Business logic rules
- State machines
- Error handling specifications
- Performance requirements
- Security specifications
- Testing specifications

**When to use:** After design is approved and before implementation begins. Provides exact contracts for implementation agents.

## Agent Roles

In addition to templates, this repository includes role definitions for AI agents in the `roles/` directory. These roles provide specialized workflows and responsibilities for different types of development work.

See [`roles/README.md`](roles/README.md) for full documentation on using agent roles.

## Document Flow

```
requirements/          What to build (user perspective)
    ↓
design/               How to approach it (architecture, patterns)
    ↓
specifications/       Formal technical contracts (APIs, schemas, rules)
    ↓
Implementation        Actual coding
    ↓
sessions/            Document what was done
    ↓
status/completed/    Archive when merged
```

## Using These Templates

### Manual Usage

1. Copy the relevant template file
2. Rename it according to your naming convention
3. Fill in the sections
4. Remove any sections that don't apply

### With `/init-context` Command

If using the `/init-context` slash command, you can fetch templates after initialization:

```bash
# Initialize your context structure
/init-context

# Then fetch templates (manual for now)
cd context/
curl -O https://raw.githubusercontent.com/YOUR-USERNAME/context-templates/main/templates/session-log-template.md
# etc.
```

### Automation Option

Add to your project's setup script:

```bash
TEMPLATES_URL="https://raw.githubusercontent.com/YOUR-USERNAME/context-templates/main/templates"

curl -o context/session-log-template.md "$TEMPLATES_URL/session-log-template.md"
curl -o context/design-doc-template.md "$TEMPLATES_URL/design-doc-template.md"
curl -o context/architecture-decision-record-template.md "$TEMPLATES_URL/architecture-decision-record-template.md"
curl -o context/requirements-template.md "$TEMPLATES_URL/requirements-template.md"
```

## Template Philosophy

These templates are designed to:

1. **Be thorough but flexible** - Include all sections that might be needed, but feel free to remove what doesn't apply
2. **Encourage documentation of rationale** - Not just *what* but *why*
3. **Support AI agents** - Structured format helps AI understand and work with the context
4. **Scale with project complexity** - Simple projects can use simpler versions, complex projects benefit from full detail

## Customization

Feel free to:
- Fork this repo and customize for your organization
- Remove sections you never use
- Add project-specific sections
- Adjust priorities and categories
- Change naming conventions to match your workflow

## Naming Conventions

These templates follow these conventions:

- **kebab-case** for filenames (`my-feature-name.md`)
- **Date prefixes** for session logs (`YYYY-MM/MM-DD-description.md`)
- **Sequential numbering** for ADRs (`adr-001-title.md`)
- **Descriptive names** over generic ones

## Contributing

If you have improvements or additional templates:
1. Fork the repository
2. Add your template
3. Update this README
4. Submit a pull request

## License

[Choose appropriate license - MIT, CC0, etc.]

---

**Related:** These templates are designed to work with the hierarchical context structure created by the `/init-context` command. See that documentation for more details on the overall structure.
