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

abstract class Feedback
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Feedback._({
    this.id,
    required this.userId,
    required this.type,
    required this.content,
    required this.submittedAt,
    required this.status,
    this.response,
    this.respondedAt,
    this.respondedBy,
  });

  factory Feedback({
    int? id,
    required int userId,
    required String type,
    required String content,
    required DateTime submittedAt,
    required String status,
    String? response,
    DateTime? respondedAt,
    int? respondedBy,
  }) = _FeedbackImpl;

  factory Feedback.fromJson(Map<String, dynamic> jsonSerialization) {
    return Feedback(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      type: jsonSerialization['type'] as String,
      content: jsonSerialization['content'] as String,
      submittedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['submittedAt']),
      status: jsonSerialization['status'] as String,
      response: jsonSerialization['response'] as String?,
      respondedAt: jsonSerialization['respondedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['respondedAt']),
      respondedBy: jsonSerialization['respondedBy'] as int?,
    );
  }

  static final t = FeedbackTable();

  static const db = FeedbackRepository._();

  @override
  int? id;

  int userId;

  String type;

  String content;

  DateTime submittedAt;

  String status;

  String? response;

  DateTime? respondedAt;

  int? respondedBy;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Feedback]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Feedback copyWith({
    int? id,
    int? userId,
    String? type,
    String? content,
    DateTime? submittedAt,
    String? status,
    String? response,
    DateTime? respondedAt,
    int? respondedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'type': type,
      'content': content,
      'submittedAt': submittedAt.toJson(),
      'status': status,
      if (response != null) 'response': response,
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
      if (respondedBy != null) 'respondedBy': respondedBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'type': type,
      'content': content,
      'submittedAt': submittedAt.toJson(),
      'status': status,
      if (response != null) 'response': response,
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
      if (respondedBy != null) 'respondedBy': respondedBy,
    };
  }

  static FeedbackInclude include() {
    return FeedbackInclude._();
  }

  static FeedbackIncludeList includeList({
    _i1.WhereExpressionBuilder<FeedbackTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FeedbackTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FeedbackTable>? orderByList,
    FeedbackInclude? include,
  }) {
    return FeedbackIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Feedback.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Feedback.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackImpl extends Feedback {
  _FeedbackImpl({
    int? id,
    required int userId,
    required String type,
    required String content,
    required DateTime submittedAt,
    required String status,
    String? response,
    DateTime? respondedAt,
    int? respondedBy,
  }) : super._(
          id: id,
          userId: userId,
          type: type,
          content: content,
          submittedAt: submittedAt,
          status: status,
          response: response,
          respondedAt: respondedAt,
          respondedBy: respondedBy,
        );

  /// Returns a shallow copy of this [Feedback]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Feedback copyWith({
    Object? id = _Undefined,
    int? userId,
    String? type,
    String? content,
    DateTime? submittedAt,
    String? status,
    Object? response = _Undefined,
    Object? respondedAt = _Undefined,
    Object? respondedBy = _Undefined,
  }) {
    return Feedback(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      content: content ?? this.content,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      response: response is String? ? response : this.response,
      respondedAt: respondedAt is DateTime? ? respondedAt : this.respondedAt,
      respondedBy: respondedBy is int? ? respondedBy : this.respondedBy,
    );
  }
}

class FeedbackTable extends _i1.Table<int?> {
  FeedbackTable({super.tableRelation}) : super(tableName: 'feedback') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    submittedAt = _i1.ColumnDateTime(
      'submittedAt',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    response = _i1.ColumnString(
      'response',
      this,
    );
    respondedAt = _i1.ColumnDateTime(
      'respondedAt',
      this,
    );
    respondedBy = _i1.ColumnInt(
      'respondedBy',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString type;

  late final _i1.ColumnString content;

  late final _i1.ColumnDateTime submittedAt;

  late final _i1.ColumnString status;

  late final _i1.ColumnString response;

  late final _i1.ColumnDateTime respondedAt;

  late final _i1.ColumnInt respondedBy;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        type,
        content,
        submittedAt,
        status,
        response,
        respondedAt,
        respondedBy,
      ];
}

class FeedbackInclude extends _i1.IncludeObject {
  FeedbackInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Feedback.t;
}

class FeedbackIncludeList extends _i1.IncludeList {
  FeedbackIncludeList._({
    _i1.WhereExpressionBuilder<FeedbackTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Feedback.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Feedback.t;
}

class FeedbackRepository {
  const FeedbackRepository._();

  /// Returns a list of [Feedback]s matching the given query parameters.
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
  Future<List<Feedback>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FeedbackTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FeedbackTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FeedbackTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Feedback>(
      where: where?.call(Feedback.t),
      orderBy: orderBy?.call(Feedback.t),
      orderByList: orderByList?.call(Feedback.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Feedback] matching the given query parameters.
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
  Future<Feedback?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FeedbackTable>? where,
    int? offset,
    _i1.OrderByBuilder<FeedbackTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FeedbackTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Feedback>(
      where: where?.call(Feedback.t),
      orderBy: orderBy?.call(Feedback.t),
      orderByList: orderByList?.call(Feedback.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Feedback] by its [id] or null if no such row exists.
  Future<Feedback?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Feedback>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Feedback]s in the list and returns the inserted rows.
  ///
  /// The returned [Feedback]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Feedback>> insert(
    _i1.Session session,
    List<Feedback> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Feedback>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Feedback] and returns the inserted row.
  ///
  /// The returned [Feedback] will have its `id` field set.
  Future<Feedback> insertRow(
    _i1.Session session,
    Feedback row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Feedback>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Feedback]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Feedback>> update(
    _i1.Session session,
    List<Feedback> rows, {
    _i1.ColumnSelections<FeedbackTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Feedback>(
      rows,
      columns: columns?.call(Feedback.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Feedback]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Feedback> updateRow(
    _i1.Session session,
    Feedback row, {
    _i1.ColumnSelections<FeedbackTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Feedback>(
      row,
      columns: columns?.call(Feedback.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Feedback]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Feedback>> delete(
    _i1.Session session,
    List<Feedback> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Feedback>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Feedback].
  Future<Feedback> deleteRow(
    _i1.Session session,
    Feedback row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Feedback>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Feedback>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<FeedbackTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Feedback>(
      where: where(Feedback.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<FeedbackTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Feedback>(
      where: where?.call(Feedback.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
