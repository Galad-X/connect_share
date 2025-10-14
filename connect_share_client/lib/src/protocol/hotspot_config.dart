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

abstract class HotspotConfig implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
