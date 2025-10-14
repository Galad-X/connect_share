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

abstract class TransactionLog implements _i1.SerializableModel {
  TransactionLog._({
    this.id,
    required this.consumerId,
    required this.providerId,
    required this.hotspotId,
    required this.planId,
    this.accessTokenId,
    required this.paystackReference,
    required this.amountPaid,
    required this.currency,
    required this.transactionDate,
    required this.status,
    this.platformFee,
    this.providerPayoutAmount,
    this.payoutStatus,
  });

  factory TransactionLog({
    int? id,
    required int consumerId,
    required int providerId,
    required int hotspotId,
    required int planId,
    int? accessTokenId,
    required String paystackReference,
    required double amountPaid,
    required String currency,
    required DateTime transactionDate,
    required String status,
    double? platformFee,
    double? providerPayoutAmount,
    String? payoutStatus,
  }) = _TransactionLogImpl;

  factory TransactionLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransactionLog(
      id: jsonSerialization['id'] as int?,
      consumerId: jsonSerialization['consumerId'] as int,
      providerId: jsonSerialization['providerId'] as int,
      hotspotId: jsonSerialization['hotspotId'] as int,
      planId: jsonSerialization['planId'] as int,
      accessTokenId: jsonSerialization['accessTokenId'] as int?,
      paystackReference: jsonSerialization['paystackReference'] as String,
      amountPaid: (jsonSerialization['amountPaid'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String,
      transactionDate: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['transactionDate']),
      status: jsonSerialization['status'] as String,
      platformFee: (jsonSerialization['platformFee'] as num?)?.toDouble(),
      providerPayoutAmount:
          (jsonSerialization['providerPayoutAmount'] as num?)?.toDouble(),
      payoutStatus: jsonSerialization['payoutStatus'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int consumerId;

  int providerId;

  int hotspotId;

  int planId;

  int? accessTokenId;

  String paystackReference;

  double amountPaid;

  String currency;

  DateTime transactionDate;

  String status;

  double? platformFee;

  double? providerPayoutAmount;

  String? payoutStatus;

  /// Returns a shallow copy of this [TransactionLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TransactionLog copyWith({
    int? id,
    int? consumerId,
    int? providerId,
    int? hotspotId,
    int? planId,
    int? accessTokenId,
    String? paystackReference,
    double? amountPaid,
    String? currency,
    DateTime? transactionDate,
    String? status,
    double? platformFee,
    double? providerPayoutAmount,
    String? payoutStatus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'consumerId': consumerId,
      'providerId': providerId,
      'hotspotId': hotspotId,
      'planId': planId,
      if (accessTokenId != null) 'accessTokenId': accessTokenId,
      'paystackReference': paystackReference,
      'amountPaid': amountPaid,
      'currency': currency,
      'transactionDate': transactionDate.toJson(),
      'status': status,
      if (platformFee != null) 'platformFee': platformFee,
      if (providerPayoutAmount != null)
        'providerPayoutAmount': providerPayoutAmount,
      if (payoutStatus != null) 'payoutStatus': payoutStatus,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransactionLogImpl extends TransactionLog {
  _TransactionLogImpl({
    int? id,
    required int consumerId,
    required int providerId,
    required int hotspotId,
    required int planId,
    int? accessTokenId,
    required String paystackReference,
    required double amountPaid,
    required String currency,
    required DateTime transactionDate,
    required String status,
    double? platformFee,
    double? providerPayoutAmount,
    String? payoutStatus,
  }) : super._(
          id: id,
          consumerId: consumerId,
          providerId: providerId,
          hotspotId: hotspotId,
          planId: planId,
          accessTokenId: accessTokenId,
          paystackReference: paystackReference,
          amountPaid: amountPaid,
          currency: currency,
          transactionDate: transactionDate,
          status: status,
          platformFee: platformFee,
          providerPayoutAmount: providerPayoutAmount,
          payoutStatus: payoutStatus,
        );

  /// Returns a shallow copy of this [TransactionLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TransactionLog copyWith({
    Object? id = _Undefined,
    int? consumerId,
    int? providerId,
    int? hotspotId,
    int? planId,
    Object? accessTokenId = _Undefined,
    String? paystackReference,
    double? amountPaid,
    String? currency,
    DateTime? transactionDate,
    String? status,
    Object? platformFee = _Undefined,
    Object? providerPayoutAmount = _Undefined,
    Object? payoutStatus = _Undefined,
  }) {
    return TransactionLog(
      id: id is int? ? id : this.id,
      consumerId: consumerId ?? this.consumerId,
      providerId: providerId ?? this.providerId,
      hotspotId: hotspotId ?? this.hotspotId,
      planId: planId ?? this.planId,
      accessTokenId: accessTokenId is int? ? accessTokenId : this.accessTokenId,
      paystackReference: paystackReference ?? this.paystackReference,
      amountPaid: amountPaid ?? this.amountPaid,
      currency: currency ?? this.currency,
      transactionDate: transactionDate ?? this.transactionDate,
      status: status ?? this.status,
      platformFee: platformFee is double? ? platformFee : this.platformFee,
      providerPayoutAmount: providerPayoutAmount is double?
          ? providerPayoutAmount
          : this.providerPayoutAmount,
      payoutStatus: payoutStatus is String? ? payoutStatus : this.payoutStatus,
    );
  }
}
