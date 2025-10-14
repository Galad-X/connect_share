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

abstract class UserProfile
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserProfile._({
    this.id,
    required this.userId,
    this.paystackAccountId,
    required this.displayName,
    this.bio,
    int? hotspotCount,
    required this.sharedDataLimit,
    double? currentDataUsage,
    double? rating,
    bool? isHotspotProvider,
    this.lastActiveTime,
    String? role,
  })  : hotspotCount = hotspotCount ?? 0,
        currentDataUsage = currentDataUsage ?? 0.0,
        rating = rating ?? 5.0,
        isHotspotProvider = isHotspotProvider ?? false,
        role = role ?? 'consumer';

  factory UserProfile({
    int? id,
    required int userId,
    String? paystackAccountId,
    required String displayName,
    String? bio,
    int? hotspotCount,
    required double sharedDataLimit,
    double? currentDataUsage,
    double? rating,
    bool? isHotspotProvider,
    DateTime? lastActiveTime,
    String? role,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      paystackAccountId: jsonSerialization['paystackAccountId'] as String?,
      displayName: jsonSerialization['displayName'] as String,
      bio: jsonSerialization['bio'] as String?,
      hotspotCount: jsonSerialization['hotspotCount'] as int,
      sharedDataLimit: (jsonSerialization['sharedDataLimit'] as num).toDouble(),
      currentDataUsage:
          (jsonSerialization['currentDataUsage'] as num).toDouble(),
      rating: (jsonSerialization['rating'] as num).toDouble(),
      isHotspotProvider: jsonSerialization['isHotspotProvider'] as bool,
      lastActiveTime: jsonSerialization['lastActiveTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastActiveTime']),
      role: jsonSerialization['role'] as String,
    );
  }

  static final t = UserProfileTable();

  static const db = UserProfileRepository._();

  @override
  int? id;

  int userId;

  String? paystackAccountId;

  String displayName;

  String? bio;

  int hotspotCount;

  double sharedDataLimit;

  double currentDataUsage;

  double rating;

  bool isHotspotProvider;

  DateTime? lastActiveTime;

  String role;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    int? id,
    int? userId,
    String? paystackAccountId,
    String? displayName,
    String? bio,
    int? hotspotCount,
    double? sharedDataLimit,
    double? currentDataUsage,
    double? rating,
    bool? isHotspotProvider,
    DateTime? lastActiveTime,
    String? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (paystackAccountId != null) 'paystackAccountId': paystackAccountId,
      'displayName': displayName,
      if (bio != null) 'bio': bio,
      'hotspotCount': hotspotCount,
      'sharedDataLimit': sharedDataLimit,
      'currentDataUsage': currentDataUsage,
      'rating': rating,
      'isHotspotProvider': isHotspotProvider,
      if (lastActiveTime != null) 'lastActiveTime': lastActiveTime?.toJson(),
      'role': role,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (paystackAccountId != null) 'paystackAccountId': paystackAccountId,
      'displayName': displayName,
      if (bio != null) 'bio': bio,
      'hotspotCount': hotspotCount,
      'sharedDataLimit': sharedDataLimit,
      'currentDataUsage': currentDataUsage,
      'rating': rating,
      'isHotspotProvider': isHotspotProvider,
      if (lastActiveTime != null) 'lastActiveTime': lastActiveTime?.toJson(),
      'role': role,
    };
  }

  static UserProfileInclude include() {
    return UserProfileInclude._();
  }

  static UserProfileIncludeList includeList({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    UserProfileInclude? include,
  }) {
    return UserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    int? id,
    required int userId,
    String? paystackAccountId,
    required String displayName,
    String? bio,
    int? hotspotCount,
    required double sharedDataLimit,
    double? currentDataUsage,
    double? rating,
    bool? isHotspotProvider,
    DateTime? lastActiveTime,
    String? role,
  }) : super._(
          id: id,
          userId: userId,
          paystackAccountId: paystackAccountId,
          displayName: displayName,
          bio: bio,
          hotspotCount: hotspotCount,
          sharedDataLimit: sharedDataLimit,
          currentDataUsage: currentDataUsage,
          rating: rating,
          isHotspotProvider: isHotspotProvider,
          lastActiveTime: lastActiveTime,
          role: role,
        );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    int? userId,
    Object? paystackAccountId = _Undefined,
    String? displayName,
    Object? bio = _Undefined,
    int? hotspotCount,
    double? sharedDataLimit,
    double? currentDataUsage,
    double? rating,
    bool? isHotspotProvider,
    Object? lastActiveTime = _Undefined,
    String? role,
  }) {
    return UserProfile(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      paystackAccountId: paystackAccountId is String?
          ? paystackAccountId
          : this.paystackAccountId,
      displayName: displayName ?? this.displayName,
      bio: bio is String? ? bio : this.bio,
      hotspotCount: hotspotCount ?? this.hotspotCount,
      sharedDataLimit: sharedDataLimit ?? this.sharedDataLimit,
      currentDataUsage: currentDataUsage ?? this.currentDataUsage,
      rating: rating ?? this.rating,
      isHotspotProvider: isHotspotProvider ?? this.isHotspotProvider,
      lastActiveTime:
          lastActiveTime is DateTime? ? lastActiveTime : this.lastActiveTime,
      role: role ?? this.role,
    );
  }
}

