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

abstract class ArgumentException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  ArgumentException._({
    String? message,
    this.parameterName,
    int? errorCode,
  })  : message = message ?? 'Invalid argument provided',
        errorCode = errorCode ?? 400;

  factory ArgumentException({
    String? message,
    String? parameterName,
    int? errorCode,
  }) = _ArgumentExceptionImpl;

  factory ArgumentException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ArgumentException(
      message: jsonSerialization['message'] as String,
      parameterName: jsonSerialization['parameterName'] as String?,
      errorCode: jsonSerialization['errorCode'] as int,
    );
  }

  String message;

  String? parameterName;

  int errorCode;

  /// Returns a shallow copy of this [ArgumentException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ArgumentException copyWith({
    String? message,
    String? parameterName,
    int? errorCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      if (parameterName != null) 'parameterName': parameterName,
      'errorCode': errorCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'message': message,
      if (parameterName != null) 'parameterName': parameterName,
      'errorCode': errorCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ArgumentExceptionImpl extends ArgumentException {
  _ArgumentExceptionImpl({
    String? message,
    String? parameterName,
    int? errorCode,
  }) : super._(
          message: message,
          parameterName: parameterName,
          errorCode: errorCode,
        );

  /// Returns a shallow copy of this [ArgumentException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ArgumentException copyWith({
    String? message,
    Object? parameterName = _Undefined,
    int? errorCode,
  }) {
    return ArgumentException(
      message: message ?? this.message,
      parameterName:
          parameterName is String? ? parameterName : this.parameterName,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
