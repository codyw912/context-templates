# Agent Roles

Role definitions for specialized AI agents working on this project. Each role provides a tailored workflow, reading list, and responsibilities to help agents focus on their specific domain.

---

## Purpose

Different tasks require different mindsets and workflows. Roles provide:

- **Clear responsibilities** - What this agent should and shouldn't do
- **Tailored entry points** - Which docs to read for this role
- **Specific workflows** - Step-by-step process for common tasks
- **Decision frameworks** - How to make decisions in this role
- **Output expectations** - What documents to create/update

---

## Available Roles

### 🎯 Orchestrator (`role-orchestrator.md`)

**Mission:** Coordinate multi-role workflows, maintain project status, and ensure smooth handoffs between specialized roles

**Responsibilities:**
- Plan multi-role workflows for complex initiatives
- Maintain project roadmap and status documents
- Track dependencies and blockers across workstreams
- Ensure proper handoffs between roles
- Coordinate parallel work by different roles
- Work collaboratively with humans on planning and decisions

**Creates:**
- Coordination plans (`planning/[initiative].md`)
- Status documents (`status/current-focus.md`, `status/roadmap.md`, `status/blockers.md`)
- Handoff checklists (`planning/handoff-*.md`)
- Session logs

**Usage:**
```
"You are the orchestrator. Read roles/role-orchestrator.md and follow that workflow."
```

**When to use:** Complex multi-phase projects requiring 3+ roles, parallel workstreams, or initiatives needing high-level coordination.

---

### 🏛️ Architect (`role-architect.md`)

**Mission:** Design system architecture and make structural decisions

**Responsibilities:**
- Design system architecture for new features
- Make technology selection decisions
- Create Architecture Decision Records (ADRs)
- Conduct architecture reviews
- Plan major refactorings
- Define technical patterns and conventions

**Creates:**
- Architecture Decision Records (`architecture/adr-XXX-*.md`)
- Design documents (`design/*.md`)
- Technical specifications (`specifications/*.md`)
- Architecture reviews (`architecture/reviews/*.md`)

**Usage:**
```
"You are the software architect. Read roles/role-architect.md and follow that workflow."
```

### 💻 Implementer (`role-implementer.md`)

**Mission:** Write code based on specifications and designs

**Responsibilities:**
- Implement features according to specifications
- Write unit and integration tests
- Follow established architectural patterns
- Handle error cases and edge conditions
- Document code appropriately

**Creates:**
- Source code
- Tests
- Code documentation
- Session logs

**Usage:**
```
"You are an implementer. Read roles/role-implementer.md and follow that workflow."
```

### 🔬 Researcher (`role-researcher.md`)

**Mission:** Investigate technologies, APIs, and approaches

**Responsibilities:**
- Research APIs and third-party services
- Evaluate libraries and frameworks
- Prototype and proof-of-concept work
- Document findings and recommendations
- Compare alternatives objectively

**Creates:**
- Research findings (`research/*.md`)
- Proof-of-concept code
- API documentation and examples
- Comparison matrices

**Usage:**
```
"You are a researcher. Read roles/role-researcher.md and follow that workflow."
```

### 🔍 Reviewer (`role-reviewer.md`)

**Mission:** Review code, designs, and documentation for quality

**Responsibilities:**
- Review code for bugs, style, and best practices
- Review designs for completeness and feasibility
- Review documentation for clarity and accuracy
- Provide constructive feedback
- Ensure consistency with project standards

**Creates:**
- Review comments and feedback
- Updated documentation (if gaps found)
- Session logs

**Usage:**
```
"You are a code reviewer. Read roles/role-reviewer.md and follow that workflow."
```

### 📚 Documenter (`role-documenter.md`)

**Mission:** Create and maintain project documentation

**Responsibilities:**
- Write clear, comprehensive documentation
- Update documentation as code changes
- Ensure documentation accuracy
- Create examples and tutorials
- Maintain documentation structure

**Creates:**
- Documentation updates across all directories
- Examples and tutorials
- API documentation
- Session logs

**Usage:**
```
"You are a documenter. Read roles/role-documenter.md and follow that workflow."
```

### 🔧 Refactorer (`role-refactorer.md`)

**Mission:** Improve code quality and reduce technical debt

**Responsibilities:**
- Refactor code for clarity and maintainability
- Reduce technical debt
- Extract reusable components
- Improve test coverage
- Modernize legacy code

**Creates:**
- Refactored code
- Updated tests
- Refactoring session logs
- Documentation updates

**Usage:**
```
"You are a refactorer. Read roles/role-refactorer.md and follow that workflow."
```

### 🐛 Debugger (`role-debugger.md`)

**Mission:** Diagnose and fix bugs

**Responsibilities:**
- Investigate bug reports
- Reproduce issues
- Identify root causes
- Implement fixes
- Add regression tests

**Creates:**
- Bug fixes
- Regression tests
- Debug session logs
- Updated documentation (if needed)

**Usage:**
```
"You are a debugger. Read roles/role-debugger.md and follow that workflow."
```

---

## How to Use Roles

### Starting a Session with a Role

At the start of a conversation, specify the role:

```
"You are the [role name]. Read roles/role-[name].md and follow that workflow for this session."
```

The agent will:
1. Read the role definition
2. Follow the role's specific reading list
3. Apply the role's workflow and decision framework
4. Create the documents expected for that role
5. Stay within the role's boundaries

### Switching Roles Mid-Session

You can switch roles if needed:

```
"Switch to the implementer role. Read roles/role-implementer.md and implement the design we just created."
```

