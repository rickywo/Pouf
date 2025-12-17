# Documentation Structure

This directory contains all feature-related documentation for the project.

## Organization

Each feature has its own subdirectory containing standardized planning documents:

```
/docs
├── README.md           # This file - explains the documentation structure
├── _template/          # Templates for new feature documentation
│   ├── README.md
│   ├── PLAN.md
│   └── CHECKLIST.md
└── <feature-name>/     # One directory per feature
    ├── README.md       # Feature overview, goals, and requirements
    ├── PLAN.md         # Implementation plan with phases and tasks
    └── CHECKLIST.md    # Progress tracking checklist
```

## Creating Documentation for a New Feature

1. Copy the `_template` directory and rename it to your feature name (lowercase, hyphenated).
2. Fill in each document with your feature-specific content.
3. Update the checklist as you make progress.

## Current Features

- [flowstate](./flowstate/) - Documentation folder structure standardization

## User Documentation

- [User Guide](./USER_GUIDE.md) - How to install, configure, and use Pouf

## Conventions

- Feature directory names should be lowercase and use hyphens for spaces.
- Each feature must have all three documents: `README.md`, `PLAN.md`, and `CHECKLIST.md`.
- Keep documentation up to date as the feature evolves.
