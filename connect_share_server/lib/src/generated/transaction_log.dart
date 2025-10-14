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

abstract class TransactionLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TransactionLog._({
    this.id,
    required this.consumerId,
    required this.providerId,
    required this.hotspotId,
    required this.planId,
    this.accessTokenId,
    required this.paystackReference,
    required this.amountPaid,
    required this.currency,
    required this.transactionDate,
    required this.status,
    this.platformFee,
    this.providerPayoutAmount,
    this.payoutStatus,
  });

  factory TransactionLog({
    int? id,
    required int consumerId,
    required int providerId,
    required int hotspotId,
    required int planId,
    int? accessTokenId,
    required String paystackReference,
    required double amountPaid,
    required String currency,
    required DateTime transactionDate,
    required String status,
    double? platformFee,
    double? providerPayoutAmount,
    String? payoutStatus,
  }) = _TransactionLogImpl;

  factory TransactionLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransactionLog(
      id: jsonSerialization['id'] as int?,
      consumerId: jsonSerialization['consumerId'] as int,
      providerId: jsonSerialization['providerId'] as int,
      hotspotId: jsonSerialization['hotspotId'] as int,
      planId: jsonSerialization['planId'] as int,
      accessTokenId: jsonSerialization['accessTokenId'] as int?,
      paystackReference: jsonSerialization['paystackReference'] as String,
      amountPaid: (jsonSerialization['amountPaid'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String,
      transactionDate: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['transactionDate']),
      status: jsonSerialization['status'] as String,
      platformFee: (jsonSerialization['platformFee'] as num?)?.toDouble(),
      providerPayoutAmount:
          (jsonSerialization['providerPayoutAmount'] as num?)?.toDouble(),
      payoutStatus: jsonSerialization['payoutStatus'] as String?,
    );
  }

  static final t = TransactionLogTable();

  static const db = TransactionLogRepository._();

  @override
  int? id;

  int consumerId;

  int providerId;

  int hotspotId;

  int planId;

  int? accessTokenId;

  String paystackReference;

  double amountPaid;

  String currency;

  DateTime transactionDate;

  String status;

  double? platformFee;

  double? providerPayoutAmount;

  String? payoutStatus;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TransactionLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TransactionLog copyWith({
    int? id,
    int? consumerId,
    int? providerId,
    int? hotspotId,
    int? planId,
    int? accessTokenId,
    String? paystackReference,
    double? amountPaid,
    String? currency,
    DateTime? transactionDate,
    String? status,
    double? platformFee,
    double? providerPayoutAmount,
    String? payoutStatus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'consumerId': consumerId,
      'providerId': providerId,
      'hotspotId': hotspotId,
      'planId': planId,
      if (accessTokenId != null) 'accessTokenId': accessTokenId,
      'paystackReference': paystackReference,
      'amountPaid': amountPaid,
      'currency': currency,
      'transactionDate': transactionDate.toJson(),
      'status': status,
      if (platformFee != null) 'platformFee': platformFee,
      if (providerPayoutAmount != null)
        'providerPayoutAmount': providerPayoutAmount,
      if (payoutStatus != null) 'payoutStatus': payoutStatus,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'consumerId': consumerId,
      'providerId': providerId,
      'hotspotId': hotspotId,
      'planId': planId,
      if (accessTokenId != null) 'accessTokenId': accessTokenId,
      'paystackReference': paystackReference,
      'amountPaid': amountPaid,
      'currency': currency,
      'transactionDate': transactionDate.toJson(),
      'status': status,
      if (platformFee != null) 'platformFee': platformFee,
      if (providerPayoutAmount != null)
        'providerPayoutAmount': providerPayoutAmount,
      if (payoutStatus != null) 'payoutStatus': payoutStatus,
    };
  }

  static TransactionLogInclude include() {
    return TransactionLogInclude._();
  }

  static TransactionLogIncludeList includeList({
    _i1.WhereExpressionBuilder<TransactionLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TransactionLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TransactionLogTable>? orderByList,
    TransactionLogInclude? include,
  }) {
    return TransactionLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TransactionLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TransactionLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransactionLogImpl extends TransactionLog {
  _TransactionLogImpl({
    int? id,
    required int consumerId,
    required int providerId,
    required int hotspotId,
    required int planId,
    int? accessTokenId,
    required String paystackReference,
    required double amountPaid,
    required String currency,
    required DateTime transactionDate,
    required String status,
    double? platformFee,
    double? providerPayoutAmount,
    String? payoutStatus,
  }) : super._(
          id: id,
          consumerId: consumerId,
          providerId: providerId,
          hotspotId: hotspotId,
          planId: planId,
          accessTokenId: accessTokenId,
          paystackReference: paystackReference,
          amountPaid: amountPaid,
          currency: currency,
          transactionDate: transactionDate,
          status: status,
          platformFee: platformFee,
          providerPayoutAmount: providerPayoutAmount,
          payoutStatus: payoutStatus,
        );

  /// Returns a shallow copy of this [TransactionLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TransactionLog copyWith({
    Object? id = _Undefined,
    int? consumerId,
    int? providerId,
    int? hotspotId,
    int? planId,
    Object? accessTokenId = _Undefined,
    String? paystackReference,
    double? amountPaid,
    String? currency,
    DateTime? transactionDate,
    String? status,
    Object? platformFee = _Undefined,
    Object? providerPayoutAmount = _Undefined,
    Object? payoutStatus = _Undefined,
  }) {
    return TransactionLog(
      id: id is int? ? id : this.id,
      consumerId: consumerId ?? this.consumerId,
      providerId: providerId ?? this.providerId,
      hotspotId: hotspotId ?? this.hotspotId,
      planId: planId ?? this.planId,
      accessTokenId: accessTokenId is int? ? accessTokenId : this.accessTokenId,
      paystackReference: paystackReference ?? this.paystackReference,
      amountPaid: amountPaid ?? this.amountPaid,
      currency: currency ?? this.currency,
      transactionDate: transactionDate ?? this.transactionDate,
      status: status ?? this.status,
      platformFee: platformFee is double? ? platformFee : this.platformFee,
      providerPayoutAmount: providerPayoutAmount is double?
          ? providerPayoutAmount
          : this.providerPayoutAmount,
      payoutStatus: payoutStatus is String? ? payoutStatus : this.payoutStatus,
    );
  }
}

