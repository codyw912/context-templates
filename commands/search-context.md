---
description: Search across all context documentation
allowed-tools: Grep, Bash, Read
---

Search for specific information across all context documentation files.

**Usage:** `/search-context <query>`
- `$1` - Search query (supports regex patterns)

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

### 2. Validate Query

Ensure a search query was provided:

```bash
if [ -z "$1" ]; then
  echo "❌ Please provide a search query"
  echo "Usage: /search-context <query>"
  echo ""
  echo "Examples:"
  echo "  /search-context authentication"
  echo "  /search-context 'Redis.*cache'"
  echo "  /search-context TODO"
  exit 1
fi

QUERY="$1"
```

### 3. Search Context Documentation

Use the Grep tool to search across all markdown files in the context directory:

**Search Parameters:**
- **Pattern**: `$QUERY`
- **Path**: `$CONTEXT_DIR`
- **Glob**: `*.md`
- **Output mode**: `content`
- **Line numbers**: `-n true`
- **Context lines**: `-C 2` (show 2 lines before and after match)
- **Case insensitive**: `-i true` (unless the query contains uppercase letters)

### 4. Format Results

Present search results in a clear, organized format:

```
🔍 Search Results for: "$QUERY"

Found [N] matches across [M] files:

───────────────────────────────────────────────────────────
📄 path/to/file.md (line XX)
───────────────────────────────────────────────────────────

  [context line before]
→ [matching line with query highlighted]
  [context line after]

───────────────────────────────────────────────────────────
📄 path/to/file.md (line YY)
───────────────────────────────────────────────────────────

  [context line before]
→ [matching line with query highlighted]
  [context line after]

...
```

**Important Formatting:**
- Group results by file
- Show line numbers
- Include context (2 lines before/after)
- Mark the matching line with `→`
- Use relative paths from project root
- If many results, show first 20 and indicate total count

### 5. Provide Quick Links

After showing results, provide quick file access:

```
📁 Files with matches:
  - context/onboarding/START_HERE.md
  - context/sessions/2025-10/10-01-feature-work.md
  - context/architecture/decisions/ADR-0003-redis-cache.md
```

### 6. Handle No Results

If no matches found:

```
🔍 Search Results for: "$QUERY"

No matches found in context documentation.

Suggestions:
- Try different keywords
- Check spelling
- Use broader search terms
- Search might be case-sensitive
```

### 7. Offer Follow-up Actions

After displaying results, optionally suggest:

```
Would you like me to:
- Read one of these files in full?
- Search for a related term?
- Narrow the search to a specific directory?
```

---

## Search Tips

**Basic Search:**
```bash
/search-context authentication
```

**Case-Sensitive Search:**
```bash
/search-context "API"  # Will match "API" but not "api"
```

**Regex Patterns:**
```bash
/search-context "Redis.*cache"     # Redis followed by cache
/search-context "TODO|FIXME"       # Either TODO or FIXME
/search-context "^## "             # All markdown h2 headers
```

**Phrase Search:**
```bash
/search-context "database migration strategy"
```

---

## Common Use Cases

1. **Find where a decision was made:**
   ```
   /search-context "decided to use PostgreSQL"
   ```

2. **Locate TODO items:**
   ```
   ```
   /search-context "TODO|FIXME|\[ \]"
   ```

3. **Find architecture discussions:**
   ```
   /search-context "architecture/.*microservice"
   ```

4. **Search recent sessions:**
   ```
   /search-context "sessions/2025-10"
   ```

5. **Find all references to a feature:**
   ```
   /search-context "user authentication"
   ```

---

## Search Scope

The search covers all `.md` files in:
- `context/onboarding/`
- `context/architecture/`
- `context/design/`
- `context/requirements/`
- `context/specifications/`
- `context/status/`
- `context/research/`
- `context/sessions/`
- `context/*.md` (templates and top-level docs)

**Excluded:**
- Role definitions (use `/role` to view these)
- Non-markdown files
- Project code (use regular grep/search for code)

---

## Example Output

```
🔍 Search Results for: "Redis"

Found 8 matches across 3 files:

───────────────────────────────────────────────────────────
📄 context/architecture/decisions/ADR-0003-use-redis.md (line 23)
───────────────────────────────────────────────────────────

  We need a shared session storage solution that:
→ We will use Redis as our session storage backend.
  Redis provides in-memory performance with persistence options

───────────────────────────────────────────────────────────
📄 context/sessions/2025-10/10-01-api-optimization.md (line 45)
───────────────────────────────────────────────────────────

  - Added indexes on user.email and user.created_at
→ - Implemented Redis caching for frequently accessed user data
  - Decided to use Redis instead of in-memory caching

───────────────────────────────────────────────────────────
📄 context/status/current-focus.md (line 12)
───────────────────────────────────────────────────────────

  ## Next Steps
→ - Add monitoring for Redis cache hit rates
  - Optimize user search endpoint

───────────────────────────────────────────────────────────

📁 Files with matches:
  - context/architecture/decisions/ADR-0003-use-redis.md
  - context/sessions/2025-10/10-01-api-optimization.md
  - context/status/current-focus.md
```

---

## Performance Notes

- Searches are fast for typical context directory sizes (< 100 files)
- For very large context directories, results may be truncated
- Use more specific queries if getting too many results
- Regex patterns may be slower than simple string searches

---

## Integration with Workflow

Use search during work to:
1. **Recall decisions**: "Why did we choose X?"
2. **Find related work**: "What else touches authentication?"
3. **Locate context**: "Where did we document the API design?"
4. **Track TODOs**: "What's still pending?"
5. **Understand history**: "When did we make this change?"

This keeps you from having to remember exactly where information lives - just search for it.
