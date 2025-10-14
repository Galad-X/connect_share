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

abstract class AnalyticsData implements _i1.SerializableModel {
  AnalyticsData._({
    required this.totalUsers,
    required this.activeHotspots,
    required this.successfulTransactions,
    required this.totalDataUsedMB,
  });

  factory AnalyticsData({
    required int totalUsers,
    required int activeHotspots,
    required int successfulTransactions,
    required int totalDataUsedMB,
  }) = _AnalyticsDataImpl;

  factory AnalyticsData.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnalyticsData(
      totalUsers: jsonSerialization['totalUsers'] as int,
      activeHotspots: jsonSerialization['activeHotspots'] as int,
      successfulTransactions:
          jsonSerialization['successfulTransactions'] as int,
      totalDataUsedMB: jsonSerialization['totalDataUsedMB'] as int,
    );
  }

  int totalUsers;

  int activeHotspots;

  int successfulTransactions;

  int totalDataUsedMB;

  /// Returns a shallow copy of this [AnalyticsData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnalyticsData copyWith({
    int? totalUsers,
    int? activeHotspots,
    int? successfulTransactions,
    int? totalDataUsedMB,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeHotspots': activeHotspots,
      'successfulTransactions': successfulTransactions,
      'totalDataUsedMB': totalDataUsedMB,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AnalyticsDataImpl extends AnalyticsData {
  _AnalyticsDataImpl({
    required int totalUsers,
    required int activeHotspots,
    required int successfulTransactions,
    required int totalDataUsedMB,
  }) : super._(
          totalUsers: totalUsers,
          activeHotspots: activeHotspots,
          successfulTransactions: successfulTransactions,
          totalDataUsedMB: totalDataUsedMB,
        );

  /// Returns a shallow copy of this [AnalyticsData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnalyticsData copyWith({
    int? totalUsers,
    int? activeHotspots,
    int? successfulTransactions,
    int? totalDataUsedMB,
  }) {
    return AnalyticsData(
      totalUsers: totalUsers ?? this.totalUsers,
      activeHotspots: activeHotspots ?? this.activeHotspots,
      successfulTransactions:
          successfulTransactions ?? this.successfulTransactions,
      totalDataUsedMB: totalDataUsedMB ?? this.totalDataUsedMB,
    );
  }
}
