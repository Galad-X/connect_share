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
import 'enums.dart' as _i2;
import 'duration.dart' as _i3;

abstract class Plan implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
