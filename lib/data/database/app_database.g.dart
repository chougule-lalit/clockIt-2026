// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetWorkHoursMeta = const VerificationMeta(
    'targetWorkHours',
  );
  @override
  late final GeneratedColumn<double> targetWorkHours = GeneratedColumn<double>(
    'target_work_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(8.0),
  );
  static const VerificationMeta _targetBreakHoursMeta = const VerificationMeta(
    'targetBreakHours',
  );
  @override
  late final GeneratedColumn<double> targetBreakHours = GeneratedColumn<double>(
    'target_break_hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.75),
  );
  static const VerificationMeta _defaultStartHourMeta = const VerificationMeta(
    'defaultStartHour',
  );
  @override
  late final GeneratedColumn<int> defaultStartHour = GeneratedColumn<int>(
    'default_start_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9),
  );
  static const VerificationMeta _defaultStartMinuteMeta =
      const VerificationMeta('defaultStartMinute');
  @override
  late final GeneratedColumn<int> defaultStartMinute = GeneratedColumn<int>(
    'default_start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _notificationLeadMinsMeta =
      const VerificationMeta('notificationLeadMins');
  @override
  late final GeneratedColumn<int> notificationLeadMins = GeneratedColumn<int>(
    'notification_lead_mins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetWorkHours,
    targetBreakHours,
    defaultStartHour,
    defaultStartMinute,
    notificationLeadMins,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_work_hours')) {
      context.handle(
        _targetWorkHoursMeta,
        targetWorkHours.isAcceptableOrUnknown(
          data['target_work_hours']!,
          _targetWorkHoursMeta,
        ),
      );
    }
    if (data.containsKey('target_break_hours')) {
      context.handle(
        _targetBreakHoursMeta,
        targetBreakHours.isAcceptableOrUnknown(
          data['target_break_hours']!,
          _targetBreakHoursMeta,
        ),
      );
    }
    if (data.containsKey('default_start_hour')) {
      context.handle(
        _defaultStartHourMeta,
        defaultStartHour.isAcceptableOrUnknown(
          data['default_start_hour']!,
          _defaultStartHourMeta,
        ),
      );
    }
    if (data.containsKey('default_start_minute')) {
      context.handle(
        _defaultStartMinuteMeta,
        defaultStartMinute.isAcceptableOrUnknown(
          data['default_start_minute']!,
          _defaultStartMinuteMeta,
        ),
      );
    }
    if (data.containsKey('notification_lead_mins')) {
      context.handle(
        _notificationLeadMinsMeta,
        notificationLeadMins.isAcceptableOrUnknown(
          data['notification_lead_mins']!,
          _notificationLeadMinsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetWorkHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_work_hours'],
      )!,
      targetBreakHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_break_hours'],
      )!,
      defaultStartHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_start_hour'],
      )!,
      defaultStartMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_start_minute'],
      )!,
      notificationLeadMins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_lead_mins'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;

  /// Target total working hours per day (e.g. 8.0).
  final double targetWorkHours;

  /// Target break hours per day (e.g. 0.75 for 45 min).
  final double targetBreakHours;

  /// Default shift start hour in 24h format.
  final int defaultStartHour;

  /// Default shift start minute.
  final int defaultStartMinute;

  /// Minutes before expected logout to fire notification.
  final int notificationLeadMins;
  const UserProfile({
    required this.id,
    required this.targetWorkHours,
    required this.targetBreakHours,
    required this.defaultStartHour,
    required this.defaultStartMinute,
    required this.notificationLeadMins,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_work_hours'] = Variable<double>(targetWorkHours);
    map['target_break_hours'] = Variable<double>(targetBreakHours);
    map['default_start_hour'] = Variable<int>(defaultStartHour);
    map['default_start_minute'] = Variable<int>(defaultStartMinute);
    map['notification_lead_mins'] = Variable<int>(notificationLeadMins);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      targetWorkHours: Value(targetWorkHours),
      targetBreakHours: Value(targetBreakHours),
      defaultStartHour: Value(defaultStartHour),
      defaultStartMinute: Value(defaultStartMinute),
      notificationLeadMins: Value(notificationLeadMins),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      targetWorkHours: serializer.fromJson<double>(json['targetWorkHours']),
      targetBreakHours: serializer.fromJson<double>(json['targetBreakHours']),
      defaultStartHour: serializer.fromJson<int>(json['defaultStartHour']),
      defaultStartMinute: serializer.fromJson<int>(json['defaultStartMinute']),
      notificationLeadMins: serializer.fromJson<int>(
        json['notificationLeadMins'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetWorkHours': serializer.toJson<double>(targetWorkHours),
      'targetBreakHours': serializer.toJson<double>(targetBreakHours),
      'defaultStartHour': serializer.toJson<int>(defaultStartHour),
      'defaultStartMinute': serializer.toJson<int>(defaultStartMinute),
      'notificationLeadMins': serializer.toJson<int>(notificationLeadMins),
    };
  }

  UserProfile copyWith({
    int? id,
    double? targetWorkHours,
    double? targetBreakHours,
    int? defaultStartHour,
    int? defaultStartMinute,
    int? notificationLeadMins,
  }) => UserProfile(
    id: id ?? this.id,
    targetWorkHours: targetWorkHours ?? this.targetWorkHours,
    targetBreakHours: targetBreakHours ?? this.targetBreakHours,
    defaultStartHour: defaultStartHour ?? this.defaultStartHour,
    defaultStartMinute: defaultStartMinute ?? this.defaultStartMinute,
    notificationLeadMins: notificationLeadMins ?? this.notificationLeadMins,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      targetWorkHours: data.targetWorkHours.present
          ? data.targetWorkHours.value
          : this.targetWorkHours,
      targetBreakHours: data.targetBreakHours.present
          ? data.targetBreakHours.value
          : this.targetBreakHours,
      defaultStartHour: data.defaultStartHour.present
          ? data.defaultStartHour.value
          : this.defaultStartHour,
      defaultStartMinute: data.defaultStartMinute.present
          ? data.defaultStartMinute.value
          : this.defaultStartMinute,
      notificationLeadMins: data.notificationLeadMins.present
          ? data.notificationLeadMins.value
          : this.notificationLeadMins,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('targetWorkHours: $targetWorkHours, ')
          ..write('targetBreakHours: $targetBreakHours, ')
          ..write('defaultStartHour: $defaultStartHour, ')
          ..write('defaultStartMinute: $defaultStartMinute, ')
          ..write('notificationLeadMins: $notificationLeadMins')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetWorkHours,
    targetBreakHours,
    defaultStartHour,
    defaultStartMinute,
    notificationLeadMins,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.targetWorkHours == this.targetWorkHours &&
          other.targetBreakHours == this.targetBreakHours &&
          other.defaultStartHour == this.defaultStartHour &&
          other.defaultStartMinute == this.defaultStartMinute &&
          other.notificationLeadMins == this.notificationLeadMins);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<double> targetWorkHours;
  final Value<double> targetBreakHours;
  final Value<int> defaultStartHour;
  final Value<int> defaultStartMinute;
  final Value<int> notificationLeadMins;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.targetWorkHours = const Value.absent(),
    this.targetBreakHours = const Value.absent(),
    this.defaultStartHour = const Value.absent(),
    this.defaultStartMinute = const Value.absent(),
    this.notificationLeadMins = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.targetWorkHours = const Value.absent(),
    this.targetBreakHours = const Value.absent(),
    this.defaultStartHour = const Value.absent(),
    this.defaultStartMinute = const Value.absent(),
    this.notificationLeadMins = const Value.absent(),
  });
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<double>? targetWorkHours,
    Expression<double>? targetBreakHours,
    Expression<int>? defaultStartHour,
    Expression<int>? defaultStartMinute,
    Expression<int>? notificationLeadMins,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetWorkHours != null) 'target_work_hours': targetWorkHours,
      if (targetBreakHours != null) 'target_break_hours': targetBreakHours,
      if (defaultStartHour != null) 'default_start_hour': defaultStartHour,
      if (defaultStartMinute != null)
        'default_start_minute': defaultStartMinute,
      if (notificationLeadMins != null)
        'notification_lead_mins': notificationLeadMins,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<double>? targetWorkHours,
    Value<double>? targetBreakHours,
    Value<int>? defaultStartHour,
    Value<int>? defaultStartMinute,
    Value<int>? notificationLeadMins,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      targetWorkHours: targetWorkHours ?? this.targetWorkHours,
      targetBreakHours: targetBreakHours ?? this.targetBreakHours,
      defaultStartHour: defaultStartHour ?? this.defaultStartHour,
      defaultStartMinute: defaultStartMinute ?? this.defaultStartMinute,
      notificationLeadMins: notificationLeadMins ?? this.notificationLeadMins,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetWorkHours.present) {
      map['target_work_hours'] = Variable<double>(targetWorkHours.value);
    }
    if (targetBreakHours.present) {
      map['target_break_hours'] = Variable<double>(targetBreakHours.value);
    }
    if (defaultStartHour.present) {
      map['default_start_hour'] = Variable<int>(defaultStartHour.value);
    }
    if (defaultStartMinute.present) {
      map['default_start_minute'] = Variable<int>(defaultStartMinute.value);
    }
    if (notificationLeadMins.present) {
      map['notification_lead_mins'] = Variable<int>(notificationLeadMins.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('targetWorkHours: $targetWorkHours, ')
          ..write('targetBreakHours: $targetBreakHours, ')
          ..write('defaultStartHour: $defaultStartHour, ')
          ..write('defaultStartMinute: $defaultStartMinute, ')
          ..write('notificationLeadMins: $notificationLeadMins')
          ..write(')'))
        .toString();
  }
}

