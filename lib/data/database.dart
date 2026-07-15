import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'database.g.dart';

List<AttributeDefinitionsCompanion> buildDefaultAttributeDefinitions() {
  return [
    AttributeDefinitionsCompanion.insert(attrKey: 'name', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'identity'),
    AttributeDefinitionsCompanion.insert(attrKey: 'alias', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'identity'),
    AttributeDefinitionsCompanion.insert(attrKey: 'species', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'identity'),
    AttributeDefinitionsCompanion.insert(attrKey: 'birth', appliesTo: 'character', valueType: 'date', mutable: Value(true), layer: 'identity'),
    AttributeDefinitionsCompanion.insert(attrKey: 'status', appliesTo: 'character', valueType: 'enum', mutable: Value(true), layer: 'narrative'),
    AttributeDefinitionsCompanion.insert(attrKey: 'location', appliesTo: 'character', valueType: 'entity_ref', mutable: Value(true), layer: 'narrative'),
    AttributeDefinitionsCompanion.insert(attrKey: 'arc', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'narrative'),
    AttributeDefinitionsCompanion.insert(attrKey: 'role', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'narrative'),
    AttributeDefinitionsCompanion.insert(attrKey: 'affiliation', appliesTo: 'character', valueType: 'entity_ref', mutable: Value(true), layer: 'narrative'),
    AttributeDefinitionsCompanion.insert(attrKey: 'production_status', appliesTo: 'character', valueType: 'enum', mutable: Value(true), layer: 'narrative'),
    AttributeDefinitionsCompanion.insert(attrKey: 'narrative_function', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'narrative'),
    AttributeDefinitionsCompanion.insert(attrKey: 'first_appearance', appliesTo: 'character', valueType: 'entity_ref', mutable: Value(false), layer: 'narrative'),
    AttributeDefinitionsCompanion.insert(attrKey: 'core_belief', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'internal_state'),
    AttributeDefinitionsCompanion.insert(attrKey: 'core_desire', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'internal_state'),
    AttributeDefinitionsCompanion.insert(attrKey: 'core_fear', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'internal_state'),
    AttributeDefinitionsCompanion.insert(attrKey: 'core_conflict', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'internal_state'),
    AttributeDefinitionsCompanion.insert(attrKey: 'decision_process', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'decision_model'),
    AttributeDefinitionsCompanion.insert(attrKey: 'never_does', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'decision_model'),
    AttributeDefinitionsCompanion.insert(attrKey: 'never_says', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'decision_model'),
    AttributeDefinitionsCompanion.insert(attrKey: 'never_admits', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'decision_model'),
    AttributeDefinitionsCompanion.insert(attrKey: 'known_secret', appliesTo: 'character', valueType: 'entity_ref', mutable: Value(true), layer: 'knowledge'),
    AttributeDefinitionsCompanion.insert(attrKey: 'hidden_secret', appliesTo: 'character', valueType: 'entity_ref', mutable: Value(true), layer: 'knowledge'),
    AttributeDefinitionsCompanion.insert(attrKey: 'false_assumption', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'knowledge'),
    AttributeDefinitionsCompanion.insert(attrKey: 'dialogue_style', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'expression'),
    AttributeDefinitionsCompanion.insert(attrKey: 'typical_behavior', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'expression'),
    AttributeDefinitionsCompanion.insert(attrKey: 'body_language', appliesTo: 'character', valueType: 'text', mutable: Value(true), layer: 'expression'),
    AttributeDefinitionsCompanion.insert(attrKey: 'trust_a_to_b', appliesTo: 'relationship', valueType: 'number', mutable: Value(true), layer: 'relationship'),
    AttributeDefinitionsCompanion.insert(attrKey: 'trust_b_to_a', appliesTo: 'relationship', valueType: 'number', mutable: Value(true), layer: 'relationship'),
    AttributeDefinitionsCompanion.insert(attrKey: 'respect_a_to_b', appliesTo: 'relationship', valueType: 'number', mutable: Value(true), layer: 'relationship'),
    AttributeDefinitionsCompanion.insert(attrKey: 'respect_b_to_a', appliesTo: 'relationship', valueType: 'number', mutable: Value(true), layer: 'relationship'),
    AttributeDefinitionsCompanion.insert(attrKey: 'open_question', appliesTo: 'reader', valueType: 'text', mutable: Value(true), layer: 'reader_knowledge'),
  ];
}

