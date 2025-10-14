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
import 'access_token.dart' as _i2;
import 'access_token_validation_result.dart' as _i3;
import 'analytics_data.dart' as _i4;
import 'argument_exception.dart' as _i5;
import 'auth_exception.dart' as _i6;
import 'duration.dart' as _i7;
import 'enums.dart' as _i8;
import 'feedback.dart' as _i9;
import 'hotspot_config.dart' as _i10;
import 'plan.dart' as _i11;
import 'policy.dart' as _i12;
import 'transaction_log.dart' as _i13;
import 'user_info.dart' as _i14;
import 'package:connect_share_client/src/protocol/user_info.dart' as _i15;
import 'package:connect_share_client/src/protocol/feedback.dart' as _i16;
import 'package:connect_share_client/src/protocol/transaction_log.dart' as _i17;
import 'package:connect_share_client/src/protocol/hotspot_config.dart' as _i18;
import 'package:connect_share_client/src/protocol/access_token.dart' as _i19;
import 'package:connect_share_client/src/protocol/plan.dart' as _i20;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i21;
export 'access_token.dart';
export 'access_token_validation_result.dart';
export 'analytics_data.dart';
export 'argument_exception.dart';
export 'auth_exception.dart';
export 'duration.dart';
export 'enums.dart';
export 'feedback.dart';
export 'hotspot_config.dart';
export 'plan.dart';
export 'policy.dart';
export 'transaction_log.dart';
export 'user_info.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.AccessToken) {
      return _i2.AccessToken.fromJson(data) as T;
    }
    if (t == _i3.AccessTokenValidationResult) {
      return _i3.AccessTokenValidationResult.fromJson(data) as T;
    }
    if (t == _i4.AnalyticsData) {
      return _i4.AnalyticsData.fromJson(data) as T;
    }
    if (t == _i5.ArgumentException) {
      return _i5.ArgumentException.fromJson(data) as T;
    }
    if (t == _i6.AuthenticationException) {
      return _i6.AuthenticationException.fromJson(data) as T;
    }
    if (t == _i7.PlanDurationType) {
      return _i7.PlanDurationType.fromJson(data) as T;
    }
    if (t == _i8.PlanType) {
      return _i8.PlanType.fromJson(data) as T;
    }
    if (t == _i9.Feedback) {
      return _i9.Feedback.fromJson(data) as T;
    }
    if (t == _i10.HotspotConfig) {
      return _i10.HotspotConfig.fromJson(data) as T;
    }
    if (t == _i11.Plan) {
      return _i11.Plan.fromJson(data) as T;
    }
    if (t == _i12.Policy) {
      return _i12.Policy.fromJson(data) as T;
    }
    if (t == _i13.TransactionLog) {
      return _i13.TransactionLog.fromJson(data) as T;
    }
    if (t == _i14.UserProfile) {
      return _i14.UserProfile.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AccessToken?>()) {
      return (data != null ? _i2.AccessToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AccessTokenValidationResult?>()) {
      return (data != null
          ? _i3.AccessTokenValidationResult.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.AnalyticsData?>()) {
      return (data != null ? _i4.AnalyticsData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ArgumentException?>()) {
      return (data != null ? _i5.ArgumentException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AuthenticationException?>()) {
      return (data != null ? _i6.AuthenticationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.PlanDurationType?>()) {
      return (data != null ? _i7.PlanDurationType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PlanType?>()) {
      return (data != null ? _i8.PlanType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Feedback?>()) {
      return (data != null ? _i9.Feedback.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.HotspotConfig?>()) {
      return (data != null ? _i10.HotspotConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Plan?>()) {
      return (data != null ? _i11.Plan.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Policy?>()) {
      return (data != null ? _i12.Policy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.TransactionLog?>()) {
      return (data != null ? _i13.TransactionLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.UserProfile?>()) {
      return (data != null ? _i14.UserProfile.fromJson(data) : null) as T;
    }
    if (t == List<_i15.UserProfile>) {
      return (data as List)
          .map((e) => deserialize<_i15.UserProfile>(e))
          .toList() as T;
    }
    if (t == List<_i16.Feedback>) {
      return (data as List).map((e) => deserialize<_i16.Feedback>(e)).toList()
          as T;
    }
    if (t == List<_i17.TransactionLog>) {
      return (data as List)
          .map((e) => deserialize<_i17.TransactionLog>(e))
          .toList() as T;
    }
    if (t == List<_i18.HotspotConfig>) {
      return (data as List)
          .map((e) => deserialize<_i18.HotspotConfig>(e))
          .toList() as T;
    }
    if (t == List<_i19.AccessToken>) {
      return (data as List)
          .map((e) => deserialize<_i19.AccessToken>(e))
          .toList() as T;
    }
    if (t == List<_i20.Plan>) {
      return (data as List).map((e) => deserialize<_i20.Plan>(e)).toList() as T;
    }
    try {
      return _i21.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.AccessToken) {
      return 'AccessToken';
    }
    if (data is _i3.AccessTokenValidationResult) {
      return 'AccessTokenValidationResult';
    }
    if (data is _i4.AnalyticsData) {
      return 'AnalyticsData';
    }
    if (data is _i5.ArgumentException) {
      return 'ArgumentException';
    }
    if (data is _i6.AuthenticationException) {
      return 'AuthenticationException';
    }
    if (data is _i7.PlanDurationType) {
      return 'PlanDurationType';
    }
    if (data is _i8.PlanType) {
      return 'PlanType';
    }
    if (data is _i9.Feedback) {
      return 'Feedback';
    }
    if (data is _i10.HotspotConfig) {
      return 'HotspotConfig';
    }
    if (data is _i11.Plan) {
      return 'Plan';
    }
    if (data is _i12.Policy) {
      return 'Policy';
    }
    if (data is _i13.TransactionLog) {
      return 'TransactionLog';
    }
    if (data is _i14.UserProfile) {
      return 'UserProfile';
    }
    className = _i21.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccessToken') {
      return deserialize<_i2.AccessToken>(data['data']);
    }
    if (dataClassName == 'AccessTokenValidationResult') {
      return deserialize<_i3.AccessTokenValidationResult>(data['data']);
    }
    if (dataClassName == 'AnalyticsData') {
      return deserialize<_i4.AnalyticsData>(data['data']);
    }
    if (dataClassName == 'ArgumentException') {
      return deserialize<_i5.ArgumentException>(data['data']);
    }
    if (dataClassName == 'AuthenticationException') {
      return deserialize<_i6.AuthenticationException>(data['data']);
    }
    if (dataClassName == 'PlanDurationType') {
      return deserialize<_i7.PlanDurationType>(data['data']);
    }
    if (dataClassName == 'PlanType') {
      return deserialize<_i8.PlanType>(data['data']);
    }
    if (dataClassName == 'Feedback') {
      return deserialize<_i9.Feedback>(data['data']);
    }
    if (dataClassName == 'HotspotConfig') {
      return deserialize<_i10.HotspotConfig>(data['data']);
    }
    if (dataClassName == 'Plan') {
      return deserialize<_i11.Plan>(data['data']);
    }
    if (dataClassName == 'Policy') {
      return deserialize<_i12.Policy>(data['data']);
    }
    if (dataClassName == 'TransactionLog') {
      return deserialize<_i13.TransactionLog>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i14.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i21.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
