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

abstract class AccessToken implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