class UserProfileTable extends _i1.Table<int?> {
  UserProfileTable({super.tableRelation}) : super(tableName: 'user_profile') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    paystackAccountId = _i1.ColumnString(
      'paystackAccountId',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
      this,
    );
    bio = _i1.ColumnString(
      'bio',
      this,
    );
    hotspotCount = _i1.ColumnInt(
      'hotspotCount',
      this,
      hasDefault: true,
    );
    sharedDataLimit = _i1.ColumnDouble(
      'sharedDataLimit',
      this,
    );
    currentDataUsage = _i1.ColumnDouble(
      'currentDataUsage',
      this,
      hasDefault: true,
    );
    rating = _i1.ColumnDouble(
      'rating',
      this,
      hasDefault: true,
    );
    isHotspotProvider = _i1.ColumnBool(
      'isHotspotProvider',
      this,
      hasDefault: true,
    );
    lastActiveTime = _i1.ColumnDateTime(
      'lastActiveTime',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString paystackAccountId;

  late final _i1.ColumnString displayName;

  late final _i1.ColumnString bio;

  late final _i1.ColumnInt hotspotCount;

  late final _i1.ColumnDouble sharedDataLimit;

  late final _i1.ColumnDouble currentDataUsage;

  late final _i1.ColumnDouble rating;

  late final _i1.ColumnBool isHotspotProvider;

  late final _i1.ColumnDateTime lastActiveTime;

  late final _i1.ColumnString role;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        paystackAccountId,
        displayName,
        bio,
        hotspotCount,
        sharedDataLimit,
        currentDataUsage,
        rating,
        isHotspotProvider,
        lastActiveTime,
        role,
      ];
}

class UserProfileInclude extends _i1.IncludeObject {
  UserProfileInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserProfile.t;
}

class UserProfileIncludeList extends _i1.IncludeList {
  UserProfileIncludeList._({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProfile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserProfile.t;
}

class UserProfileRepository {
  const UserProfileRepository._();

  /// Returns a list of [UserProfile]s matching the given query parameters.
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
  Future<List<UserProfile>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserProfile] matching the given query parameters.
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
  Future<UserProfile?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserProfile] by its [id] or null if no such row exists.
  Future<UserProfile?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserProfile>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserProfile>> insert(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserProfile] and returns the inserted row.
  ///
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile> insertRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserProfile>> update(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserProfile>(
      rows,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfile> updateRow(
    _i1.Session session,
    UserProfile row, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfile>(
      row,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserProfile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserProfile>> delete(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserProfile].
  Future<UserProfile> deleteRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserProfile>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserProfile>(
      where: where(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserProfile>(
      where: where?.call(UserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
