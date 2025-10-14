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

abstract class AuthenticationException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  AuthenticationException._({
    String? message,
    int? errorCode,
  })  : message = message ?? 'Authentication failed',
        errorCode = errorCode ?? 401;

  factory AuthenticationException({
    String? message,
    int? errorCode,
  }) = _AuthenticationExceptionImpl;

  factory AuthenticationException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return AuthenticationException(
      message: jsonSerialization['message'] as String,
      errorCode: jsonSerialization['errorCode'] as int,
    );
  }

  String message;

  int errorCode;

  /// Returns a shallow copy of this [AuthenticationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthenticationException copyWith({
    String? message,
    int? errorCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'errorCode': errorCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'message': message,
      'errorCode': errorCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AuthenticationExceptionImpl extends AuthenticationException {
  _AuthenticationExceptionImpl({
    String? message,
    int? errorCode,
  }) : super._(
          message: message,
          errorCode: errorCode,
        );

  /// Returns a shallow copy of this [AuthenticationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthenticationException copyWith({
    String? message,
    int? errorCode,
  }) {
    return AuthenticationException(
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
