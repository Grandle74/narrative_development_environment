# Project AI Guidelines & Codebase Map

## 1. CRITICAL: CORE GUARDRAILS & CODE LOCKS

Every change committed to this repository is a **user-reviewed and approved change**. **RULE FOR ALL AI AGENTS & MODELS:**

- **Do not delete, rewrite, or revert** working features, styles, layout logic, or database migrations unless the user explicitly requests changes to that specific feature.
- If you think a change is needed in an existing reviewed feature, **stop and ask the user for permission** first.
- Always check the **Implementation History & Decisions Log** at the bottom of this file before modifying code.

---

## 2. REPOSITORY STRUCTURE MAP

### `/lib` (Dart/Flutter Source Code)

- **\[lib/main.dart\](file:///home/grandle/Projects/narrative_development_environment/lib/main.dart)**: Entrypoint. Initializes the `AppDatabase` and `ThemeController`, configures bilingual locales (`en` and `ar`), and loads the `CharacterListScreen`.
- **\[lib/data/\](file:///home/grandle/Projects/narrative_development_environment/lib/data)**: Data models, persistence layer, and database.
  - **\[tables.dart\](file:///home/grandle/Projects/narrative_development_environment/lib/data/tables.dart)**: Drift SQLite tables definitions.
    - `Entities`: Subjects (e.g. characters, relationships). Uses `id`, `entityType`, and a denormalized cache `displayName`.
    - `AttributeDefinitions`: Metadata registry mapping attribute keys (`attrKey`), types, mutability, and layout layers.
    - `Facts`: Dynamic EAV (Entity-Attribute-Value) storage. **Important:** Canonical values are stored here as timestamped assertions (immutable log, corrections use `supersedes`).
    - `Settings`: Generic key-value store for app settings (e.g., theme seed, dark mode choice).
  - **\[database.dart\](file:///home/grandle/Projects/narrative_development_environment/lib/data/database.dart)**: AppDatabase setup, database schema version (currently V8), and SQLite migrations logic in `onUpgrade`.
  - **\[attribute_labels.dart\](file:///home/grandle/Projects/narrative_development_environment/lib/data/attribute_labels.dart)**: Helper to map attribute keys to human-readable names and layers.
  - **\[enum_options.dart\](file:///home/grandle/Projects/narrative_development_environment/lib/data/enum_options.dart)**: Hardcoded lists for enum-type attributes (like species, nationality, powers).
  - **\[nature_powers.dart\](file:///home/grandle/Projects/narrative_development_environment/lib/data/nature_powers.dart)**: Specific details and groupings for powers.
- **\[lib/widgets/\](file:///home/grandle/Projects/narrative_development_environment/lib/widgets)**: Shared reusable widgets.
  - **\[lockable_field.dart\](file:///home/grandle/Projects/narrative_development_environment/lib/widgets/lockable_field.dart)**: Wraps text/dropdown editing fields with a lock icon. Prevents accidental edits until clicked. Must be used for editable fields.
  - **\[app_dialog_button.dart\](file:///home/grandle/Projects/narrative_development_environment/lib/widgets/app_dialog_button.dart)**: Reusable button for dialog action triggers.
  - **\[inputs/\](file:///home/grandle/Projects/narrative_development_environment/lib/widgets/inputs)**: Input widgets dynamically mapping attribute types.
    - `attribute_fields.dart`: Routes attributes to their correct picker/field type (text, number, date, tag_list, enum, etc.).
    - `nationality_picker.dart`: Country/nationality selector dropdown.
    - `power_selector.dart`: Layout presenting one main power button and up to 8 stone slot selector buttons.
- **\[lib/features/\](file:///home/grandle/Projects/narrative_development_environment/lib/features)**: App Screens.
  - **\[characters/\](file:///home/grandle/Projects/narrative_development_environment/lib/features/characters)**:
    - `character_list_screen.dart`: List of characters with search capabilities.
    - `character_detail_screen.dart`: Editor interface showing character attributes organized by layers, utilizing lockable inputs.
  - **\[settings/\](file:///home/grandle/Projects/narrative_development_environment/lib/features/settings)**:
    - `settings_screen.dart`: Configures application dark/light theme, seed colors, and localization.
- **\[lib/theme/\](file:///home/grandle/Projects/narrative_development_environment/lib/theme)**: Light/Dark Material 3 theme colors (`app_theme.dart`) and reactive local storage controller (`theme_controller.dart`).
- **\[lib/l10n/\](file:///home/grandle/Projects/narrative_development_environment/lib/l10n)**: Localization resources (`intl` AR/EN).

---

## 3. DATABASE PATTERNS & MIGRATION RULES

- **Dynamic Schema (EAV Registry)**: The `Entities` table is kept minimal. Instead of adding columns to the table when a new character detail is needed, we register new rows in `AttributeDefinitions` (via `buildDefaultAttributeDefinitions()` in `database.dart`) and write assertions in `Facts`. Do not add new columns to the `Entities` table for character attributes.
- **Upgrade Migrations (**`onUpgrade`**)**:
  - The schema version is **8**.
  - Any schema change requires incrementing `schemaVersion` and adding an upgrade block (`if (from < N)`) inside `onUpgrade` in `database.dart`.
  - **Never modify or remove past migration blocks** (from &lt; 2, from &lt; 3, ..., from &lt; 8). They are critical to preserve existing user data on upgrade.

---

## 4. UI/UX & LOCALIZATION STANDARDS

- **Bilingual Support (AR/EN)**: The app supports English (`en`) and Arabic (`ar`). All strings displayed in the UI must be localized. Use `AppLocalizations.of(context)!.yourStringKey` and define corresponding translation keys in the l10n files.
- **Responsive Layout**: Design layouts to adapt smoothly across form factors. Use standard Material 3 layouts and flexible elements.
- **Editable Fields**: Any attribute field in character details must utilize the lockable pattern (`LockableField`) so edits require deliberate unlocking.

---

## 5. GROWABLE IMPLEMENTATION HISTORY & DECISIONS LOG

*When you (the AI) successfully implement a feature, database migration, or complete a user task, you **MUST** update this log. Add a new row at the bottom explaining the change, files modified, key decisions, and mark it as* `[LOCKED / REVIEWED]` *once committed.*

| Date | Database Schema Version | Feature / Migration Description | Impacted Files | Key Architectural & Design Decisions | Status |
| --- | --- | --- | --- | --- | --- |
| **Legacy** | 1 - 7 | Initial database tables and migration paths. | `lib/data/` | Set up initial Entity, Fact, and Settings tables. Managed tag fields, restored chapter numbers. | `[LOCKED / REVIEWED]` |
| **Legacy** | 8 | Purged orphaned location/arc columns, consolidated into `participated_arcs`. | `lib/data/database.dart` | Cleaned up unused registry attributes and migrated existing legacy data to `participated_arcs`. | `[LOCKED / REVIEWED]` |
| **Legacy** | 8 | Refactored Character detail page with Power Selector & Lockable Fields. | `lib/widgets/`, `lib/features/` | Added 8 stone power slots to the character detail view using lockable input widgets. | `[LOCKED / REVIEWED]` |
| **2026-07-19** | 8 | Created AI guidelines (`AI_RULES.md`) and config files (`.cursorrules`, `.clinerules`). | `AI_RULES.md`, `.cursorrules`, `.clinerules` | Established a central workspace map and guardrail log to prevent future AIs from breaking reviewed changes. | `[LOCKED / REVIEWED]` |