@DriftDatabase(tables: [Entities, AttributeDefinitions, Facts, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedAttributeDefinitions();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(settings);
            // 'birth' was seeded as free text before real-world dates
            // were wired up. Existing installs get corrected in place —
            // this is registry data, not a schema change.
            await (update(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('birth')))
                .write(const AttributeDefinitionsCompanion(
              valueType: Value('date'),
            ));
          }
          if (from < 3) {
            // 'current_location' / 'current_arc' implied live tracking
            // they never did — every attribute here is "latest known
            // Fact," not just these two. Renamed to drop the misleading
            // prefix. Registry row + every historical Fact both move.
            await (update(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('current_location')))
                .write(const AttributeDefinitionsCompanion(attrKey: Value('location')));
            await (update(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('current_arc')))
                .write(const AttributeDefinitionsCompanion(attrKey: Value('arc')));
            await (update(facts)..where((f) => f.attribute.equals('current_location')))
                .write(const FactsCompanion(attribute: Value('location')));
            await (update(facts)..where((f) => f.attribute.equals('current_arc')))
                .write(const FactsCompanion(attribute: Value('arc')));
          }
        },
      );

  // The full v0.1 Character field list, registered as data — not schema.
  Future<void> _seedAttributeDefinitions() async {
    final defs = buildDefaultAttributeDefinitions();
    await batch((b) => b.insertAll(attributeDefinitions, defs));
  }

  // ---- Entities ----

  Future<String> createEntity(String entityType, {String displayName = ''}) async {
    final id = const Uuid().v4();
    await into(entities).insert(
      EntitiesCompanion.insert(
        id: id,
        entityType: entityType,
        displayName: Value(displayName),
      ),
    );
    return id;
  }

  Future<void> renameEntity(String entityId, String displayName) async {
    await (update(entities)..where((e) => e.id.equals(entityId))).write(
      EntitiesCompanion(displayName: Value(displayName)),
    );
  }

  Stream<List<EntityRow>> watchEntitiesByType(String entityType) {
    return (select(entities)
          ..where((e) => e.entityType.equals(entityType))
          ..orderBy([(e) => OrderingTerm(expression: e.displayName)]))
        .watch();
  }

  Future<EntityRow?> getEntity(String id) {
    return (select(entities)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  /// Simple in-memory filter over entities of a given type. Fine at
  /// current data volumes; revisit with a real SQL LIKE query if lists
  /// grow large.
  Future<List<EntityRow>> searchEntities(String entityType, String query) async {
    final all = await (select(entities)
          ..where((e) => e.entityType.equals(entityType))
          ..orderBy([(e) => OrderingTerm(expression: e.displayName)]))
        .get();
    if (query.trim().isEmpty) return all;
    final needle = query.toLowerCase();
    return all.where((e) => e.displayName.toLowerCase().contains(needle)).toList();
  }

  // ---- Facts ----

  Future<String> writeFact({
    required String subjectId,
    required String attribute,
    required String value,
    String? storyTime,
    String? sceneId,
    String source = 'author_manual',
    String? supersedes,
  }) async {
    final id = const Uuid().v4();
    await into(facts).insert(
      FactsCompanion.insert(
        id: id,
        subjectId: subjectId,
        attribute: attribute,
        value: value,
        storyTime: Value(storyTime),
        sceneId: Value(sceneId),
        source: Value(source),
        supersedes: Value(supersedes),
      ),
    );
    return id;
  }

  /// Every fact ever written for a subject, newest first. The full,
  /// permanent, append-only log — use [currentAttributeValues] for the
  /// resolved read-time view.
  Future<List<FactRow>> factHistory(String subjectId) async {
    return (select(facts)
          ..where((f) => f.subjectId.equals(subjectId))
          ..orderBy([(f) => OrderingTerm.desc(f.authoringTime)]))
        .get();
  }

  /// The real current-state query: the most recent Fact per attribute
  /// for a subject, resolved by authoring time. Current state is never
  /// stored — it's always derived from the log at read time.
  ///
  /// Note: "most recent" currently means "most recently typed in," not
  /// "most recent in the story's internal chronology" — there's no
  /// story-time anchor to resolve against until Scenes/Events exist.
  /// This is the thing to revisit once Part 6/8 land.
  Future<Map<String, FactRow>> currentAttributeValues(String subjectId) async {
    final rows = await (select(facts)..where((f) => f.subjectId.equals(subjectId))).get();
    final byAttribute = <String, FactRow>{};
    for (final row in rows) {
      final existing = byAttribute[row.attribute];
      if (existing == null || row.authoringTime.isAfter(existing.authoringTime)) {
        byAttribute[row.attribute] = row;
      }
    }
    return byAttribute;
  }

  // ---- Settings (app preferences, not narrative data) ----

  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(settings).insertOnConflictUpdate(
      SettingsCompanion.insert(key: key, value: value),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nde.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
