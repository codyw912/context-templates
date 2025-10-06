---
description: Create an Architecture Decision Record (ADR)
allowed-tools: Write, Read, Bash, Glob
---

Create a new Architecture Decision Record (ADR) to document an important architectural decision.

**Usage:** `/adr <title>`
- `$1` - Title of the decision (e.g., "use-postgresql-for-database", "adopt-microservices-architecture")

**What are ADRs?**
ADRs document significant architectural decisions, their context, and consequences. They create a historical record of why decisions were made.

## Instructions

### 1. Find Context Directory

Locate the context directory:

```bash
if [ -d "context/architecture" ]; then
  CONTEXT_DIR="context"
else
  CONTEXT_DIR=$(find . -maxdepth 2 -type d -name "architecture" | head -1 | xargs dirname)
fi

if [ -z "$CONTEXT_DIR" ]; then
  echo "❌ No context directory found. Run /init-context first."
  exit 1
fi
```

### 2. Create Decisions Directory

Ensure the decisions directory exists:

```bash
mkdir -p "$CONTEXT_DIR/architecture/decisions"
```

### 3. Determine ADR Number

Find the next ADR number by checking existing ADRs:

```bash
# Find highest existing ADR number
LAST_ADR=$(ls "$CONTEXT_DIR/architecture/decisions" | grep -E "^ADR-[0-9]+" | sort -V | tail -1 | grep -oE "[0-9]+" | head -1)

if [ -z "$LAST_ADR" ]; then
  ADR_NUM=1
else
  ADR_NUM=$((LAST_ADR + 1))
fi

# Format with leading zeros (e.g., 0001, 0042)
ADR_NUM_FORMATTED=$(printf "%04d" $ADR_NUM)
```

### 4. Validate Title

Ensure title is provided and properly formatted:

```bash
if [ -z "$1" ]; then
  echo "❌ Please provide a title for the ADR"
  echo "Usage: /adr <title>"
  echo ""
  echo "Examples:"
  echo "  /adr use-postgresql-for-database"
  echo "  /adr adopt-microservices-architecture"
  echo "  /adr implement-event-sourcing"
  exit 1
fi

# Convert title to kebab-case if needed
TITLE=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
```

### 5. Gather Decision Information

Before creating the ADR, gather information from the user:

```
Creating ADR-$ADR_NUM_FORMATTED: $TITLE

To document this decision, I need some information:

1. What is the context or problem that led to this decision?
2. What decision was made?
3. What are the consequences (positive and negative) of this decision?
4. What alternatives were considered?
```

**Required Information:**
1. **Context**: The situation or problem that necessitates a decision
2. **Decision**: What was decided and why
3. **Consequences**: Trade-offs, benefits, and drawbacks
4. **Alternatives** (optional): Other options that were considered

### 6. Create ADR File

Create the ADR with this format:

```markdown
# ADR-[NUMBER]: [Title]

**Status**: Proposed | Accepted | Deprecated | Superseded

**Date**: [YYYY-MM-DD]

**Deciders**: [Names or roles of decision makers]

---

## Context

[Describe the situation, problem, or opportunity that necessitates a decision.
Include relevant background, constraints, and requirements.]

What is the issue we're trying to solve?
What forces are at play (technical, business, social)?

---

## Decision

[Clearly state the decision that was made]

We will [decision statement].

[Explain the reasoning behind this decision]

---

## Consequences

### Positive

- [Benefit 1]
- [Benefit 2]
- [Benefit 3]

### Negative

- [Trade-off 1]
- [Trade-off 2]
- [Risk 1]

### Neutral

- [Change 1]
- [Change 2]

---

## Alternatives Considered

### Alternative 1: [Name]

**Pros**:
- [Pro 1]
- [Pro 2]

**Cons**:
- [Con 1]
- [Con 2]

**Why not chosen**: [Reason]

### Alternative 2: [Name]

[Same structure]

---

## References

- [Link to relevant docs, RFCs, or discussions]
- [Related ADRs]
- [External resources]

---

## Notes

[Any additional notes, implementation details, or follow-up actions]
```

**File path**: `$CONTEXT_DIR/architecture/decisions/ADR-$ADR_NUM_FORMATTED-$TITLE.md`

