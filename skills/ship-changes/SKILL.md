---
name: ship-changes
description: Commit and push changes following repo conventions. Detects repo pattern (single-commit vs grouped) and executes appropriate workflow. Handles amend, rebase, and force-push safely.
compatibility: Requires git. Optional: glab/gh CLI for MR/PR creation
---

# Ship Changes

Interactive workflow for committing and pushing changes following repository conventions.

## Workflow Detection

### 1. Identify Repository Pattern

```bash
# Check if service repo (single commit per branch) or docs/notes repo (multiple logical commits)
git log --oneline -5 | head -3
```

**Single-commit repos** (services, libraries, feature branches):
- One commit per branch
- Amend workflow for updates
- Force-push for cleanup

**Multi-commit repos** (documentation, notes, monorepos):
- Multiple logical commits OK
- Group related changes together
- Regular push workflow

---

## Single-Commit Pattern: Amend Workflow

### 2. Check Current State

```bash
git fetch origin
git rev-list --left-right --count origin/main...HEAD
# or
git rev-list --left-right --count origin/$(target_branch)...HEAD
```

| Output | Meaning | Next Step |
|--------|---------|-----------|
| `0 0` | No commits yet | Create new commit |
| `0 1` | 1 commit exists | Amend & update |
| `N 1` | Behind target by N | Rebase first |
| `N 2+` | Multiple commits | Squash to 1 |

### 3. Generate Commit Message

**If JIRA/issue ticket convention exists in your repo:**

```bash
# Extract ticket from branch name
git rev-parse --abbrev-ref HEAD
# Example: feat/PROJ-123-description → [PROJ-123]

# Check recent commit style
git log --oneline -10

# Format: <type>: [<TICKET>] [<component>:] <description>
# Example: feat: [PROJ-123] add user preferences panel
```

**If no ticket system, use general format:**

```bash
git commit -m "feat: add user preferences panel"
git commit -m "fix: handle null pointer in validation"
git commit -m "docs: update API authentication guide"
```

### 4. Execute Based on State

**No commit exists (0 0):**
```bash
git add -A
git commit -m "type: [TICKET] description"
git push -u origin HEAD
```

**Commit exists (0 1) - Amend:**
```bash
git add -A
git commit --amend -m "type: [TICKET] updated description"
git push --force-with-lease
```

**Behind target (N 1) - Rebase first:**
```bash
git rebase origin/$(target_branch)
# Resolve conflicts if any
git add -A
git commit --amend -m "type: [TICKET] description"
git push --force-with-lease
```

**Multiple commits (N 2+) - Squash:**
```bash
git reset --soft origin/$(target_branch)
git commit -m "type: [TICKET] description"
git push --force-with-lease
```

### 5. Create/Update Merge Request (Optional)

```bash
# GitLab
glab mr create --fill --yes --assignee @me

# GitHub
gh pr create --fill --assignee @me

# If MR already exists, update it
glab mr update --assignee @me
```

---

## Multi-Commit Pattern: Group and Ship

### 2. Review Changes

```bash
git status
git diff --stat
git diff --cached  # staged changes
```

### 3. Identify Logical Groups

Group related changes by:
- Feature/ticket
- Component or module
- Documentation section
- Tool or utility

### 4. Stage and Commit Each Group

```bash
# Group 1: Feature implementation
git add src/features/auth/
git add tests/features/auth/
git commit -m "feat: implement OAuth2 flow"

# Group 2: Bug fixes
git add src/utils/validation.ts
git commit -m "fix: handle edge case in date parsing"

# Group 3: Documentation
git add docs/api/auth.md
git commit -m "docs: add OAuth2 troubleshooting guide"
```

Each commit should be self-contained and make sense on its own.

### 5. Push

```bash
git push
# or
git push -u origin HEAD  # for new branch
```

---

## Commit Message Conventions

### Common Types

- **feat**: New feature or capability
- **fix**: Bug fix
- **docs**: Documentation updates
- **refactor**: Code restructuring (no behavior change)
- **test**: Test additions or updates
- **perf**: Performance improvements
- **chore**: Maintenance, dependencies, config
- **ci**: CI/CD pipeline changes

### With Ticket (if applicable)

```
type: [TICKET-123] brief description
```

### Without Ticket

```
type: brief description
```

### Component Scoping (optional)

```
type: [TICKET] component: description
type: fix: auth: prevent token expiry race condition
```

---

## Error Handling

**Rebase conflicts:**
1. View conflicts: `git diff`
2. Fix files manually
3. Stage resolved files: `git add <files>`
4. Continue rebase: `git rebase --continue`
5. Then proceed with commit/push

**Push rejected (force-with-lease failed):**
- Someone else pushed to your branch or remote changed
- Review incoming changes: `git fetch && git log HEAD..origin/HEAD`
- Pull and rebase: `git pull --rebase`
- If needed, force-push again: `git push --force-with-lease`

**Diverged history:**
- Use `git push --force-with-lease` (safer than `--force`)
- Only overwrites remote if it matches expected state
- Use `--force` only if absolutely necessary (and you know why)

---

## Safety Rules

- **NEVER skip hooks** (`--no-verify`) unless explicitly requested
- **NEVER use `--force`** alone—always use `--force-with-lease` for safety
- **NEVER push directly to main/master/develop** (use feature branches + MR/PR workflow)
- **After hook failure**: Create a NEW commit (don't amend after a failed hook)
- **Test before pushing**: Run tests locally to catch issues early

---

## Quick Reference

```bash
# View staged changes
git diff --cached

# View all changes
git diff HEAD

# Amend last commit
git commit --amend

# Rebase on target
git rebase origin/main

# Squash last N commits
git rebase -i HEAD~N

# Safe force push
git push --force-with-lease

# Push new branch
git push -u origin HEAD
```

---

## Related Skills

- **Commit message generation**: Use `/commit-message` skill to format properly
- **Git conventions**: Check your repo's contributing guide for specific rules
- **MR/PR workflow**: Create and manage merge/pull requests for code review