class $DailyShiftsTable extends DailyShifts
    with TableInfo<$DailyShiftsTable, DailyShift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyShiftsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clockInMeta = const VerificationMeta(
    'clockIn',
  );
  @override
  late final GeneratedColumn<DateTime> clockIn = GeneratedColumn<DateTime>(
    'clock_in',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clockOutMeta = const VerificationMeta(
    'clockOut',
  );
  @override
  late final GeneratedColumn<DateTime> clockOut = GeneratedColumn<DateTime>(
    'clock_out',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualTotalHoursMeta = const VerificationMeta(
    'actualTotalHours',
  );
  @override
  late final GeneratedColumn<double> actualTotalHours = GeneratedColumn<double>(
    'actual_total_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overtimeMeta = const VerificationMeta(
    'overtime',
  );
  @override
  late final GeneratedColumn<double> overtime = GeneratedColumn<double>(
    'overtime',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    clockIn,
    clockOut,
    actualTotalHours,
    overtime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_shifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyShift> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('clock_in')) {
      context.handle(
        _clockInMeta,
        clockIn.isAcceptableOrUnknown(data['clock_in']!, _clockInMeta),
      );
    }
    if (data.containsKey('clock_out')) {
      context.handle(
        _clockOutMeta,
        clockOut.isAcceptableOrUnknown(data['clock_out']!, _clockOutMeta),
      );
    }
    if (data.containsKey('actual_total_hours')) {
      context.handle(
        _actualTotalHoursMeta,
        actualTotalHours.isAcceptableOrUnknown(
          data['actual_total_hours']!,
          _actualTotalHoursMeta,
        ),
      );
    }
    if (data.containsKey('overtime')) {
      context.handle(
        _overtimeMeta,
        overtime.isAcceptableOrUnknown(data['overtime']!, _overtimeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyShift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyShift(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      clockIn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clock_in'],
      ),
      clockOut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clock_out'],
      ),
      actualTotalHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_total_hours'],
      ),
      overtime: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}overtime'],
      ),
    );
  }

  @override
  $DailyShiftsTable createAlias(String alias) {
    return $DailyShiftsTable(attachedDatabase, alias);
  }
}

class DailyShift extends DataClass implements Insertable<DailyShift> {
  final int id;

  /// The calendar date for this shift (stored as ISO-8601 text).
  final DateTime date;

  /// When the user clocked in. Null if shift not yet started.
  final DateTime? clockIn;

  /// When the user clocked out. Null if still in progress.
  final DateTime? clockOut;

  /// Actual total hours worked. Computed on clock-out.
  final double? actualTotalHours;

  /// Positive = overtime, negative = early logout, null = in progress.
  final double? overtime;
  const DailyShift({
    required this.id,
    required this.date,
    this.clockIn,
    this.clockOut,
    this.actualTotalHours,
    this.overtime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || clockIn != null) {
      map['clock_in'] = Variable<DateTime>(clockIn);
    }
    if (!nullToAbsent || clockOut != null) {
      map['clock_out'] = Variable<DateTime>(clockOut);
    }
    if (!nullToAbsent || actualTotalHours != null) {
      map['actual_total_hours'] = Variable<double>(actualTotalHours);
    }
    if (!nullToAbsent || overtime != null) {
      map['overtime'] = Variable<double>(overtime);
    }
    return map;
  }

  DailyShiftsCompanion toCompanion(bool nullToAbsent) {
    return DailyShiftsCompanion(
      id: Value(id),
      date: Value(date),
      clockIn: clockIn == null && nullToAbsent
          ? const Value.absent()
          : Value(clockIn),
      clockOut: clockOut == null && nullToAbsent
          ? const Value.absent()
          : Value(clockOut),
      actualTotalHours: actualTotalHours == null && nullToAbsent
          ? const Value.absent()
          : Value(actualTotalHours),
      overtime: overtime == null && nullToAbsent
          ? const Value.absent()
          : Value(overtime),
    );
  }

