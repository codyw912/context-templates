---
description: Create a structured review document for code, architecture, or quality reviews
allowed-tools: Write, Read, Bash, Glob, Grep
---

Create a structured review document to capture review findings with agent role assignments.

**Usage:** `/review <type> <subject>`
- `$1` - Review type: `code` | `test` | `architecture` | `security` | `performance`
- `$2` - Subject of review (e.g., "auth-module", "api-endpoints", "database-design")

## Instructions

### 1. Find Context Directory

Locate the context directory:

```bash
if [ -d "context/reviews" ]; then
  CONTEXT_DIR="context"
else
  CONTEXT_DIR=$(find . -maxdepth 2 -type d -name "reviews" | head -1 | xargs dirname)
fi

if [ -z "$CONTEXT_DIR" ]; then
  echo "❌ No context directory found. Run /init-context first."
  exit 1
fi

# Ensure reviews directory exists
mkdir -p "$CONTEXT_DIR/reviews"
```

### 2. Validate Arguments

Ensure type and subject are provided:

```bash
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "❌ Please provide review type and subject"
  echo "Usage: /review <type> <subject>"
  echo ""
  echo "Types:"
  echo "  code         - Code review"
  echo "  test         - Test coverage and quality review"
  echo "  architecture - Architecture and design review"
  echo "  security     - Security audit review"
  echo "  performance  - Performance review"
  echo ""
  echo "Examples:"
  echo "  /review code auth-module"
  echo "  /review test api-endpoints"
  echo "  /review security user-data-handling"
  exit 1
fi

REVIEW_TYPE="$1"
SUBJECT="$2"

# Validate review type
case "$REVIEW_TYPE" in
  code|test|architecture|security|performance)
    ;;
  *)
    echo "❌ Invalid review type: $REVIEW_TYPE"
    echo "Valid types: code, test, architecture, security, performance"
    exit 1
    ;;
esac
```

### 3. Create Review File

Generate the review document filename:

```bash
CURRENT_DATE=$(date +%Y-%m-%d)
REVIEW_FILE="$CONTEXT_DIR/reviews/$CURRENT_DATE-$REVIEW_TYPE-$SUBJECT.md"

# Check if file already exists
if [ -f "$REVIEW_FILE" ]; then
  echo "⚠️  Review already exists: $REVIEW_FILE"
  echo "   Appending timestamp to filename..."
  REVIEW_FILE="$CONTEXT_DIR/reviews/$CURRENT_DATE-$REVIEW_TYPE-$SUBJECT-$(date +%H%M).md"
fi
```

### 4. Determine Review Title

Create human-readable title from type and subject:

```bash
# Capitalize type
TITLE_TYPE=$(echo "$REVIEW_TYPE" | sed 's/./\U&/')

# Convert subject kebab-case to Title Case
TITLE_SUBJECT=$(echo "$SUBJECT" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')

REVIEW_TITLE="$TITLE_TYPE: $TITLE_SUBJECT"
```

### 5. Create Review Document

**You are the reviewer**, so compile your findings into the review document.

Think through:
- What did you review? (scope)
- What issues did you find? (categorized by severity)
- What was done well? (positive observations)
- What should be done next? (recommendations)
- Which agent roles should address which findings?

Create the review document with this structure:

```markdown
# Review: [Title] - [Date]

**Type**: [Review Type]
**Reviewer**: reviewer
**Status**: Pending
**Scope**: [What was reviewed - be specific about files, modules, or areas]

## Summary

[2-3 sentence overview of the review and key findings]

## Findings

### Critical (Must Fix)

- [ ] **[Component/File]**: [Issue description]
  - **Impact**: [Why this is critical]
  - **Recommendation**: [Specific fix]
  - **Assigned to**: [agent-role: implementer|tester|security-auditor|architect|refactorer|etc.]

### High Priority

- [ ] **[Component/File]**: [Issue description]
  - **Impact**: [Consequence if not fixed]
  - **Recommendation**: [How to fix]
  - **Assigned to**: [agent-role]

### Medium Priority

- [ ] **[Component/File]**: [Issue description]
  - **Recommendation**: [Suggested improvement]
  - **Assigned to**: [agent-role]

### Low Priority / Nice to Have

- [ ] **[Component/File]**: [Minor issue or suggestion]
  - **Recommendation**: [Optional improvement]
  - **Assigned to**: [agent-role]

## Positive Observations

[What was done well - be specific with examples]

- [Positive observation 1]
- [Positive observation 2]
- [Positive observation 3]

## Recommendations

[High-level guidance and next steps, prioritized]

1. [Priority 1 recommendation]
2. [Priority 2 recommendation]
3. [Priority 3 recommendation]

## References

- [Link to related docs, standards, best practices, or discussions]
- [Related ADRs or design docs]
- [External resources referenced]

---

**Next Steps**: [Which agent roles should review and address their assigned findings]
```

