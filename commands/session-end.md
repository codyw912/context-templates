---
description: Create a session log and update project status
allowed-tools: Write, Read, Bash, Glob
---

End your work session by creating a session log and updating the current focus document.

**Usage:** `/session-end [description]`
- `$1` - Optional: Brief description of the session (e.g., "auth-refactor", "bug-fixes")

## Instructions

### 1. Find Context Directory

Locate the context directory:

```bash
if [ -d "context/sessions" ]; then
  CONTEXT_DIR="context"
else
  CONTEXT_DIR=$(find . -maxdepth 2 -type d -name "sessions" -path "*/sessions" | head -1 | xargs dirname)
fi

if [ -z "$CONTEXT_DIR" ]; then
  echo "❌ No context directory found. Run /init-context first."
  exit 1
fi
```

### 2. Compile Session Information

**You were doing the work**, so you should know what happened. Compile the session information from your work:

**Required Information:**
1. **Session description** (if not provided as $1): Short keyword for the work (e.g., "database-migration", "api-refactor")
2. **What was accomplished**: Concrete deliverables and changes you made
3. **Key decisions made**: Important choices you made and their rationale
4. **Issues encountered**: Blockers, bugs, or challenges you faced (or "None")
5. **Next steps**: Clear actions needed for the next session

**Think back through the session:**
- What files did you create/modify?
- What problems did you solve?
- What choices did you make and why?
- What's left to do?

If the session description wasn't provided as an argument, infer one from the work (e.g., if you refactored auth code, use "auth-refactor")

### 3. Create Session Log File

Generate the session log:

```bash
# Get current date
CURRENT_DATE=$(date +%Y-%m-%d)
YEAR_MONTH=$(date +%Y-%m)
DAY=$(date +%m-%d)

# Create month directory if it doesn't exist
mkdir -p "$CONTEXT_DIR/sessions/$YEAR_MONTH"

# Generate filename
SESSION_FILE="$CONTEXT_DIR/sessions/$YEAR_MONTH/$DAY-$SESSION_DESCRIPTION.md"

# Check if file already exists
if [ -f "$SESSION_FILE" ]; then
  echo "⚠️  Session log already exists: $SESSION_FILE"
  echo "   Appending timestamp to filename..."
  SESSION_FILE="$CONTEXT_DIR/sessions/$YEAR_MONTH/$DAY-$SESSION_DESCRIPTION-$(date +%H%M).md"
fi
```

### 4. Write Session Log

Create the session log file with the following format:

```markdown
# Session: [Title] - [Date]

## Accomplished

[List of what was accomplished - be specific with bullet points]

## Key Decisions

[Important choices and their rationale - or "None" if no major decisions]

## Issues Encountered

[Blockers, bugs, or challenges - or "None" if smooth sailing]

## Next Steps

[Clear actions for the next session - bullet points]

---

**Session date**: [YYYY-MM-DD]
**Duration**: [Approximate time if known, otherwise omit]
```

**IMPORTANT**:
- Use the actual information provided by the user
- Be specific and concrete
- Use bullet points for readability
- Link to relevant files or docs where applicable

### 5. Update Current Focus (Optional but Recommended)

After creating the session log, ask the user:

```
Would you like me to update status/current-focus.md to reflect the completed work and next steps? (yes/no)
```

If yes:
- Read `$CONTEXT_DIR/status/current-focus.md`
- Update it based on what was accomplished and next steps
- If the file doesn't exist, offer to create it with a basic template

### 6. Confirm Creation

After creating the log, inform the user:

```
✅ Session log created: sessions/[YEAR-MONTH]/[DAY]-[description].md

Summary:
- [X] items accomplished
- [Y] key decisions documented
- [Z] next steps identified

[If current-focus.md was updated:]
✅ Updated status/current-focus.md with latest progress
```

---

## Session Log Template

Use this structure when creating the log:

```markdown
# Session: [Human-Readable Title] - [Date]

## Accomplished

- Item 1 with specific details
- Item 2 with specific details
- Item 3 with specific details

## Key Decisions

- **Decision 1**: Why this approach was chosen
- **Decision 2**: Trade-offs considered

(Or "No major decisions made this session.")

## Issues Encountered

- **Issue 1**: Description and resolution/workaround
- **Issue 2**: Description and current status

(Or "No significant issues encountered.")

## Next Steps

- [ ] Task 1 with clear action
- [ ] Task 2 with clear action
- [ ] Task 3 with clear action

## References

- Link to relevant design docs
- Link to related PRs or commits
- Link to external resources used

---

**Session date**: YYYY-MM-DD
```

## Best Practices

1. **Be Specific**: "Implemented user authentication" is better than "worked on auth"
2. **Include Context**: Link to files, PRs, issues when relevant
3. **Honest Recording**: Document problems and blockers, not just successes
4. **Actionable Next Steps**: Be clear about what comes next
5. **Capture Rationale**: Future you will thank you for explaining "why"

## Example Session Flow

```
User: /session-end api-optimization

Agent: [Reflects on the work done this session]

During this session, I:
- Optimized database queries for the user listing endpoint
- Added indexes on user.email and user.created_at columns
- Implemented Redis caching for frequently accessed user data
- Decided to use Redis instead of in-memory caching for better scalability across instances
- Encountered complexity with refactoring the user search joins
- Still need to add monitoring for cache hit rates and optimize the search endpoint

[Creates session log with this information]

✅ Session log created: sessions/2025-10/10-01-api-optimization.md

Summary:
- 3 items accomplished
- 1 key decision documented
- 1 issue noted
- 2 next steps identified

Would you like me to update status/current-focus.md with this progress? (yes/no)
```