  factory DailyShift.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyShift(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      clockIn: serializer.fromJson<DateTime?>(json['clockIn']),
      clockOut: serializer.fromJson<DateTime?>(json['clockOut']),
      actualTotalHours: serializer.fromJson<double?>(json['actualTotalHours']),
      overtime: serializer.fromJson<double?>(json['overtime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'clockIn': serializer.toJson<DateTime?>(clockIn),
      'clockOut': serializer.toJson<DateTime?>(clockOut),
      'actualTotalHours': serializer.toJson<double?>(actualTotalHours),
      'overtime': serializer.toJson<double?>(overtime),
    };
  }

  DailyShift copyWith({
    int? id,
    DateTime? date,
    Value<DateTime?> clockIn = const Value.absent(),
    Value<DateTime?> clockOut = const Value.absent(),
    Value<double?> actualTotalHours = const Value.absent(),
    Value<double?> overtime = const Value.absent(),
  }) => DailyShift(
    id: id ?? this.id,
    date: date ?? this.date,
    clockIn: clockIn.present ? clockIn.value : this.clockIn,
    clockOut: clockOut.present ? clockOut.value : this.clockOut,
    actualTotalHours: actualTotalHours.present
        ? actualTotalHours.value
        : this.actualTotalHours,
    overtime: overtime.present ? overtime.value : this.overtime,
  );
  DailyShift copyWithCompanion(DailyShiftsCompanion data) {
    return DailyShift(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      clockIn: data.clockIn.present ? data.clockIn.value : this.clockIn,
      clockOut: data.clockOut.present ? data.clockOut.value : this.clockOut,
      actualTotalHours: data.actualTotalHours.present
          ? data.actualTotalHours.value
          : this.actualTotalHours,
      overtime: data.overtime.present ? data.overtime.value : this.overtime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyShift(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('actualTotalHours: $actualTotalHours, ')
          ..write('overtime: $overtime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, clockIn, clockOut, actualTotalHours, overtime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyShift &&
          other.id == this.id &&
          other.date == this.date &&
          other.clockIn == this.clockIn &&
          other.clockOut == this.clockOut &&
          other.actualTotalHours == this.actualTotalHours &&
          other.overtime == this.overtime);
}

class DailyShiftsCompanion extends UpdateCompanion<DailyShift> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<DateTime?> clockIn;
  final Value<DateTime?> clockOut;
  final Value<double?> actualTotalHours;
  final Value<double?> overtime;
  const DailyShiftsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.actualTotalHours = const Value.absent(),
    this.overtime = const Value.absent(),
  });
  DailyShiftsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.actualTotalHours = const Value.absent(),
    this.overtime = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailyShift> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<DateTime>? clockIn,
    Expression<DateTime>? clockOut,
    Expression<double>? actualTotalHours,
    Expression<double>? overtime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (clockIn != null) 'clock_in': clockIn,
      if (clockOut != null) 'clock_out': clockOut,
      if (actualTotalHours != null) 'actual_total_hours': actualTotalHours,
      if (overtime != null) 'overtime': overtime,
    });
  }

  DailyShiftsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<DateTime?>? clockIn,
    Value<DateTime?>? clockOut,
    Value<double?>? actualTotalHours,
    Value<double?>? overtime,
  }) {
    return DailyShiftsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      actualTotalHours: actualTotalHours ?? this.actualTotalHours,
      overtime: overtime ?? this.overtime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (clockIn.present) {
      map['clock_in'] = Variable<DateTime>(clockIn.value);
    }
    if (clockOut.present) {
      map['clock_out'] = Variable<DateTime>(clockOut.value);
    }
    if (actualTotalHours.present) {
      map['actual_total_hours'] = Variable<double>(actualTotalHours.value);
    }
    if (overtime.present) {
      map['overtime'] = Variable<double>(overtime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyShiftsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('actualTotalHours: $actualTotalHours, ')
          ..write('overtime: $overtime')
          ..write(')'))
        .toString();
  }
}

class $TimesheetBucketsTable extends TimesheetBuckets
    with TableInfo<$TimesheetBucketsTable, TimesheetBucket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimesheetBucketsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _officialNameMeta = const VerificationMeta(
    'officialName',
  );
  @override
  late final GeneratedColumn<String> officialName = GeneratedColumn<String>(
    'official_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, officialName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timesheet_buckets';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimesheetBucket> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('official_name')) {
      context.handle(
        _officialNameMeta,
        officialName.isAcceptableOrUnknown(
          data['official_name']!,
          _officialNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_officialNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimesheetBucket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimesheetBucket(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      officialName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}official_name'],
      )!,
    );
  }

  @override
  $TimesheetBucketsTable createAlias(String alias) {
    return $TimesheetBucketsTable(attachedDatabase, alias);
  }
}

class TimesheetBucket extends DataClass implements Insertable<TimesheetBucket> {
  final int id;

