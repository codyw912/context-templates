---
description: Generate a concise project status summary from context documentation
allowed-tools: Read, Bash, Glob
---

Generate a comprehensive summary of the project's current state by reading context documentation.

**Usage:** `/context-summary`

Perfect for:
- Returning to work after time away
- Getting oriented on a new project
- Quick status check before starting work
- Onboarding someone new to the project

## Instructions

### 1. Find Context Directory

Locate the context directory:

```bash
if [ -d "context" ]; then
  CONTEXT_DIR="context"
else
  CONTEXT_DIR=$(find . -maxdepth 2 -type d -name "onboarding" -o -name "sessions" | head -1 | xargs dirname)
fi

if [ -z "$CONTEXT_DIR" ]; then
  echo "❌ No context directory found. Run /init-context first."
  exit 1
fi
```

### 2. Read Key Documentation

Read the following files in order (skip if file doesn't exist):

1. **Project Overview**: `$CONTEXT_DIR/onboarding/START_HERE.md`
   - Extract: Project name, tech stack, purpose
   - This gives you the foundational understanding

2. **Current Focus**: `$CONTEXT_DIR/status/current-focus.md`
   - Extract: Current work, priorities, blockers
   - Shows what's actively being worked on

3. **Recent Session Logs**: Last 3-5 session logs from `$CONTEXT_DIR/sessions/`
   - Find the most recent sessions (by date in filename)
   - Extract: Recent accomplishments, decisions, next steps
   - Pattern: `YYYY-MM/MM-DD-description.md`

```bash
# Find recent session logs (last 5)
find "$CONTEXT_DIR/sessions" -type f -name "*.md" ! -name "README.md" | sort -r | head -5
```

4. **Active Design Docs** (optional): Check `$CONTEXT_DIR/design/` for recent docs

### 3. Generate Summary

Create a concise summary with the following structure:

```markdown
# Project Status Summary

**Generated**: [Current Date and Time]

---

## 📋 Project Overview

**Name**: [Project Name]
**Tech Stack**: [Technologies]
**Purpose**: [Brief description of what the project does]

[If available from START_HERE.md]

---

## 🎯 Current Focus

[Extract from current-focus.md - what's being worked on now]

**Active Work**:
- [Current tasks/features]

**Priorities**:
- [Key priorities]

**Blockers**:
- [Any blockers or issues, or "None"]

---

## 📊 Recent Activity

[Extract from last 3-5 session logs]

### Last Session ([Date])
- **Accomplished**: [Key items]
- **Decisions**: [Important decisions if any]
- **Next**: [Immediate next steps]

### Previous Sessions
- [Brief bullet points of what was done in prior sessions]

---

## 🚀 Next Steps

[Synthesized from current-focus.md and recent session logs]

1. [Immediate priority]
2. [Second priority]
3. [Third priority]

---

## 📁 Quick Links

- [START_HERE.md](./context/onboarding/START_HERE.md)
- [Current Focus](./context/status/current-focus.md)
- [Recent Sessions](./context/sessions/)
```

### 4. Present the Summary

**Important Guidelines**:
- Be concise - aim for 1-2 screen lengths
- Highlight the most important information
- Use clear headings and bullet points
- Include dates for recent activity
- Note any critical blockers or urgent items
- If files are missing, note them gracefully

### 5. Offer Next Actions

After presenting the summary, optionally suggest:
```
What would you like to focus on?
- Continue with [most recent next step]
- Address blocker: [if any blockers exist]
- Start new work
```

---

## Example Output

```markdown
# Project Status Summary

**Generated**: 2025-10-01 14:30

---

## 📋 Project Overview

**Name**: Defuse
**Tech Stack**: Python, uv, Dangerzone
**Purpose**: PDF sanitization tool that removes threats by converting PDFs to safe images

---

## 🎯 Current Focus

**Active Work**:
- Refactoring Docker default sandbox implementation
- Improving error handling and logging

**Priorities**:
1. Complete sandbox refactor
2. Add comprehensive test coverage
3. Update documentation

**Blockers**: None

---

## 📊 Recent Activity

### Last Session (2025-09-30)
- **Accomplished**: Implemented new sandbox abstraction layer, refactored container cleanup
- **Decisions**: Using context managers for resource cleanup to prevent leaks
- **Next**: Add unit tests for sandbox implementations

### Previous Sessions
- 09-28: Fixed PDF conversion pipeline, improved error messages
- 09-25: Initial Docker sandbox implementation
- 09-23: Research on Dangerzone integration patterns

---

## 🚀 Next Steps

1. Write unit tests for sandbox.py module
2. Test sandbox with various PDF types
3. Update README with new architecture

---

## 📁 Quick Links

- [START_HERE.md](./context/onboarding/START_HERE.md)
- [Current Focus](./context/status/current-focus.md)
- [Recent Sessions](./context/sessions/)

---

**What would you like to focus on?**
- Continue with unit tests for sandbox module
- Review and update documentation
- Start new work
```

---

## Notes

- **Quick and Informative**: Should take 30 seconds to read and get oriented
- **Context-Aware**: Adapt summary based on what documentation exists
- **Missing Files**: Gracefully handle missing docs (e.g., "No current-focus.md found - project may be in early stages")
- **Freshness**: Always include generation timestamp
- **Actionable**: End with clear next steps or options

---

## When Files Don't Exist

If key files are missing, adapt:

- **No START_HERE.md**: "Project overview not available. Run /init-context to set up documentation structure."
- **No current-focus.md**: "No active focus document. Consider creating one to track current work."
- **No session logs**: "No session history found. This may be a new project or documentation hasn't been started yet."

Still provide whatever information is available and suggest creating the missing documentation.
