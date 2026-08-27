import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';


class HotspotEndpoint extends Endpoint {
  Future<List<HotspotConfig>> listHotspotsForProvider(Session session) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    return await HotspotConfig.db
        .find(session, where: (t) => t.providerId.equals(userInfo.userId));
  }

  Future<HotspotConfig> createHotspot(Session session, String name, String ssid,
      double latitude, double longitude) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    return await HotspotConfig.db.insertRow(
        session,
        HotspotConfig(
          providerId: userInfo.userId,
          name: name,
          ssid: ssid,
          latitude: latitude,
          longitude: longitude,
          // A saved configuration is not an active broadcast until the
          // provider successfully starts tethering on the device.
          isActive: false,
          createdAt: DateTime.now(),
        ));
  }

  Future<bool> updateHotspot(Session session, int hotspotId, String name,
      String ssid, double latitude, double longitude, bool isActive) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (hotspot == null || hotspot.providerId != userInfo.userId) return false;
    await HotspotConfig.db.updateRow(
        session,
        hotspot.copyWith(
          name: name,
          ssid: ssid,
          latitude: latitude,
          longitude: longitude,
          isActive: isActive,
        ));
    return true;
  }
  // updateHotspotStatus
  Future<bool> updateHotspotStatus(
      Session session, int hotspotId, bool isActive) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }

    // Find the hotspot and verify ownership
    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (hotspot == null || hotspot.providerId != userInfo.userId) {
      return false;
    }

    // Update only the isActive status
    await HotspotConfig.db
        .updateRow(session, hotspot.copyWith(isActive: isActive));

    return true;
  }

  Future<bool> deleteHotspot(Session session, int hotspotId) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    final hotspot = await HotspotConfig.db.findById(session, hotspotId);
    if (hotspot == null || hotspot.providerId != userInfo.userId) return false;
    await HotspotConfig.db.deleteRow(session, hotspot);
    return true;
  }

  Future<List<AccessToken>> listActiveSessionsForProvider(
      Session session) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    final hotspots = await HotspotConfig.db
        .find(session, where: (t) => t.providerId.equals(userInfo.userId));
    final hotspotIds = hotspots.map((h) => h.id!).toList();
    return await AccessToken.db.find(session,
        where: (t) => t.hotspotId.inSet((hotspotIds).toSet()) & t.isActive.equals(true));
  }

  Future<List<HotspotConfig>> listNearbyHotspots(Session session,
      double latitude, double longitude, double radiusKm) async {
    final userInfo = await session.authenticated;
    if (userInfo == null) {
      throw AuthenticationException(message: 'User not authenticated');
    }
    // Simplified distance calculation (use PostGIS for production)
    return await HotspotConfig.db.find(session,
        where: (t) =>
            t.latitude.between(
                latitude - 0.01 * radiusKm, latitude + 0.01 * radiusKm) &
            t.longitude.between(
                longitude - 0.01 * radiusKm, longitude + 0.01 * radiusKm) &
            t.isActive.equals(true));
  }

  Future<HotspotConfig?> getHotspotDetails(
      Session session, int hotspotId) async {
    return await HotspotConfig.db.findById(session, hotspotId);
  }
}
