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

abstract class Policy implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Policy._({
    this.id,
    required this.type,
    required this.content,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory Policy({
    int? id,
    required String type,
    required String content,
    required DateTime updatedAt,
    required int updatedBy,
  }) = _PolicyImpl;

  factory Policy.fromJson(Map<String, dynamic> jsonSerialization) {
    return Policy(
      id: jsonSerialization['id'] as int?,
      type: jsonSerialization['type'] as String,
      content: jsonSerialization['content'] as String,
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      updatedBy: jsonSerialization['updatedBy'] as int,
    );
  }

  static final t = PolicyTable();

  static const db = PolicyRepository._();

  @override
  int? id;

  String type;

  String content;

  DateTime updatedAt;

  int updatedBy;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Policy]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Policy copyWith({
    int? id,
    String? type,
    String? content,
    DateTime? updatedAt,
    int? updatedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'content': content,
      'updatedAt': updatedAt.toJson(),
      'updatedBy': updatedBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'content': content,
      'updatedAt': updatedAt.toJson(),
      'updatedBy': updatedBy,
    };
  }

  static PolicyInclude include() {
    return PolicyInclude._();
  }

  static PolicyIncludeList includeList({
    _i1.WhereExpressionBuilder<PolicyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PolicyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PolicyTable>? orderByList,
    PolicyInclude? include,
  }) {
    return PolicyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Policy.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Policy.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PolicyImpl extends Policy {
  _PolicyImpl({
    int? id,
    required String type,
    required String content,
    required DateTime updatedAt,
    required int updatedBy,
  }) : super._(
          id: id,
          type: type,
          content: content,
          updatedAt: updatedAt,
          updatedBy: updatedBy,
        );

  /// Returns a shallow copy of this [Policy]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Policy copyWith({
    Object? id = _Undefined,
    String? type,
    String? content,
    DateTime? updatedAt,
    int? updatedBy,
  }) {
    return Policy(
      id: id is int? ? id : this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}

class PolicyTable extends _i1.Table<int?> {
  PolicyTable({super.tableRelation}) : super(tableName: 'policy') {
    type = _i1.ColumnString(
      'type',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    updatedBy = _i1.ColumnInt(
      'updatedBy',
      this,
    );
  }

  late final _i1.ColumnString type;

  late final _i1.ColumnString content;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnInt updatedBy;

  @override
  List<_i1.Column> get columns => [
        id,
        type,
        content,
        updatedAt,
        updatedBy,
      ];
}

class PolicyInclude extends _i1.IncludeObject {
  PolicyInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Policy.t;
}

class PolicyIncludeList extends _i1.IncludeList {
  PolicyIncludeList._({
    _i1.WhereExpressionBuilder<PolicyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Policy.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Policy.t;
}

class PolicyRepository {
  const PolicyRepository._();

  /// Returns a list of [Policy]s matching the given query parameters.
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
  Future<List<Policy>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PolicyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PolicyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PolicyTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Policy>(
      where: where?.call(Policy.t),
      orderBy: orderBy?.call(Policy.t),
      orderByList: orderByList?.call(Policy.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Policy] matching the given query parameters.
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
  Future<Policy?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PolicyTable>? where,
    int? offset,
    _i1.OrderByBuilder<PolicyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PolicyTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Policy>(
      where: where?.call(Policy.t),
      orderBy: orderBy?.call(Policy.t),
      orderByList: orderByList?.call(Policy.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Policy] by its [id] or null if no such row exists.
  Future<Policy?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Policy>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Policy]s in the list and returns the inserted rows.
  ///
  /// The returned [Policy]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Policy>> insert(
    _i1.Session session,
    List<Policy> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Policy>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Policy] and returns the inserted row.
  ///
  /// The returned [Policy] will have its `id` field set.
  Future<Policy> insertRow(
    _i1.Session session,
    Policy row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Policy>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Policy]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Policy>> update(
    _i1.Session session,
    List<Policy> rows, {
    _i1.ColumnSelections<PolicyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Policy>(
      rows,
      columns: columns?.call(Policy.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Policy]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Policy> updateRow(
    _i1.Session session,
    Policy row, {
    _i1.ColumnSelections<PolicyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Policy>(
      row,
      columns: columns?.call(Policy.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Policy]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Policy>> delete(
    _i1.Session session,
    List<Policy> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Policy>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Policy].
  Future<Policy> deleteRow(
    _i1.Session session,
    Policy row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Policy>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Policy>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PolicyTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Policy>(
      where: where(Policy.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PolicyTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Policy>(
      where: where?.call(Policy.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
