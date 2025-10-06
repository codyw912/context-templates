---
description: Validate context documentation structure and health
allowed-tools: Bash, Read, Glob, Grep
---

Validate the context documentation structure, checking for missing files, broken links, and potential issues.

**Usage:** `/validate-context`

Performs health checks on your context documentation to ensure it's well-maintained and usable.

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

echo "🔍 Validating context documentation in: $CONTEXT_DIR"
echo ""
```

### 2. Check Required Files

Verify that essential files exist:

**Critical Files:**
- `README.md` - Main navigation guide
- `onboarding/START_HERE.md` - Entry point for the project

**Important Files:**
- `status/current-focus.md` - Current work tracking
- `sessions/README.md` - Session logging guide

```bash
ISSUES_FOUND=0
WARNINGS=0

# Check critical files
if [ ! -f "$CONTEXT_DIR/README.md" ]; then
  echo "❌ Missing: README.md (navigation guide)"
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

if [ ! -f "$CONTEXT_DIR/onboarding/START_HERE.md" ]; then
  echo "❌ Missing: onboarding/START_HERE.md (entry point)"
  ISSUES_FOUND=$((ISSUES_FOUND + 1))
fi

# Check important files
if [ ! -f "$CONTEXT_DIR/status/current-focus.md" ]; then
  echo "⚠️  Recommended: status/current-focus.md (track current work)"
  WARNINGS=$((WARNINGS + 1))
fi
```

### 3. Check Directory Structure

Verify expected directories exist:

```bash
EXPECTED_DIRS=(
  "onboarding"
  "architecture"
  "design"
  "requirements"
  "specifications"
  "status"
  "research"
  "roles"
  "sessions"
)

for dir in "${EXPECTED_DIRS[@]}"; do
  if [ ! -d "$CONTEXT_DIR/$dir" ]; then
    echo "⚠️  Missing directory: $dir/"
    WARNINGS=$((WARNINGS + 1))
  fi
done
```

### 4. Check for Broken Internal Links

Scan markdown files for internal links and verify they exist:

**Process:**
1. Use Grep to find all markdown links: `\[.*\]\((\.\.?/.*\.md.*?)\)`
2. Extract the file paths
3. Check if referenced files exist
4. Report broken links

```bash
# Find all markdown files
find "$CONTEXT_DIR" -name "*.md" -type f | while read -r file; do
  # Extract internal links (relative paths to .md files)
  grep -oE '\[.*?\]\((\.\.?/[^)]+\.md[^)]*)\)' "$file" 2>/dev/null | \
  grep -oE '\((\.\.?/[^)]+\.md[^)]*)' | \
  tr -d '()' | while read -r link; do
    # Resolve relative path
    FILE_DIR=$(dirname "$file")
    RESOLVED_PATH=$(cd "$FILE_DIR" && realpath "$link" 2>/dev/null)

    if [ ! -f "$RESOLVED_PATH" ]; then
      echo "🔗 Broken link in $(basename $file): $link"
      ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
  done
done
```

### 5. Check Session Logs Organization

Verify session logs are properly organized:

```bash
# Check if sessions follow YYYY-MM/MM-DD-description.md pattern
if [ -d "$CONTEXT_DIR/sessions" ]; then
  MISNAMED_SESSIONS=$(find "$CONTEXT_DIR/sessions" -name "*.md" ! -name "README.md" ! -regex ".*/[0-9]{4}-[0-9]{2}/[0-9]{2}-[0-9]{2}-.*\.md")

  if [ -n "$MISNAMED_SESSIONS" ]; then
    echo "⚠️  Session logs not following naming convention:"
    echo "$MISNAMED_SESSIONS"
    WARNINGS=$((WARNINGS + 1))
  fi

  # Check for very old sessions (> 1 year ago)
  ONE_YEAR_AGO=$(date -d "1 year ago" +%Y-%m 2>/dev/null || date -v-1y +%Y-%m)
  OLD_SESSIONS=$(find "$CONTEXT_DIR/sessions" -type d -name "[0-9][0-9][0-9][0-9]-[0-9][0-9]" | while read dir; do
    DIR_DATE=$(basename "$dir")
    if [[ "$DIR_DATE" < "$ONE_YEAR_AGO" ]]; then
      echo "$dir"
    fi
  done)

  if [ -n "$OLD_SESSIONS" ]; then
    echo "📦 Old session logs found (consider archiving):"
    echo "$OLD_SESSIONS"
    WARNINGS=$((WARNINGS + 1))
  fi
fi
```

### 6. Check for Empty Directories

Find directories with no content:

```bash
find "$CONTEXT_DIR" -type d -empty | while read -r empty_dir; do
  if [[ ! "$empty_dir" =~ sessions/[0-9]{4}-[0-9]{2}$ ]]; then
    echo "📁 Empty directory: $(realpath --relative-to=. "$empty_dir")"
    WARNINGS=$((WARNINGS + 1))
  fi
done
```

### 7. Check for TODO/FIXME Items

Scan for TODO items in documentation:

```bash
TODO_COUNT=$(grep -r "TODO\|FIXME\|\[ \]" "$CONTEXT_DIR" --include="*.md" | wc -l)