  /// The official name matching the organisation's timesheet system.
  final String officialName;
  const TimesheetBucket({required this.id, required this.officialName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['official_name'] = Variable<String>(officialName);
    return map;
  }

  TimesheetBucketsCompanion toCompanion(bool nullToAbsent) {
    return TimesheetBucketsCompanion(
      id: Value(id),
      officialName: Value(officialName),
    );
  }

  factory TimesheetBucket.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimesheetBucket(
      id: serializer.fromJson<int>(json['id']),
      officialName: serializer.fromJson<String>(json['officialName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'officialName': serializer.toJson<String>(officialName),
    };
  }

  TimesheetBucket copyWith({int? id, String? officialName}) => TimesheetBucket(
    id: id ?? this.id,
    officialName: officialName ?? this.officialName,
  );
  TimesheetBucket copyWithCompanion(TimesheetBucketsCompanion data) {
    return TimesheetBucket(
      id: data.id.present ? data.id.value : this.id,
      officialName: data.officialName.present
          ? data.officialName.value
          : this.officialName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimesheetBucket(')
          ..write('id: $id, ')
          ..write('officialName: $officialName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, officialName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimesheetBucket &&
          other.id == this.id &&
          other.officialName == this.officialName);
}

class TimesheetBucketsCompanion extends UpdateCompanion<TimesheetBucket> {
  final Value<int> id;
  final Value<String> officialName;
  const TimesheetBucketsCompanion({
    this.id = const Value.absent(),
    this.officialName = const Value.absent(),
  });
  TimesheetBucketsCompanion.insert({
    this.id = const Value.absent(),
    required String officialName,
  }) : officialName = Value(officialName);
  static Insertable<TimesheetBucket> custom({
    Expression<int>? id,
    Expression<String>? officialName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (officialName != null) 'official_name': officialName,
    });
  }

  TimesheetBucketsCompanion copyWith({
    Value<int>? id,
    Value<String>? officialName,
  }) {
    return TimesheetBucketsCompanion(
      id: id ?? this.id,
      officialName: officialName ?? this.officialName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (officialName.present) {
      map['official_name'] = Variable<String>(officialName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimesheetBucketsCompanion(')
          ..write('id: $id, ')
          ..write('officialName: $officialName')
          ..write(')'))
        .toString();
  }
}

class $CategoryTagsTable extends CategoryTags
    with TableInfo<$CategoryTagsTable, CategoryTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryTagsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tagNameMeta = const VerificationMeta(
    'tagName',
  );
  @override
  late final GeneratedColumn<String> tagName = GeneratedColumn<String>(
    'tag_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _bucketIdMeta = const VerificationMeta(
    'bucketId',
  );
  @override
  late final GeneratedColumn<int> bucketId = GeneratedColumn<int>(
    'bucket_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES timesheet_buckets (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, tagName, bucketId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tag_name')) {
      context.handle(
        _tagNameMeta,
        tagName.isAcceptableOrUnknown(data['tag_name']!, _tagNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tagNameMeta);
    }
    if (data.containsKey('bucket_id')) {
      context.handle(
        _bucketIdMeta,
        bucketId.isAcceptableOrUnknown(data['bucket_id']!, _bucketIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tagName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_name'],
      )!,
      bucketId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bucket_id'],
      ),
    );
  }

  @override
  $CategoryTagsTable createAlias(String alias) {
    return $CategoryTagsTable(attachedDatabase, alias);
  }
}

class CategoryTag extends DataClass implements Insertable<CategoryTag> {
  final int id;

  /// Display name shown on chips in the timeline.
  final String tagName;

  /// FK to [TimesheetBuckets]. Null if unmapped.
  final int? bucketId;
  const CategoryTag({required this.id, required this.tagName, this.bucketId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tag_name'] = Variable<String>(tagName);
    if (!nullToAbsent || bucketId != null) {
      map['bucket_id'] = Variable<int>(bucketId);
    }
    return map;
  }

  CategoryTagsCompanion toCompanion(bool nullToAbsent) {
    return CategoryTagsCompanion(
      id: Value(id),
      tagName: Value(tagName),
      bucketId: bucketId == null && nullToAbsent
          ? const Value.absent()
          : Value(bucketId),
    );
  }

  factory CategoryTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryTag(
      id: serializer.fromJson<int>(json['id']),
      tagName: serializer.fromJson<String>(json['tagName']),
      bucketId: serializer.fromJson<int?>(json['bucketId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tagName': serializer.toJson<String>(tagName),
      'bucketId': serializer.toJson<int?>(bucketId),
    };
  }

  CategoryTag copyWith({
    int? id,
    String? tagName,
    Value<int?> bucketId = const Value.absent(),
  }) => CategoryTag(
    id: id ?? this.id,
    tagName: tagName ?? this.tagName,
    bucketId: bucketId.present ? bucketId.value : this.bucketId,
  );
  CategoryTag copyWithCompanion(CategoryTagsCompanion data) {
    return CategoryTag(
      id: data.id.present ? data.id.value : this.id,
      tagName: data.tagName.present ? data.tagName.value : this.tagName,
      bucketId: data.bucketId.present ? data.bucketId.value : this.bucketId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTag(')
          ..write('id: $id, ')
          ..write('tagName: $tagName, ')
          ..write('bucketId: $bucketId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tagName, bucketId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryTag &&
          other.id == this.id &&
          other.tagName == this.tagName &&
          other.bucketId == this.bucketId);
}

class CategoryTagsCompanion extends UpdateCompanion<CategoryTag> {
  final Value<int> id;
  final Value<String> tagName;
  final Value<int?> bucketId;
  const CategoryTagsCompanion({
    this.id = const Value.absent(),
    this.tagName = const Value.absent(),
    this.bucketId = const Value.absent(),
  });
  CategoryTagsCompanion.insert({
    this.id = const Value.absent(),
    required String tagName,
    this.bucketId = const Value.absent(),
  }) : tagName = Value(tagName);
  static Insertable<CategoryTag> custom({
    Expression<int>? id,
    Expression<String>? tagName,
    Expression<int>? bucketId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tagName != null) 'tag_name': tagName,
      if (bucketId != null) 'bucket_id': bucketId,
    });
  }

  CategoryTagsCompanion copyWith({
    Value<int>? id,
    Value<String>? tagName,
    Value<int?>? bucketId,
  }) {
    return CategoryTagsCompanion(
      id: id ?? this.id,
      tagName: tagName ?? this.tagName,
      bucketId: bucketId ?? this.bucketId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tagName.present) {
      map['tag_name'] = Variable<String>(tagName.value);
    }
    if (bucketId.present) {
      map['bucket_id'] = Variable<int>(bucketId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryTagsCompanion(')
          ..write('id: $id, ')
          ..write('tagName: $tagName, ')
          ..write('bucketId: $bucketId')
          ..write(')'))
        .toString();
  }
}

class $TaskItemsTable extends TaskItems
    with TableInfo<$TaskItemsTable, TaskItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category_tags (id)',
    ),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    description,
    categoryId,
    isCompleted,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TaskItemsTable createAlias(String alias) {
    return $TaskItemsTable(attachedDatabase, alias);
  }
}

class TaskItem extends DataClass implements Insertable<TaskItem> {
  final int id;

  /// Task title / description (e.g. "JIRA-4822 Code Review").
  final String description;

  /// FK to [CategoryTags]. Null if not categorised.
  final int? categoryId;

  /// Whether the task has been completed.
  final bool isCompleted;

  /// When the task was created (used for daily rollover in Phase 4).
  final DateTime createdAt;
  const TaskItem({
    required this.id,
    required this.description,
    this.categoryId,
    required this.isCompleted,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskItemsCompanion toCompanion(bool nullToAbsent) {
    return TaskItemsCompanion(
      id: Value(id),
      description: Value(description),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
    );
  }

  factory TaskItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskItem(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'categoryId': serializer.toJson<int?>(categoryId),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskItem copyWith({
    int? id,
    String? description,
    Value<int?> categoryId = const Value.absent(),
    bool? isCompleted,
    DateTime? createdAt,
  }) => TaskItem(
    id: id ?? this.id,
    description: description ?? this.description,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskItem copyWithCompanion(TaskItemsCompanion data) {
    return TaskItem(
      id: data.id.present ? data.id.value : this.id,
      description: data.description.present
          ? data.description.value
          : this.description,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskItem(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, description, categoryId, isCompleted, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskItem &&
          other.id == this.id &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt);
}

class TaskItemsCompanion extends UpdateCompanion<TaskItem> {
  final Value<int> id;
  final Value<String> description;
  final Value<int?> categoryId;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  const TaskItemsCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TaskItemsCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    this.categoryId = const Value.absent(),
    this.isCompleted = const Value.absent(),
    required DateTime createdAt,
  }) : description = Value(description),
       createdAt = Value(createdAt);
  static Insertable<TaskItem> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TaskItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? description,
    Value<int?>? categoryId,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
  }) {
    return TaskItemsCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskItemsCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TimelineEntriesTable extends TimelineEntries
    with TableInfo<$TimelineEntriesTable, TimelineEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimelineEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_shifts (id)',
    ),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category_tags (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shiftId,
    startTime,
    endTime,
    categoryId,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timeline_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimelineEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimelineEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimelineEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift_id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $TimelineEntriesTable createAlias(String alias) {
    return $TimelineEntriesTable(attachedDatabase, alias);
  }
}

class TimelineEntry extends DataClass implements Insertable<TimelineEntry> {
  final int id;

  /// FK to the parent [DailyShifts].
  final int shiftId;

  /// Block start time.
  final DateTime startTime;

  /// Block end time.
  final DateTime endTime;

  /// FK to [CategoryTags]. Null if uncategorised.
  final int? categoryId;

  /// Free-text description (e.g. "JIRA-4822 Code Review").
  final String description;
  const TimelineEntry({
    required this.id,
    required this.shiftId,
    required this.startTime,
    required this.endTime,
    this.categoryId,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shift_id'] = Variable<int>(shiftId);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['description'] = Variable<String>(description);
    return map;
  }

  TimelineEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimelineEntriesCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      description: Value(description),
    );
  }

  factory TimelineEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimelineEntry(
      id: serializer.fromJson<int>(json['id']),
      shiftId: serializer.fromJson<int>(json['shiftId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shiftId': serializer.toJson<int>(shiftId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'categoryId': serializer.toJson<int?>(categoryId),
      'description': serializer.toJson<String>(description),
    };
  }

  TimelineEntry copyWith({
    int? id,
    int? shiftId,
    DateTime? startTime,
    DateTime? endTime,
    Value<int?> categoryId = const Value.absent(),
    String? description,
  }) => TimelineEntry(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    description: description ?? this.description,
  );
  TimelineEntry copyWithCompanion(TimelineEntriesCompanion data) {
    return TimelineEntry(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimelineEntry(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, shiftId, startTime, endTime, categoryId, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineEntry &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.categoryId == this.categoryId &&
          other.description == this.description);
}

class TimelineEntriesCompanion extends UpdateCompanion<TimelineEntry> {
  final Value<int> id;
  final Value<int> shiftId;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<int?> categoryId;
  final Value<String> description;
  const TimelineEntriesCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
  });
  TimelineEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int shiftId,
    required DateTime startTime,
    required DateTime endTime,
    this.categoryId = const Value.absent(),
    this.description = const Value.absent(),
  }) : shiftId = Value(shiftId),
       startTime = Value(startTime),
       endTime = Value(endTime);
  static Insertable<TimelineEntry> custom({
    Expression<int>? id,
    Expression<int>? shiftId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? categoryId,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (categoryId != null) 'category_id': categoryId,
      if (description != null) 'description': description,
    });
  }

  TimelineEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? shiftId,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<int?>? categoryId,
    Value<String>? description,
  }) {
    return TimelineEntriesCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimelineEntriesCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('categoryId: $categoryId, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $DailyShiftsTable dailyShifts = $DailyShiftsTable(this);
  late final $TimesheetBucketsTable timesheetBuckets = $TimesheetBucketsTable(
    this,
  );
  late final $CategoryTagsTable categoryTags = $CategoryTagsTable(this);
  late final $TaskItemsTable taskItems = $TaskItemsTable(this);
  late final $TimelineEntriesTable timelineEntries = $TimelineEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    dailyShifts,
    timesheetBuckets,
    categoryTags,
    taskItems,
    timelineEntries,
  ];
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<double> targetWorkHours,
      Value<double> targetBreakHours,
      Value<int> defaultStartHour,
      Value<int> defaultStartMinute,
      Value<int> notificationLeadMins,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<double> targetWorkHours,
      Value<double> targetBreakHours,
      Value<int> defaultStartHour,
      Value<int> defaultStartMinute,
      Value<int> notificationLeadMins,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
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

  ColumnFilters<double> get targetWorkHours => $composableBuilder(
    column: $table.targetWorkHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetBreakHours => $composableBuilder(
    column: $table.targetBreakHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultStartHour => $composableBuilder(
    column: $table.defaultStartHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultStartMinute => $composableBuilder(
    column: $table.defaultStartMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationLeadMins => $composableBuilder(
    column: $table.notificationLeadMins,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
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

  ColumnOrderings<double> get targetWorkHours => $composableBuilder(
    column: $table.targetWorkHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetBreakHours => $composableBuilder(
    column: $table.targetBreakHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultStartHour => $composableBuilder(
    column: $table.defaultStartHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultStartMinute => $composableBuilder(
    column: $table.defaultStartMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationLeadMins => $composableBuilder(
    column: $table.notificationLeadMins,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get targetWorkHours => $composableBuilder(
    column: $table.targetWorkHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetBreakHours => $composableBuilder(
    column: $table.targetBreakHours,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultStartHour => $composableBuilder(
    column: $table.defaultStartHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultStartMinute => $composableBuilder(
    column: $table.defaultStartMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationLeadMins => $composableBuilder(
    column: $table.notificationLeadMins,
    builder: (column) => column,
  );
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> targetWorkHours = const Value.absent(),
                Value<double> targetBreakHours = const Value.absent(),
                Value<int> defaultStartHour = const Value.absent(),
                Value<int> defaultStartMinute = const Value.absent(),
                Value<int> notificationLeadMins = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                targetWorkHours: targetWorkHours,
                targetBreakHours: targetBreakHours,
                defaultStartHour: defaultStartHour,
                defaultStartMinute: defaultStartMinute,
                notificationLeadMins: notificationLeadMins,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> targetWorkHours = const Value.absent(),
                Value<double> targetBreakHours = const Value.absent(),
                Value<int> defaultStartHour = const Value.absent(),
                Value<int> defaultStartMinute = const Value.absent(),
                Value<int> notificationLeadMins = const Value.absent(),
              }) => UserProfilesCompanion.insert(
                id: id,
                targetWorkHours: targetWorkHours,
                targetBreakHours: targetBreakHours,
                defaultStartHour: defaultStartHour,
                defaultStartMinute: defaultStartMinute,
                notificationLeadMins: notificationLeadMins,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$DailyShiftsTableCreateCompanionBuilder =
    DailyShiftsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<DateTime?> clockIn,
      Value<DateTime?> clockOut,
      Value<double?> actualTotalHours,
      Value<double?> overtime,
    });
typedef $$DailyShiftsTableUpdateCompanionBuilder =
    DailyShiftsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<DateTime?> clockIn,
      Value<DateTime?> clockOut,
      Value<double?> actualTotalHours,
      Value<double?> overtime,
    });

final class $$DailyShiftsTableReferences
    extends BaseReferences<_$AppDatabase, $DailyShiftsTable, DailyShift> {
  $$DailyShiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TimelineEntriesTable, List<TimelineEntry>>
  _timelineEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timelineEntries,
    aliasName: $_aliasNameGenerator(
      db.dailyShifts.id,
      db.timelineEntries.shiftId,
    ),
  );

  $$TimelineEntriesTableProcessedTableManager get timelineEntriesRefs {
    final manager = $$TimelineEntriesTableTableManager(
      $_db,
      $_db.timelineEntries,
    ).filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _timelineEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyShiftsTable> {
  $$DailyShiftsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualTotalHours => $composableBuilder(
    column: $table.actualTotalHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overtime => $composableBuilder(
    column: $table.overtime,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> timelineEntriesRefs(
    Expression<bool> Function($$TimelineEntriesTableFilterComposer f) f,
  ) {
    final $$TimelineEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timelineEntries,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimelineEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timelineEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyShiftsTable> {
  $$DailyShiftsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualTotalHours => $composableBuilder(
    column: $table.actualTotalHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overtime => $composableBuilder(
    column: $table.overtime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyShiftsTable> {
  $$DailyShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get clockIn =>
      $composableBuilder(column: $table.clockIn, builder: (column) => column);

  GeneratedColumn<DateTime> get clockOut =>
      $composableBuilder(column: $table.clockOut, builder: (column) => column);

  GeneratedColumn<double> get actualTotalHours => $composableBuilder(
    column: $table.actualTotalHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get overtime =>
      $composableBuilder(column: $table.overtime, builder: (column) => column);

  Expression<T> timelineEntriesRefs<T extends Object>(
    Expression<T> Function($$TimelineEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimelineEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timelineEntries,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimelineEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timelineEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyShiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyShiftsTable,
          DailyShift,
          $$DailyShiftsTableFilterComposer,
          $$DailyShiftsTableOrderingComposer,
          $$DailyShiftsTableAnnotationComposer,
          $$DailyShiftsTableCreateCompanionBuilder,
          $$DailyShiftsTableUpdateCompanionBuilder,
          (DailyShift, $$DailyShiftsTableReferences),
          DailyShift,
          PrefetchHooks Function({bool timelineEntriesRefs})
        > {
  $$DailyShiftsTableTableManager(_$AppDatabase db, $DailyShiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<DateTime?> clockIn = const Value.absent(),
                Value<DateTime?> clockOut = const Value.absent(),
                Value<double?> actualTotalHours = const Value.absent(),
                Value<double?> overtime = const Value.absent(),
              }) => DailyShiftsCompanion(
                id: id,
                date: date,
                clockIn: clockIn,
                clockOut: clockOut,
                actualTotalHours: actualTotalHours,
                overtime: overtime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<DateTime?> clockIn = const Value.absent(),
                Value<DateTime?> clockOut = const Value.absent(),
                Value<double?> actualTotalHours = const Value.absent(),
                Value<double?> overtime = const Value.absent(),
              }) => DailyShiftsCompanion.insert(
                id: id,
                date: date,
                clockIn: clockIn,
                clockOut: clockOut,
                actualTotalHours: actualTotalHours,
                overtime: overtime,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyShiftsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({timelineEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (timelineEntriesRefs) db.timelineEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (timelineEntriesRefs)
                    await $_getPrefetchedData<
                      DailyShift,
                      $DailyShiftsTable,
                      TimelineEntry
                    >(
                      currentTable: table,
                      referencedTable: $$DailyShiftsTableReferences
                          ._timelineEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DailyShiftsTableReferences(
                            db,
                            table,
                            p0,
                          ).timelineEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.shiftId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DailyShiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyShiftsTable,
      DailyShift,
      $$DailyShiftsTableFilterComposer,
      $$DailyShiftsTableOrderingComposer,
      $$DailyShiftsTableAnnotationComposer,
      $$DailyShiftsTableCreateCompanionBuilder,
      $$DailyShiftsTableUpdateCompanionBuilder,
      (DailyShift, $$DailyShiftsTableReferences),
      DailyShift,
      PrefetchHooks Function({bool timelineEntriesRefs})
    >;
typedef $$TimesheetBucketsTableCreateCompanionBuilder =
    TimesheetBucketsCompanion Function({
      Value<int> id,
      required String officialName,
    });
typedef $$TimesheetBucketsTableUpdateCompanionBuilder =
    TimesheetBucketsCompanion Function({
      Value<int> id,
      Value<String> officialName,
    });

final class $$TimesheetBucketsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TimesheetBucketsTable, TimesheetBucket> {
  $$TimesheetBucketsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CategoryTagsTable, List<CategoryTag>>
  _categoryTagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.categoryTags,
    aliasName: $_aliasNameGenerator(
      db.timesheetBuckets.id,
      db.categoryTags.bucketId,
    ),
  );

  $$CategoryTagsTableProcessedTableManager get categoryTagsRefs {
    final manager = $$CategoryTagsTableTableManager(
      $_db,
      $_db.categoryTags,
    ).filter((f) => f.bucketId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoryTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TimesheetBucketsTableFilterComposer
    extends Composer<_$AppDatabase, $TimesheetBucketsTable> {
  $$TimesheetBucketsTableFilterComposer({
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

  ColumnFilters<String> get officialName => $composableBuilder(
    column: $table.officialName,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoryTagsRefs(
    Expression<bool> Function($$CategoryTagsTableFilterComposer f) f,
  ) {
    final $$CategoryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryTags,
      getReferencedColumn: (t) => t.bucketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTagsTableFilterComposer(
            $db: $db,
            $table: $db.categoryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimesheetBucketsTableOrderingComposer
    extends Composer<_$AppDatabase, $TimesheetBucketsTable> {
  $$TimesheetBucketsTableOrderingComposer({
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

  ColumnOrderings<String> get officialName => $composableBuilder(
    column: $table.officialName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TimesheetBucketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimesheetBucketsTable> {
  $$TimesheetBucketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get officialName => $composableBuilder(
    column: $table.officialName,
    builder: (column) => column,
  );

  Expression<T> categoryTagsRefs<T extends Object>(
    Expression<T> Function($$CategoryTagsTableAnnotationComposer a) f,
  ) {
    final $$CategoryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryTags,
      getReferencedColumn: (t) => t.bucketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimesheetBucketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimesheetBucketsTable,
          TimesheetBucket,
          $$TimesheetBucketsTableFilterComposer,
          $$TimesheetBucketsTableOrderingComposer,
          $$TimesheetBucketsTableAnnotationComposer,
          $$TimesheetBucketsTableCreateCompanionBuilder,
          $$TimesheetBucketsTableUpdateCompanionBuilder,
          (TimesheetBucket, $$TimesheetBucketsTableReferences),
          TimesheetBucket,
          PrefetchHooks Function({bool categoryTagsRefs})
        > {
  $$TimesheetBucketsTableTableManager(
    _$AppDatabase db,
    $TimesheetBucketsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimesheetBucketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimesheetBucketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimesheetBucketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> officialName = const Value.absent(),
              }) =>
                  TimesheetBucketsCompanion(id: id, officialName: officialName),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String officialName,
              }) => TimesheetBucketsCompanion.insert(
                id: id,
                officialName: officialName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimesheetBucketsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (categoryTagsRefs) db.categoryTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (categoryTagsRefs)
                    await $_getPrefetchedData<
                      TimesheetBucket,
                      $TimesheetBucketsTable,
                      CategoryTag
                    >(
                      currentTable: table,
                      referencedTable: $$TimesheetBucketsTableReferences
                          ._categoryTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TimesheetBucketsTableReferences(
                            db,
                            table,
                            p0,
                          ).categoryTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.bucketId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TimesheetBucketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimesheetBucketsTable,
      TimesheetBucket,
      $$TimesheetBucketsTableFilterComposer,
      $$TimesheetBucketsTableOrderingComposer,
      $$TimesheetBucketsTableAnnotationComposer,
      $$TimesheetBucketsTableCreateCompanionBuilder,
      $$TimesheetBucketsTableUpdateCompanionBuilder,
      (TimesheetBucket, $$TimesheetBucketsTableReferences),
      TimesheetBucket,
      PrefetchHooks Function({bool categoryTagsRefs})
    >;
typedef $$CategoryTagsTableCreateCompanionBuilder =
    CategoryTagsCompanion Function({
      Value<int> id,
      required String tagName,
      Value<int?> bucketId,
    });
typedef $$CategoryTagsTableUpdateCompanionBuilder =
    CategoryTagsCompanion Function({
      Value<int> id,
      Value<String> tagName,
      Value<int?> bucketId,
    });

final class $$CategoryTagsTableReferences
    extends BaseReferences<_$AppDatabase, $CategoryTagsTable, CategoryTag> {
  $$CategoryTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TimesheetBucketsTable _bucketIdTable(_$AppDatabase db) =>
      db.timesheetBuckets.createAlias(
        $_aliasNameGenerator(db.categoryTags.bucketId, db.timesheetBuckets.id),
      );

  $$TimesheetBucketsTableProcessedTableManager? get bucketId {
    final $_column = $_itemColumn<int>('bucket_id');
    if ($_column == null) return null;
    final manager = $$TimesheetBucketsTableTableManager(
      $_db,
      $_db.timesheetBuckets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bucketIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskItemsTable, List<TaskItem>>
  _taskItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskItems,
    aliasName: $_aliasNameGenerator(
      db.categoryTags.id,
      db.taskItems.categoryId,
    ),
  );

  $$TaskItemsTableProcessedTableManager get taskItemsRefs {
    final manager = $$TaskItemsTableTableManager(
      $_db,
      $_db.taskItems,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimelineEntriesTable, List<TimelineEntry>>
  _timelineEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timelineEntries,
    aliasName: $_aliasNameGenerator(
      db.categoryTags.id,
      db.timelineEntries.categoryId,
    ),
  );

  $$TimelineEntriesTableProcessedTableManager get timelineEntriesRefs {
    final manager = $$TimelineEntriesTableTableManager(
      $_db,
      $_db.timelineEntries,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _timelineEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoryTagsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryTagsTable> {
  $$CategoryTagsTableFilterComposer({
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

  ColumnFilters<String> get tagName => $composableBuilder(
    column: $table.tagName,
    builder: (column) => ColumnFilters(column),
  );

  $$TimesheetBucketsTableFilterComposer get bucketId {
    final $$TimesheetBucketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bucketId,
      referencedTable: $db.timesheetBuckets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimesheetBucketsTableFilterComposer(
            $db: $db,
            $table: $db.timesheetBuckets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskItemsRefs(
    Expression<bool> Function($$TaskItemsTableFilterComposer f) f,
  ) {
    final $$TaskItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskItems,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskItemsTableFilterComposer(
            $db: $db,
            $table: $db.taskItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timelineEntriesRefs(
    Expression<bool> Function($$TimelineEntriesTableFilterComposer f) f,
  ) {
    final $$TimelineEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timelineEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimelineEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timelineEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryTagsTable> {
  $$CategoryTagsTableOrderingComposer({
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

  ColumnOrderings<String> get tagName => $composableBuilder(
    column: $table.tagName,
    builder: (column) => ColumnOrderings(column),
  );

  $$TimesheetBucketsTableOrderingComposer get bucketId {
    final $$TimesheetBucketsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bucketId,
      referencedTable: $db.timesheetBuckets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimesheetBucketsTableOrderingComposer(
            $db: $db,
            $table: $db.timesheetBuckets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryTagsTable> {
  $$CategoryTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tagName =>
      $composableBuilder(column: $table.tagName, builder: (column) => column);

  $$TimesheetBucketsTableAnnotationComposer get bucketId {
    final $$TimesheetBucketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bucketId,
      referencedTable: $db.timesheetBuckets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimesheetBucketsTableAnnotationComposer(
            $db: $db,
            $table: $db.timesheetBuckets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskItemsRefs<T extends Object>(
    Expression<T> Function($$TaskItemsTableAnnotationComposer a) f,
  ) {
    final $$TaskItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskItems,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timelineEntriesRefs<T extends Object>(
    Expression<T> Function($$TimelineEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimelineEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timelineEntries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimelineEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timelineEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryTagsTable,
          CategoryTag,
          $$CategoryTagsTableFilterComposer,
          $$CategoryTagsTableOrderingComposer,
          $$CategoryTagsTableAnnotationComposer,
          $$CategoryTagsTableCreateCompanionBuilder,
          $$CategoryTagsTableUpdateCompanionBuilder,
          (CategoryTag, $$CategoryTagsTableReferences),
          CategoryTag,
          PrefetchHooks Function({
            bool bucketId,
            bool taskItemsRefs,
            bool timelineEntriesRefs,
          })
        > {
  $$CategoryTagsTableTableManager(_$AppDatabase db, $CategoryTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tagName = const Value.absent(),
                Value<int?> bucketId = const Value.absent(),
              }) => CategoryTagsCompanion(
                id: id,
                tagName: tagName,
                bucketId: bucketId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String tagName,
                Value<int?> bucketId = const Value.absent(),
              }) => CategoryTagsCompanion.insert(
                id: id,
                tagName: tagName,
                bucketId: bucketId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoryTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bucketId = false,
                taskItemsRefs = false,
                timelineEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskItemsRefs) db.taskItems,
                    if (timelineEntriesRefs) db.timelineEntries,
                  ],
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
                        if (bucketId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bucketId,
                                    referencedTable:
                                        $$CategoryTagsTableReferences
                                            ._bucketIdTable(db),
                                    referencedColumn:
                                        $$CategoryTagsTableReferences
                                            ._bucketIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskItemsRefs)
                        await $_getPrefetchedData<
                          CategoryTag,
                          $CategoryTagsTable,
                          TaskItem
                        >(
                          currentTable: table,
                          referencedTable: $$CategoryTagsTableReferences
                              ._taskItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoryTagsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timelineEntriesRefs)
                        await $_getPrefetchedData<
                          CategoryTag,
                          $CategoryTagsTable,
                          TimelineEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CategoryTagsTableReferences
                              ._timelineEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoryTagsTableReferences(
                                db,
                                table,
                                p0,
                              ).timelineEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoryTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryTagsTable,
      CategoryTag,
      $$CategoryTagsTableFilterComposer,
      $$CategoryTagsTableOrderingComposer,
      $$CategoryTagsTableAnnotationComposer,
      $$CategoryTagsTableCreateCompanionBuilder,
      $$CategoryTagsTableUpdateCompanionBuilder,
      (CategoryTag, $$CategoryTagsTableReferences),
      CategoryTag,
      PrefetchHooks Function({
        bool bucketId,
        bool taskItemsRefs,
        bool timelineEntriesRefs,
      })
    >;
typedef $$TaskItemsTableCreateCompanionBuilder =
    TaskItemsCompanion Function({
      Value<int> id,
      required String description,
      Value<int?> categoryId,
      Value<bool> isCompleted,
      required DateTime createdAt,
    });
typedef $$TaskItemsTableUpdateCompanionBuilder =
    TaskItemsCompanion Function({
      Value<int> id,
      Value<String> description,
      Value<int?> categoryId,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
    });

final class $$TaskItemsTableReferences
    extends BaseReferences<_$AppDatabase, $TaskItemsTable, TaskItem> {
  $$TaskItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoryTagsTable _categoryIdTable(_$AppDatabase db) =>
      db.categoryTags.createAlias(
        $_aliasNameGenerator(db.taskItems.categoryId, db.categoryTags.id),
      );

  $$CategoryTagsTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoryTagsTableTableManager(
      $_db,
      $_db.categoryTags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskItemsTable> {
  $$TaskItemsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoryTagsTableFilterComposer get categoryId {
    final $$CategoryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoryTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTagsTableFilterComposer(
            $db: $db,
            $table: $db.categoryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskItemsTable> {
  $$TaskItemsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoryTagsTableOrderingComposer get categoryId {
    final $$CategoryTagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoryTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTagsTableOrderingComposer(
            $db: $db,
            $table: $db.categoryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskItemsTable> {
  $$TaskItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoryTagsTableAnnotationComposer get categoryId {
    final $$CategoryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoryTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskItemsTable,
          TaskItem,
          $$TaskItemsTableFilterComposer,
          $$TaskItemsTableOrderingComposer,
          $$TaskItemsTableAnnotationComposer,
          $$TaskItemsTableCreateCompanionBuilder,
          $$TaskItemsTableUpdateCompanionBuilder,
          (TaskItem, $$TaskItemsTableReferences),
          TaskItem,
          PrefetchHooks Function({bool categoryId})
        > {
  $$TaskItemsTableTableManager(_$AppDatabase db, $TaskItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TaskItemsCompanion(
                id: id,
                description: description,
                categoryId: categoryId,
                isCompleted: isCompleted,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String description,
                Value<int?> categoryId = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                required DateTime createdAt,
              }) => TaskItemsCompanion.insert(
                id: id,
                description: description,
                categoryId: categoryId,
                isCompleted: isCompleted,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
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
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$TaskItemsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$TaskItemsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$TaskItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskItemsTable,
      TaskItem,
      $$TaskItemsTableFilterComposer,
      $$TaskItemsTableOrderingComposer,
      $$TaskItemsTableAnnotationComposer,
      $$TaskItemsTableCreateCompanionBuilder,
      $$TaskItemsTableUpdateCompanionBuilder,
      (TaskItem, $$TaskItemsTableReferences),
      TaskItem,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$TimelineEntriesTableCreateCompanionBuilder =
    TimelineEntriesCompanion Function({
      Value<int> id,
      required int shiftId,
      required DateTime startTime,
      required DateTime endTime,
      Value<int?> categoryId,
      Value<String> description,
    });
typedef $$TimelineEntriesTableUpdateCompanionBuilder =
    TimelineEntriesCompanion Function({
      Value<int> id,
      Value<int> shiftId,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<int?> categoryId,
      Value<String> description,
    });

final class $$TimelineEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $TimelineEntriesTable, TimelineEntry> {
  $$TimelineEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DailyShiftsTable _shiftIdTable(_$AppDatabase db) =>
      db.dailyShifts.createAlias(
        $_aliasNameGenerator(db.timelineEntries.shiftId, db.dailyShifts.id),
      );

  $$DailyShiftsTableProcessedTableManager get shiftId {
    final $_column = $_itemColumn<int>('shift_id')!;

    final manager = $$DailyShiftsTableTableManager(
      $_db,
      $_db.dailyShifts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoryTagsTable _categoryIdTable(_$AppDatabase db) =>
      db.categoryTags.createAlias(
        $_aliasNameGenerator(db.timelineEntries.categoryId, db.categoryTags.id),
      );

  $$CategoryTagsTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoryTagsTableTableManager(
      $_db,
      $_db.categoryTags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimelineEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TimelineEntriesTable> {
  $$TimelineEntriesTableFilterComposer({
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

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyShiftsTableFilterComposer get shiftId {
    final $$DailyShiftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.dailyShifts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyShiftsTableFilterComposer(
            $db: $db,
            $table: $db.dailyShifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoryTagsTableFilterComposer get categoryId {
    final $$CategoryTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoryTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTagsTableFilterComposer(
            $db: $db,
            $table: $db.categoryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimelineEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimelineEntriesTable> {
  $$TimelineEntriesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyShiftsTableOrderingComposer get shiftId {
    final $$DailyShiftsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.dailyShifts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyShiftsTableOrderingComposer(
            $db: $db,
            $table: $db.dailyShifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoryTagsTableOrderingComposer get categoryId {
    final $$CategoryTagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoryTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTagsTableOrderingComposer(
            $db: $db,
            $table: $db.categoryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimelineEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimelineEntriesTable> {
  $$TimelineEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$DailyShiftsTableAnnotationComposer get shiftId {
    final $$DailyShiftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.dailyShifts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyShiftsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyShifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoryTagsTableAnnotationComposer get categoryId {
    final $$CategoryTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoryTags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimelineEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimelineEntriesTable,
          TimelineEntry,
          $$TimelineEntriesTableFilterComposer,
          $$TimelineEntriesTableOrderingComposer,
          $$TimelineEntriesTableAnnotationComposer,
          $$TimelineEntriesTableCreateCompanionBuilder,
          $$TimelineEntriesTableUpdateCompanionBuilder,
          (TimelineEntry, $$TimelineEntriesTableReferences),
          TimelineEntry,
          PrefetchHooks Function({bool shiftId, bool categoryId})
        > {
  $$TimelineEntriesTableTableManager(
    _$AppDatabase db,
    $TimelineEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimelineEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimelineEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimelineEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shiftId = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => TimelineEntriesCompanion(
                id: id,
                shiftId: shiftId,
                startTime: startTime,
                endTime: endTime,
                categoryId: categoryId,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shiftId,
                required DateTime startTime,
                required DateTime endTime,
                Value<int?> categoryId = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => TimelineEntriesCompanion.insert(
                id: id,
                shiftId: shiftId,
                startTime: startTime,
                endTime: endTime,
                categoryId: categoryId,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimelineEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shiftId = false, categoryId = false}) {
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
                    if (shiftId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.shiftId,
                                referencedTable:
                                    $$TimelineEntriesTableReferences
                                        ._shiftIdTable(db),
                                referencedColumn:
                                    $$TimelineEntriesTableReferences
                                        ._shiftIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable:
                                    $$TimelineEntriesTableReferences
                                        ._categoryIdTable(db),
                                referencedColumn:
                                    $$TimelineEntriesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$TimelineEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimelineEntriesTable,
      TimelineEntry,
      $$TimelineEntriesTableFilterComposer,
      $$TimelineEntriesTableOrderingComposer,
      $$TimelineEntriesTableAnnotationComposer,
      $$TimelineEntriesTableCreateCompanionBuilder,
      $$TimelineEntriesTableUpdateCompanionBuilder,
      (TimelineEntry, $$TimelineEntriesTableReferences),
      TimelineEntry,
      PrefetchHooks Function({bool shiftId, bool categoryId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$DailyShiftsTableTableManager get dailyShifts =>
      $$DailyShiftsTableTableManager(_db, _db.dailyShifts);
  $$TimesheetBucketsTableTableManager get timesheetBuckets =>
      $$TimesheetBucketsTableTableManager(_db, _db.timesheetBuckets);
  $$CategoryTagsTableTableManager get categoryTags =>
      $$CategoryTagsTableTableManager(_db, _db.categoryTags);
  $$TaskItemsTableTableManager get taskItems =>
      $$TaskItemsTableTableManager(_db, _db.taskItems);
  $$TimelineEntriesTableTableManager get timelineEntries =>
      $$TimelineEntriesTableTableManager(_db, _db.timelineEntries);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