### 7. Confirm Creation

After creating the ADR, inform the user:

```
✅ ADR created: architecture/decisions/ADR-[NUMBER]-[title].md

Next steps:
1. Review and refine the ADR content
2. Share with team for feedback
3. Update status to "Accepted" once approved
4. Reference this ADR in related code or docs
```

---

## ADR Status Values

- **Proposed**: Decision is under consideration
- **Accepted**: Decision has been approved and is active
- **Deprecated**: Decision is no longer recommended but may still be in use
- **Superseded**: Decision has been replaced (reference the new ADR)

Start all ADRs with "Proposed" status.

---

## Best Practices

1. **Be Specific**: "Use PostgreSQL" is better than "Use a database"
2. **Document Trade-offs**: Include both pros and cons
3. **Include Context**: Explain why the decision was needed
4. **Reference Sources**: Link to research, benchmarks, or discussions
5. **Update Status**: Keep the status field current
6. **Link Related ADRs**: If this supersedes another ADR, reference it

---

## Example ADR

```markdown
# ADR-0003: Use Redis for Session Storage

**Status**: Accepted

**Date**: 2025-10-01

**Deciders**: Engineering Team, Platform Lead

---

## Context

Our application currently stores user sessions in memory, which causes problems:
- Sessions are lost when the server restarts
- Load balancing requires sticky sessions
- Multiple server instances can't share session data
- We're planning to scale horizontally

We need a shared session storage solution that:
- Persists across server restarts
- Can be accessed by multiple application instances
- Supports TTL for automatic session expiration
- Has low latency (< 10ms)

---

## Decision

We will use Redis as our session storage backend.

Redis provides:
- In-memory performance with persistence options
- Built-in TTL support for automatic expiration
- Simple key-value operations perfect for session data
- Proven scalability and reliability
- Wide ecosystem support and tooling

---

## Consequences

### Positive

- Sessions persist across server restarts
- Can scale horizontally without sticky sessions
- Automatic session expiration via TTL
- Sub-millisecond read/write latency
- Reduced memory usage on application servers

### Negative

- Adds external dependency to infrastructure
- Requires Redis cluster management and monitoring
- Network latency between app and Redis (though minimal)
- Additional cost for Redis hosting

### Neutral

- Need to update deployment configuration
- Team needs to learn Redis basics (low learning curve)

---

## Alternatives Considered

### Alternative 1: PostgreSQL

**Pros**:
- Already using PostgreSQL for application data
- Strong consistency guarantees
- No new infrastructure needed

**Cons**:
- Slower than in-memory solution (20-50ms latency)
- Adds load to primary database
- Requires additional tables and cleanup jobs

**Why not chosen**: Performance requirements favor in-memory solution

### Alternative 2: Memcached

**Pros**:
- Simple and fast in-memory cache
- Proven technology

**Cons**:
- No persistence (sessions lost on restart)
- No built-in TTL per key
- Limited data structures

**Why not chosen**: Lack of persistence is a dealbreaker

---

## References

- [Redis documentation on session storage](https://redis.io/topics/sessions)
- [Benchmark: Redis vs PostgreSQL for sessions](internal-link)
- Related: ADR-0001 (horizontal scaling strategy)

---

## Notes

Implementation plan:
1. Set up Redis cluster (primary + replica)
2. Add redis client library to application
3. Implement session store adapter
4. Migrate existing sessions gradually
5. Monitor performance and adjust TTL settings

Expected completion: Sprint 24
```

---

## Tips

- **Create ADRs for significant decisions**: Don't document every small choice
- **Write when fresh**: Document the decision while context is clear
- **Be honest about trade-offs**: Acknowledge the negatives
- **Update as needed**: If the decision changes, update the ADR or create a new one
- **Review regularly**: Periodically review ADRs to see if they're still valid

---

## When to Create an ADR

Create an ADR when:
- Choosing a major technology or framework
- Deciding on architectural patterns or structure
- Making trade-offs with significant consequences
- Solving a problem with multiple valid solutions
- The decision will impact the team for a long time

Don't create an ADR for:
- Minor implementation details
- Obvious or trivial choices
- Temporary workarounds
- Individual code-level decisions
