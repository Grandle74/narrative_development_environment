import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'database.g.dart';

List<AttributeDefinitionsCompanion> buildDefaultAttributeDefinitions() {
  return <AttributeDefinitionsCompanion>[
    _attributeDefinitionCompanion('name', 'character', 'text', true, 'identity'),
    _attributeDefinitionCompanion('alias', 'character', 'tag_list', true, 'identity'),
    _attributeDefinitionCompanion('species', 'character', 'enum', true, 'identity'),
    _attributeDefinitionCompanion('birth', 'character', 'date', true, 'identity'),
    _attributeDefinitionCompanion('nationality', 'character', 'enum', true, 'identity'),
    // Powers: one main power (the big button) plus up to 8 stone-granted
    // powers (the small glowing slots). Every slot is a free-standing
    // registry row so adding a 9th stone later is just another row.
    _attributeDefinitionCompanion('main_power', 'character', 'enum', true, 'powers'),
    for (var i = 1; i <= 8; i++)
      _attributeDefinitionCompanion('stone_${i}_power', 'character', 'enum', true, 'powers'),
    _attributeDefinitionCompanion('current_arc', 'character', 'tag_list', true, 'narrative'),
    _attributeDefinitionCompanion('role', 'character', 'tag_list', true, 'narrative'),
    _attributeDefinitionCompanion('affiliation', 'character', 'tag_list', true, 'narrative'),
    _attributeDefinitionCompanion('production_status', 'character', 'enum', true, 'narrative'),
    _attributeDefinitionCompanion('narrative_purpose', 'character', 'tag_list', true, 'narrative'),
    _attributeDefinitionCompanion('first_appearance_volume', 'character', 'number', false, 'narrative'),
    _attributeDefinitionCompanion('first_appearance_chapter', 'character', 'number', false, 'narrative'),
    _attributeDefinitionCompanion('core_belief', 'character', 'text', true, 'internal_state'),
    _attributeDefinitionCompanion('core_desire', 'character', 'text', true, 'internal_state'),
    _attributeDefinitionCompanion('core_fear', 'character', 'text', true, 'internal_state'),
    _attributeDefinitionCompanion('core_conflict', 'character', 'text', true, 'internal_state'),
    _attributeDefinitionCompanion('decision_process', 'character', 'text', true, 'decision_model'),
    _attributeDefinitionCompanion('never_does', 'character', 'text', true, 'decision_model'),
    _attributeDefinitionCompanion('never_says', 'character', 'text', true, 'decision_model'),
    _attributeDefinitionCompanion('never_admits', 'character', 'text', true, 'decision_model'),
    _attributeDefinitionCompanion('known_secret', 'character', 'entity_ref', true, 'knowledge'),
    _attributeDefinitionCompanion('hidden_secret', 'character', 'entity_ref', true, 'knowledge'),
    _attributeDefinitionCompanion('false_assumption', 'character', 'text', true, 'knowledge'),
    _attributeDefinitionCompanion('dialogue_style', 'character', 'text', true, 'expression'),
    _attributeDefinitionCompanion('typical_behavior', 'character', 'text', true, 'expression'),
    _attributeDefinitionCompanion('body_language', 'character', 'text', true, 'expression'),
    _attributeDefinitionCompanion('trust_a_to_b', 'relationship', 'number', true, 'relationship'),
    _attributeDefinitionCompanion('trust_b_to_a', 'relationship', 'number', true, 'relationship'),
    _attributeDefinitionCompanion('respect_a_to_b', 'relationship', 'number', true, 'relationship'),
    _attributeDefinitionCompanion('respect_b_to_a', 'relationship', 'number', true, 'relationship'),
    _attributeDefinitionCompanion('open_question', 'reader', 'text', true, 'reader_knowledge'),
  ];
}

AttributeDefinitionsCompanion _attributeDefinitionCompanion(
  String key,
  String appliesTo,
  String valueType,
  bool mutable,
  String layer,
) {
  return AttributeDefinitionsCompanion.insert(
    attrKey: key,
    appliesTo: appliesTo,
    valueType: valueType,
    mutable: Value(mutable),
    layer: layer,
  );
}

@DriftDatabase(tables: [Entities, AttributeDefinitions, Facts, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

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
            for (final attrKey in ['name', 'alias', 'species', 'birth']) {
              await (update(attributeDefinitions)
                    ..where((a) => a.attrKey.equals(attrKey)))
                  .write(const AttributeDefinitionsCompanion(
                mutable: Value(true),
              ));
            }
          }
          if (from < 4) {
            // Status changes constantly through the story and never held
            // still long enough to be one field — dropped. Any Facts
            // already logged for it stay in the permanent log untouched;
            // they just no longer surface as a form field.
            await (delete(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('status')))
                .go();

            // Narrative Function asked for an abstract label up front.
            // Narrative Purpose replaces it as a tag field, so notes can
            // be jotted down as they occur to you instead of needing one
            // tidy answer.
            await (delete(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('narrative_function')))
                .go();
            await into(attributeDefinitions).insert(
              _attributeDefinitionCompanion(
                  'narrative_purpose', 'character', 'tag_list', true, 'narrative'),
            );

            // Species becomes a fixed set of options instead of free text.
            await (update(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('species')))
                .write(const AttributeDefinitionsCompanion(
              valueType: Value('enum'),
            ));

            // Arc and Role become tag lists instead of comma-separated text.
            await (update(attributeDefinitions)
                  ..where((a) => a.attrKey.isIn(['current_arc', 'role'])))
                .write(const AttributeDefinitionsCompanion(
              valueType: Value('tag_list'),
            ));

            // First appearance splits into chapter + page.
            await (delete(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('first_appearance')))
                .go();
            await batch((b) => b.insertAll(attributeDefinitions, [
                  _attributeDefinitionCompanion(
                      'first_appearance_chapter', 'character', 'number', false, 'narrative'),
                  _attributeDefinitionCompanion(
                      'first_appearance_page', 'character', 'number', false, 'narrative'),
                ]));

            // Powers: one main power + 8 stone-granted powers.
            await batch((b) => b.insertAll(attributeDefinitions, [
                  _attributeDefinitionCompanion('main_power', 'character', 'enum', true, 'powers'),
                  for (var i = 1; i <= 8; i++)
                    _attributeDefinitionCompanion(
                        'stone_${i}_power', 'character', 'enum', true, 'powers'),
                ]));
          }
          if (from < 5) {
            await (delete(attributeDefinitions)
                  ..where((a) => a.attrKey.isIn(['current_location', 'first_appearance_page']))
                )
                .go();
            await (delete(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('first_appearance_chapter')))
                .go();
            await (update(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('alias')))
                .write(const AttributeDefinitionsCompanion(
              valueType: Value('tag_list'),
            ));
            await (update(attributeDefinitions)
                  ..where((a) => a.attrKey.equals('affiliation')))
                .write(const AttributeDefinitionsCompanion(
              valueType: Value('tag_list'),
            ));
            await batch((b) => b.insertAll(attributeDefinitions, [
                  _attributeDefinitionCompanion('nationality', 'character', 'enum', true, 'identity'),
                  _attributeDefinitionCompanion(
                      'first_appearance_volume', 'character', 'number', false, 'narrative'),
                  _attributeDefinitionCompanion(
                      'first_appearance_chapter', 'character', 'number', false, 'narrative'),
                ]));
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
