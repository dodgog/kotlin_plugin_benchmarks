// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Events extends Table with TableInfo<Events, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Events(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL PRIMARY KEY');
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _attributeMeta =
      const VerificationMeta('attribute');
  late final GeneratedColumn<String> attribute = GeneratedColumn<String>(
      'attribute', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL');
  @override
  List<GeneratedColumn> get $columns =>
      [id, entityId, attribute, value, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('attribute')) {
      context.handle(_attributeMeta,
          attribute.isAcceptableOrUnknown(data['attribute']!, _attributeMeta));
    } else if (isInserting) {
      context.missing(_attributeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      attribute: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attribute'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  Events createAlias(String alias) {
    return Events(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Event extends DataClass implements Insertable<Event> {
  final String id;
  final String entityId;

  /// doesn't always reference an existing node, so references is omitted
  final String attribute;
  final String value;
  final String timestamp;
  const Event(
      {required this.id,
      required this.entityId,
      required this.attribute,
      required this.value,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_id'] = Variable<String>(entityId);
    map['attribute'] = Variable<String>(attribute);
    map['value'] = Variable<String>(value);
    map['timestamp'] = Variable<String>(timestamp);
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      entityId: Value(entityId),
      attribute: Value(attribute),
      value: Value(value),
      timestamp: Value(timestamp),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<String>(json['id']),
      entityId: serializer.fromJson<String>(json['entity_id']),
      attribute: serializer.fromJson<String>(json['attribute']),
      value: serializer.fromJson<String>(json['value']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entity_id': serializer.toJson<String>(entityId),
      'attribute': serializer.toJson<String>(attribute),
      'value': serializer.toJson<String>(value),
      'timestamp': serializer.toJson<String>(timestamp),
    };
  }

  Event copyWith(
          {String? id,
          String? entityId,
          String? attribute,
          String? value,
          String? timestamp}) =>
      Event(
        id: id ?? this.id,
        entityId: entityId ?? this.entityId,
        attribute: attribute ?? this.attribute,
        value: value ?? this.value,
        timestamp: timestamp ?? this.timestamp,
      );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      attribute: data.attribute.present ? data.attribute.value : this.attribute,
      value: data.value.present ? data.value.value : this.value,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('attribute: $attribute, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityId, attribute, value, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.entityId == this.entityId &&
          other.attribute == this.attribute &&
          other.value == this.value &&
          other.timestamp == this.timestamp);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<String> id;
  final Value<String> entityId;
  final Value<String> attribute;
  final Value<String> value;
  final Value<String> timestamp;
  final Value<int> rowid;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.entityId = const Value.absent(),
    this.attribute = const Value.absent(),
    this.value = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required String id,
    required String entityId,
    required String attribute,
    required String value,
    required String timestamp,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityId = Value(entityId),
        attribute = Value(attribute),
        value = Value(value),
        timestamp = Value(timestamp);
  static Insertable<Event> custom({
    Expression<String>? id,
    Expression<String>? entityId,
    Expression<String>? attribute,
    Expression<String>? value,
    Expression<String>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityId != null) 'entity_id': entityId,
      if (attribute != null) 'attribute': attribute,
      if (value != null) 'value': value,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityId,
      Value<String>? attribute,
      Value<String>? value,
      Value<String>? timestamp,
      Value<int>? rowid}) {
    return EventsCompanion(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      attribute: attribute ?? this.attribute,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (attribute.present) {
      map['attribute'] = Variable<String>(attribute.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('attribute: $attribute, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Events events = Events(this);
  Selectable<Event> getEvents() {
    return customSelect('SELECT * FROM events', variables: [], readsFrom: {
      events,
    }).asyncMap(events.mapFromRow);
  }

  Future<int> insertEvent(String id, String entityId, String attribute,
      String value, String timestamp) {
    return customInsert(
      'INSERT INTO events (id, entity_id, attribute, value, timestamp) VALUES (?1, ?2, ?3, ?4, ?5)',
      variables: [
        Variable<String>(id),
        Variable<String>(entityId),
        Variable<String>(attribute),
        Variable<String>(value),
        Variable<String>(timestamp)
      ],
      updates: {events},
    );
  }

  Selectable<Event> getEventByEntityId(String entityId) {
    return customSelect('SELECT * FROM events WHERE entity_id = ?1',
        variables: [
          Variable<String>(entityId)
        ],
        readsFrom: {
          events,
        }).asyncMap(events.mapFromRow);
  }

  Future<int> resetDatabase() {
    return customUpdate(
      'DELETE FROM events',
      variables: [],
      updates: {events},
      updateKind: UpdateKind.delete,
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [events];
}

typedef $EventsCreateCompanionBuilder = EventsCompanion Function({
  required String id,
  required String entityId,
  required String attribute,
  required String value,
  required String timestamp,
  Value<int> rowid,
});
typedef $EventsUpdateCompanionBuilder = EventsCompanion Function({
  Value<String> id,
  Value<String> entityId,
  Value<String> attribute,
  Value<String> value,
  Value<String> timestamp,
  Value<int> rowid,
});

class $EventsFilterComposer extends Composer<_$AppDatabase, Events> {
  $EventsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attribute => $composableBuilder(
      column: $table.attribute, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $EventsOrderingComposer extends Composer<_$AppDatabase, Events> {
  $EventsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attribute => $composableBuilder(
      column: $table.attribute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $EventsAnnotationComposer extends Composer<_$AppDatabase, Events> {
  $EventsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get attribute =>
      $composableBuilder(column: $table.attribute, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $EventsTableManager extends RootTableManager<
    _$AppDatabase,
    Events,
    Event,
    $EventsFilterComposer,
    $EventsOrderingComposer,
    $EventsAnnotationComposer,
    $EventsCreateCompanionBuilder,
    $EventsUpdateCompanionBuilder,
    (Event, BaseReferences<_$AppDatabase, Events, Event>),
    Event,
    PrefetchHooks Function()> {
  $EventsTableManager(_$AppDatabase db, Events table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EventsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EventsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EventsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> attribute = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<String> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EventsCompanion(
            id: id,
            entityId: entityId,
            attribute: attribute,
            value: value,
            timestamp: timestamp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityId,
            required String attribute,
            required String value,
            required String timestamp,
            Value<int> rowid = const Value.absent(),
          }) =>
              EventsCompanion.insert(
            id: id,
            entityId: entityId,
            attribute: attribute,
            value: value,
            timestamp: timestamp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $EventsProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    Events,
    Event,
    $EventsFilterComposer,
    $EventsOrderingComposer,
    $EventsAnnotationComposer,
    $EventsCreateCompanionBuilder,
    $EventsUpdateCompanionBuilder,
    (Event, BaseReferences<_$AppDatabase, Events, Event>),
    Event,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $EventsTableManager get events => $EventsTableManager(_db, _db.events);
}