**IMPORTANT Guidelines:**
- Be specific about what was reviewed (file paths, components)
- Categorize findings by severity appropriately
- Explain the IMPACT of each issue, not just the issue itself
- Provide ACTIONABLE recommendations with specifics
- Assign findings to appropriate agent roles for implementation
- Balance criticism with positive observations
- Include references to standards or best practices

### 6. Confirm Creation

After creating the review, inform the user:

```
✅ Review created: reviews/[DATE]-[TYPE]-[subject].md

Summary:
- [X] critical findings
- [Y] high priority findings
- [Z] medium priority findings
- [W] low priority findings

Assigned to:
- [agent-role-1]: [N] findings
- [agent-role-2]: [M] findings

Next steps:
1. Review and refine the findings
2. Share with team or load assigned agent roles
3. Address findings in priority order
4. Update review status as items are completed
```

---

## Agent Role Assignments

When assigning findings, use these agent roles:

- **implementer**: General code changes, bug fixes, feature additions
- **tester**: Test coverage, test improvements, test fixes
- **security-auditor**: Security vulnerabilities, threat mitigation
- **performance-optimizer**: Performance issues, optimization
- **architect**: Architecture changes, design pattern improvements
- **refactorer**: Code quality improvements, pattern application
- **documenter**: Documentation improvements, inline docs
- **devops**: Infrastructure, deployment, CI/CD issues

Multiple findings can be assigned to the same role, and a finding can be assigned to multiple roles if coordination is needed.

---

## Review Type Guidelines

### Code Review
**Focus**: Correctness, quality, maintainability
**Common Findings**:
- Logic errors and edge cases
- Code duplication
- Poor naming
- Complex functions needing refactoring
- Missing error handling

**Typical Assignments**: implementer, refactorer

### Test Review
**Focus**: Coverage, quality, reliability
**Common Findings**:
- Missing test cases
- Poor test organization
- Flaky tests
- Inadequate edge case coverage
- Over-mocking or under-mocking

**Typical Assignments**: tester

### Architecture Review
**Focus**: Design, patterns, structure
**Common Findings**:
- Tight coupling
- Violation of SOLID principles
- Inappropriate patterns
- Poor separation of concerns
- Scalability concerns

**Typical Assignments**: architect, refactorer

### Security Review
**Focus**: Vulnerabilities, secure coding
**Common Findings**:
- Input validation issues
- Authentication/authorization flaws
- SQL injection vulnerabilities
- XSS vulnerabilities
- Insecure data handling

**Typical Assignments**: security-auditor, implementer

### Performance Review
**Focus**: Speed, efficiency, resource usage
**Common Findings**:
- Inefficient algorithms
- N+1 queries
- Memory leaks
- Missing caching
- Slow database queries

**Typical Assignments**: performance-optimizer, implementer

---

## Example: Code Review

