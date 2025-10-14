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

abstract class HotspotConfig
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  HotspotConfig._({
    this.id,
    required this.providerId,
    required this.name,
    this.ssid,
    required this.latitude,
    required this.longitude,
    this.geofenceRadiusMeters,
    required this.isActive,
    required this.createdAt,
    this.lastOnlineAt,
  });

  factory HotspotConfig({
    int? id,
    required int providerId,
    required String name,
    String? ssid,
    required double latitude,
    required double longitude,
    double? geofenceRadiusMeters,
    required bool isActive,
    required DateTime createdAt,
    DateTime? lastOnlineAt,
  }) = _HotspotConfigImpl;

  factory HotspotConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return HotspotConfig(
      id: jsonSerialization['id'] as int?,
      providerId: jsonSerialization['providerId'] as int,
      name: jsonSerialization['name'] as String,
      ssid: jsonSerialization['ssid'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      geofenceRadiusMeters:
          (jsonSerialization['geofenceRadiusMeters'] as num?)?.toDouble(),
      isActive: jsonSerialization['isActive'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastOnlineAt: jsonSerialization['lastOnlineAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastOnlineAt']),
    );
  }

  static final t = HotspotConfigTable();

  static const db = HotspotConfigRepository._();

  @override
  int? id;

  int providerId;

  String name;

  String? ssid;

  double latitude;

  double longitude;

  double? geofenceRadiusMeters;

  bool isActive;

  DateTime createdAt;

  DateTime? lastOnlineAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [HotspotConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HotspotConfig copyWith({
    int? id,
    int? providerId,
    String? name,
    String? ssid,
    double? latitude,
    double? longitude,
    double? geofenceRadiusMeters,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastOnlineAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'providerId': providerId,
      'name': name,
      if (ssid != null) 'ssid': ssid,
      'latitude': latitude,
      'longitude': longitude,
      if (geofenceRadiusMeters != null)
        'geofenceRadiusMeters': geofenceRadiusMeters,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (lastOnlineAt != null) 'lastOnlineAt': lastOnlineAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'providerId': providerId,
      'name': name,
      if (ssid != null) 'ssid': ssid,
      'latitude': latitude,
      'longitude': longitude,
      if (geofenceRadiusMeters != null)
        'geofenceRadiusMeters': geofenceRadiusMeters,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (lastOnlineAt != null) 'lastOnlineAt': lastOnlineAt?.toJson(),
    };
  }

  static HotspotConfigInclude include() {
    return HotspotConfigInclude._();
  }

  static HotspotConfigIncludeList includeList({
    _i1.WhereExpressionBuilder<HotspotConfigTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HotspotConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HotspotConfigTable>? orderByList,
    HotspotConfigInclude? include,
  }) {
    return HotspotConfigIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HotspotConfig.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(HotspotConfig.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HotspotConfigImpl extends HotspotConfig {
  _HotspotConfigImpl({
    int? id,
    required int providerId,
    required String name,
    String? ssid,
    required double latitude,
    required double longitude,
    double? geofenceRadiusMeters,
    required bool isActive,
    required DateTime createdAt,
    DateTime? lastOnlineAt,
  }) : super._(
          id: id,
          providerId: providerId,
          name: name,
          ssid: ssid,
          latitude: latitude,
          longitude: longitude,
          geofenceRadiusMeters: geofenceRadiusMeters,
          isActive: isActive,
          createdAt: createdAt,
          lastOnlineAt: lastOnlineAt,
        );

  /// Returns a shallow copy of this [HotspotConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HotspotConfig copyWith({
    Object? id = _Undefined,
    int? providerId,
    String? name,
    Object? ssid = _Undefined,
    double? latitude,
    double? longitude,
    Object? geofenceRadiusMeters = _Undefined,
    bool? isActive,
    DateTime? createdAt,
    Object? lastOnlineAt = _Undefined,
  }) {
    return HotspotConfig(
      id: id is int? ? id : this.id,
      providerId: providerId ?? this.providerId,
      name: name ?? this.name,
      ssid: ssid is String? ? ssid : this.ssid,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      geofenceRadiusMeters: geofenceRadiusMeters is double?
          ? geofenceRadiusMeters
          : this.geofenceRadiusMeters,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastOnlineAt:
          lastOnlineAt is DateTime? ? lastOnlineAt : this.lastOnlineAt,
    );
  }
}

class HotspotConfigTable extends _i1.Table<int?> {
  HotspotConfigTable({super.tableRelation})
      : super(tableName: 'hotspot_config') {
    providerId = _i1.ColumnInt(
      'providerId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    ssid = _i1.ColumnString(
      'ssid',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    geofenceRadiusMeters = _i1.ColumnDouble(
      'geofenceRadiusMeters',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    lastOnlineAt = _i1.ColumnDateTime(
      'lastOnlineAt',
      this,
    );
  }

  late final _i1.ColumnInt providerId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString ssid;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnDouble geofenceRadiusMeters;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime lastOnlineAt;

  @override
  List<_i1.Column> get columns => [
        id,
        providerId,
        name,
        ssid,
        latitude,
        longitude,
        geofenceRadiusMeters,
        isActive,
        createdAt,
        lastOnlineAt,
      ];
}

class HotspotConfigInclude extends _i1.IncludeObject {
  HotspotConfigInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => HotspotConfig.t;
}

class HotspotConfigIncludeList extends _i1.IncludeList {
  HotspotConfigIncludeList._({
    _i1.WhereExpressionBuilder<HotspotConfigTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HotspotConfig.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => HotspotConfig.t;
}

class HotspotConfigRepository {
  const HotspotConfigRepository._();

  /// Returns a list of [HotspotConfig]s matching the given query parameters.
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
  Future<List<HotspotConfig>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<HotspotConfigTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HotspotConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HotspotConfigTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<HotspotConfig>(
      where: where?.call(HotspotConfig.t),
      orderBy: orderBy?.call(HotspotConfig.t),
      orderByList: orderByList?.call(HotspotConfig.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [HotspotConfig] matching the given query parameters.
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
  Future<HotspotConfig?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<HotspotConfigTable>? where,
    int? offset,
    _i1.OrderByBuilder<HotspotConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HotspotConfigTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<HotspotConfig>(
      where: where?.call(HotspotConfig.t),
      orderBy: orderBy?.call(HotspotConfig.t),
      orderByList: orderByList?.call(HotspotConfig.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [HotspotConfig] by its [id] or null if no such row exists.
  Future<HotspotConfig?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<HotspotConfig>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [HotspotConfig]s in the list and returns the inserted rows.
  ///
  /// The returned [HotspotConfig]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<HotspotConfig>> insert(
    _i1.Session session,
    List<HotspotConfig> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<HotspotConfig>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [HotspotConfig] and returns the inserted row.
  ///
  /// The returned [HotspotConfig] will have its `id` field set.
  Future<HotspotConfig> insertRow(
    _i1.Session session,
    HotspotConfig row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<HotspotConfig>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [HotspotConfig]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<HotspotConfig>> update(
    _i1.Session session,
    List<HotspotConfig> rows, {
    _i1.ColumnSelections<HotspotConfigTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<HotspotConfig>(
      rows,
      columns: columns?.call(HotspotConfig.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HotspotConfig]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HotspotConfig> updateRow(
    _i1.Session session,
    HotspotConfig row, {
    _i1.ColumnSelections<HotspotConfigTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<HotspotConfig>(
      row,
      columns: columns?.call(HotspotConfig.t),
      transaction: transaction,
    );
  }

  /// Deletes all [HotspotConfig]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<HotspotConfig>> delete(
    _i1.Session session,
    List<HotspotConfig> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<HotspotConfig>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [HotspotConfig].
  Future<HotspotConfig> deleteRow(
    _i1.Session session,
    HotspotConfig row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HotspotConfig>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<HotspotConfig>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<HotspotConfigTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<HotspotConfig>(
      where: where(HotspotConfig.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<HotspotConfigTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<HotspotConfig>(
      where: where?.call(HotspotConfig.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