class TransactionLogTable extends _i1.Table<int?> {
  TransactionLogTable({super.tableRelation})
      : super(tableName: 'transaction_log') {
    consumerId = _i1.ColumnInt(
      'consumerId',
      this,
    );
    providerId = _i1.ColumnInt(
      'providerId',
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
    accessTokenId = _i1.ColumnInt(
      'accessTokenId',
      this,
    );
    paystackReference = _i1.ColumnString(
      'paystackReference',
      this,
    );
    amountPaid = _i1.ColumnDouble(
      'amountPaid',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
    );
    transactionDate = _i1.ColumnDateTime(
      'transactionDate',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    platformFee = _i1.ColumnDouble(
      'platformFee',
      this,
    );
    providerPayoutAmount = _i1.ColumnDouble(
      'providerPayoutAmount',
      this,
    );
    payoutStatus = _i1.ColumnString(
      'payoutStatus',
      this,
    );
  }

  late final _i1.ColumnInt consumerId;

  late final _i1.ColumnInt providerId;

  late final _i1.ColumnInt hotspotId;

  late final _i1.ColumnInt planId;

  late final _i1.ColumnInt accessTokenId;

  late final _i1.ColumnString paystackReference;

  late final _i1.ColumnDouble amountPaid;

  late final _i1.ColumnString currency;

  late final _i1.ColumnDateTime transactionDate;

  late final _i1.ColumnString status;

  late final _i1.ColumnDouble platformFee;

  late final _i1.ColumnDouble providerPayoutAmount;

  late final _i1.ColumnString payoutStatus;

  @override
  List<_i1.Column> get columns => [
        id,
        consumerId,
        providerId,
        hotspotId,
        planId,
        accessTokenId,
        paystackReference,
        amountPaid,
        currency,
        transactionDate,
        status,
        platformFee,
        providerPayoutAmount,
        payoutStatus,
      ];
}

class TransactionLogInclude extends _i1.IncludeObject {
  TransactionLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TransactionLog.t;
}

class TransactionLogIncludeList extends _i1.IncludeList {
  TransactionLogIncludeList._({
    _i1.WhereExpressionBuilder<TransactionLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TransactionLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TransactionLog.t;
}

class TransactionLogRepository {
  const TransactionLogRepository._();

  /// Returns a list of [TransactionLog]s matching the given query parameters.
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
  Future<List<TransactionLog>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TransactionLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TransactionLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TransactionLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TransactionLog>(
      where: where?.call(TransactionLog.t),
      orderBy: orderBy?.call(TransactionLog.t),
      orderByList: orderByList?.call(TransactionLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TransactionLog] matching the given query parameters.
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
  Future<TransactionLog?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TransactionLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<TransactionLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TransactionLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TransactionLog>(
      where: where?.call(TransactionLog.t),
      orderBy: orderBy?.call(TransactionLog.t),
      orderByList: orderByList?.call(TransactionLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TransactionLog] by its [id] or null if no such row exists.
  Future<TransactionLog?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TransactionLog>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TransactionLog]s in the list and returns the inserted rows.
  ///
  /// The returned [TransactionLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TransactionLog>> insert(
    _i1.Session session,
    List<TransactionLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TransactionLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TransactionLog] and returns the inserted row.
  ///
  /// The returned [TransactionLog] will have its `id` field set.
  Future<TransactionLog> insertRow(
    _i1.Session session,
    TransactionLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TransactionLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TransactionLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TransactionLog>> update(
    _i1.Session session,
    List<TransactionLog> rows, {
    _i1.ColumnSelections<TransactionLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TransactionLog>(
      rows,
      columns: columns?.call(TransactionLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TransactionLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TransactionLog> updateRow(
    _i1.Session session,
    TransactionLog row, {
    _i1.ColumnSelections<TransactionLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TransactionLog>(
      row,
      columns: columns?.call(TransactionLog.t),
      transaction: transaction,
    );
  }

  /// Deletes all [TransactionLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TransactionLog>> delete(
    _i1.Session session,
    List<TransactionLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TransactionLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TransactionLog].
  Future<TransactionLog> deleteRow(
    _i1.Session session,
    TransactionLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TransactionLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TransactionLog>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TransactionLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TransactionLog>(
      where: where(TransactionLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TransactionLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TransactionLog>(
      where: where?.call(TransactionLog.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
