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
import 'dart:async' as _i2;
import 'package:connect_share_client/src/protocol/user_info.dart' as _i3;
import 'package:connect_share_client/src/protocol/policy.dart' as _i4;
import 'package:connect_share_client/src/protocol/feedback.dart' as _i5;
import 'package:connect_share_client/src/protocol/transaction_log.dart' as _i6;
import 'package:connect_share_client/src/protocol/analytics_data.dart' as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
import 'package:connect_share_client/src/protocol/hotspot_config.dart' as _i9;
import 'package:connect_share_client/src/protocol/access_token.dart' as _i10;
import 'package:connect_share_client/src/protocol/plan.dart' as _i11;
import 'package:connect_share_client/src/protocol/enums.dart' as _i12;
import 'package:connect_share_client/src/protocol/duration.dart' as _i13;
import 'package:connect_share_client/src/protocol/access_token_validation_result.dart'
    as _i14;
import 'protocol.dart' as _i15;

/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i2.Future<List<_i3.UserProfile>> listUsers({
    String? role,
    int? limit,
  }) =>
      caller.callServerEndpoint<List<_i3.UserProfile>>(
        'admin',
        'listUsers',
        {
          'role': role,
          'limit': limit,
        },
      );

  _i2.Future<void> suspendUser(int userId) => caller.callServerEndpoint<void>(
        'admin',
        'suspendUser',
        {'userId': userId},
      );

  _i2.Future<void> deleteUser(int userId) => caller.callServerEndpoint<void>(
        'admin',
        'deleteUser',
        {'userId': userId},
      );

  _i2.Future<_i4.Policy?> getPolicy(String type) =>
      caller.callServerEndpoint<_i4.Policy?>(
        'admin',
        'getPolicy',
        {'type': type},
      );

  _i2.Future<void> updatePolicy(
    String type,
    String content,
  ) =>
      caller.callServerEndpoint<void>(
        'admin',
        'updatePolicy',
        {
          'type': type,
          'content': content,
        },
      );

  _i2.Future<List<_i5.Feedback>> listFeedback({
    String? status,
    int? limit,
  }) =>
      caller.callServerEndpoint<List<_i5.Feedback>>(
        'admin',
        'listFeedback',
        {
          'status': status,
          'limit': limit,
        },
      );

  _i2.Future<void> respondToFeedback(
    int feedbackId,
    String response,
  ) =>
      caller.callServerEndpoint<void>(
        'admin',
        'respondToFeedback',
        {
          'feedbackId': feedbackId,
          'response': response,
        },
      );

  _i2.Future<List<_i6.TransactionLog>> listTransactions({
    String? status,
    int? limit,
  }) =>
      caller.callServerEndpoint<List<_i6.TransactionLog>>(
        'admin',
        'listTransactions',
        {
          'status': status,
          'limit': limit,
        },
      );

  _i2.Future<void> processPayout(String paystackReference) =>
      caller.callServerEndpoint<void>(
        'admin',
        'processPayout',
        {'paystackReference': paystackReference},
      );

  _i2.Future<_i7.AnalyticsData> getAnalytics() =>
      caller.callServerEndpoint<_i7.AnalyticsData>(
        'admin',
        'getAnalytics',
        {},
      );
}

/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  _i2.Future<_i8.UserInfo?> completeUserSetupAndProfile(
    int userId,
    String displayNameForProfile,
    String roleName,
  ) =>
      caller.callServerEndpoint<_i8.UserInfo?>(
        'auth',
        'completeUserSetupAndProfile',
        {
          'userId': userId,
          'displayNameForProfile': displayNameForProfile,
          'roleName': roleName,
        },
      );
}

