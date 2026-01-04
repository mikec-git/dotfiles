# CLAUDE.md

Personal preferences for Claude Code across all projects.

## Code Style
- Prefer concise, readable code over clever solutions
- Use descriptive variable names
- Keep functions small and focused

## Workflow
- Run tests before committing
- Write meaningful commit messages
- Prefer editing existing files over creating new ones

## Communication
- Be direct and concise
- Skip obvious explanations
- Focus on implementation, not theory

## Git
- Branch naming: feature/*, hotfix/*, /bugfix/*, chore/*, etc.
- Flag commit messages based on the context of the change ([Feature], [Bugfix], [Chore], [Docs], etc.)
- Keep commits atomic and focused

## Error Handling
- Prefer early returns over nested conditionals
- Use descriptive error messages
- Handle errors at appropriate boundaries

## Documentation
- Only add comments for non-obvious logic
- Keep README files up to date
- Prefer self-documenting code over excessive comments

## Project Documentation
- For new projects, always initialize a DOCS.md file at the root directory
- After making any changes, update CLAUDE.md with relevant context about those changes (architecture decisions, new patterns, important files, etc.)