```markdown
# Review: Code: Authentication Module - 2025-10-03

**Type**: Code Review
**Reviewer**: reviewer
**Status**: Pending
**Scope**: src/auth/ directory - login, registration, and session management

## Summary

Reviewed authentication module implementation. Core functionality is solid with good use of password hashing. Found critical security issue with session token generation and several opportunities for test coverage improvements.

## Findings

### Critical (Must Fix)

- [ ] **src/auth/session.py:45**: Session tokens use predictable UUID generation
  - **Impact**: Attackers could potentially guess valid session tokens
  - **Recommendation**: Use `secrets.token_urlsafe(32)` for cryptographically secure tokens
  - **Assigned to**: security-auditor

### High Priority

- [ ] **src/auth/login.py:23-30**: No rate limiting on login attempts
  - **Impact**: Vulnerable to brute force password attacks
  - **Recommendation**: Implement rate limiting (max 5 attempts per 15 minutes per IP)
  - **Assigned to**: implementer

- [ ] **tests/test_auth.py**: Missing tests for registration edge cases
  - **Impact**: Validation bugs could slip through
  - **Recommendation**: Add tests for: duplicate email, invalid email format, weak passwords
  - **Assigned to**: tester

### Medium Priority

- [ ] **src/auth/login.py:15-82**: Login function exceeds 65 lines
  - **Recommendation**: Extract validation and token generation to separate functions
  - **Assigned to**: refactorer

### Low Priority

- [ ] **src/auth/models.py**: Lacks comprehensive docstrings
  - **Recommendation**: Add class and method docstrings explaining purpose and usage
  - **Assigned to**: documenter

## Positive Observations

- Excellent password hashing implementation using bcrypt with appropriate cost factor
- Clean separation between auth logic and API routes
- Clear, user-friendly error messages
- Comprehensive input validation for user registration

## Recommendations

1. **Immediate**: Fix critical security issue with session token generation
2. **This Sprint**: Add rate limiting and expand test coverage
3. **Next Sprint**: Refactor large functions for improved maintainability
4. **Future**: Enhance documentation throughout the module

## References

- [OWASP Authentication Cheat Sheet](https://cheatsheetsoftware.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- Related: ADR-0002 (authentication strategy decision)
- Related: context/design/auth-system-design.md

---

**Next Steps**: Security auditor should address critical finding immediately. Implementer and tester should address high priority items this sprint.
```

---

## Example: Test Review

```markdown
# Review: Test: API Endpoints - 2025-10-03

**Type**: Test Review
**Reviewer**: reviewer
**Status**: Pending
**Scope**: tests/api/ directory - all API endpoint tests

## Summary

Reviewed test suite for API endpoints. Coverage is good at 78%, but missing critical edge cases and error handling tests. Some tests are flaky due to database state dependencies.

## Findings

### Critical (Must Fix)

- [ ] **tests/api/test_users.py**: No tests for authentication failures
  - **Impact**: Auth bugs could go undetected in production
  - **Recommendation**: Add tests for expired tokens, invalid tokens, missing auth headers
  - **Assigned to**: tester

### High Priority

- [ ] **tests/api/test_orders.py:45-67**: Flaky test due to timing dependency
  - **Impact**: CI pipeline fails intermittently, slowing development
  - **Recommendation**: Mock the time-dependent logic or use fixed timestamps
  - **Assigned to**: tester

- [ ] **tests/api/**: Missing tests for pagination edge cases
  - **Impact**: Pagination bugs (empty results, invalid page numbers) not caught
  - **Recommendation**: Add tests for: page 0, negative page, page beyond results
  - **Assigned to**: tester

### Medium Priority

- [ ] **tests/api/test_products.py**: Tests don't verify response schema
  - **Recommendation**: Add JSON schema validation to ensure API contract consistency
  - **Assigned to**: tester

## Positive Observations

- Good use of test fixtures for database setup
- Clear test names that document expected behavior
- Comprehensive happy path coverage
- Good use of parametrized tests for multiple input scenarios

## Recommendations

1. **Immediate**: Add authentication failure tests and fix flaky test
2. **This Week**: Add pagination and error handling edge case tests
3. **Next Week**: Add schema validation to all API tests
4. **Future**: Consider adding contract tests for external API dependencies

## References

- Test coverage report: 78% overall, 65% on error paths
- Related: context/architecture/testing-strategy.md

---

**Next Steps**: Tester should address critical and high priority findings this week.
```

---

## Workflow Integration

1. **Reviewer** creates review using `/review code auth-module`
2. **Reviewer** fills in findings with agent assignments
3. **User** runs `/role security-auditor` → Agent sees pending review items
4. **Security auditor** addresses critical security findings
5. **Security auditor** updates review (marks items complete)
6. **User** runs `/role tester` → Agent sees their pending items
7. Process continues until all findings addressed

This creates clear handoff and accountability for review findings.
