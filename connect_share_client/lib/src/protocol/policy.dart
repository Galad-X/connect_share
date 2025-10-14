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

abstract class Policy implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String type;

  String content;

  DateTime updatedAt;

  int updatedBy;

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
