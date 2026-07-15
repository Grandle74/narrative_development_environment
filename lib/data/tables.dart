import 'package:drift/drift.dart';

/// Any subject in the graph: a character, a relationship, the reader,
/// and eventually events, scenes, organizations, etc.
@DataClassName('EntityRow')
class Entities extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  // Denormalized cache for fast lists/search. The canonical value still
  // lives as a Fact (attribute: 'name') — this column is just a mirror
  // kept in sync on write, for read speed.
  TextColumn get displayName => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// The registry: what attributes exist, what they mean, what type they
/// hold. New attributes are new rows here, not new columns anywhere.
class AttributeDefinitions extends Table {
  TextColumn get attrKey => text()();
  TextColumn get appliesTo => text()(); // character | relationship | reader | ...
  // text | number | boolean | entity_ref | enum | date
  TextColumn get valueType => text()();
  BoolColumn get mutable => boolean().withDefault(const Constant(true))();
  TextColumn get layer => text()();

  @override
  Set<Column> get primaryKey => {attrKey};
}

/// A single timestamped assertion. Immutable once written — a correction
/// is a new row with `supersedes` set, never an edit in place.
@DataClassName('FactRow')
class Facts extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text()();
  TextColumn get attribute => text()();
  TextColumn get value => text()();
  TextColumn get storyTime => text().nullable()();
  TextColumn get sceneId => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('author_manual'))();
  BoolColumn get aiAssistedPhrasing => boolean().nullable()();
  DateTimeColumn get authoringTime => dateTime().withDefault(currentDateAndTime)();
  TextColumn get supersedes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Small generic key-value store for app-level preferences that aren't
/// part of the narrative data model (theme mode, UI state, etc). Kept in
/// the same local SQLite file so there's no second storage mechanism to
/// manage.
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
