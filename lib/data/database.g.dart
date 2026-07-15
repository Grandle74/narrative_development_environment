// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EntitiesTable extends Entities
    with TableInfo<$EntitiesTable, EntityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    displayName,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entities';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EntitiesTable createAlias(String alias) {
    return $EntitiesTable(attachedDatabase, alias);
  }
}

class EntityRow extends DataClass implements Insertable<EntityRow> {
  final String id;
  final String entityType;
  final String displayName;
  final DateTime createdAt;
  const EntityRow({
    required this.id,
    required this.entityType,
    required this.displayName,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['display_name'] = Variable<String>(displayName);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EntitiesCompanion toCompanion(bool nullToAbsent) {
    return EntitiesCompanion(
      id: Value(id),
      entityType: Value(entityType),
      displayName: Value(displayName),
      createdAt: Value(createdAt),
    );
  }

  factory EntityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityRow(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      displayName: serializer.fromJson<String>(json['displayName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'displayName': serializer.toJson<String>(displayName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EntityRow copyWith({
    String? id,
    String? entityType,
    String? displayName,
    DateTime? createdAt,
  }) => EntityRow(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    displayName: displayName ?? this.displayName,
    createdAt: createdAt ?? this.createdAt,
  );
  EntityRow copyWithCompanion(EntitiesCompanion data) {
    return EntityRow(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityRow(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, displayName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityRow &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.displayName == this.displayName &&
          other.createdAt == this.createdAt);
}

class EntitiesCompanion extends UpdateCompanion<EntityRow> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> displayName;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EntitiesCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitiesCompanion.insert({
    required String id,
    required String entityType,
    this.displayName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType);
  static Insertable<EntityRow> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? displayName,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (displayName != null) 'display_name': displayName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? displayName,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EntitiesCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('displayName: $displayName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttributeDefinitionsTable extends AttributeDefinitions
    with TableInfo<$AttributeDefinitionsTable, AttributeDefinition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttributeDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _attrKeyMeta = const VerificationMeta(
    'attrKey',
  );
  @override
  late final GeneratedColumn<String> attrKey = GeneratedColumn<String>(
    'attr_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appliesToMeta = const VerificationMeta(
    'appliesTo',
  );
  @override
  late final GeneratedColumn<String> appliesTo = GeneratedColumn<String>(
    'applies_to',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mutableMeta = const VerificationMeta(
    'mutable',
  );
  @override
  late final GeneratedColumn<bool> mutable = GeneratedColumn<bool>(
    'mutable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mutable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _layerMeta = const VerificationMeta('layer');
  @override
  late final GeneratedColumn<String> layer = GeneratedColumn<String>(
    'layer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    attrKey,
    appliesTo,
    valueType,
    mutable,
    layer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attribute_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttributeDefinition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('attr_key')) {
      context.handle(
        _attrKeyMeta,
        attrKey.isAcceptableOrUnknown(data['attr_key']!, _attrKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_attrKeyMeta);
    }
    if (data.containsKey('applies_to')) {
      context.handle(
        _appliesToMeta,
        appliesTo.isAcceptableOrUnknown(data['applies_to']!, _appliesToMeta),
      );
    } else if (isInserting) {
      context.missing(_appliesToMeta);
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_valueTypeMeta);
    }
    if (data.containsKey('mutable')) {
      context.handle(
        _mutableMeta,
        mutable.isAcceptableOrUnknown(data['mutable']!, _mutableMeta),
      );
    }
    if (data.containsKey('layer')) {
      context.handle(
        _layerMeta,
        layer.isAcceptableOrUnknown(data['layer']!, _layerMeta),
      );
    } else if (isInserting) {
      context.missing(_layerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attrKey};
  @override
  AttributeDefinition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttributeDefinition(
      attrKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attr_key'],
      )!,
      appliesTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}applies_to'],
      )!,
      valueType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_type'],
      )!,
      mutable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mutable'],
      )!,
      layer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layer'],
      )!,
    );
  }

  @override
  $AttributeDefinitionsTable createAlias(String alias) {
    return $AttributeDefinitionsTable(attachedDatabase, alias);
  }
}

class AttributeDefinition extends DataClass
    implements Insertable<AttributeDefinition> {
  final String attrKey;
  final String appliesTo;
  final String valueType;
  final bool mutable;
  final String layer;
  const AttributeDefinition({
    required this.attrKey,
    required this.appliesTo,
    required this.valueType,
    required this.mutable,
    required this.layer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attr_key'] = Variable<String>(attrKey);
    map['applies_to'] = Variable<String>(appliesTo);
    map['value_type'] = Variable<String>(valueType);
    map['mutable'] = Variable<bool>(mutable);
    map['layer'] = Variable<String>(layer);
    return map;
  }

  AttributeDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return AttributeDefinitionsCompanion(
      attrKey: Value(attrKey),
      appliesTo: Value(appliesTo),
      valueType: Value(valueType),
      mutable: Value(mutable),
      layer: Value(layer),
    );
  }

  factory AttributeDefinition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttributeDefinition(
      attrKey: serializer.fromJson<String>(json['attrKey']),
      appliesTo: serializer.fromJson<String>(json['appliesTo']),
      valueType: serializer.fromJson<String>(json['valueType']),
      mutable: serializer.fromJson<bool>(json['mutable']),
      layer: serializer.fromJson<String>(json['layer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attrKey': serializer.toJson<String>(attrKey),
      'appliesTo': serializer.toJson<String>(appliesTo),
      'valueType': serializer.toJson<String>(valueType),
      'mutable': serializer.toJson<bool>(mutable),
      'layer': serializer.toJson<String>(layer),
    };
  }

  AttributeDefinition copyWith({
    String? attrKey,
    String? appliesTo,
    String? valueType,
    bool? mutable,
    String? layer,
  }) => AttributeDefinition(
    attrKey: attrKey ?? this.attrKey,
    appliesTo: appliesTo ?? this.appliesTo,
    valueType: valueType ?? this.valueType,
    mutable: mutable ?? this.mutable,
    layer: layer ?? this.layer,
  );
  AttributeDefinition copyWithCompanion(AttributeDefinitionsCompanion data) {
    return AttributeDefinition(
      attrKey: data.attrKey.present ? data.attrKey.value : this.attrKey,
      appliesTo: data.appliesTo.present ? data.appliesTo.value : this.appliesTo,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      mutable: data.mutable.present ? data.mutable.value : this.mutable,
      layer: data.layer.present ? data.layer.value : this.layer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttributeDefinition(')
          ..write('attrKey: $attrKey, ')
          ..write('appliesTo: $appliesTo, ')
          ..write('valueType: $valueType, ')
          ..write('mutable: $mutable, ')
          ..write('layer: $layer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(attrKey, appliesTo, valueType, mutable, layer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttributeDefinition &&
          other.attrKey == this.attrKey &&
          other.appliesTo == this.appliesTo &&
          other.valueType == this.valueType &&
          other.mutable == this.mutable &&
          other.layer == this.layer);
}

class AttributeDefinitionsCompanion
    extends UpdateCompanion<AttributeDefinition> {
  final Value<String> attrKey;
  final Value<String> appliesTo;
  final Value<String> valueType;
  final Value<bool> mutable;
  final Value<String> layer;
  final Value<int> rowid;
  const AttributeDefinitionsCompanion({
    this.attrKey = const Value.absent(),
    this.appliesTo = const Value.absent(),
    this.valueType = const Value.absent(),
    this.mutable = const Value.absent(),
    this.layer = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttributeDefinitionsCompanion.insert({
    required String attrKey,
    required String appliesTo,
    required String valueType,
    this.mutable = const Value.absent(),
    required String layer,
    this.rowid = const Value.absent(),
  }) : attrKey = Value(attrKey),
       appliesTo = Value(appliesTo),
       valueType = Value(valueType),
       layer = Value(layer);
  static Insertable<AttributeDefinition> custom({
    Expression<String>? attrKey,
    Expression<String>? appliesTo,
    Expression<String>? valueType,
    Expression<bool>? mutable,
    Expression<String>? layer,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attrKey != null) 'attr_key': attrKey,
      if (appliesTo != null) 'applies_to': appliesTo,
      if (valueType != null) 'value_type': valueType,
      if (mutable != null) 'mutable': mutable,
      if (layer != null) 'layer': layer,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttributeDefinitionsCompanion copyWith({
    Value<String>? attrKey,
    Value<String>? appliesTo,
    Value<String>? valueType,
    Value<bool>? mutable,
    Value<String>? layer,
    Value<int>? rowid,
  }) {
    return AttributeDefinitionsCompanion(
      attrKey: attrKey ?? this.attrKey,
      appliesTo: appliesTo ?? this.appliesTo,
      valueType: valueType ?? this.valueType,
      mutable: mutable ?? this.mutable,
      layer: layer ?? this.layer,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attrKey.present) {
      map['attr_key'] = Variable<String>(attrKey.value);
    }
    if (appliesTo.present) {
      map['applies_to'] = Variable<String>(appliesTo.value);
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (mutable.present) {
      map['mutable'] = Variable<bool>(mutable.value);
    }
    if (layer.present) {
      map['layer'] = Variable<String>(layer.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttributeDefinitionsCompanion(')
          ..write('attrKey: $attrKey, ')
          ..write('appliesTo: $appliesTo, ')
          ..write('valueType: $valueType, ')
          ..write('mutable: $mutable, ')
          ..write('layer: $layer, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FactsTable extends Facts with TableInfo<$FactsTable, FactRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attributeMeta = const VerificationMeta(
    'attribute',
  );
  @override
  late final GeneratedColumn<String> attribute = GeneratedColumn<String>(
    'attribute',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storyTimeMeta = const VerificationMeta(
    'storyTime',
  );
  @override
  late final GeneratedColumn<String> storyTime = GeneratedColumn<String>(
    'story_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sceneIdMeta = const VerificationMeta(
    'sceneId',
  );
  @override
  late final GeneratedColumn<String> sceneId = GeneratedColumn<String>(
    'scene_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('author_manual'),
  );
  static const VerificationMeta _aiAssistedPhrasingMeta =
      const VerificationMeta('aiAssistedPhrasing');
  @override
  late final GeneratedColumn<bool> aiAssistedPhrasing = GeneratedColumn<bool>(
    'ai_assisted_phrasing',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ai_assisted_phrasing" IN (0, 1))',
    ),
  );
  static const VerificationMeta _authoringTimeMeta = const VerificationMeta(
    'authoringTime',
  );
  @override
  late final GeneratedColumn<DateTime> authoringTime =
      GeneratedColumn<DateTime>(
        'authoring_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _supersedesMeta = const VerificationMeta(
    'supersedes',
  );
  @override
  late final GeneratedColumn<String> supersedes = GeneratedColumn<String>(
    'supersedes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    attribute,
    value,
    storyTime,
    sceneId,
    source,
    aiAssistedPhrasing,
    authoringTime,
    supersedes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'facts';
  @override
  VerificationContext validateIntegrity(
    Insertable<FactRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('attribute')) {
      context.handle(
        _attributeMeta,
        attribute.isAcceptableOrUnknown(data['attribute']!, _attributeMeta),
      );
    } else if (isInserting) {
      context.missing(_attributeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('story_time')) {
      context.handle(
        _storyTimeMeta,
        storyTime.isAcceptableOrUnknown(data['story_time']!, _storyTimeMeta),
      );
    }
    if (data.containsKey('scene_id')) {
      context.handle(
        _sceneIdMeta,
        sceneId.isAcceptableOrUnknown(data['scene_id']!, _sceneIdMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('ai_assisted_phrasing')) {
      context.handle(
        _aiAssistedPhrasingMeta,
        aiAssistedPhrasing.isAcceptableOrUnknown(
          data['ai_assisted_phrasing']!,
          _aiAssistedPhrasingMeta,
        ),
      );
    }
    if (data.containsKey('authoring_time')) {
      context.handle(
        _authoringTimeMeta,
        authoringTime.isAcceptableOrUnknown(
          data['authoring_time']!,
          _authoringTimeMeta,
        ),
      );
    }
    if (data.containsKey('supersedes')) {
      context.handle(
        _supersedesMeta,
        supersedes.isAcceptableOrUnknown(data['supersedes']!, _supersedesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FactRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FactRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      attribute: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attribute'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      storyTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_time'],
      ),
      sceneId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scene_id'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      aiAssistedPhrasing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ai_assisted_phrasing'],
      ),
      authoringTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}authoring_time'],
      )!,
      supersedes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supersedes'],
      ),
    );
  }

  @override
  $FactsTable createAlias(String alias) {
    return $FactsTable(attachedDatabase, alias);
  }
}

class FactRow extends DataClass implements Insertable<FactRow> {
  final String id;
  final String subjectId;
  final String attribute;
  final String value;
  final String? storyTime;
  final String? sceneId;
  final String source;
  final bool? aiAssistedPhrasing;
  final DateTime authoringTime;
  final String? supersedes;
  const FactRow({
    required this.id,
    required this.subjectId,
    required this.attribute,
    required this.value,
    this.storyTime,
    this.sceneId,
    required this.source,
    this.aiAssistedPhrasing,
    required this.authoringTime,
    this.supersedes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['attribute'] = Variable<String>(attribute);
    map['value'] = Variable<String>(value);
    if (!nullToAbsent || storyTime != null) {
      map['story_time'] = Variable<String>(storyTime);
    }
    if (!nullToAbsent || sceneId != null) {
      map['scene_id'] = Variable<String>(sceneId);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || aiAssistedPhrasing != null) {
      map['ai_assisted_phrasing'] = Variable<bool>(aiAssistedPhrasing);
    }
    map['authoring_time'] = Variable<DateTime>(authoringTime);
    if (!nullToAbsent || supersedes != null) {
      map['supersedes'] = Variable<String>(supersedes);
    }
    return map;
  }

  FactsCompanion toCompanion(bool nullToAbsent) {
    return FactsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      attribute: Value(attribute),
      value: Value(value),
      storyTime: storyTime == null && nullToAbsent
          ? const Value.absent()
          : Value(storyTime),
      sceneId: sceneId == null && nullToAbsent
          ? const Value.absent()
          : Value(sceneId),
      source: Value(source),
      aiAssistedPhrasing: aiAssistedPhrasing == null && nullToAbsent
          ? const Value.absent()
          : Value(aiAssistedPhrasing),
      authoringTime: Value(authoringTime),
      supersedes: supersedes == null && nullToAbsent
          ? const Value.absent()
          : Value(supersedes),
    );
  }

  factory FactRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FactRow(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      attribute: serializer.fromJson<String>(json['attribute']),
      value: serializer.fromJson<String>(json['value']),
      storyTime: serializer.fromJson<String?>(json['storyTime']),
      sceneId: serializer.fromJson<String?>(json['sceneId']),
      source: serializer.fromJson<String>(json['source']),
      aiAssistedPhrasing: serializer.fromJson<bool?>(
        json['aiAssistedPhrasing'],
      ),
      authoringTime: serializer.fromJson<DateTime>(json['authoringTime']),
      supersedes: serializer.fromJson<String?>(json['supersedes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'attribute': serializer.toJson<String>(attribute),
      'value': serializer.toJson<String>(value),
      'storyTime': serializer.toJson<String?>(storyTime),
      'sceneId': serializer.toJson<String?>(sceneId),
      'source': serializer.toJson<String>(source),
      'aiAssistedPhrasing': serializer.toJson<bool?>(aiAssistedPhrasing),
      'authoringTime': serializer.toJson<DateTime>(authoringTime),
      'supersedes': serializer.toJson<String?>(supersedes),
    };
  }

  FactRow copyWith({
    String? id,
    String? subjectId,
    String? attribute,
    String? value,
    Value<String?> storyTime = const Value.absent(),
    Value<String?> sceneId = const Value.absent(),
    String? source,
    Value<bool?> aiAssistedPhrasing = const Value.absent(),
    DateTime? authoringTime,
    Value<String?> supersedes = const Value.absent(),
  }) => FactRow(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    attribute: attribute ?? this.attribute,
    value: value ?? this.value,
    storyTime: storyTime.present ? storyTime.value : this.storyTime,
    sceneId: sceneId.present ? sceneId.value : this.sceneId,
    source: source ?? this.source,
    aiAssistedPhrasing: aiAssistedPhrasing.present
        ? aiAssistedPhrasing.value
        : this.aiAssistedPhrasing,
    authoringTime: authoringTime ?? this.authoringTime,
    supersedes: supersedes.present ? supersedes.value : this.supersedes,
  );
  FactRow copyWithCompanion(FactsCompanion data) {
    return FactRow(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      attribute: data.attribute.present ? data.attribute.value : this.attribute,
      value: data.value.present ? data.value.value : this.value,
      storyTime: data.storyTime.present ? data.storyTime.value : this.storyTime,
      sceneId: data.sceneId.present ? data.sceneId.value : this.sceneId,
      source: data.source.present ? data.source.value : this.source,
      aiAssistedPhrasing: data.aiAssistedPhrasing.present
          ? data.aiAssistedPhrasing.value
          : this.aiAssistedPhrasing,
      authoringTime: data.authoringTime.present
          ? data.authoringTime.value
          : this.authoringTime,
      supersedes: data.supersedes.present
          ? data.supersedes.value
          : this.supersedes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FactRow(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('attribute: $attribute, ')
          ..write('value: $value, ')
          ..write('storyTime: $storyTime, ')
          ..write('sceneId: $sceneId, ')
          ..write('source: $source, ')
          ..write('aiAssistedPhrasing: $aiAssistedPhrasing, ')
          ..write('authoringTime: $authoringTime, ')
          ..write('supersedes: $supersedes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    attribute,
    value,
    storyTime,
    sceneId,
    source,
    aiAssistedPhrasing,
    authoringTime,
    supersedes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FactRow &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.attribute == this.attribute &&
          other.value == this.value &&
          other.storyTime == this.storyTime &&
          other.sceneId == this.sceneId &&
          other.source == this.source &&
          other.aiAssistedPhrasing == this.aiAssistedPhrasing &&
          other.authoringTime == this.authoringTime &&
          other.supersedes == this.supersedes);
}

class FactsCompanion extends UpdateCompanion<FactRow> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> attribute;
  final Value<String> value;
  final Value<String?> storyTime;
  final Value<String?> sceneId;
  final Value<String> source;
  final Value<bool?> aiAssistedPhrasing;
  final Value<DateTime> authoringTime;
  final Value<String?> supersedes;
  final Value<int> rowid;
  const FactsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.attribute = const Value.absent(),
    this.value = const Value.absent(),
    this.storyTime = const Value.absent(),
    this.sceneId = const Value.absent(),
    this.source = const Value.absent(),
    this.aiAssistedPhrasing = const Value.absent(),
    this.authoringTime = const Value.absent(),
    this.supersedes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FactsCompanion.insert({
    required String id,
    required String subjectId,
    required String attribute,
    required String value,
    this.storyTime = const Value.absent(),
    this.sceneId = const Value.absent(),
    this.source = const Value.absent(),
    this.aiAssistedPhrasing = const Value.absent(),
    this.authoringTime = const Value.absent(),
    this.supersedes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       attribute = Value(attribute),
       value = Value(value);
  static Insertable<FactRow> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? attribute,
    Expression<String>? value,
    Expression<String>? storyTime,
    Expression<String>? sceneId,
    Expression<String>? source,
    Expression<bool>? aiAssistedPhrasing,
    Expression<DateTime>? authoringTime,
    Expression<String>? supersedes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (attribute != null) 'attribute': attribute,
      if (value != null) 'value': value,
      if (storyTime != null) 'story_time': storyTime,
      if (sceneId != null) 'scene_id': sceneId,
      if (source != null) 'source': source,
      if (aiAssistedPhrasing != null)
        'ai_assisted_phrasing': aiAssistedPhrasing,
      if (authoringTime != null) 'authoring_time': authoringTime,
      if (supersedes != null) 'supersedes': supersedes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FactsCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<String>? attribute,
    Value<String>? value,
    Value<String?>? storyTime,
    Value<String?>? sceneId,
    Value<String>? source,
    Value<bool?>? aiAssistedPhrasing,
    Value<DateTime>? authoringTime,
    Value<String?>? supersedes,
    Value<int>? rowid,
  }) {
    return FactsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      attribute: attribute ?? this.attribute,
      value: value ?? this.value,
      storyTime: storyTime ?? this.storyTime,
      sceneId: sceneId ?? this.sceneId,
      source: source ?? this.source,
      aiAssistedPhrasing: aiAssistedPhrasing ?? this.aiAssistedPhrasing,
      authoringTime: authoringTime ?? this.authoringTime,
      supersedes: supersedes ?? this.supersedes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (attribute.present) {
      map['attribute'] = Variable<String>(attribute.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (storyTime.present) {
      map['story_time'] = Variable<String>(storyTime.value);
    }
    if (sceneId.present) {
      map['scene_id'] = Variable<String>(sceneId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (aiAssistedPhrasing.present) {
      map['ai_assisted_phrasing'] = Variable<bool>(aiAssistedPhrasing.value);
    }
    if (authoringTime.present) {
      map['authoring_time'] = Variable<DateTime>(authoringTime.value);
    }
    if (supersedes.present) {
      map['supersedes'] = Variable<String>(supersedes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FactsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('attribute: $attribute, ')
          ..write('value: $value, ')
          ..write('storyTime: $storyTime, ')
          ..write('sceneId: $sceneId, ')
          ..write('source: $source, ')
          ..write('aiAssistedPhrasing: $aiAssistedPhrasing, ')
          ..write('authoringTime: $authoringTime, ')
          ..write('supersedes: $supersedes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EntitiesTable entities = $EntitiesTable(this);
  late final $AttributeDefinitionsTable attributeDefinitions =
      $AttributeDefinitionsTable(this);
  late final $FactsTable facts = $FactsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    entities,
    attributeDefinitions,
    facts,
    settings,
  ];
}

typedef $$EntitiesTableCreateCompanionBuilder =
    EntitiesCompanion Function({
      required String id,
      required String entityType,
      Value<String> displayName,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$EntitiesTableUpdateCompanionBuilder =
    EntitiesCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> displayName,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$EntitiesTableFilterComposer
    extends Composer<_$AppDatabase, $EntitiesTable> {
  $$EntitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EntitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntitiesTable> {
  $$EntitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EntitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntitiesTable> {
  $$EntitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EntitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntitiesTable,
          EntityRow,
          $$EntitiesTableFilterComposer,
          $$EntitiesTableOrderingComposer,
          $$EntitiesTableAnnotationComposer,
          $$EntitiesTableCreateCompanionBuilder,
          $$EntitiesTableUpdateCompanionBuilder,
          (EntityRow, BaseReferences<_$AppDatabase, $EntitiesTable, EntityRow>),
          EntityRow,
          PrefetchHooks Function()
        > {
  $$EntitiesTableTableManager(_$AppDatabase db, $EntitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitiesCompanion(
                id: id,
                entityType: entityType,
                displayName: displayName,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                Value<String> displayName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntitiesCompanion.insert(
                id: id,
                entityType: entityType,
                displayName: displayName,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EntitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntitiesTable,
      EntityRow,
      $$EntitiesTableFilterComposer,
      $$EntitiesTableOrderingComposer,
      $$EntitiesTableAnnotationComposer,
      $$EntitiesTableCreateCompanionBuilder,
      $$EntitiesTableUpdateCompanionBuilder,
      (EntityRow, BaseReferences<_$AppDatabase, $EntitiesTable, EntityRow>),
      EntityRow,
      PrefetchHooks Function()
    >;
typedef $$AttributeDefinitionsTableCreateCompanionBuilder =
    AttributeDefinitionsCompanion Function({
      required String attrKey,
      required String appliesTo,
      required String valueType,
      Value<bool> mutable,
      required String layer,
      Value<int> rowid,
    });
typedef $$AttributeDefinitionsTableUpdateCompanionBuilder =
    AttributeDefinitionsCompanion Function({
      Value<String> attrKey,
      Value<String> appliesTo,
      Value<String> valueType,
      Value<bool> mutable,
      Value<String> layer,
      Value<int> rowid,
    });

class $$AttributeDefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $AttributeDefinitionsTable> {
  $$AttributeDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get attrKey => $composableBuilder(
    column: $table.attrKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appliesTo => $composableBuilder(
    column: $table.appliesTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mutable => $composableBuilder(
    column: $table.mutable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layer => $composableBuilder(
    column: $table.layer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttributeDefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $AttributeDefinitionsTable> {
  $$AttributeDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get attrKey => $composableBuilder(
    column: $table.attrKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appliesTo => $composableBuilder(
    column: $table.appliesTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mutable => $composableBuilder(
    column: $table.mutable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layer => $composableBuilder(
    column: $table.layer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttributeDefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttributeDefinitionsTable> {
  $$AttributeDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get attrKey =>
      $composableBuilder(column: $table.attrKey, builder: (column) => column);

  GeneratedColumn<String> get appliesTo =>
      $composableBuilder(column: $table.appliesTo, builder: (column) => column);

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<bool> get mutable =>
      $composableBuilder(column: $table.mutable, builder: (column) => column);

  GeneratedColumn<String> get layer =>
      $composableBuilder(column: $table.layer, builder: (column) => column);
}

class $$AttributeDefinitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttributeDefinitionsTable,
          AttributeDefinition,
          $$AttributeDefinitionsTableFilterComposer,
          $$AttributeDefinitionsTableOrderingComposer,
          $$AttributeDefinitionsTableAnnotationComposer,
          $$AttributeDefinitionsTableCreateCompanionBuilder,
          $$AttributeDefinitionsTableUpdateCompanionBuilder,
          (
            AttributeDefinition,
            BaseReferences<
              _$AppDatabase,
              $AttributeDefinitionsTable,
              AttributeDefinition
            >,
          ),
          AttributeDefinition,
          PrefetchHooks Function()
        > {
  $$AttributeDefinitionsTableTableManager(
    _$AppDatabase db,
    $AttributeDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttributeDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttributeDefinitionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AttributeDefinitionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> attrKey = const Value.absent(),
                Value<String> appliesTo = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<bool> mutable = const Value.absent(),
                Value<String> layer = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttributeDefinitionsCompanion(
                attrKey: attrKey,
                appliesTo: appliesTo,
                valueType: valueType,
                mutable: mutable,
                layer: layer,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String attrKey,
                required String appliesTo,
                required String valueType,
                Value<bool> mutable = const Value.absent(),
                required String layer,
                Value<int> rowid = const Value.absent(),
              }) => AttributeDefinitionsCompanion.insert(
                attrKey: attrKey,
                appliesTo: appliesTo,
                valueType: valueType,
                mutable: mutable,
                layer: layer,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttributeDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttributeDefinitionsTable,
      AttributeDefinition,
      $$AttributeDefinitionsTableFilterComposer,
      $$AttributeDefinitionsTableOrderingComposer,
      $$AttributeDefinitionsTableAnnotationComposer,
      $$AttributeDefinitionsTableCreateCompanionBuilder,
      $$AttributeDefinitionsTableUpdateCompanionBuilder,
      (
        AttributeDefinition,
        BaseReferences<
          _$AppDatabase,
          $AttributeDefinitionsTable,
          AttributeDefinition
        >,
      ),
      AttributeDefinition,
      PrefetchHooks Function()
    >;
typedef $$FactsTableCreateCompanionBuilder =
    FactsCompanion Function({
      required String id,
      required String subjectId,
      required String attribute,
      required String value,
      Value<String?> storyTime,
      Value<String?> sceneId,
      Value<String> source,
      Value<bool?> aiAssistedPhrasing,
      Value<DateTime> authoringTime,
      Value<String?> supersedes,
      Value<int> rowid,
    });
typedef $$FactsTableUpdateCompanionBuilder =
    FactsCompanion Function({
      Value<String> id,
      Value<String> subjectId,
      Value<String> attribute,
      Value<String> value,
      Value<String?> storyTime,
      Value<String?> sceneId,
      Value<String> source,
      Value<bool?> aiAssistedPhrasing,
      Value<DateTime> authoringTime,
      Value<String?> supersedes,
      Value<int> rowid,
    });

class $$FactsTableFilterComposer extends Composer<_$AppDatabase, $FactsTable> {
  $$FactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attribute => $composableBuilder(
    column: $table.attribute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storyTime => $composableBuilder(
    column: $table.storyTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sceneId => $composableBuilder(
    column: $table.sceneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aiAssistedPhrasing => $composableBuilder(
    column: $table.aiAssistedPhrasing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get authoringTime => $composableBuilder(
    column: $table.authoringTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supersedes => $composableBuilder(
    column: $table.supersedes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FactsTableOrderingComposer
    extends Composer<_$AppDatabase, $FactsTable> {
  $$FactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attribute => $composableBuilder(
    column: $table.attribute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storyTime => $composableBuilder(
    column: $table.storyTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sceneId => $composableBuilder(
    column: $table.sceneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aiAssistedPhrasing => $composableBuilder(
    column: $table.aiAssistedPhrasing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get authoringTime => $composableBuilder(
    column: $table.authoringTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supersedes => $composableBuilder(
    column: $table.supersedes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FactsTable> {
  $$FactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get attribute =>
      $composableBuilder(column: $table.attribute, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get storyTime =>
      $composableBuilder(column: $table.storyTime, builder: (column) => column);

  GeneratedColumn<String> get sceneId =>
      $composableBuilder(column: $table.sceneId, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get aiAssistedPhrasing => $composableBuilder(
    column: $table.aiAssistedPhrasing,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get authoringTime => $composableBuilder(
    column: $table.authoringTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supersedes => $composableBuilder(
    column: $table.supersedes,
    builder: (column) => column,
  );
}

class $$FactsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FactsTable,
          FactRow,
          $$FactsTableFilterComposer,
          $$FactsTableOrderingComposer,
          $$FactsTableAnnotationComposer,
          $$FactsTableCreateCompanionBuilder,
          $$FactsTableUpdateCompanionBuilder,
          (FactRow, BaseReferences<_$AppDatabase, $FactsTable, FactRow>),
          FactRow,
          PrefetchHooks Function()
        > {
  $$FactsTableTableManager(_$AppDatabase db, $FactsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> attribute = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String?> storyTime = const Value.absent(),
                Value<String?> sceneId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool?> aiAssistedPhrasing = const Value.absent(),
                Value<DateTime> authoringTime = const Value.absent(),
                Value<String?> supersedes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FactsCompanion(
                id: id,
                subjectId: subjectId,
                attribute: attribute,
                value: value,
                storyTime: storyTime,
                sceneId: sceneId,
                source: source,
                aiAssistedPhrasing: aiAssistedPhrasing,
                authoringTime: authoringTime,
                supersedes: supersedes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                required String attribute,
                required String value,
                Value<String?> storyTime = const Value.absent(),
                Value<String?> sceneId = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool?> aiAssistedPhrasing = const Value.absent(),
                Value<DateTime> authoringTime = const Value.absent(),
                Value<String?> supersedes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FactsCompanion.insert(
                id: id,
                subjectId: subjectId,
                attribute: attribute,
                value: value,
                storyTime: storyTime,
                sceneId: sceneId,
                source: source,
                aiAssistedPhrasing: aiAssistedPhrasing,
                authoringTime: authoringTime,
                supersedes: supersedes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FactsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FactsTable,
      FactRow,
      $$FactsTableFilterComposer,
      $$FactsTableOrderingComposer,
      $$FactsTableAnnotationComposer,
      $$FactsTableCreateCompanionBuilder,
      $$FactsTableUpdateCompanionBuilder,
      (FactRow, BaseReferences<_$AppDatabase, $FactsTable, FactRow>),
      FactRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>),
      SettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EntitiesTableTableManager get entities =>
      $$EntitiesTableTableManager(_db, _db.entities);
  $$AttributeDefinitionsTableTableManager get attributeDefinitions =>
      $$AttributeDefinitionsTableTableManager(_db, _db.attributeDefinitions);
  $$FactsTableTableManager get facts =>
      $$FactsTableTableManager(_db, _db.facts);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