/// {@category Endpoint}
class EndpointHotspot extends _i1.EndpointRef {
  EndpointHotspot(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'hotspot';

  _i2.Future<List<_i9.HotspotConfig>> listHotspotsForProvider() =>
      caller.callServerEndpoint<List<_i9.HotspotConfig>>(
        'hotspot',
        'listHotspotsForProvider',
        {},
      );

  _i2.Future<_i9.HotspotConfig> createHotspot(
    String name,
    String ssid,
    double latitude,
    double longitude,
  ) =>
      caller.callServerEndpoint<_i9.HotspotConfig>(
        'hotspot',
        'createHotspot',
        {
          'name': name,
          'ssid': ssid,
          'latitude': latitude,
          'longitude': longitude,
        },
      );

  _i2.Future<bool> updateHotspot(
    int hotspotId,
    String name,
    String ssid,
    double latitude,
    double longitude,
    bool isActive,
  ) =>
      caller.callServerEndpoint<bool>(
        'hotspot',
        'updateHotspot',
        {
          'hotspotId': hotspotId,
          'name': name,
          'ssid': ssid,
          'latitude': latitude,
          'longitude': longitude,
          'isActive': isActive,
        },
      );

  _i2.Future<bool> updateHotspotStatus(
    int hotspotId,
    bool isActive,
  ) =>
      caller.callServerEndpoint<bool>(
        'hotspot',
        'updateHotspotStatus',
        {
          'hotspotId': hotspotId,
          'isActive': isActive,
        },
      );

  _i2.Future<bool> deleteHotspot(int hotspotId) =>
      caller.callServerEndpoint<bool>(
        'hotspot',
        'deleteHotspot',
        {'hotspotId': hotspotId},
      );

  _i2.Future<List<_i10.AccessToken>> listActiveSessionsForProvider() =>
      caller.callServerEndpoint<List<_i10.AccessToken>>(
        'hotspot',
        'listActiveSessionsForProvider',
        {},
      );

  _i2.Future<List<_i9.HotspotConfig>> listNearbyHotspots(
    double latitude,
    double longitude,
    double radiusKm,
  ) =>
      caller.callServerEndpoint<List<_i9.HotspotConfig>>(
        'hotspot',
        'listNearbyHotspots',
        {
          'latitude': latitude,
          'longitude': longitude,
          'radiusKm': radiusKm,
        },
      );

  _i2.Future<_i9.HotspotConfig?> getHotspotDetails(int hotspotId) =>
      caller.callServerEndpoint<_i9.HotspotConfig?>(
        'hotspot',
        'getHotspotDetails',
        {'hotspotId': hotspotId},
      );
}

/// {@category Endpoint}
class EndpointPlan extends _i1.EndpointRef {
  EndpointPlan(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'plan';

  _i2.Future<List<_i11.Plan>> listPlansForHotspot(int hotspotId) =>
      caller.callServerEndpoint<List<_i11.Plan>>(
        'plan',
        'listPlansForHotspot',
        {'hotspotId': hotspotId},
      );

  _i2.Future<_i11.Plan> createPlanForHotspot(
    int hotspotId,
    String name,
    String? description,
    _i12.PlanType type,
    _i13.PlanDurationType durationType,
    int durationValue,
    double price,
    String currency,
    double? dataLimitGB,
    double? bandwidthDownMbps,
    double? bandwidthUpMbps,
    bool isActive,
  ) =>
      caller.callServerEndpoint<_i11.Plan>(
        'plan',
        'createPlanForHotspot',
        {
          'hotspotId': hotspotId,
          'name': name,
          'description': description,
          'type': type,
          'durationType': durationType,
          'durationValue': durationValue,
          'price': price,
          'currency': currency,
          'dataLimitGB': dataLimitGB,
          'bandwidthDownMbps': bandwidthDownMbps,
          'bandwidthUpMbps': bandwidthUpMbps,
          'isActive': isActive,
        },
      );

  _i2.Future<bool> updatePlan(_i11.Plan plan) =>
      caller.callServerEndpoint<bool>(
        'plan',
        'updatePlan',
        {'plan': plan},
      );

  _i2.Future<bool> deletePlan(int planId) => caller.callServerEndpoint<bool>(
        'plan',
        'deletePlan',
        {'planId': planId},
      );
}

/// {@category Endpoint}
class EndpointToken extends _i1.EndpointRef {
  EndpointToken(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'token';

  _i2.Future<_i10.AccessToken?> purchasePlanAndGenerateToken(
    int hotspotId,
    int planId,
  ) =>
      caller.callServerEndpoint<_i10.AccessToken?>(
        'token',
        'purchasePlanAndGenerateToken',
        {
          'hotspotId': hotspotId,
          'planId': planId,
        },
      );

  _i2.Future<_i14.AccessTokenValidationResult>
      validateAccessTokenForCaptivePortal(
    String tokenValue,
    String clientMacAddress,
    int hotspotId,
  ) =>
          caller.callServerEndpoint<_i14.AccessTokenValidationResult>(
            'token',
            'validateAccessTokenForCaptivePortal',
            {
              'tokenValue': tokenValue,
              'clientMacAddress': clientMacAddress,
              'hotspotId': hotspotId,
            },
          );

  _i2.Future<void> reportDataUsage(
    String tokenValue,
    int bytesUsed,
  ) =>
      caller.callServerEndpoint<void>(
        'token',
        'reportDataUsage',
        {
          'tokenValue': tokenValue,
          'bytesUsed': bytesUsed,
        },
      );

  _i2.Future<List<_i10.AccessToken>> listMyActiveTokens() =>
      caller.callServerEndpoint<List<_i10.AccessToken>>(
        'token',
        'listMyActiveTokens',
        {},
      );
}

/// {@category Endpoint}
class EndpointTransaction extends _i1.EndpointRef {
  EndpointTransaction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'transaction';

