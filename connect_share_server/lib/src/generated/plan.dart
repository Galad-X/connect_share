/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'enums.dart' as _i2;
import 'duration.dart' as _i3;

abstract class Plan implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Plan._({
    this.id,
    required this.hotspotId,
    required this.name,
    this.description,
    required this.type,
    required this.durationType,
    required this.durationValue,
    required this.price,
    required this.currency,
    this.dataLimitGB,
    this.bandwidthDownMbps,
    this.bandwidthUpMbps,
    required this.isActive,
  });

  factory Plan({
    int? id,
    required int hotspotId,
    required String name,
    String? description,
    required _i2.PlanType type,
    required _i3.PlanDurationType durationType,
    required int durationValue,
    required double price,
    required String currency,
    double? dataLimitGB,
    double? bandwidthDownMbps,
    double? bandwidthUpMbps,
    required bool isActive,
  }) = _PlanImpl;

  factory Plan.fromJson(Map<String, dynamic> jsonSerialization) {
    return Plan(
      id: jsonSerialization['id'] as int?,
      hotspotId: jsonSerialization['hotspotId'] as int,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      type: _i2.PlanType.fromJson((jsonSerialization['type'] as int)),
      durationType: _i3.PlanDurationType.fromJson(
          (jsonSerialization['durationType'] as int)),
      durationValue: jsonSerialization['durationValue'] as int,
      price: (jsonSerialization['price'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String,
      dataLimitGB: (jsonSerialization['dataLimitGB'] as num?)?.toDouble(),
      bandwidthDownMbps:
          (jsonSerialization['bandwidthDownMbps'] as num?)?.toDouble(),
      bandwidthUpMbps:
          (jsonSerialization['bandwidthUpMbps'] as num?)?.toDouble(),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  static final t = PlanTable();

  static const db = PlanRepository._();

  @override
  int? id;

  int hotspotId;

  String name;

  String? description;

  _i2.PlanType type;

  _i3.PlanDurationType durationType;

  int durationValue;

  double price;

  String currency;

  double? dataLimitGB;

  double? bandwidthDownMbps;

  double? bandwidthUpMbps;

  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Plan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Plan copyWith({
    int? id,
    int? hotspotId,
    String? name,
    String? description,
    _i2.PlanType? type,
    _i3.PlanDurationType? durationType,
    int? durationValue,
    double? price,
    String? currency,
    double? dataLimitGB,
    double? bandwidthDownMbps,
    double? bandwidthUpMbps,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'hotspotId': hotspotId,
      'name': name,
      if (description != null) 'description': description,
      'type': type.toJson(),
      'durationType': durationType.toJson(),
      'durationValue': durationValue,
      'price': price,
      'currency': currency,
      if (dataLimitGB != null) 'dataLimitGB': dataLimitGB,
      if (bandwidthDownMbps != null) 'bandwidthDownMbps': bandwidthDownMbps,
      if (bandwidthUpMbps != null) 'bandwidthUpMbps': bandwidthUpMbps,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'hotspotId': hotspotId,
      'name': name,
      if (description != null) 'description': description,
      'type': type.toJson(),
      'durationType': durationType.toJson(),
      'durationValue': durationValue,
      'price': price,
      'currency': currency,
      if (dataLimitGB != null) 'dataLimitGB': dataLimitGB,
      if (bandwidthDownMbps != null) 'bandwidthDownMbps': bandwidthDownMbps,
      if (bandwidthUpMbps != null) 'bandwidthUpMbps': bandwidthUpMbps,
      'isActive': isActive,
    };
  }

  static PlanInclude include() {
    return PlanInclude._();
  }

  static PlanIncludeList includeList({
    _i1.WhereExpressionBuilder<PlanTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlanTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlanTable>? orderByList,
    PlanInclude? include,
  }) {
    return PlanIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Plan.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Plan.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlanImpl extends Plan {
  _PlanImpl({
    int? id,
    required int hotspotId,
    required String name,
    String? description,
    required _i2.PlanType type,
    required _i3.PlanDurationType durationType,
    required int durationValue,
    required double price,
    required String currency,
    double? dataLimitGB,
    double? bandwidthDownMbps,
    double? bandwidthUpMbps,
    required bool isActive,
  }) : super._(
          id: id,
          hotspotId: hotspotId,
          name: name,
          description: description,
          type: type,
          durationType: durationType,
          durationValue: durationValue,
          price: price,
          currency: currency,
          dataLimitGB: dataLimitGB,
          bandwidthDownMbps: bandwidthDownMbps,
          bandwidthUpMbps: bandwidthUpMbps,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [Plan]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Plan copyWith({
    Object? id = _Undefined,
    int? hotspotId,
    String? name,
    Object? description = _Undefined,
    _i2.PlanType? type,
    _i3.PlanDurationType? durationType,
    int? durationValue,
    double? price,
    String? currency,
    Object? dataLimitGB = _Undefined,
    Object? bandwidthDownMbps = _Undefined,
    Object? bandwidthUpMbps = _Undefined,
    bool? isActive,
  }) {
    return Plan(
      id: id is int? ? id : this.id,
      hotspotId: hotspotId ?? this.hotspotId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      type: type ?? this.type,
      durationType: durationType ?? this.durationType,
      durationValue: durationValue ?? this.durationValue,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      dataLimitGB: dataLimitGB is double? ? dataLimitGB : this.dataLimitGB,
      bandwidthDownMbps: bandwidthDownMbps is double?
          ? bandwidthDownMbps
          : this.bandwidthDownMbps,
      bandwidthUpMbps:
          bandwidthUpMbps is double? ? bandwidthUpMbps : this.bandwidthUpMbps,
      isActive: isActive ?? this.isActive,
    );
  }
}

class PlanTable extends _i1.Table<int?> {
  PlanTable({super.tableRelation}) : super(tableName: 'plan') {
    hotspotId = _i1.ColumnInt(
      'hotspotId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    type = _i1.ColumnEnum(
      'type',
      this,
      _i1.EnumSerialization.byIndex,
    );
    durationType = _i1.ColumnEnum(
      'durationType',
      this,
      _i1.EnumSerialization.byIndex,
    );
    durationValue = _i1.ColumnInt(
      'durationValue',
      this,
    );
    price = _i1.ColumnDouble(
      'price',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
    );
    dataLimitGB = _i1.ColumnDouble(
      'dataLimitGB',
      this,
    );
    bandwidthDownMbps = _i1.ColumnDouble(
      'bandwidthDownMbps',
      this,
    );
    bandwidthUpMbps = _i1.ColumnDouble(
      'bandwidthUpMbps',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
  }

  late final _i1.ColumnInt hotspotId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnEnum<_i2.PlanType> type;

  late final _i1.ColumnEnum<_i3.PlanDurationType> durationType;

  late final _i1.ColumnInt durationValue;

  late final _i1.ColumnDouble price;

  late final _i1.ColumnString currency;

  late final _i1.ColumnDouble dataLimitGB;

  late final _i1.ColumnDouble bandwidthDownMbps;

  late final _i1.ColumnDouble bandwidthUpMbps;

  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
        id,
        hotspotId,
        name,
        description,
        type,
        durationType,
        durationValue,
        price,
        currency,
        dataLimitGB,
        bandwidthDownMbps,
        bandwidthUpMbps,
        isActive,
      ];
}

class PlanInclude extends _i1.IncludeObject {
  PlanInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Plan.t;
}

class PlanIncludeList extends _i1.IncludeList {
  PlanIncludeList._({
    _i1.WhereExpressionBuilder<PlanTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Plan.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Plan.t;
}

class PlanRepository {
  const PlanRepository._();

  /// Returns a list of [Plan]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Plan>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlanTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlanTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlanTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Plan>(
      where: where?.call(Plan.t),
      orderBy: orderBy?.call(Plan.t),
      orderByList: orderByList?.call(Plan.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Plan] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Plan?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlanTable>? where,
    int? offset,
    _i1.OrderByBuilder<PlanTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlanTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Plan>(
      where: where?.call(Plan.t),
      orderBy: orderBy?.call(Plan.t),
      orderByList: orderByList?.call(Plan.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Plan] by its [id] or null if no such row exists.
  Future<Plan?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Plan>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Plan]s in the list and returns the inserted rows.
  ///
  /// The returned [Plan]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Plan>> insert(
    _i1.Session session,
    List<Plan> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Plan>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Plan] and returns the inserted row.
  ///
  /// The returned [Plan] will have its `id` field set.
  Future<Plan> insertRow(
    _i1.Session session,
    Plan row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Plan>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Plan]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Plan>> update(
    _i1.Session session,
    List<Plan> rows, {
    _i1.ColumnSelections<PlanTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Plan>(
      rows,
      columns: columns?.call(Plan.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Plan]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Plan> updateRow(
    _i1.Session session,
    Plan row, {
    _i1.ColumnSelections<PlanTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Plan>(
      row,
      columns: columns?.call(Plan.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Plan]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Plan>> delete(
    _i1.Session session,
    List<Plan> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Plan>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Plan].
  Future<Plan> deleteRow(
    _i1.Session session,
    Plan row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Plan>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Plan>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PlanTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Plan>(
      where: where(Plan.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlanTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Plan>(
      where: where?.call(Plan.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