### Combining Roles

Some tasks may require multiple roles sequentially:

1. **Orchestrator** plans the multi-role workflow (for complex initiatives)
2. **Architect** designs the system
3. **Implementer** builds it
4. **Reviewer** checks quality
5. **Documenter** writes the docs

For simple tasks, skip the orchestrator and use roles directly.

---

## Role Boundaries

Each role has clear boundaries:

**Orchestrator:**
- ✅ Plan multi-role workflows and maintain project status
- ✅ Facilitate handoffs and track progress
- ❌ Make architectural or technical decisions (collaborate with architect and human)
- ❌ Execute specialized work (coordinate, don't do)

**Architect:**
- ✅ Design systems and make architectural decisions
- ❌ Write production code (POCs/prototypes are fine)

**Implementer:**
- ✅ Write code according to specifications
- ❌ Make architectural decisions (ask architect)

**Researcher:**
- ✅ Investigate and document options
- ❌ Make final decisions (present findings to architect)

**Reviewer:**
- ✅ Provide feedback and suggestions
- ❌ Implement changes (that's implementer's job)

**Documenter:**
- ✅ Write and update documentation
- ❌ Make technical decisions (document what exists)

**Refactorer:**
- ✅ Improve existing code structure
- ❌ Add new features (that's implementer's job)

**Debugger:**
- ✅ Fix bugs and add regression tests
- ❌ Add new features or refactor unrelated code

---

## Creating Custom Roles

You can create custom roles for your project:

1. Copy an existing role as a template
2. Customize:
   - Mission and responsibilities
   - Reading list (what docs to start with)
   - Workflow (steps to follow)
   - What documents to create
   - Decision framework
   - Boundaries (what NOT to do)
3. Name it `role-[name].md`
4. Place in `roles/` directory

**Custom role ideas:**
- `role-data-engineer.md` - For data pipeline work
- `role-devops.md` - For infrastructure and deployment
- `role-security-auditor.md` - For security reviews
- `role-performance-optimizer.md` - For performance work
- `role-integration-specialist.md` - For third-party integrations

---

## Role Templates

Each role document should include:

1. **Header**
   - Role name and primary responsibility
   - Mission statement

2. **Boundaries**
   - What this role IS responsible for
   - What this role is NOT responsible for

3. **Starting a Session**
   - Specific reading list for this role
   - How to understand the task

4. **Workflow**
   - Step-by-step process for common tasks
   - Decision-making frameworks
   - Validation checklists

5. **Documents Created**
   - What documents this role creates
   - Where they go

6. **Communication Guidelines**
   - How to write for this role's audience
   - Handoff procedures

7. **Anti-Patterns**
   - Common mistakes to avoid

8. **Session End Checklist**
   - What to do before ending the session

---

## Best Practices

**For Users:**
- Be explicit about which role you want at the start
- Let the agent know when to switch roles
- Respect role boundaries - don't ask an implementer to make architectural decisions

**For Agents:**
- Read your role definition at the start of each session
- Follow your role's specific workflow
- Stay within your boundaries - escalate if something is outside your role
- Create the documents your role is responsible for
- Document your work in session logs

---

## Role Workflow Example

### Simple Feature (Direct Role Usage)

For straightforward tasks, use roles directly:

```
User: "Implement the login endpoint according to the spec"

Session 1 - Implementer:
"You are the implementer. Implement the login endpoint."
→ Creates: Source code, tests
```

### Complex Initiative (With Orchestrator)

For multi-phase projects, start with the orchestrator:

```
User: "We need to add user authentication with OAuth support"

Session 1 - Orchestrator:
"You are the orchestrator. Help me plan the authentication initiative."
→ Assesses current state, creates coordination plan
→ Creates: planning/authentication-initiative.md
→ Updates: status/roadmap.md, status/current-focus.md
→ Human approves plan

Session 2 - Researcher:
"You are the researcher. Investigate OAuth providers."
→ Creates: research/oauth-providers.md

Session 3 - Architect:
"You are the architect. Design the authentication system."
→ Creates: design/authentication.md, architecture/adr-015-oauth-choice.md
→ Human approves architecture

Session 4 - Architect:
"You are the architect. Create the implementation specification."
→ Creates: specifications/authentication-api.md

Session 5 - Implementer:
"You are the implementer. Implement the authentication spec."
→ Creates: Source code, tests

Session 6 - Reviewer:
"You are the reviewer. Review the authentication implementation."
→ Creates: reviews/2025-10-15-auth-code-review.md (with findings)

Session 7 - Security Auditor:
"You are the security auditor. Address the security findings from the review."
→ Fixes security issues, marks review items complete

Session 8 - Documenter:
"You are the documenter. Document how to use authentication."
→ Creates: Updated docs

Session 9 - Orchestrator:
"You are the orchestrator. Verify the authentication initiative is complete."
→ Updates: status/current-focus.md, planning/authentication-initiative.md (complete)
→ Reports completion to human
```

---

## Why Roles Matter

**Without roles:**
- Agents may work outside their expertise
- Workflow is unclear
- Documentation is inconsistent
- Handoffs are messy

**With roles:**
- Clear responsibilities and boundaries
- Consistent workflows and outputs
- Better quality in specialized areas
- Smooth handoffs between phases
- Easier to onboard new agents/humans

---

## Summary

Roles provide structure and specialization for agent work. Use them to:
- Get better quality output in specialized domains
- Follow consistent workflows
- Create predictable documentation
- Enable smooth handoffs between work phases
- Scale your development process

**Start every session by assigning a role!**
