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

abstract class Feedback implements _i1.SerializableModel {
  Feedback._({
    this.id,
    required this.userId,
    required this.type,
    required this.content,
    required this.submittedAt,
    required this.status,
    this.response,
    this.respondedAt,
    this.respondedBy,
  });

  factory Feedback({
    int? id,
    required int userId,
    required String type,
    required String content,
    required DateTime submittedAt,
    required String status,
    String? response,
    DateTime? respondedAt,
    int? respondedBy,
  }) = _FeedbackImpl;

  factory Feedback.fromJson(Map<String, dynamic> jsonSerialization) {
    return Feedback(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      type: jsonSerialization['type'] as String,
      content: jsonSerialization['content'] as String,
      submittedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['submittedAt']),
      status: jsonSerialization['status'] as String,
      response: jsonSerialization['response'] as String?,
      respondedAt: jsonSerialization['respondedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['respondedAt']),
      respondedBy: jsonSerialization['respondedBy'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String type;

  String content;

  DateTime submittedAt;

  String status;

  String? response;

  DateTime? respondedAt;

  int? respondedBy;

  /// Returns a shallow copy of this [Feedback]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Feedback copyWith({
    int? id,
    int? userId,
    String? type,
    String? content,
    DateTime? submittedAt,
    String? status,
    String? response,
    DateTime? respondedAt,
    int? respondedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'type': type,
      'content': content,
      'submittedAt': submittedAt.toJson(),
      'status': status,
      if (response != null) 'response': response,
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
      if (respondedBy != null) 'respondedBy': respondedBy,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackImpl extends Feedback {
  _FeedbackImpl({
    int? id,
    required int userId,
    required String type,
    required String content,
    required DateTime submittedAt,
    required String status,
    String? response,
    DateTime? respondedAt,
    int? respondedBy,
  }) : super._(
          id: id,
          userId: userId,
          type: type,
          content: content,
          submittedAt: submittedAt,
          status: status,
          response: response,
          respondedAt: respondedAt,
          respondedBy: respondedBy,
        );

  /// Returns a shallow copy of this [Feedback]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Feedback copyWith({
    Object? id = _Undefined,
    int? userId,
    String? type,
    String? content,
    DateTime? submittedAt,
    String? status,
    Object? response = _Undefined,
    Object? respondedAt = _Undefined,
    Object? respondedBy = _Undefined,
  }) {
    return Feedback(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      content: content ?? this.content,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      response: response is String? ? response : this.response,
      respondedAt: respondedAt is DateTime? ? respondedAt : this.respondedAt,
      respondedBy: respondedBy is int? ? respondedBy : this.respondedBy,
    );
  }
}
