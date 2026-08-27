import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PlanEndpoint extends Endpoint {
  Future<List<Plan>> listPlansForHotspot(Session session, int hotspotId) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (hotspot == null || !hotspot.isActive) {
      throw ArgumentException(message: 'Hotspot not found or inactive');
    }
    return await Plan.db.find(
      session,
      where: (t) => t.hotspotId.equals(hotspotId) & t.isActive.equals(true),
    );
  }

  Future<Plan> createPlanForHotspot(
    Session session,
    int hotspotId,
    String name,
    String? description,
    PlanType type,
    PlanDurationType durationType,
    int durationValue,
    double price,
    String currency,
    double? dataLimitGB,
    double? bandwidthDownMbps,
    double? bandwidthUpMbps,
    bool isActive,
  ) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (hotspot == null || hotspot.providerId != userInfo.userId) {
      throw AuthenticationException(message: 'Unauthorized access to hotspot');
    }
    if (name.isEmpty || price <= 0 || durationValue <= 0 || currency.isEmpty) {
      throw ArgumentException(message: 'Invalid plan details');
    }
    return await Plan.db.insertRow(
        session,
        Plan(
          hotspotId: hotspotId,
          name: name,
          description: description,
          type: type,
          durationType: durationType,
          durationValue: durationValue,
          price: price,
          currency: currency,
          dataLimitGB: dataLimitGB,
          bandwidthDownMbps: bandwidthDownMbps,
          bandwidthUpMbps: bandwidthUpMbps,
          isActive: isActive,
        ));
  }

  Future<bool> updatePlan(Session session, Plan plan) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    final existingPlan = await Plan.db.findById(session, plan.id!);
    if (existingPlan == null) return false;
    final hotspot =
        await HotspotConfig.db.findById(session, existingPlan.hotspotId);
    if (hotspot == null || hotspot.providerId != userInfo.userId) {
      throw AuthenticationException(message: 'Unauthorized access to hotspot');
    }
    if (plan.name.isEmpty ||
        plan.price <= 0 ||
        plan.durationValue <= 0 ||
        plan.currency.isEmpty) {
      throw ArgumentException(message: 'Invalid plan details');
    }
    await Plan.db.updateRow(session, plan);
    return true;
  }

  Future<bool> deletePlan(Session session, int planId) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    final plan = await Plan.db.findById(session, planId);
    if (plan == null) return false;
    final hotspot = await HotspotConfig.db.findById(session, plan.hotspotId);
    if (hotspot == null || hotspot.providerId != userInfo.userId) {
      throw AuthenticationException(message: 'Unauthorized access to hotspot');
    }
    await Plan.db.deleteRow(session, plan);
    return true;
  }
}
