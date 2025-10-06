---
description: Load an agent role definition with project context
allowed-tools: Read, Glob, Bash, Grep
---

Load a specialized agent role definition and provide full project context.

**Usage:** `/role <role-name>`
- `$1` - Role name (e.g., architect, implementer, researcher, reviewer, etc.)

## Instructions

### 1. Find Context Directory

Look for the context directory (default: "context", but could be named differently):

```bash
# Check if default "context" directory exists
if [ -d "context/roles" ]; then
  CONTEXT_DIR="context"
else
  # Try to find any directory with a roles/ subdirectory
  CONTEXT_DIR=$(find . -maxdepth 2 -type d -name "roles" -path "*/roles" | head -1 | xargs dirname)
fi

if [ -z "$CONTEXT_DIR" ]; then
  echo "❌ No context directory found. Run /init-context first."
  exit 1
fi

echo "📁 Using context directory: $CONTEXT_DIR"
```

### 2. Check if Role Exists

Verify the requested role file exists:

```bash
ROLE_NAME="$1"
ROLE_FILE="$CONTEXT_DIR/roles/role-$ROLE_NAME.md"

if [ -z "$ROLE_NAME" ]; then
  echo "❌ Please specify a role name. Usage: /role <role-name>"
  echo ""
  echo "Available roles:"
  ls -1 "$CONTEXT_DIR/roles/"role-*.md 2>/dev/null | xargs -n1 basename | sed 's/role-//;s/.md$//' | sed 's/^/  - /'
  exit 1
fi

if [ ! -f "$ROLE_FILE" ]; then
  echo "❌ Role '$ROLE_NAME' not found at: $ROLE_FILE"
  echo ""
  echo "Available roles:"
  ls -1 "$CONTEXT_DIR/roles/"role-*.md 2>/dev/null | xargs -n1 basename | sed 's/role-//;s/.md$//' | sed 's/^/  - /'
  exit 1
fi
```

### 3. Load Role and Project Context

Once the role is found, you must read and internalize the following files in order:

1. **Role Definition**: Read `$CONTEXT_DIR/roles/role-$ROLE_NAME.md`
   - This defines your responsibilities, workflow, and how to approach tasks
   - Follow the role's instructions precisely

2. **Project Overview**: Read `$CONTEXT_DIR/onboarding/START_HERE.md` (if exists)
   - Provides quick context about the project, tech stack, and structure
   - Gives you essential background to operate effectively

3. **Current Focus**: Read `$CONTEXT_DIR/status/current-focus.md` (if exists)
   - Shows what's currently being worked on
   - Indicates priorities and next steps

### 4. Check for Pending Reviews

Search for review documents that have findings assigned to your role:

```bash
# Search for pending reviews assigned to this role
if [ -d "$CONTEXT_DIR/reviews" ]; then
  # Look for unchecked items assigned to this role
  grep -l "Assigned to.*$ROLE_NAME" "$CONTEXT_DIR/reviews"/*.md 2>/dev/null | \
  xargs grep -l "^- \[ \]" 2>/dev/null
fi
```

If pending reviews are found:
1. Read each review file to understand the findings
2. Identify which specific findings are assigned to your role
3. Note their priority (Critical, High, Medium, Low)
4. Include this in your initial status report

### 5. Adopt the Role

After reading all context files and checking for pending reviews:

1. **Announce your role**: Briefly confirm you've loaded the role and are ready
2. **Report pending reviews**: If any reviews have findings for you, mention them
3. **Follow the role's workflow**: Use the methods and approach defined in the role file
4. **Stay in character**: Maintain the role's perspective and responsibilities throughout the session
5. **Reference context**: Use the project context you've loaded to inform your work

### 6. Output Format

After loading, provide a brief confirmation:

**Without pending reviews:**
```
✅ Loaded role: [Role Name]
📚 Project context loaded

Ready to work as [role description]. What would you like me to focus on?
```

**With pending reviews:**
```
✅ Loaded role: [Role Name]
📚 Project context loaded
📋 Pending review findings: 3 items assigned to [role-name]

Reviews with pending items:
  - reviews/2025-10-03-code-review-auth.md (2 high priority, 1 medium)
  - reviews/2025-10-02-test-coverage-api.md (1 critical)

Ready to work as [role description]. Would you like me to:
- Address pending review findings?
- Work on something else?
```

**With missing context files:**
```
✅ Loaded role: [Role Name]
⚠️  Some context files not found:
  - status/current-focus.md (consider creating this)

Ready to work as [role description]. What would you like me to focus on?
```

---

## Notes for Agents

- **Read the files**, don't just acknowledge them - you need the actual content
- **Internalize the role** - your behavior should match the role definition
- **Use the context** - reference START_HERE.md and current-focus.md to understand the project
- **Check for pending reviews** - look for review findings assigned to your role
- **Stay focused** - maintain the role's perspective throughout the session
- **Be proactive** - follow the role's workflow for approaching tasks

**Pending Reviews Workflow:**
- If you find pending reviews assigned to your role, read them carefully
- Prioritize critical and high-priority findings
- Address findings systematically, updating the review document as you complete them
- Mark completed items by changing `- [ ]` to `- [x]` in the review document

If the role file includes specific instructions for how to start a session, follow those exactly.