  _i2.Future<_i6.TransactionLog> createTransaction(
    int hotspotId,
    int planId,
    String paystackReference,
    double amountPaid,
    String currency,
  ) =>
      caller.callServerEndpoint<_i6.TransactionLog>(
        'transaction',
        'createTransaction',
        {
          'hotspotId': hotspotId,
          'planId': planId,
          'paystackReference': paystackReference,
          'amountPaid': amountPaid,
          'currency': currency,
        },
      );

  _i2.Future<_i6.TransactionLog> updateTransactionStatus(
    String paystackReference,
    String newStatus, {
    int? accessTokenId,
  }) =>
      caller.callServerEndpoint<_i6.TransactionLog>(
        'transaction',
        'updateTransactionStatus',
        {
          'paystackReference': paystackReference,
          'newStatus': newStatus,
          'accessTokenId': accessTokenId,
        },
      );

  _i2.Future<List<_i6.TransactionLog>> listConsumerTransactions({int? limit}) =>
      caller.callServerEndpoint<List<_i6.TransactionLog>>(
        'transaction',
        'listConsumerTransactions',
        {'limit': limit},
      );

  _i2.Future<List<_i6.TransactionLog>> listProviderTransactions({int? limit}) =>
      caller.callServerEndpoint<List<_i6.TransactionLog>>(
        'transaction',
        'listProviderTransactions',
        {'limit': limit},
      );

  _i2.Future<_i6.TransactionLog> updatePayoutStatus(
    String paystackReference,
    String newPayoutStatus,
  ) =>
      caller.callServerEndpoint<_i6.TransactionLog>(
        'transaction',
        'updatePayoutStatus',
        {
          'paystackReference': paystackReference,
          'newPayoutStatus': newPayoutStatus,
        },
      );
}

/// {@category Endpoint}
class EndpointUserProfile extends _i1.EndpointRef {
  EndpointUserProfile(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userProfile';

  _i2.Future<_i3.UserProfile?> getUserProfile(int userId) =>
      caller.callServerEndpoint<_i3.UserProfile?>(
        'userProfile',
        'getUserProfile',
        {'userId': userId},
      );

  _i2.Future<_i3.UserProfile?> getProfile() =>
      caller.callServerEndpoint<_i3.UserProfile?>(
        'userProfile',
        'getProfile',
        {},
      );

  _i2.Future<bool> updatePaystackAccount(String paystackAccountId) =>
      caller.callServerEndpoint<bool>(
        'userProfile',
        'updatePaystackAccount',
        {'paystackAccountId': paystackAccountId},
      );

  _i2.Future<void> makeAdminByEmail(String email) =>
      caller.callServerEndpoint<void>(
        'userProfile',
        'makeAdminByEmail',
        {'email': email},
      );

  _i2.Future<void> makeAdmin(int userId) => caller.callServerEndpoint<void>(
        'userProfile',
        'makeAdmin',
        {'userId': userId},
      );

  _i2.Future<void> removeAdmin(int userId) => caller.callServerEndpoint<void>(
        'userProfile',
        'removeAdmin',
        {'userId': userId},
      );

  _i2.Future<List<_i3.UserProfile>> listUsers({
    String? role,
    int? limit,
  }) =>
      caller.callServerEndpoint<List<_i3.UserProfile>>(
        'userProfile',
        'listUsers',
        {
          'role': role,
          'limit': limit,
        },
      );
}

class Modules {
  Modules(Client client) {
    auth = _i8.Caller(client);
  }

  late final _i8.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i15.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    admin = EndpointAdmin(this);
    auth = EndpointAuth(this);
    hotspot = EndpointHotspot(this);
    plan = EndpointPlan(this);
    token = EndpointToken(this);
    transaction = EndpointTransaction(this);
    userProfile = EndpointUserProfile(this);
    modules = Modules(this);
  }

  late final EndpointAdmin admin;

  late final EndpointAuth auth;

  late final EndpointHotspot hotspot;

  late final EndpointPlan plan;

  late final EndpointToken token;

  late final EndpointTransaction transaction;

  late final EndpointUserProfile userProfile;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'auth': auth,
        'hotspot': hotspot,
        'plan': plan,
        'token': token,
        'transaction': transaction,
        'userProfile': userProfile,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
