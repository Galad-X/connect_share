/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class UserProfile implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
