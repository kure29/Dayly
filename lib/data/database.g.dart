// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TaskTemplatesTable extends TaskTemplates
    with TableInfo<$TaskTemplatesTable, TemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorIndexMeta = const VerificationMeta(
    'colorIndex',
  );
  @override
  late final GeneratedColumn<int> colorIndex = GeneratedColumn<int>(
    'color_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatKindMeta = const VerificationMeta(
    'repeatKind',
  );
  @override
  late final GeneratedColumn<String> repeatKind = GeneratedColumn<String>(
    'repeat_kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatDaysMeta = const VerificationMeta(
    'repeatDays',
  );
  @override
  late final GeneratedColumn<int> repeatDays = GeneratedColumn<int>(
    'repeat_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    colorIndex,
    type,
    target,
    step,
    unit,
    repeatKind,
    repeatDays,
    isActive,
    sortOrder,
    createdAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_index')) {
      context.handle(
        _colorIndexMeta,
        colorIndex.isAcceptableOrUnknown(data['color_index']!, _colorIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorIndexMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    } else if (isInserting) {
      context.missing(_stepMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('repeat_kind')) {
      context.handle(
        _repeatKindMeta,
        repeatKind.isAcceptableOrUnknown(data['repeat_kind']!, _repeatKindMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatKindMeta);
    }
    if (data.containsKey('repeat_days')) {
      context.handle(
        _repeatDaysMeta,
        repeatDays.isAcceptableOrUnknown(data['repeat_days']!, _repeatDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_repeatDaysMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_index'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      repeatKind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_kind'],
      )!,
      repeatDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_days'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $TaskTemplatesTable createAlias(String alias) {
    return $TaskTemplatesTable(attachedDatabase, alias);
  }
}

class TemplateRow extends DataClass implements Insertable<TemplateRow> {
  final int id;
  final String name;
  final String icon;
  final int colorIndex;

  /// `TaskType.name`.
  final String type;
  final int target;
  final int step;
  final String unit;

  /// `RepeatKind.name`.
  final String repeatKind;

  /// Bit 0 = Monday … bit 6 = Sunday.
  final int repeatDays;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? archivedAt;
  const TemplateRow({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorIndex,
    required this.type,
    required this.target,
    required this.step,
    required this.unit,
    required this.repeatKind,
    required this.repeatDays,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color_index'] = Variable<int>(colorIndex);
    map['type'] = Variable<String>(type);
    map['target'] = Variable<int>(target);
    map['step'] = Variable<int>(step);
    map['unit'] = Variable<String>(unit);
    map['repeat_kind'] = Variable<String>(repeatKind);
    map['repeat_days'] = Variable<int>(repeatDays);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  TaskTemplatesCompanion toCompanion(bool nullToAbsent) {
    return TaskTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      colorIndex: Value(colorIndex),
      type: Value(type),
      target: Value(target),
      step: Value(step),
      unit: Value(unit),
      repeatKind: Value(repeatKind),
      repeatDays: Value(repeatDays),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory TemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      colorIndex: serializer.fromJson<int>(json['colorIndex']),
      type: serializer.fromJson<String>(json['type']),
      target: serializer.fromJson<int>(json['target']),
      step: serializer.fromJson<int>(json['step']),
      unit: serializer.fromJson<String>(json['unit']),
      repeatKind: serializer.fromJson<String>(json['repeatKind']),
      repeatDays: serializer.fromJson<int>(json['repeatDays']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'colorIndex': serializer.toJson<int>(colorIndex),
      'type': serializer.toJson<String>(type),
      'target': serializer.toJson<int>(target),
      'step': serializer.toJson<int>(step),
      'unit': serializer.toJson<String>(unit),
      'repeatKind': serializer.toJson<String>(repeatKind),
      'repeatDays': serializer.toJson<int>(repeatDays),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  TemplateRow copyWith({
    int? id,
    String? name,
    String? icon,
    int? colorIndex,
    String? type,
    int? target,
    int? step,
    String? unit,
    String? repeatKind,
    int? repeatDays,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => TemplateRow(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorIndex: colorIndex ?? this.colorIndex,
    type: type ?? this.type,
    target: target ?? this.target,
    step: step ?? this.step,
    unit: unit ?? this.unit,
    repeatKind: repeatKind ?? this.repeatKind,
    repeatDays: repeatDays ?? this.repeatDays,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  TemplateRow copyWithCompanion(TaskTemplatesCompanion data) {
    return TemplateRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorIndex: data.colorIndex.present
          ? data.colorIndex.value
          : this.colorIndex,
      type: data.type.present ? data.type.value : this.type,
      target: data.target.present ? data.target.value : this.target,
      step: data.step.present ? data.step.value : this.step,
      unit: data.unit.present ? data.unit.value : this.unit,
      repeatKind: data.repeatKind.present
          ? data.repeatKind.value
          : this.repeatKind,
      repeatDays: data.repeatDays.present
          ? data.repeatDays.value
          : this.repeatDays,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('step: $step, ')
          ..write('unit: $unit, ')
          ..write('repeatKind: $repeatKind, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    icon,
    colorIndex,
    type,
    target,
    step,
    unit,
    repeatKind,
    repeatDays,
    isActive,
    sortOrder,
    createdAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorIndex == this.colorIndex &&
          other.type == this.type &&
          other.target == this.target &&
          other.step == this.step &&
          other.unit == this.unit &&
          other.repeatKind == this.repeatKind &&
          other.repeatDays == this.repeatDays &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt);
}

class TaskTemplatesCompanion extends UpdateCompanion<TemplateRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> colorIndex;
  final Value<String> type;
  final Value<int> target;
  final Value<int> step;
  final Value<String> unit;
  final Value<String> repeatKind;
  final Value<int> repeatDays;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  const TaskTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorIndex = const Value.absent(),
    this.type = const Value.absent(),
    this.target = const Value.absent(),
    this.step = const Value.absent(),
    this.unit = const Value.absent(),
    this.repeatKind = const Value.absent(),
    this.repeatDays = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
  });
  TaskTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    required int colorIndex,
    required String type,
    required int target,
    required int step,
    required String unit,
    required String repeatKind,
    required int repeatDays,
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon),
       colorIndex = Value(colorIndex),
       type = Value(type),
       target = Value(target),
       step = Value(step),
       unit = Value(unit),
       repeatKind = Value(repeatKind),
       repeatDays = Value(repeatDays),
       createdAt = Value(createdAt);
  static Insertable<TemplateRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? colorIndex,
    Expression<String>? type,
    Expression<int>? target,
    Expression<int>? step,
    Expression<String>? unit,
    Expression<String>? repeatKind,
    Expression<int>? repeatDays,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorIndex != null) 'color_index': colorIndex,
      if (type != null) 'type': type,
      if (target != null) 'target': target,
      if (step != null) 'step': step,
      if (unit != null) 'unit': unit,
      if (repeatKind != null) 'repeat_kind': repeatKind,
      if (repeatDays != null) 'repeat_days': repeatDays,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
    });
  }

  TaskTemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? colorIndex,
    Value<String>? type,
    Value<int>? target,
    Value<int>? step,
    Value<String>? unit,
    Value<String>? repeatKind,
    Value<int>? repeatDays,
    Value<bool>? isActive,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
  }) {
    return TaskTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorIndex: colorIndex ?? this.colorIndex,
      type: type ?? this.type,
      target: target ?? this.target,
      step: step ?? this.step,
      unit: unit ?? this.unit,
      repeatKind: repeatKind ?? this.repeatKind,
      repeatDays: repeatDays ?? this.repeatDays,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorIndex.present) {
      map['color_index'] = Variable<int>(colorIndex.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (repeatKind.present) {
      map['repeat_kind'] = Variable<String>(repeatKind.value);
    }
    if (repeatDays.present) {
      map['repeat_days'] = Variable<int>(repeatDays.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('type: $type, ')
          ..write('target: $target, ')
          ..write('step: $step, ')
          ..write('unit: $unit, ')
          ..write('repeatKind: $repeatKind, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyTasksTable extends DailyTasks
    with TableInfo<$DailyTasksTable, DailyTaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_templates (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<int> target = GeneratedColumn<int>(
    'target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    date,
    progress,
    completedAt,
    name,
    target,
    unit,
    step,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyTaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target')) {
      context.handle(
        _targetMeta,
        target.isAcceptableOrUnknown(data['target']!, _targetMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    } else if (isInserting) {
      context.missing(_stepMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {templateId, date},
  ];
  @override
  DailyTaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyTaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      target: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $DailyTasksTable createAlias(String alias) {
    return $DailyTasksTable(attachedDatabase, alias);
  }
}

class DailyTaskRow extends DataClass implements Insertable<DailyTaskRow> {
  final int id;
  final int templateId;

  /// `yyyy-MM-dd` logical date.
  final String date;
  final int progress;
  final DateTime? completedAt;
  final String name;
  final int target;
  final String unit;
  final int step;
  final String type;
  const DailyTaskRow({
    required this.id,
    required this.templateId,
    required this.date,
    required this.progress,
    this.completedAt,
    required this.name,
    required this.target,
    required this.unit,
    required this.step,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_id'] = Variable<int>(templateId);
    map['date'] = Variable<String>(date);
    map['progress'] = Variable<int>(progress);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['name'] = Variable<String>(name);
    map['target'] = Variable<int>(target);
    map['unit'] = Variable<String>(unit);
    map['step'] = Variable<int>(step);
    map['type'] = Variable<String>(type);
    return map;
  }

  DailyTasksCompanion toCompanion(bool nullToAbsent) {
    return DailyTasksCompanion(
      id: Value(id),
      templateId: Value(templateId),
      date: Value(date),
      progress: Value(progress),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      name: Value(name),
      target: Value(target),
      unit: Value(unit),
      step: Value(step),
      type: Value(type),
    );
  }

  factory DailyTaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyTaskRow(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<int>(json['templateId']),
      date: serializer.fromJson<String>(json['date']),
      progress: serializer.fromJson<int>(json['progress']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      name: serializer.fromJson<String>(json['name']),
      target: serializer.fromJson<int>(json['target']),
      unit: serializer.fromJson<String>(json['unit']),
      step: serializer.fromJson<int>(json['step']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateId': serializer.toJson<int>(templateId),
      'date': serializer.toJson<String>(date),
      'progress': serializer.toJson<int>(progress),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'name': serializer.toJson<String>(name),
      'target': serializer.toJson<int>(target),
      'unit': serializer.toJson<String>(unit),
      'step': serializer.toJson<int>(step),
      'type': serializer.toJson<String>(type),
    };
  }

  DailyTaskRow copyWith({
    int? id,
    int? templateId,
    String? date,
    int? progress,
    Value<DateTime?> completedAt = const Value.absent(),
    String? name,
    int? target,
    String? unit,
    int? step,
    String? type,
  }) => DailyTaskRow(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    date: date ?? this.date,
    progress: progress ?? this.progress,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    name: name ?? this.name,
    target: target ?? this.target,
    unit: unit ?? this.unit,
    step: step ?? this.step,
    type: type ?? this.type,
  );
  DailyTaskRow copyWithCompanion(DailyTasksCompanion data) {
    return DailyTaskRow(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      date: data.date.present ? data.date.value : this.date,
      progress: data.progress.present ? data.progress.value : this.progress,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      name: data.name.present ? data.name.value : this.name,
      target: data.target.present ? data.target.value : this.target,
      unit: data.unit.present ? data.unit.value : this.unit,
      step: data.step.present ? data.step.value : this.step,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyTaskRow(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('date: $date, ')
          ..write('progress: $progress, ')
          ..write('completedAt: $completedAt, ')
          ..write('name: $name, ')
          ..write('target: $target, ')
          ..write('unit: $unit, ')
          ..write('step: $step, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateId,
    date,
    progress,
    completedAt,
    name,
    target,
    unit,
    step,
    type,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyTaskRow &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.date == this.date &&
          other.progress == this.progress &&
          other.completedAt == this.completedAt &&
          other.name == this.name &&
          other.target == this.target &&
          other.unit == this.unit &&
          other.step == this.step &&
          other.type == this.type);
}

class DailyTasksCompanion extends UpdateCompanion<DailyTaskRow> {
  final Value<int> id;
  final Value<int> templateId;
  final Value<String> date;
  final Value<int> progress;
  final Value<DateTime?> completedAt;
  final Value<String> name;
  final Value<int> target;
  final Value<String> unit;
  final Value<int> step;
  final Value<String> type;
  const DailyTasksCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.date = const Value.absent(),
    this.progress = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.name = const Value.absent(),
    this.target = const Value.absent(),
    this.unit = const Value.absent(),
    this.step = const Value.absent(),
    this.type = const Value.absent(),
  });
  DailyTasksCompanion.insert({
    this.id = const Value.absent(),
    required int templateId,
    required String date,
    this.progress = const Value.absent(),
    this.completedAt = const Value.absent(),
    required String name,
    required int target,
    required String unit,
    required int step,
    required String type,
  }) : templateId = Value(templateId),
       date = Value(date),
       name = Value(name),
       target = Value(target),
       unit = Value(unit),
       step = Value(step),
       type = Value(type);
  static Insertable<DailyTaskRow> custom({
    Expression<int>? id,
    Expression<int>? templateId,
    Expression<String>? date,
    Expression<int>? progress,
    Expression<DateTime>? completedAt,
    Expression<String>? name,
    Expression<int>? target,
    Expression<String>? unit,
    Expression<int>? step,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (date != null) 'date': date,
      if (progress != null) 'progress': progress,
      if (completedAt != null) 'completed_at': completedAt,
      if (name != null) 'name': name,
      if (target != null) 'target': target,
      if (unit != null) 'unit': unit,
      if (step != null) 'step': step,
      if (type != null) 'type': type,
    });
  }

  DailyTasksCompanion copyWith({
    Value<int>? id,
    Value<int>? templateId,
    Value<String>? date,
    Value<int>? progress,
    Value<DateTime?>? completedAt,
    Value<String>? name,
    Value<int>? target,
    Value<String>? unit,
    Value<int>? step,
    Value<String>? type,
  }) {
    return DailyTasksCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      date: date ?? this.date,
      progress: progress ?? this.progress,
      completedAt: completedAt ?? this.completedAt,
      name: name ?? this.name,
      target: target ?? this.target,
      unit: unit ?? this.unit,
      step: step ?? this.step,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (target.present) {
      map['target'] = Variable<int>(target.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyTasksCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('date: $date, ')
          ..write('progress: $progress, ')
          ..write('completedAt: $completedAt, ')
          ..write('name: $name, ')
          ..write('target: $target, ')
          ..write('unit: $unit, ')
          ..write('step: $step, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $TaskEventsTable extends TaskEvents
    with TableInfo<$TaskEventsTable, TaskEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dailyTaskIdMeta = const VerificationMeta(
    'dailyTaskId',
  );
  @override
  late final GeneratedColumn<int> dailyTaskId = GeneratedColumn<int>(
    'daily_task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
    'delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newProgressMeta = const VerificationMeta(
    'newProgress',
  );
  @override
  late final GeneratedColumn<int> newProgress = GeneratedColumn<int>(
    'new_progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyTaskId,
    templateId,
    date,
    delta,
    newProgress,
    kind,
    source,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_task_id')) {
      context.handle(
        _dailyTaskIdMeta,
        dailyTaskId.isAcceptableOrUnknown(
          data['daily_task_id']!,
          _dailyTaskIdMeta,
        ),
      );
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('new_progress')) {
      context.handle(
        _newProgressMeta,
        newProgress.isAcceptableOrUnknown(
          data['new_progress']!,
          _newProgressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newProgressMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dailyTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_task_id'],
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delta'],
      )!,
      newProgress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_progress'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $TaskEventsTable createAlias(String alias) {
    return $TaskEventsTable(attachedDatabase, alias);
  }
}

class TaskEventRow extends DataClass implements Insertable<TaskEventRow> {
  final int id;

  /// Null for day-level events. No FK so the log survives task deletion.
  final int? dailyTaskId;
  final int? templateId;
  final String date;
  final int delta;
  final int newProgress;

  /// `EventKind.name`.
  final String kind;

  /// `EventSource.name`.
  final String source;
  final DateTime occurredAt;
  const TaskEventRow({
    required this.id,
    this.dailyTaskId,
    this.templateId,
    required this.date,
    required this.delta,
    required this.newProgress,
    required this.kind,
    required this.source,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || dailyTaskId != null) {
      map['daily_task_id'] = Variable<int>(dailyTaskId);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<int>(templateId);
    }
    map['date'] = Variable<String>(date);
    map['delta'] = Variable<int>(delta);
    map['new_progress'] = Variable<int>(newProgress);
    map['kind'] = Variable<String>(kind);
    map['source'] = Variable<String>(source);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  TaskEventsCompanion toCompanion(bool nullToAbsent) {
    return TaskEventsCompanion(
      id: Value(id),
      dailyTaskId: dailyTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyTaskId),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      date: Value(date),
      delta: Value(delta),
      newProgress: Value(newProgress),
      kind: Value(kind),
      source: Value(source),
      occurredAt: Value(occurredAt),
    );
  }

  factory TaskEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskEventRow(
      id: serializer.fromJson<int>(json['id']),
      dailyTaskId: serializer.fromJson<int?>(json['dailyTaskId']),
      templateId: serializer.fromJson<int?>(json['templateId']),
      date: serializer.fromJson<String>(json['date']),
      delta: serializer.fromJson<int>(json['delta']),
      newProgress: serializer.fromJson<int>(json['newProgress']),
      kind: serializer.fromJson<String>(json['kind']),
      source: serializer.fromJson<String>(json['source']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyTaskId': serializer.toJson<int?>(dailyTaskId),
      'templateId': serializer.toJson<int?>(templateId),
      'date': serializer.toJson<String>(date),
      'delta': serializer.toJson<int>(delta),
      'newProgress': serializer.toJson<int>(newProgress),
      'kind': serializer.toJson<String>(kind),
      'source': serializer.toJson<String>(source),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  TaskEventRow copyWith({
    int? id,
    Value<int?> dailyTaskId = const Value.absent(),
    Value<int?> templateId = const Value.absent(),
    String? date,
    int? delta,
    int? newProgress,
    String? kind,
    String? source,
    DateTime? occurredAt,
  }) => TaskEventRow(
    id: id ?? this.id,
    dailyTaskId: dailyTaskId.present ? dailyTaskId.value : this.dailyTaskId,
    templateId: templateId.present ? templateId.value : this.templateId,
    date: date ?? this.date,
    delta: delta ?? this.delta,
    newProgress: newProgress ?? this.newProgress,
    kind: kind ?? this.kind,
    source: source ?? this.source,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  TaskEventRow copyWithCompanion(TaskEventsCompanion data) {
    return TaskEventRow(
      id: data.id.present ? data.id.value : this.id,
      dailyTaskId: data.dailyTaskId.present
          ? data.dailyTaskId.value
          : this.dailyTaskId,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      date: data.date.present ? data.date.value : this.date,
      delta: data.delta.present ? data.delta.value : this.delta,
      newProgress: data.newProgress.present
          ? data.newProgress.value
          : this.newProgress,
      kind: data.kind.present ? data.kind.value : this.kind,
      source: data.source.present ? data.source.value : this.source,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskEventRow(')
          ..write('id: $id, ')
          ..write('dailyTaskId: $dailyTaskId, ')
          ..write('templateId: $templateId, ')
          ..write('date: $date, ')
          ..write('delta: $delta, ')
          ..write('newProgress: $newProgress, ')
          ..write('kind: $kind, ')
          ..write('source: $source, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyTaskId,
    templateId,
    date,
    delta,
    newProgress,
    kind,
    source,
    occurredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskEventRow &&
          other.id == this.id &&
          other.dailyTaskId == this.dailyTaskId &&
          other.templateId == this.templateId &&
          other.date == this.date &&
          other.delta == this.delta &&
          other.newProgress == this.newProgress &&
          other.kind == this.kind &&
          other.source == this.source &&
          other.occurredAt == this.occurredAt);
}

class TaskEventsCompanion extends UpdateCompanion<TaskEventRow> {
  final Value<int> id;
  final Value<int?> dailyTaskId;
  final Value<int?> templateId;
  final Value<String> date;
  final Value<int> delta;
  final Value<int> newProgress;
  final Value<String> kind;
  final Value<String> source;
  final Value<DateTime> occurredAt;
  const TaskEventsCompanion({
    this.id = const Value.absent(),
    this.dailyTaskId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.date = const Value.absent(),
    this.delta = const Value.absent(),
    this.newProgress = const Value.absent(),
    this.kind = const Value.absent(),
    this.source = const Value.absent(),
    this.occurredAt = const Value.absent(),
  });
  TaskEventsCompanion.insert({
    this.id = const Value.absent(),
    this.dailyTaskId = const Value.absent(),
    this.templateId = const Value.absent(),
    required String date,
    required int delta,
    required int newProgress,
    required String kind,
    required String source,
    required DateTime occurredAt,
  }) : date = Value(date),
       delta = Value(delta),
       newProgress = Value(newProgress),
       kind = Value(kind),
       source = Value(source),
       occurredAt = Value(occurredAt);
  static Insertable<TaskEventRow> custom({
    Expression<int>? id,
    Expression<int>? dailyTaskId,
    Expression<int>? templateId,
    Expression<String>? date,
    Expression<int>? delta,
    Expression<int>? newProgress,
    Expression<String>? kind,
    Expression<String>? source,
    Expression<DateTime>? occurredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyTaskId != null) 'daily_task_id': dailyTaskId,
      if (templateId != null) 'template_id': templateId,
      if (date != null) 'date': date,
      if (delta != null) 'delta': delta,
      if (newProgress != null) 'new_progress': newProgress,
      if (kind != null) 'kind': kind,
      if (source != null) 'source': source,
      if (occurredAt != null) 'occurred_at': occurredAt,
    });
  }

  TaskEventsCompanion copyWith({
    Value<int>? id,
    Value<int?>? dailyTaskId,
    Value<int?>? templateId,
    Value<String>? date,
    Value<int>? delta,
    Value<int>? newProgress,
    Value<String>? kind,
    Value<String>? source,
    Value<DateTime>? occurredAt,
  }) {
    return TaskEventsCompanion(
      id: id ?? this.id,
      dailyTaskId: dailyTaskId ?? this.dailyTaskId,
      templateId: templateId ?? this.templateId,
      date: date ?? this.date,
      delta: delta ?? this.delta,
      newProgress: newProgress ?? this.newProgress,
      kind: kind ?? this.kind,
      source: source ?? this.source,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyTaskId.present) {
      map['daily_task_id'] = Variable<int>(dailyTaskId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (newProgress.present) {
      map['new_progress'] = Variable<int>(newProgress.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskEventsCompanion(')
          ..write('id: $id, ')
          ..write('dailyTaskId: $dailyTaskId, ')
          ..write('templateId: $templateId, ')
          ..write('date: $date, ')
          ..write('delta: $delta, ')
          ..write('newProgress: $newProgress, ')
          ..write('kind: $kind, ')
          ..write('source: $source, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarCharMeta = const VerificationMeta(
    'avatarChar',
  );
  @override
  late final GeneratedColumn<String> avatarChar = GeneratedColumn<String>(
    'avatar_char',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nickname, avatarChar];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    } else if (isInserting) {
      context.missing(_nicknameMeta);
    }
    if (data.containsKey('avatar_char')) {
      context.handle(
        _avatarCharMeta,
        avatarChar.isAcceptableOrUnknown(data['avatar_char']!, _avatarCharMeta),
      );
    } else if (isInserting) {
      context.missing(_avatarCharMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      )!,
      avatarChar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_char'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;
  final String nickname;
  final String avatarChar;
  const ProfileRow({
    required this.id,
    required this.nickname,
    required this.avatarChar,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nickname'] = Variable<String>(nickname);
    map['avatar_char'] = Variable<String>(avatarChar);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      nickname: Value(nickname),
      avatarChar: Value(avatarChar),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      nickname: serializer.fromJson<String>(json['nickname']),
      avatarChar: serializer.fromJson<String>(json['avatarChar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nickname': serializer.toJson<String>(nickname),
      'avatarChar': serializer.toJson<String>(avatarChar),
    };
  }

  ProfileRow copyWith({int? id, String? nickname, String? avatarChar}) =>
      ProfileRow(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        avatarChar: avatarChar ?? this.avatarChar,
      );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      avatarChar: data.avatarChar.present
          ? data.avatarChar.value
          : this.avatarChar,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarChar: $avatarChar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nickname, avatarChar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.nickname == this.nickname &&
          other.avatarChar == this.avatarChar);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<String> nickname;
  final Value<String> avatarChar;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.nickname = const Value.absent(),
    this.avatarChar = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String nickname,
    required String avatarChar,
  }) : nickname = Value(nickname),
       avatarChar = Value(avatarChar);
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<String>? nickname,
    Expression<String>? avatarChar,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nickname != null) 'nickname': nickname,
      if (avatarChar != null) 'avatar_char': avatarChar,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? nickname,
    Value<String>? avatarChar,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      avatarChar: avatarChar ?? this.avatarChar,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (avatarChar.present) {
      map['avatar_char'] = Variable<String>(avatarChar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('nickname: $nickname, ')
          ..write('avatarChar: $avatarChar')
          ..write(')'))
        .toString();
  }
}

class $SettingsEntriesTable extends SettingsEntries
    with TableInfo<$SettingsEntriesTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _schemeIdMeta = const VerificationMeta(
    'schemeId',
  );
  @override
  late final GeneratedColumn<String> schemeId = GeneratedColumn<String>(
    'scheme_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customAccentMeta = const VerificationMeta(
    'customAccent',
  );
  @override
  late final GeneratedColumn<int> customAccent = GeneratedColumn<int>(
    'custom_accent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brightnessModeMeta = const VerificationMeta(
    'brightnessMode',
  );
  @override
  late final GeneratedColumn<String> brightnessMode = GeneratedColumn<String>(
    'brightness_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayStartHourMeta = const VerificationMeta(
    'dayStartHour',
  );
  @override
  late final GeneratedColumn<int> dayStartHour = GeneratedColumn<int>(
    'day_start_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
  );
  static const VerificationMeta _reminderMinutesMeta = const VerificationMeta(
    'reminderMinutes',
  );
  @override
  late final GeneratedColumn<int> reminderMinutes = GeneratedColumn<int>(
    'reminder_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seededMeta = const VerificationMeta('seeded');
  @override
  late final GeneratedColumn<bool> seeded = GeneratedColumn<bool>(
    'seeded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("seeded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    schemeId,
    customAccent,
    brightnessMode,
    dayStartHour,
    reminderEnabled,
    reminderMinutes,
    seeded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scheme_id')) {
      context.handle(
        _schemeIdMeta,
        schemeId.isAcceptableOrUnknown(data['scheme_id']!, _schemeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_schemeIdMeta);
    }
    if (data.containsKey('custom_accent')) {
      context.handle(
        _customAccentMeta,
        customAccent.isAcceptableOrUnknown(
          data['custom_accent']!,
          _customAccentMeta,
        ),
      );
    }
    if (data.containsKey('brightness_mode')) {
      context.handle(
        _brightnessModeMeta,
        brightnessMode.isAcceptableOrUnknown(
          data['brightness_mode']!,
          _brightnessModeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_brightnessModeMeta);
    }
    if (data.containsKey('day_start_hour')) {
      context.handle(
        _dayStartHourMeta,
        dayStartHour.isAcceptableOrUnknown(
          data['day_start_hour']!,
          _dayStartHourMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dayStartHourMeta);
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reminderEnabledMeta);
    }
    if (data.containsKey('reminder_minutes')) {
      context.handle(
        _reminderMinutesMeta,
        reminderMinutes.isAcceptableOrUnknown(
          data['reminder_minutes']!,
          _reminderMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reminderMinutesMeta);
    }
    if (data.containsKey('seeded')) {
      context.handle(
        _seededMeta,
        seeded.isAcceptableOrUnknown(data['seeded']!, _seededMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      schemeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheme_id'],
      )!,
      customAccent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_accent'],
      ),
      brightnessMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brightness_mode'],
      )!,
      dayStartHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_start_hour'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_minutes'],
      )!,
      seeded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}seeded'],
      )!,
    );
  }

  @override
  $SettingsEntriesTable createAlias(String alias) {
    return $SettingsEntriesTable(attachedDatabase, alias);
  }
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final String schemeId;
  final int? customAccent;
  final String brightnessMode;
  final int dayStartHour;
  final bool reminderEnabled;
  final int reminderMinutes;
  final bool seeded;
  const SettingsRow({
    required this.id,
    required this.schemeId,
    this.customAccent,
    required this.brightnessMode,
    required this.dayStartHour,
    required this.reminderEnabled,
    required this.reminderMinutes,
    required this.seeded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scheme_id'] = Variable<String>(schemeId);
    if (!nullToAbsent || customAccent != null) {
      map['custom_accent'] = Variable<int>(customAccent);
    }
    map['brightness_mode'] = Variable<String>(brightnessMode);
    map['day_start_hour'] = Variable<int>(dayStartHour);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['reminder_minutes'] = Variable<int>(reminderMinutes);
    map['seeded'] = Variable<bool>(seeded);
    return map;
  }

  SettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return SettingsEntriesCompanion(
      id: Value(id),
      schemeId: Value(schemeId),
      customAccent: customAccent == null && nullToAbsent
          ? const Value.absent()
          : Value(customAccent),
      brightnessMode: Value(brightnessMode),
      dayStartHour: Value(dayStartHour),
      reminderEnabled: Value(reminderEnabled),
      reminderMinutes: Value(reminderMinutes),
      seeded: Value(seeded),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      schemeId: serializer.fromJson<String>(json['schemeId']),
      customAccent: serializer.fromJson<int?>(json['customAccent']),
      brightnessMode: serializer.fromJson<String>(json['brightnessMode']),
      dayStartHour: serializer.fromJson<int>(json['dayStartHour']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderMinutes: serializer.fromJson<int>(json['reminderMinutes']),
      seeded: serializer.fromJson<bool>(json['seeded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'schemeId': serializer.toJson<String>(schemeId),
      'customAccent': serializer.toJson<int?>(customAccent),
      'brightnessMode': serializer.toJson<String>(brightnessMode),
      'dayStartHour': serializer.toJson<int>(dayStartHour),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderMinutes': serializer.toJson<int>(reminderMinutes),
      'seeded': serializer.toJson<bool>(seeded),
    };
  }

  SettingsRow copyWith({
    int? id,
    String? schemeId,
    Value<int?> customAccent = const Value.absent(),
    String? brightnessMode,
    int? dayStartHour,
    bool? reminderEnabled,
    int? reminderMinutes,
    bool? seeded,
  }) => SettingsRow(
    id: id ?? this.id,
    schemeId: schemeId ?? this.schemeId,
    customAccent: customAccent.present ? customAccent.value : this.customAccent,
    brightnessMode: brightnessMode ?? this.brightnessMode,
    dayStartHour: dayStartHour ?? this.dayStartHour,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    seeded: seeded ?? this.seeded,
  );
  SettingsRow copyWithCompanion(SettingsEntriesCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      schemeId: data.schemeId.present ? data.schemeId.value : this.schemeId,
      customAccent: data.customAccent.present
          ? data.customAccent.value
          : this.customAccent,
      brightnessMode: data.brightnessMode.present
          ? data.brightnessMode.value
          : this.brightnessMode,
      dayStartHour: data.dayStartHour.present
          ? data.dayStartHour.value
          : this.dayStartHour,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderMinutes: data.reminderMinutes.present
          ? data.reminderMinutes.value
          : this.reminderMinutes,
      seeded: data.seeded.present ? data.seeded.value : this.seeded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('schemeId: $schemeId, ')
          ..write('customAccent: $customAccent, ')
          ..write('brightnessMode: $brightnessMode, ')
          ..write('dayStartHour: $dayStartHour, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('seeded: $seeded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    schemeId,
    customAccent,
    brightnessMode,
    dayStartHour,
    reminderEnabled,
    reminderMinutes,
    seeded,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.schemeId == this.schemeId &&
          other.customAccent == this.customAccent &&
          other.brightnessMode == this.brightnessMode &&
          other.dayStartHour == this.dayStartHour &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderMinutes == this.reminderMinutes &&
          other.seeded == this.seeded);
}

class SettingsEntriesCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<String> schemeId;
  final Value<int?> customAccent;
  final Value<String> brightnessMode;
  final Value<int> dayStartHour;
  final Value<bool> reminderEnabled;
  final Value<int> reminderMinutes;
  final Value<bool> seeded;
  const SettingsEntriesCompanion({
    this.id = const Value.absent(),
    this.schemeId = const Value.absent(),
    this.customAccent = const Value.absent(),
    this.brightnessMode = const Value.absent(),
    this.dayStartHour = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderMinutes = const Value.absent(),
    this.seeded = const Value.absent(),
  });
  SettingsEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String schemeId,
    this.customAccent = const Value.absent(),
    required String brightnessMode,
    required int dayStartHour,
    required bool reminderEnabled,
    required int reminderMinutes,
    this.seeded = const Value.absent(),
  }) : schemeId = Value(schemeId),
       brightnessMode = Value(brightnessMode),
       dayStartHour = Value(dayStartHour),
       reminderEnabled = Value(reminderEnabled),
       reminderMinutes = Value(reminderMinutes);
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? schemeId,
    Expression<int>? customAccent,
    Expression<String>? brightnessMode,
    Expression<int>? dayStartHour,
    Expression<bool>? reminderEnabled,
    Expression<int>? reminderMinutes,
    Expression<bool>? seeded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schemeId != null) 'scheme_id': schemeId,
      if (customAccent != null) 'custom_accent': customAccent,
      if (brightnessMode != null) 'brightness_mode': brightnessMode,
      if (dayStartHour != null) 'day_start_hour': dayStartHour,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderMinutes != null) 'reminder_minutes': reminderMinutes,
      if (seeded != null) 'seeded': seeded,
    });
  }

  SettingsEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? schemeId,
    Value<int?>? customAccent,
    Value<String>? brightnessMode,
    Value<int>? dayStartHour,
    Value<bool>? reminderEnabled,
    Value<int>? reminderMinutes,
    Value<bool>? seeded,
  }) {
    return SettingsEntriesCompanion(
      id: id ?? this.id,
      schemeId: schemeId ?? this.schemeId,
      customAccent: customAccent ?? this.customAccent,
      brightnessMode: brightnessMode ?? this.brightnessMode,
      dayStartHour: dayStartHour ?? this.dayStartHour,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      seeded: seeded ?? this.seeded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (schemeId.present) {
      map['scheme_id'] = Variable<String>(schemeId.value);
    }
    if (customAccent.present) {
      map['custom_accent'] = Variable<int>(customAccent.value);
    }
    if (brightnessMode.present) {
      map['brightness_mode'] = Variable<String>(brightnessMode.value);
    }
    if (dayStartHour.present) {
      map['day_start_hour'] = Variable<int>(dayStartHour.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderMinutes.present) {
      map['reminder_minutes'] = Variable<int>(reminderMinutes.value);
    }
    if (seeded.present) {
      map['seeded'] = Variable<bool>(seeded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntriesCompanion(')
          ..write('id: $id, ')
          ..write('schemeId: $schemeId, ')
          ..write('customAccent: $customAccent, ')
          ..write('brightnessMode: $brightnessMode, ')
          ..write('dayStartHour: $dayStartHour, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderMinutes: $reminderMinutes, ')
          ..write('seeded: $seeded')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskTemplatesTable taskTemplates = $TaskTemplatesTable(this);
  late final $DailyTasksTable dailyTasks = $DailyTasksTable(this);
  late final $TaskEventsTable taskEvents = $TaskEventsTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $SettingsEntriesTable settingsEntries = $SettingsEntriesTable(
    this,
  );
  late final Index dailyTasksDate = Index(
    'daily_tasks_date',
    'CREATE INDEX daily_tasks_date ON daily_tasks (date)',
  );
  late final Index taskEventsDate = Index(
    'task_events_date',
    'CREATE INDEX task_events_date ON task_events (date)',
  );
  late final Index taskEventsDailyTask = Index(
    'task_events_daily_task',
    'CREATE INDEX task_events_daily_task ON task_events (daily_task_id)',
  );
  late final TasksDao tasksDao = TasksDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskTemplates,
    dailyTasks,
    taskEvents,
    profiles,
    settingsEntries,
    dailyTasksDate,
    taskEventsDate,
    taskEventsDailyTask,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$TaskTemplatesTableCreateCompanionBuilder =
    TaskTemplatesCompanion Function({
      Value<int> id,
      required String name,
      required String icon,
      required int colorIndex,
      required String type,
      required int target,
      required int step,
      required String unit,
      required String repeatKind,
      required int repeatDays,
      Value<bool> isActive,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<DateTime?> archivedAt,
    });
typedef $$TaskTemplatesTableUpdateCompanionBuilder =
    TaskTemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icon,
      Value<int> colorIndex,
      Value<String> type,
      Value<int> target,
      Value<int> step,
      Value<String> unit,
      Value<String> repeatKind,
      Value<int> repeatDays,
      Value<bool> isActive,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime?> archivedAt,
    });

final class $$TaskTemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $TaskTemplatesTable, TemplateRow> {
  $$TaskTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DailyTasksTable, List<DailyTaskRow>>
  _dailyTasksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.dailyTasks,
    aliasName: 'task_templates__id__daily_tasks__template_id',
  );

  $$DailyTasksTableProcessedTableManager get dailyTasksRefs {
    final manager = $$DailyTasksTableTableManager(
      $_db,
      $_db.dailyTasks,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dailyTasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatKind => $composableBuilder(
    column: $table.repeatKind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dailyTasksRefs(
    Expression<bool> Function($$DailyTasksTableFilterComposer f) f,
  ) {
    final $$DailyTasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyTasks,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyTasksTableFilterComposer(
            $db: $db,
            $table: $db.dailyTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatKind => $composableBuilder(
    column: $table.repeatKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorIndex => $composableBuilder(
    column: $table.colorIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get repeatKind => $composableBuilder(
    column: $table.repeatKind,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> dailyTasksRefs<T extends Object>(
    Expression<T> Function($$DailyTasksTableAnnotationComposer a) f,
  ) {
    final $$DailyTasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyTasks,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyTasksTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyTasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskTemplatesTable,
          TemplateRow,
          $$TaskTemplatesTableFilterComposer,
          $$TaskTemplatesTableOrderingComposer,
          $$TaskTemplatesTableAnnotationComposer,
          $$TaskTemplatesTableCreateCompanionBuilder,
          $$TaskTemplatesTableUpdateCompanionBuilder,
          (TemplateRow, $$TaskTemplatesTableReferences),
          TemplateRow,
          PrefetchHooks Function({bool dailyTasksRefs})
        > {
  $$TaskTemplatesTableTableManager(_$AppDatabase db, $TaskTemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> colorIndex = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> repeatKind = const Value.absent(),
                Value<int> repeatDays = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
              }) => TaskTemplatesCompanion(
                id: id,
                name: name,
                icon: icon,
                colorIndex: colorIndex,
                type: type,
                target: target,
                step: step,
                unit: unit,
                repeatKind: repeatKind,
                repeatDays: repeatDays,
                isActive: isActive,
                sortOrder: sortOrder,
                createdAt: createdAt,
                archivedAt: archivedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String icon,
                required int colorIndex,
                required String type,
                required int target,
                required int step,
                required String unit,
                required String repeatKind,
                required int repeatDays,
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> archivedAt = const Value.absent(),
              }) => TaskTemplatesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                colorIndex: colorIndex,
                type: type,
                target: target,
                step: step,
                unit: unit,
                repeatKind: repeatKind,
                repeatDays: repeatDays,
                isActive: isActive,
                sortOrder: sortOrder,
                createdAt: createdAt,
                archivedAt: archivedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TaskTemplatesTable, TemplateRow>(table),
                  $$TaskTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyTasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (dailyTasksRefs) db.dailyTasks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyTasksRefs)
                    await $_getPrefetchedData<
                      TemplateRow,
                      $TaskTemplatesTable,
                      DailyTaskRow
                    >(
                      currentTable: table,
                      referencedTable: $$TaskTemplatesTableReferences
                          ._dailyTasksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TaskTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).dailyTasksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskTemplatesTable,
      TemplateRow,
      $$TaskTemplatesTableFilterComposer,
      $$TaskTemplatesTableOrderingComposer,
      $$TaskTemplatesTableAnnotationComposer,
      $$TaskTemplatesTableCreateCompanionBuilder,
      $$TaskTemplatesTableUpdateCompanionBuilder,
      (TemplateRow, $$TaskTemplatesTableReferences),
      TemplateRow,
      PrefetchHooks Function({bool dailyTasksRefs})
    >;
typedef $$DailyTasksTableCreateCompanionBuilder = DailyTasksCompanion Function({
  Value<int> id,
  required int templateId,
  required String date,
  Value<int> progress,
  Value<DateTime?> completedAt,
  required String name,
  required int target,
  required String unit,
  required int step,
  required String type,
});
typedef $$DailyTasksTableUpdateCompanionBuilder = DailyTasksCompanion Function({
  Value<int> id,
  Value<int> templateId,
  Value<String> date,
  Value<int> progress,
  Value<DateTime?> completedAt,
  Value<String> name,
  Value<int> target,
  Value<String> unit,
  Value<int> step,
  Value<String> type,
});

final class $$DailyTasksTableReferences
    extends BaseReferences<_$AppDatabase, $DailyTasksTable, DailyTaskRow> {
  $$DailyTasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TaskTemplatesTable _templateIdTable(_$AppDatabase db) => db
      .taskTemplates
      .createAlias('daily_tasks__template_id__task_templates__id');

  $$TaskTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<int>('template_id')!;

    final manager = $$TaskTemplatesTableTableManager(
      $_db,
      $_db.taskTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DailyTasksTableFilterComposer
    extends Composer<_$AppDatabase, $DailyTasksTable> {
  $$DailyTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskTemplatesTableFilterComposer get templateId {
    final $$TaskTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyTasksTable> {
  $$DailyTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get target => $composableBuilder(
    column: $table.target,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskTemplatesTableOrderingComposer get templateId {
    final $$TaskTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyTasksTable> {
  $$DailyTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  $$TaskTemplatesTableAnnotationComposer get templateId {
    final $$TaskTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.taskTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DailyTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyTasksTable,
          DailyTaskRow,
          $$DailyTasksTableFilterComposer,
          $$DailyTasksTableOrderingComposer,
          $$DailyTasksTableAnnotationComposer,
          $$DailyTasksTableCreateCompanionBuilder,
          $$DailyTasksTableUpdateCompanionBuilder,
          (DailyTaskRow, $$DailyTasksTableReferences),
          DailyTaskRow,
          PrefetchHooks Function({bool templateId})
        > {
  $$DailyTasksTableTableManager(_$AppDatabase db, $DailyTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> templateId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> target = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => DailyTasksCompanion(
                id: id,
                templateId: templateId,
                date: date,
                progress: progress,
                completedAt: completedAt,
                name: name,
                target: target,
                unit: unit,
                step: step,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int templateId,
                required String date,
                Value<int> progress = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required String name,
                required int target,
                required String unit,
                required int step,
                required String type,
              }) => DailyTasksCompanion.insert(
                id: id,
                templateId: templateId,
                date: date,
                progress: progress,
                completedAt: completedAt,
                name: name,
                target: target,
                unit: unit,
                step: step,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyTasksTable, DailyTaskRow>(table),
                  $$DailyTasksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (templateId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.templateId,
                        referencedTable: $$DailyTasksTableReferences
                            ._templateIdTable(db),
                        referencedColumn: $$DailyTasksTableReferences
                            ._templateIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DailyTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyTasksTable,
      DailyTaskRow,
      $$DailyTasksTableFilterComposer,
      $$DailyTasksTableOrderingComposer,
      $$DailyTasksTableAnnotationComposer,
      $$DailyTasksTableCreateCompanionBuilder,
      $$DailyTasksTableUpdateCompanionBuilder,
      (DailyTaskRow, $$DailyTasksTableReferences),
      DailyTaskRow,
      PrefetchHooks Function({bool templateId})
    >;
typedef $$TaskEventsTableCreateCompanionBuilder = TaskEventsCompanion Function({
  Value<int> id,
  Value<int?> dailyTaskId,
  Value<int?> templateId,
  required String date,
  required int delta,
  required int newProgress,
  required String kind,
  required String source,
  required DateTime occurredAt,
});
typedef $$TaskEventsTableUpdateCompanionBuilder = TaskEventsCompanion Function({
  Value<int> id,
  Value<int?> dailyTaskId,
  Value<int?> templateId,
  Value<String> date,
  Value<int> delta,
  Value<int> newProgress,
  Value<String> kind,
  Value<String> source,
  Value<DateTime> occurredAt,
});

class $$TaskEventsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskEventsTable> {
  $$TaskEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyTaskId => $composableBuilder(
    column: $table.dailyTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newProgress => $composableBuilder(
    column: $table.newProgress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskEventsTable> {
  $$TaskEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyTaskId => $composableBuilder(
    column: $table.dailyTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newProgress => $composableBuilder(
    column: $table.newProgress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskEventsTable> {
  $$TaskEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dailyTaskId => $composableBuilder(
    column: $table.dailyTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<int> get newProgress => $composableBuilder(
    column: $table.newProgress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );
}

class $$TaskEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskEventsTable,
          TaskEventRow,
          $$TaskEventsTableFilterComposer,
          $$TaskEventsTableOrderingComposer,
          $$TaskEventsTableAnnotationComposer,
          $$TaskEventsTableCreateCompanionBuilder,
          $$TaskEventsTableUpdateCompanionBuilder,
          (
            TaskEventRow,
            BaseReferences<_$AppDatabase, $TaskEventsTable, TaskEventRow>,
          ),
          TaskEventRow,
          PrefetchHooks Function()
        > {
  $$TaskEventsTableTableManager(_$AppDatabase db, $TaskEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> dailyTaskId = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> delta = const Value.absent(),
                Value<int> newProgress = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
              }) => TaskEventsCompanion(
                id: id,
                dailyTaskId: dailyTaskId,
                templateId: templateId,
                date: date,
                delta: delta,
                newProgress: newProgress,
                kind: kind,
                source: source,
                occurredAt: occurredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> dailyTaskId = const Value.absent(),
                Value<int?> templateId = const Value.absent(),
                required String date,
                required int delta,
                required int newProgress,
                required String kind,
                required String source,
                required DateTime occurredAt,
              }) => TaskEventsCompanion.insert(
                id: id,
                dailyTaskId: dailyTaskId,
                templateId: templateId,
                date: date,
                delta: delta,
                newProgress: newProgress,
                kind: kind,
                source: source,
                occurredAt: occurredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TaskEventsTable, TaskEventRow>(table),
                  BaseReferences<_$AppDatabase, $TaskEventsTable, TaskEventRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskEventsTable,
      TaskEventRow,
      $$TaskEventsTableFilterComposer,
      $$TaskEventsTableOrderingComposer,
      $$TaskEventsTableAnnotationComposer,
      $$TaskEventsTableCreateCompanionBuilder,
      $$TaskEventsTableUpdateCompanionBuilder,
      (
        TaskEventRow,
        BaseReferences<_$AppDatabase, $TaskEventsTable, TaskEventRow>,
      ),
      TaskEventRow,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required String nickname,
  required String avatarChar,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> nickname,
  Value<String> avatarChar,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarChar => $composableBuilder(
    column: $table.avatarChar,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarChar => $composableBuilder(
    column: $table.avatarChar,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get avatarChar => $composableBuilder(
    column: $table.avatarChar,
    builder: (column) => column,
  );
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nickname = const Value.absent(),
                Value<String> avatarChar = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                nickname: nickname,
                avatarChar: avatarChar,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nickname,
                required String avatarChar,
              }) => ProfilesCompanion.insert(
                id: id,
                nickname: nickname,
                avatarChar: avatarChar,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsEntriesTableCreateCompanionBuilder =
    SettingsEntriesCompanion Function({
      Value<int> id,
      required String schemeId,
      Value<int?> customAccent,
      required String brightnessMode,
      required int dayStartHour,
      required bool reminderEnabled,
      required int reminderMinutes,
      Value<bool> seeded,
    });
typedef $$SettingsEntriesTableUpdateCompanionBuilder =
    SettingsEntriesCompanion Function({
      Value<int> id,
      Value<String> schemeId,
      Value<int?> customAccent,
      Value<String> brightnessMode,
      Value<int> dayStartHour,
      Value<bool> reminderEnabled,
      Value<int> reminderMinutes,
      Value<bool> seeded,
    });

class $$SettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schemeId => $composableBuilder(
    column: $table.schemeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customAccent => $composableBuilder(
    column: $table.customAccent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brightnessMode => $composableBuilder(
    column: $table.brightnessMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayStartHour => $composableBuilder(
    column: $table.dayStartHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get seeded => $composableBuilder(
    column: $table.seeded,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schemeId => $composableBuilder(
    column: $table.schemeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customAccent => $composableBuilder(
    column: $table.customAccent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brightnessMode => $composableBuilder(
    column: $table.brightnessMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayStartHour => $composableBuilder(
    column: $table.dayStartHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get seeded => $composableBuilder(
    column: $table.seeded,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get schemeId =>
      $composableBuilder(column: $table.schemeId, builder: (column) => column);

  GeneratedColumn<int> get customAccent => $composableBuilder(
    column: $table.customAccent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brightnessMode => $composableBuilder(
    column: $table.brightnessMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayStartHour => $composableBuilder(
    column: $table.dayStartHour,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderMinutes => $composableBuilder(
    column: $table.reminderMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get seeded =>
      $composableBuilder(column: $table.seeded, builder: (column) => column);
}

class $$SettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsEntriesTable,
          SettingsRow,
          $$SettingsEntriesTableFilterComposer,
          $$SettingsEntriesTableOrderingComposer,
          $$SettingsEntriesTableAnnotationComposer,
          $$SettingsEntriesTableCreateCompanionBuilder,
          $$SettingsEntriesTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsEntriesTableTableManager(
    _$AppDatabase db,
    $SettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> schemeId = const Value.absent(),
                Value<int?> customAccent = const Value.absent(),
                Value<String> brightnessMode = const Value.absent(),
                Value<int> dayStartHour = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int> reminderMinutes = const Value.absent(),
                Value<bool> seeded = const Value.absent(),
              }) => SettingsEntriesCompanion(
                id: id,
                schemeId: schemeId,
                customAccent: customAccent,
                brightnessMode: brightnessMode,
                dayStartHour: dayStartHour,
                reminderEnabled: reminderEnabled,
                reminderMinutes: reminderMinutes,
                seeded: seeded,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String schemeId,
                Value<int?> customAccent = const Value.absent(),
                required String brightnessMode,
                required int dayStartHour,
                required bool reminderEnabled,
                required int reminderMinutes,
                Value<bool> seeded = const Value.absent(),
              }) => SettingsEntriesCompanion.insert(
                id: id,
                schemeId: schemeId,
                customAccent: customAccent,
                brightnessMode: brightnessMode,
                dayStartHour: dayStartHour,
                reminderEnabled: reminderEnabled,
                reminderMinutes: reminderMinutes,
                seeded: seeded,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsEntriesTable, SettingsRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SettingsEntriesTable,
                    SettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsEntriesTable,
      SettingsRow,
      $$SettingsEntriesTableFilterComposer,
      $$SettingsEntriesTableOrderingComposer,
      $$SettingsEntriesTableAnnotationComposer,
      $$SettingsEntriesTableCreateCompanionBuilder,
      $$SettingsEntriesTableUpdateCompanionBuilder,
      (
        SettingsRow,
        BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingsRow>,
      ),
      SettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskTemplatesTableTableManager get taskTemplates =>
      $$TaskTemplatesTableTableManager(_db, _db.taskTemplates);
  $$DailyTasksTableTableManager get dailyTasks =>
      $$DailyTasksTableTableManager(_db, _db.dailyTasks);
  $$TaskEventsTableTableManager get taskEvents =>
      $$TaskEventsTableTableManager(_db, _db.taskEvents);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$SettingsEntriesTableTableManager get settingsEntries =>
      $$SettingsEntriesTableTableManager(_db, _db.settingsEntries);
}
