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

abstract class AccessToken
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccessToken._({
    this.id,
    required this.tokenValue,
    required this.consumerId,
    required this.hotspotId,
    required this.planId,
    required this.issueDate,
    this.activationDate,
    required this.expiryDate,
    required this.isActive,
    this.dataUsedBytes,
    this.lastUsed,
    this.lastUsedDeviceIdentifier,
  });

  factory AccessToken({
    int? id,
    required String tokenValue,
    required int consumerId,
    required int hotspotId,
    required int planId,
    required DateTime issueDate,
    DateTime? activationDate,
    required DateTime expiryDate,
    required bool isActive,
    BigInt? dataUsedBytes,
    DateTime? lastUsed,
    String? lastUsedDeviceIdentifier,
  }) = _AccessTokenImpl;

  factory AccessToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccessToken(
      id: jsonSerialization['id'] as int?,
      tokenValue: jsonSerialization['tokenValue'] as String,
      consumerId: jsonSerialization['consumerId'] as int,
      hotspotId: jsonSerialization['hotspotId'] as int,
      planId: jsonSerialization['planId'] as int,
      issueDate:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['issueDate']),
      activationDate: jsonSerialization['activationDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['activationDate']),
      expiryDate:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiryDate']),
      isActive: jsonSerialization['isActive'] as bool,
      dataUsedBytes: jsonSerialization['dataUsedBytes'] == null
          ? null
          : _i1.BigIntJsonExtension.fromJson(
              jsonSerialization['dataUsedBytes']),
      lastUsed: jsonSerialization['lastUsed'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUsed']),
      lastUsedDeviceIdentifier:
          jsonSerialization['lastUsedDeviceIdentifier'] as String?,
    );
  }

  static final t = AccessTokenTable();

  static const db = AccessTokenRepository._();

  @override
  int? id;

  String tokenValue;

  int consumerId;

  int hotspotId;

  int planId;

  DateTime issueDate;

  DateTime? activationDate;

  DateTime expiryDate;

  bool isActive;

  BigInt? dataUsedBytes;

  DateTime? lastUsed;

  String? lastUsedDeviceIdentifier;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccessToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccessToken copyWith({
    int? id,
    String? tokenValue,
    int? consumerId,
    int? hotspotId,
    int? planId,
    DateTime? issueDate,
    DateTime? activationDate,
    DateTime? expiryDate,
    bool? isActive,
    BigInt? dataUsedBytes,
    DateTime? lastUsed,
    String? lastUsedDeviceIdentifier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'tokenValue': tokenValue,
      'consumerId': consumerId,
      'hotspotId': hotspotId,
      'planId': planId,
      'issueDate': issueDate.toJson(),
      if (activationDate != null) 'activationDate': activationDate?.toJson(),
      'expiryDate': expiryDate.toJson(),
      'isActive': isActive,
      if (dataUsedBytes != null) 'dataUsedBytes': dataUsedBytes?.toJson(),
      if (lastUsed != null) 'lastUsed': lastUsed?.toJson(),
      if (lastUsedDeviceIdentifier != null)
        'lastUsedDeviceIdentifier': lastUsedDeviceIdentifier,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'tokenValue': tokenValue,
      'consumerId': consumerId,
      'hotspotId': hotspotId,
      'planId': planId,
      'issueDate': issueDate.toJson(),
      if (activationDate != null) 'activationDate': activationDate?.toJson(),
      'expiryDate': expiryDate.toJson(),
      'isActive': isActive,
      if (dataUsedBytes != null) 'dataUsedBytes': dataUsedBytes?.toJson(),
      if (lastUsed != null) 'lastUsed': lastUsed?.toJson(),
      if (lastUsedDeviceIdentifier != null)
        'lastUsedDeviceIdentifier': lastUsedDeviceIdentifier,
    };
  }

  static AccessTokenInclude include() {
    return AccessTokenInclude._();
  }

  static AccessTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<AccessTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccessTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccessTokenTable>? orderByList,
    AccessTokenInclude? include,
  }) {
    return AccessTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccessToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccessToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccessTokenImpl extends AccessToken {
  _AccessTokenImpl({
    int? id,
    required String tokenValue,
    required int consumerId,
    required int hotspotId,
    required int planId,
    required DateTime issueDate,
    DateTime? activationDate,
    required DateTime expiryDate,
    required bool isActive,
    BigInt? dataUsedBytes,
    DateTime? lastUsed,
    String? lastUsedDeviceIdentifier,
  }) : super._(
          id: id,
          tokenValue: tokenValue,
          consumerId: consumerId,
          hotspotId: hotspotId,
          planId: planId,
          issueDate: issueDate,
          activationDate: activationDate,
          expiryDate: expiryDate,
          isActive: isActive,
          dataUsedBytes: dataUsedBytes,
          lastUsed: lastUsed,
          lastUsedDeviceIdentifier: lastUsedDeviceIdentifier,
        );

  /// Returns a shallow copy of this [AccessToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccessToken copyWith({
    Object? id = _Undefined,
    String? tokenValue,
    int? consumerId,
    int? hotspotId,
    int? planId,
    DateTime? issueDate,
    Object? activationDate = _Undefined,
    DateTime? expiryDate,
    bool? isActive,
    Object? dataUsedBytes = _Undefined,
    Object? lastUsed = _Undefined,
    Object? lastUsedDeviceIdentifier = _Undefined,
  }) {
    return AccessToken(
      id: id is int? ? id : this.id,
      tokenValue: tokenValue ?? this.tokenValue,
      consumerId: consumerId ?? this.consumerId,
      hotspotId: hotspotId ?? this.hotspotId,
      planId: planId ?? this.planId,
      issueDate: issueDate ?? this.issueDate,
      activationDate:
          activationDate is DateTime? ? activationDate : this.activationDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      dataUsedBytes:
          dataUsedBytes is BigInt? ? dataUsedBytes : this.dataUsedBytes,
      lastUsed: lastUsed is DateTime? ? lastUsed : this.lastUsed,
      lastUsedDeviceIdentifier: lastUsedDeviceIdentifier is String?
          ? lastUsedDeviceIdentifier
          : this.lastUsedDeviceIdentifier,
    );
  }
}

