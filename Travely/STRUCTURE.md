# Travely Source Structure

This project keeps source code organized by architectural role first, then by feature.

## Top-Level Folders

- `App/`
  Root app entry point, app reducer, and shell navigation.
- `Dependencies/`
  External integrations wrapped behind dependency clients.
- `Models/`
  Shared domain models used by features and repositories.
- `Features/`
  User-facing features grouped by screen or flow.
- `Persistence/`
  SwiftData entities, mappers, and repository implementation.

## Feature Folder Conventions

Each feature should keep its reducer and main view at the folder root:

- `<FeatureName>Feature.swift`
- `<FeatureName>View.swift`

Optional supporting folders:

- `Components/`
  Reusable feature-local view pieces.
- `Previews/`
  Preview fixtures and preview-only data.
- `Support/`
  Small helper types such as shapes or view-specific support models.

## Practical Rules

- Keep domain models in `Models/`, not inside individual features.
- Keep dependency clients in `Dependencies/`, not mixed into features.
- Prefer `Components/` only when a feature has enough subviews to justify grouping.
- Use `Support/` for feature-local helpers that are not full UI components.
- Avoid adding generic "Utils" folders inside features.
