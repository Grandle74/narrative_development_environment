import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Entities, AttributeDefinitions, Facts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedAttributeDefinitions();
        },
      );

  // The full v0.1 Character field list, registered as data — not schema.
  Future<void> _seedAttributeDefinitions() async {
    final defs = <AttributeDefinitionsCompanion>[
      _def('name', 'character', 'text', false, 'identity'),
      _def('alias', 'character', 'text', false, 'identity'),
      _def('species', 'character', 'text', false, 'identity'),
      _def('birth', 'character', 'text', false, 'identity'),
      _def('status', 'character', 'enum', true, 'narrative'),
      _def('current_location', 'character', 'entity_ref', true, 'narrative'),
      _def('current_arc', 'character', 'text', true, 'narrative'),
      _def('role', 'character', 'text', true, 'narrative'),
      _def('affiliation', 'character', 'entity_ref', true, 'narrative'),
      _def('production_status', 'character', 'enum', true, 'narrative'),
      _def('narrative_function', 'character', 'text', true, 'narrative'),
      _def('first_appearance', 'character', 'entity_ref', false, 'narrative'),
      _def('core_belief', 'character', 'text', true, 'internal_state'),
      _def('core_desire', 'character', 'text', true, 'internal_state'),
      _def('core_fear', 'character', 'text', true, 'internal_state'),
      _def('core_conflict', 'character', 'text', true, 'internal_state'),
      _def('decision_process', 'character', 'text', true, 'decision_model'),
      _def('never_does', 'character', 'text', true, 'decision_model'),
      _def('never_says', 'character', 'text', true, 'decision_model'),
      _def('never_admits', 'character', 'text', true, 'decision_model'),
      _def('known_secret', 'character', 'entity_ref', true, 'knowledge'),
      _def('hidden_secret', 'character', 'entity_ref', true, 'knowledge'),
      _def('false_assumption', 'character', 'text', true, 'knowledge'),
      _def('dialogue_style', 'character', 'text', true, 'expression'),
      _def('typical_behavior', 'character', 'text', true, 'expression'),
      _def('body_language', 'character', 'text', true, 'expression'),
      _def('trust_a_to_b', 'relationship', 'number', true, 'relationship'),
      _def('trust_b_to_a', 'relationship', 'number', true, 'relationship'),
      _def('respect_a_to_b', 'relationship', 'number', true, 'relationship'),
      _def('respect_b_to_a', 'relationship', 'number', true, 'relationship'),
      _def('open_question', 'reader', 'text', true, 'reader_knowledge'),
    ];
    await batch((b) => b.insertAll(attributeDefinitions, defs));
  }

  AttributeDefinitionsCompanion _def(
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

  // Every fact ever written for a subject. "Latest per attribute"
  // resolution (the real current-state query) lands in Part 2, once
  // there's more than one fact per attribute to resolve between.
  Future<List<FactRow>> currentFacts(String subjectId) async {
    return (select(facts)..where((f) => f.subjectId.equals(subjectId))).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nde.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
