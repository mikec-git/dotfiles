## Code Style
- Refer to ~/.claude/CLEAN_CODE.md

## Initialization
- Run `/init` for initializing CLAUDE.md in the local repository, allow claude to automatically create it

## Writing Style
- Use regular hyphens (-) instead of em dashes (—) or en dashes (–)

## Workflow
- Run tests before committing
- Write meaningful commit messages
- Prefer editing existing files over creating new ones

## Git
- Branch naming: feature/*, hotfix/*, bugfix/*, chore/*, etc.
- Flag commit messages based on context: `[Feature] Add user auth`, `[Bugfix] Fix null check`, `[Chore] Update deps`, `[Docs] Update README`
- Keep commits atomic and focused

## Error Handling
- Prefer early returns over nested conditionals
- Use descriptive error messages
- Handle errors at appropriate boundaries

## Security
- Never commit secrets, API keys, or credentials
- Validate user inputs at boundaries
- Follow OWASP guidelines for web applications

## Dependencies
- Minimize new dependencies
- Prefer well-maintained, widely-used packages
- Check for security vulnerabilities before adding

## Documentation
- Keep README files up to date
- Only add comments for non-obvious logic
- Prefer self-documenting code over excessive comments
- For new projects, initialize a DOCS.md file at the root directory
- Update DOCS.md after architectural changes or new patterns

## Before Completing Tasks
- Verify changes don't break existing functionality
- Check for console.logs or debug statements
- Ensure no TODO comments are left unresolved
