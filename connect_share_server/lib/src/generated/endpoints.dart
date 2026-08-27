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
import '../endpoints/admin_endpoint.dart' as _i2;
import '../endpoints/auth_endpoint.dart' as _i3;
import '../endpoints/hotspot_endpoint.dart' as _i4;
import '../endpoints/plan_endpoint.dart' as _i5;
import '../endpoints/token_endpoint.dart' as _i6;
import '../endpoints/transaction_endpoint.dart' as _i7;
import '../endpoints/user_profile_endpoint.dart' as _i8;
import 'package:connect_share_server/src/generated/enums.dart' as _i9;
import 'package:connect_share_server/src/generated/duration.dart' as _i10;
import 'package:connect_share_server/src/generated/plan.dart' as _i11;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i12;
import 'package:connect_share_server/src/generated/access_token.dart' as _i13;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'admin': _i2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'auth': _i3.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'hotspot': _i4.HotspotEndpoint()
        ..initialize(
          server,
          'hotspot',
          null,
        ),
      'plan': _i5.PlanEndpoint()
        ..initialize(
          server,
          'plan',
          null,
        ),
      'token': _i6.TokenEndpoint()
        ..initialize(
          server,
          'token',
          null,
        ),
      'transaction': _i7.TransactionEndpoint()
        ..initialize(
          server,
          'transaction',
          null,
        ),
      'userProfile': _i8.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
    };
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'listUsers': _i1.MethodConnector(
          name: 'listUsers',
          params: {
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).listUsers(
            session,
            role: params['role'],
            limit: params['limit'],
          ),
        ),
        'suspendUser': _i1.MethodConnector(
          name: 'suspendUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).suspendUser(
            session,
            params['userId'],
          ),
        ),
        'deleteUser': _i1.MethodConnector(
          name: 'deleteUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).deleteUser(
            session,
            params['userId'],
          ),
        ),
        'getPolicy': _i1.MethodConnector(
          name: 'getPolicy',
          params: {
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getPolicy(
            session,
            params['type'],
          ),
        ),
        'updatePolicy': _i1.MethodConnector(
          name: 'updatePolicy',
          params: {
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'content': _i1.ParameterDescription(
              name: 'content',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).updatePolicy(
            session,
            params['type'],
            params['content'],
          ),
        ),
        'listFeedback': _i1.MethodConnector(
          name: 'listFeedback',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).listFeedback(
            session,
            status: params['status'],
            limit: params['limit'],
          ),
        ),
        'respondToFeedback': _i1.MethodConnector(
          name: 'respondToFeedback',
          params: {
            'feedbackId': _i1.ParameterDescription(
              name: 'feedbackId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'response': _i1.ParameterDescription(
              name: 'response',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).respondToFeedback(
            session,
            params['feedbackId'],
            params['response'],
          ),
        ),
        'listTransactions': _i1.MethodConnector(
          name: 'listTransactions',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).listTransactions(
            session,
            status: params['status'],
            limit: params['limit'],
          ),
        ),
        'processPayout': _i1.MethodConnector(
          name: 'processPayout',
          params: {
            'paystackReference': _i1.ParameterDescription(
              name: 'paystackReference',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).processPayout(
            session,
            params['paystackReference'],
          ),
        ),
        'getAnalytics': _i1.MethodConnector(
          name: 'getAnalytics',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['admin'] as _i2.AdminEndpoint).getAnalytics(session),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'completeUserSetupAndProfile': _i1.MethodConnector(
          name: 'completeUserSetupAndProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'displayNameForProfile': _i1.ParameterDescription(
              name: 'displayNameForProfile',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'roleName': _i1.ParameterDescription(
              name: 'roleName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['auth'] as _i3.AuthEndpoint)
                  .completeUserSetupAndProfile(
            session,
            params['userId'],
            params['displayNameForProfile'],
            params['roleName'],
          ),
        )
      },
    );
    connectors['hotspot'] = _i1.EndpointConnector(
      name: 'hotspot',
      endpoint: endpoints['hotspot']!,
      methodConnectors: {
        'listHotspotsForProvider': _i1.MethodConnector(
          name: 'listHotspotsForProvider',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['hotspot'] as _i4.HotspotEndpoint)
                  .listHotspotsForProvider(session),
        ),
        'createHotspot': _i1.MethodConnector(
          name: 'createHotspot',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'ssid': _i1.ParameterDescription(
              name: 'ssid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['hotspot'] as _i4.HotspotEndpoint).createHotspot(
            session,
            params['name'],
            params['ssid'],
            params['latitude'],
            params['longitude'],
          ),
        ),
        'updateHotspot': _i1.MethodConnector(
          name: 'updateHotspot',
          params: {
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'ssid': _i1.ParameterDescription(
              name: 'ssid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['hotspot'] as _i4.HotspotEndpoint).updateHotspot(
            session,
            params['hotspotId'],
            params['name'],
            params['ssid'],
            params['latitude'],
            params['longitude'],
            params['isActive'],
          ),
        ),
        'updateHotspotStatus': _i1.MethodConnector(
          name: 'updateHotspotStatus',
          params: {
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['hotspot'] as _i4.HotspotEndpoint).updateHotspotStatus(
            session,
            params['hotspotId'],
            params['isActive'],
          ),
        ),
        'deleteHotspot': _i1.MethodConnector(
          name: 'deleteHotspot',
          params: {
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['hotspot'] as _i4.HotspotEndpoint).deleteHotspot(
            session,
            params['hotspotId'],
          ),
        ),
        'listActiveSessionsForProvider': _i1.MethodConnector(
          name: 'listActiveSessionsForProvider',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['hotspot'] as _i4.HotspotEndpoint)
                  .listActiveSessionsForProvider(session),
        ),
        'listNearbyHotspots': _i1.MethodConnector(
          name: 'listNearbyHotspots',
          params: {
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'radiusKm': _i1.ParameterDescription(
              name: 'radiusKm',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['hotspot'] as _i4.HotspotEndpoint).listNearbyHotspots(
            session,
            params['latitude'],
            params['longitude'],
            params['radiusKm'],
          ),
        ),
        'getHotspotDetails': _i1.MethodConnector(
          name: 'getHotspotDetails',
          params: {
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['hotspot'] as _i4.HotspotEndpoint).getHotspotDetails(
            session,
            params['hotspotId'],
          ),
        ),
      },
    );
    connectors['plan'] = _i1.EndpointConnector(
      name: 'plan',
      endpoint: endpoints['plan']!,
      methodConnectors: {
        'listPlansForHotspot': _i1.MethodConnector(
          name: 'listPlansForHotspot',
          params: {
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['plan'] as _i5.PlanEndpoint).listPlansForHotspot(
            session,
            params['hotspotId'],
          ),
        ),
        'createPlanForHotspot': _i1.MethodConnector(
          name: 'createPlanForHotspot',
          params: {
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'type': _i1.ParameterDescription(
              name: 'type',
              type: _i1.getType<_i9.PlanType>(),
              nullable: false,
            ),
            'durationType': _i1.ParameterDescription(
              name: 'durationType',
              type: _i1.getType<_i10.PlanDurationType>(),
              nullable: false,
            ),
            'durationValue': _i1.ParameterDescription(
              name: 'durationValue',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'price': _i1.ParameterDescription(
              name: 'price',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'currency': _i1.ParameterDescription(
              name: 'currency',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'dataLimitGB': _i1.ParameterDescription(
              name: 'dataLimitGB',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'bandwidthDownMbps': _i1.ParameterDescription(
              name: 'bandwidthDownMbps',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'bandwidthUpMbps': _i1.ParameterDescription(
              name: 'bandwidthUpMbps',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['plan'] as _i5.PlanEndpoint).createPlanForHotspot(
            session,
            params['hotspotId'],
            params['name'],
            params['description'],
            params['type'],
            params['durationType'],
            params['durationValue'],
            params['price'],
            params['currency'],
            params['dataLimitGB'],
            params['bandwidthDownMbps'],
            params['bandwidthUpMbps'],
            params['isActive'],
          ),
        ),
        'updatePlan': _i1.MethodConnector(
          name: 'updatePlan',
          params: {
            'plan': _i1.ParameterDescription(
              name: 'plan',
              type: _i1.getType<_i11.Plan>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['plan'] as _i5.PlanEndpoint).updatePlan(
            session,
            params['plan'],
          ),
        ),
        'deletePlan': _i1.MethodConnector(
          name: 'deletePlan',
          params: {
            'planId': _i1.ParameterDescription(
              name: 'planId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['plan'] as _i5.PlanEndpoint).deletePlan(
            session,
            params['planId'],
          ),
        ),
      },
    );
    connectors['token'] = _i1.EndpointConnector(
      name: 'token',
      endpoint: endpoints['token']!,
      methodConnectors: {
        'validateAccessTokenForCaptivePortal': _i1.MethodConnector(
          name: 'validateAccessTokenForCaptivePortal',
          params: {
            'tokenValue': _i1.ParameterDescription(
              name: 'tokenValue',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'clientMacAddress': _i1.ParameterDescription(
              name: 'clientMacAddress',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['token'] as _i6.TokenEndpoint)
                  .validateAccessTokenForCaptivePortal(
            session,
            params['tokenValue'],
            params['clientMacAddress'],
            params['hotspotId'],
          ),
        ),
        'reportDataUsage': _i1.MethodConnector(
          name: 'reportDataUsage',
          params: {
            'tokenValue': _i1.ParameterDescription(
              name: 'tokenValue',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'bytesUsed': _i1.ParameterDescription(
              name: 'bytesUsed',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['token'] as _i6.TokenEndpoint).reportDataUsage(
            session,
            params['tokenValue'],
            params['bytesUsed'],
          ),
        ),
        'listMyActiveTokens': _i1.MethodConnector(
          name: 'listMyActiveTokens',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['token'] as _i6.TokenEndpoint)
                  .listMyActiveTokens(session),
        ),
      },
    );
    connectors['transaction'] = _i1.EndpointConnector(
      name: 'transaction',
      endpoint: endpoints['transaction']!,
      methodConnectors: {
        'initializePayment': _i1.MethodConnector(
          name: 'initializePayment',
          params: {
            'paystackReference': _i1.ParameterDescription(
              name: 'paystackReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'planId': _i1.ParameterDescription(
              name: 'planId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (_i1.Session session, Map<String, dynamic> params) async =>
              (endpoints['transaction'] as _i7.TransactionEndpoint)
                  .initializePayment(
            session,
            params['paystackReference'],
            params['email'],
            params['hotspotId'],
            params['planId'],
          ),
        ),
        'verifyPaymentAndGenerateToken': _i1.MethodConnector(
          name: 'verifyPaymentAndGenerateToken',
          params: {
            'paystackReference': _i1.ParameterDescription(
              name: 'paystackReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'planId': _i1.ParameterDescription(
              name: 'planId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i7.TransactionEndpoint)
                  .verifyPaymentAndGenerateToken(
            session,
            params['paystackReference'],
            params['hotspotId'],
            params['planId'],
          ),
        ),
        'createTransaction': _i1.MethodConnector(
          name: 'createTransaction',
          params: {
            'hotspotId': _i1.ParameterDescription(
              name: 'hotspotId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'planId': _i1.ParameterDescription(
              name: 'planId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'paystackReference': _i1.ParameterDescription(
              name: 'paystackReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'amountPaid': _i1.ParameterDescription(
              name: 'amountPaid',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'currency': _i1.ParameterDescription(
              name: 'currency',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i7.TransactionEndpoint)
                  .createTransaction(
            session,
            params['hotspotId'],
            params['planId'],
            params['paystackReference'],
            params['amountPaid'],
            params['currency'],
          ),
        ),
        'updateTransactionStatus': _i1.MethodConnector(
          name: 'updateTransactionStatus',
          params: {
            'paystackReference': _i1.ParameterDescription(
              name: 'paystackReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newStatus': _i1.ParameterDescription(
              name: 'newStatus',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'accessTokenId': _i1.ParameterDescription(
              name: 'accessTokenId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i7.TransactionEndpoint)
                  .updateTransactionStatus(
            session,
            params['paystackReference'],
            params['newStatus'],
            accessTokenId: params['accessTokenId'],
          ),
        ),
        'listConsumerTransactions': _i1.MethodConnector(
          name: 'listConsumerTransactions',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i7.TransactionEndpoint)
                  .listConsumerTransactions(
            session,
            limit: params['limit'],
          ),
        ),
        'listProviderTransactions': _i1.MethodConnector(
          name: 'listProviderTransactions',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i7.TransactionEndpoint)
                  .listProviderTransactions(
            session,
            limit: params['limit'],
          ),
        ),
        'updatePayoutStatus': _i1.MethodConnector(
          name: 'updatePayoutStatus',
          params: {
            'paystackReference': _i1.ParameterDescription(
              name: 'paystackReference',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPayoutStatus': _i1.ParameterDescription(
              name: 'newPayoutStatus',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transaction'] as _i7.TransactionEndpoint)
                  .updatePayoutStatus(
            session,
            params['paystackReference'],
            params['newPayoutStatus'],
          ),
        ),
      },
    );
    connectors['userProfile'] = _i1.EndpointConnector(
      name: 'userProfile',
      endpoint: endpoints['userProfile']!,
      methodConnectors: {
        'getUserProfile': _i1.MethodConnector(
          name: 'getUserProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .getUserProfile(
            session,
            params['userId'],
          ),
        ),
        'getProfile': _i1.MethodConnector(
          name: 'getProfile',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .getProfile(session),
        ),
        'updatePaystackAccount': _i1.MethodConnector(
          name: 'updatePaystackAccount',
          params: {
            'paystackAccountId': _i1.ParameterDescription(
              name: 'paystackAccountId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .updatePaystackAccount(
            session,
            params['paystackAccountId'],
          ),
        ),
        'makeAdminByEmail': _i1.MethodConnector(
          name: 'makeAdminByEmail',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .makeAdminByEmail(
            session,
            params['email'],
          ),
        ),
        'makeAdmin': _i1.MethodConnector(
          name: 'makeAdmin',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i8.UserProfileEndpoint).makeAdmin(
            session,
            params['userId'],
          ),
        ),
        'removeAdmin': _i1.MethodConnector(
          name: 'removeAdmin',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i8.UserProfileEndpoint).removeAdmin(
            session,
            params['userId'],
          ),
        ),
        'listUsers': _i1.MethodConnector(
          name: 'listUsers',
          params: {
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['userProfile'] as _i8.UserProfileEndpoint).listUsers(
            session,
            role: params['role'],
            limit: params['limit'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i12.Endpoints()..initializeEndpoints(server);
  }
}
