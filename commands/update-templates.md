---
description: Update context documentation templates from the repository
allowed-tools: Bash
---

Update role definitions and document templates to the latest version from the context-templates repository.

**Usage:** `/update-templates`

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

echo "📁 Found context directory: $CONTEXT_DIR"
```

### 2. Backup Existing Templates (Optional)

Before updating, offer to backup existing templates:

```bash
if [ -d "$CONTEXT_DIR/roles" ] && [ "$(ls -A $CONTEXT_DIR/roles)" ]; then
  echo "⚠️  Existing templates will be updated. Custom modifications may be overwritten."
  echo "   Consider backing up any customized role files before proceeding."
fi
```

### 3. Download and Update Templates

Fetch the latest templates from the repository:

```bash
REPO_URL="https://github.com/codyw912/context-templates"
TARBALL_URL="$REPO_URL/archive/refs/heads/main.tar.gz"

echo "📥 Fetching latest templates from repository..."

# Create temporary directory for extraction
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and extract tarball
if ! curl -sL "$TARBALL_URL" | tar xz --strip-components=1; then
  echo "❌ Failed to download templates. Check your internet connection."
  cd ..
  rm -rf "$TEMP_DIR"
  exit 1
fi

# Track what was updated
UPDATED_ROLES=0
UPDATED_TEMPLATES=0

# Update role definitions
if [ -d "roles" ]; then
  for role_file in roles/*.md; do
    if [ -f "$role_file" ]; then
      cp "$role_file" "../$CONTEXT_DIR/roles/"
      UPDATED_ROLES=$((UPDATED_ROLES + 1))
    fi
  done
  echo "  ✓ Updated $UPDATED_ROLES role definitions"
fi

# Update document templates (only files ending in -template.md)
if [ -d "templates" ]; then
  for template_file in templates/*-template.md; do
    if [ -f "$template_file" ]; then
      cp "$template_file" "../$CONTEXT_DIR/"
      UPDATED_TEMPLATES=$((UPDATED_TEMPLATES + 1))
    fi
  done
  echo "  ✓ Updated $UPDATED_TEMPLATES document templates"
fi

# Clean up
cd ..
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Templates updated successfully!"
echo ""
echo "Updated:"
echo "  - $UPDATED_ROLES role definitions in $CONTEXT_DIR/roles/"
echo "  - $UPDATED_TEMPLATES document templates in $CONTEXT_DIR/"
echo ""
echo "Repository: $REPO_URL"
```

### 4. Verify Update

After updating, confirm the operation:

```bash
# Show timestamp of last update (optional)
echo "Last updated: $(date)"
```

---

## What This Updates

```
$CONTEXT_DIR/
├── roles/                    # All role definition files
│   ├── role-architect.md
│   ├── role-implementer.md
│   ├── role-tester.md
│   └── ... (all 13 roles)
└── *-template.md            # Document templates
    ├── session-log-template.md
    ├── design-doc-template.md
    └── ...
```

## Notes

- **Custom modifications**: If you've customized any role files, they will be overwritten. Back them up first.
- **Internet required**: This command requires an internet connection to fetch updates.
- **Non-destructive**: Only updates template files, doesn't affect your project documentation.
- **Safe to run**: Can be run multiple times without issues.

## When to Use

- After new roles are added to the context-templates repository
- When role definitions are updated with improvements
- When document templates are enhanced
- Periodically to stay up-to-date with best practices

---

**Tip**: If you've customized roles for your project, consider renaming them (e.g., `role-custom-architect.md`) to avoid being overwritten by updates.
