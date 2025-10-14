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
import 'plan.dart' as _i2;

abstract class AccessTokenValidationResult implements _i1.SerializableModel {
  AccessTokenValidationResult._({
    required this.isValid,
    this.message,
    this.userId,
    this.planDetails,
    this.remainingDataBytes,
    this.sessionExpiryTime,
  });

  factory AccessTokenValidationResult({
    required bool isValid,
    String? message,
    int? userId,
    _i2.Plan? planDetails,
    double? remainingDataBytes,
    DateTime? sessionExpiryTime,
  }) = _AccessTokenValidationResultImpl;

  factory AccessTokenValidationResult.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return AccessTokenValidationResult(
      isValid: jsonSerialization['isValid'] as bool,
      message: jsonSerialization['message'] as String?,
      userId: jsonSerialization['userId'] as int?,
      planDetails: jsonSerialization['planDetails'] == null
          ? null
          : _i2.Plan.fromJson(
              (jsonSerialization['planDetails'] as Map<String, dynamic>)),
      remainingDataBytes:
          (jsonSerialization['remainingDataBytes'] as num?)?.toDouble(),
      sessionExpiryTime: jsonSerialization['sessionExpiryTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['sessionExpiryTime']),
    );
  }

  bool isValid;

  String? message;

  int? userId;

  _i2.Plan? planDetails;

  double? remainingDataBytes;

  DateTime? sessionExpiryTime;

  /// Returns a shallow copy of this [AccessTokenValidationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccessTokenValidationResult copyWith({
    bool? isValid,
    String? message,
    int? userId,
    _i2.Plan? planDetails,
    double? remainingDataBytes,
    DateTime? sessionExpiryTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      if (message != null) 'message': message,
      if (userId != null) 'userId': userId,
      if (planDetails != null) 'planDetails': planDetails?.toJson(),
      if (remainingDataBytes != null) 'remainingDataBytes': remainingDataBytes,
      if (sessionExpiryTime != null)
        'sessionExpiryTime': sessionExpiryTime?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccessTokenValidationResultImpl extends AccessTokenValidationResult {
  _AccessTokenValidationResultImpl({
    required bool isValid,
    String? message,
    int? userId,
    _i2.Plan? planDetails,
    double? remainingDataBytes,
    DateTime? sessionExpiryTime,
  }) : super._(
          isValid: isValid,
          message: message,
          userId: userId,
          planDetails: planDetails,
          remainingDataBytes: remainingDataBytes,
          sessionExpiryTime: sessionExpiryTime,
        );

  /// Returns a shallow copy of this [AccessTokenValidationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccessTokenValidationResult copyWith({
    bool? isValid,
    Object? message = _Undefined,
    Object? userId = _Undefined,
    Object? planDetails = _Undefined,
    Object? remainingDataBytes = _Undefined,
    Object? sessionExpiryTime = _Undefined,
  }) {
    return AccessTokenValidationResult(
      isValid: isValid ?? this.isValid,
      message: message is String? ? message : this.message,
      userId: userId is int? ? userId : this.userId,
      planDetails:
          planDetails is _i2.Plan? ? planDetails : this.planDetails?.copyWith(),
      remainingDataBytes: remainingDataBytes is double?
          ? remainingDataBytes
          : this.remainingDataBytes,
      sessionExpiryTime: sessionExpiryTime is DateTime?
          ? sessionExpiryTime
          : this.sessionExpiryTime,
    );
  }
}