class AccessTokenTable extends _i1.Table<int?> {
  AccessTokenTable({super.tableRelation}) : super(tableName: 'access_token') {
    tokenValue = _i1.ColumnString(
      'tokenValue',
      this,
    );
    consumerId = _i1.ColumnInt(
      'consumerId',
      this,
    );
    hotspotId = _i1.ColumnInt(
      'hotspotId',
      this,
    );
    planId = _i1.ColumnInt(
      'planId',
      this,
    );
    issueDate = _i1.ColumnDateTime(
      'issueDate',
      this,
    );
    activationDate = _i1.ColumnDateTime(
      'activationDate',
      this,
    );
    expiryDate = _i1.ColumnDateTime(
      'expiryDate',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    dataUsedBytes = _i1.ColumnBigInt(
      'dataUsedBytes',
      this,
    );
    lastUsed = _i1.ColumnDateTime(
      'lastUsed',
      this,
    );
    lastUsedDeviceIdentifier = _i1.ColumnString(
      'lastUsedDeviceIdentifier',
      this,
    );
  }

  late final _i1.ColumnString tokenValue;

  late final _i1.ColumnInt consumerId;

  late final _i1.ColumnInt hotspotId;

  late final _i1.ColumnInt planId;

  late final _i1.ColumnDateTime issueDate;

  late final _i1.ColumnDateTime activationDate;

  late final _i1.ColumnDateTime expiryDate;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnBigInt dataUsedBytes;

  late final _i1.ColumnDateTime lastUsed;

  late final _i1.ColumnString lastUsedDeviceIdentifier;

  @override
  List<_i1.Column> get columns => [
        id,
        tokenValue,
        consumerId,
        hotspotId,
        planId,
        issueDate,
        activationDate,
        expiryDate,
        isActive,
        dataUsedBytes,
        lastUsed,
        lastUsedDeviceIdentifier,
      ];
}

class AccessTokenInclude extends _i1.IncludeObject {
  AccessTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccessToken.t;
}

class AccessTokenIncludeList extends _i1.IncludeList {
  AccessTokenIncludeList._({
    _i1.WhereExpressionBuilder<AccessTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccessToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccessToken.t;
}

class AccessTokenRepository {
  const AccessTokenRepository._();

  /// Returns a list of [AccessToken]s matching the given query parameters.
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
  Future<List<AccessToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccessTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccessTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccessTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AccessToken>(
      where: where?.call(AccessToken.t),
      orderBy: orderBy?.call(AccessToken.t),
      orderByList: orderByList?.call(AccessToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AccessToken] matching the given query parameters.
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
  Future<AccessToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccessTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccessTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccessTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AccessToken>(
      where: where?.call(AccessToken.t),
      orderBy: orderBy?.call(AccessToken.t),
      orderByList: orderByList?.call(AccessToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AccessToken] by its [id] or null if no such row exists.
  Future<AccessToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AccessToken>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AccessToken]s in the list and returns the inserted rows.
  ///
  /// The returned [AccessToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AccessToken>> insert(
    _i1.Session session,
    List<AccessToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AccessToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AccessToken] and returns the inserted row.
  ///
  /// The returned [AccessToken] will have its `id` field set.
  Future<AccessToken> insertRow(
    _i1.Session session,
    AccessToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccessToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccessToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccessToken>> update(
    _i1.Session session,
    List<AccessToken> rows, {
    _i1.ColumnSelections<AccessTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccessToken>(
      rows,
      columns: columns?.call(AccessToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccessToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccessToken> updateRow(
    _i1.Session session,
    AccessToken row, {
    _i1.ColumnSelections<AccessTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccessToken>(
      row,
      columns: columns?.call(AccessToken.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AccessToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccessToken>> delete(
    _i1.Session session,
    List<AccessToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccessToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccessToken].
  Future<AccessToken> deleteRow(
    _i1.Session session,
    AccessToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccessToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccessToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AccessTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccessToken>(
      where: where(AccessToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccessTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccessToken>(
      where: where?.call(AccessToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