if [ "$TODO_COUNT" -gt 0 ]; then
  echo "📝 Found $TODO_COUNT TODO/FIXME items in documentation"
  echo "   Run: /search-context 'TODO|FIXME' to see them"
fi
```

### 8. Check ADR Numbering

Verify ADRs are properly numbered:

```bash
if [ -d "$CONTEXT_DIR/architecture/decisions" ]; then
  ADR_FILES=$(ls "$CONTEXT_DIR/architecture/decisions"/ADR-*.md 2>/dev/null | sort)

  if [ -n "$ADR_FILES" ]; then
    EXPECTED_NUM=1
    echo "$ADR_FILES" | while read -r adr; do
      ADR_NUM=$(basename "$adr" | grep -oE "^ADR-([0-9]+)" | grep -oE "[0-9]+")
      ADR_NUM=$((10#$ADR_NUM))  # Remove leading zeros

      if [ "$ADR_NUM" != "$EXPECTED_NUM" ]; then
        echo "⚠️  ADR numbering gap: Expected ADR-$(printf %04d $EXPECTED_NUM), found ADR-$(printf %04d $ADR_NUM)"
        WARNINGS=$((WARNINGS + 1))
      fi

      EXPECTED_NUM=$((ADR_NUM + 1))
    done
  fi
fi
```

### 9. Generate Validation Report

Summarize findings:

```
═══════════════════════════════════════════════════════════
📊 VALIDATION REPORT
═══════════════════════════════════════════════════════════

Status: [HEALTHY / ISSUES FOUND / WARNINGS]

✅ Passed Checks:
  - Required files exist
  - Directory structure complete
  - No broken internal links
  - Session logs properly organized
  - ADR numbering consistent

❌ Issues Found: [N]
  [List critical issues]

⚠️  Warnings: [N]
  [List warnings]

📋 Recommendations:
  [Specific suggestions based on findings]

═══════════════════════════════════════════════════════════
```

**Status Levels:**
- **HEALTHY**: No issues, 0-2 minor warnings
- **WARNINGS**: No critical issues, but several warnings
- **ISSUES FOUND**: Critical issues that should be addressed

### 10. Provide Actionable Recommendations

Based on findings, suggest specific actions:

```
🔧 Suggested Actions:

1. Create missing files:
   - Run: /init-context to regenerate structure
   - Manually create: status/current-focus.md

2. Fix broken links:
   - Update link in architecture/overview.md
   - Remove reference to deleted file

3. Organize content:
   - Archive old session logs from 2023
   - Consolidate empty directories

4. Complete documentation:
   - Fill in placeholders in START_HERE.md
   - Resolve 5 TODO items in design docs
```

---

## Validation Checklist

The command checks:

**Structure:**
- ✓ Required files exist (README.md, START_HERE.md)
- ✓ Expected directories present
- ✓ No empty directories (except session month folders)

**Content Quality:**
- ✓ No broken internal links
- ✓ Session logs follow naming convention
- ✓ ADRs properly numbered
- ✓ No placeholder content in critical files

**Maintenance:**
- ✓ No very old session logs (suggest archiving)
- ✓ TODO items tracked
- ✓ Status documents up to date

---

## Example Output

```
🔍 Validating context documentation in: context

Checking required files...
  ✅ README.md exists
  ✅ onboarding/START_HERE.md exists
  ⚠️  status/current-focus.md not found

Checking directory structure...
  ✅ All expected directories present

Checking internal links...
  ✅ No broken links found

Checking session logs...
  ✅ Naming convention followed
  📦 Old session logs found: sessions/2023-01/ (consider archiving)

Checking ADR numbering...
  ✅ ADR sequence is correct (ADR-0001 through ADR-0005)

Checking for TODOs...
  📝 Found 3 TODO items in documentation

═══════════════════════════════════════════════════════════
📊 VALIDATION REPORT
═══════════════════════════════════════════════════════════

Status: HEALTHY ✅

✅ Passed Checks: 5
⚠️  Warnings: 2
❌ Issues Found: 0

Warnings:
  - status/current-focus.md not found (recommended)
  - Old session logs from 2023 should be archived

📋 Recommendations:
  1. Create status/current-focus.md to track active work
  2. Archive or delete sessions/2023-*/ directories
  3. Review and resolve 3 TODO items

Overall: Your context documentation is in good shape!

═══════════════════════════════════════════════════════════
```

---

## When to Run

Run validation:
- **Monthly**: Regular health check
- **After major reorganization**: Verify structure integrity
- **Before archiving**: Ensure everything is properly documented
- **When returning to project**: Check if documentation is current
- **Before onboarding**: Ensure docs are ready for new contributors

---

## Auto-Fix Options

Some issues can be auto-fixed. After validation, offer:

```
Would you like me to:
- Create missing status/current-focus.md? (yes/no)
- Archive old session logs? (yes/no)
- Fix broken links automatically? (yes/no)
```

---

## Integration Notes

- Non-destructive: Only reads files, doesn't modify anything
- Fast: Completes in seconds for typical projects
- Informative: Provides specific, actionable feedback
- Preventive: Catches issues before they become problems

Use this regularly to maintain documentation quality and ensure the context system remains helpful rather than becoming technical debt.
