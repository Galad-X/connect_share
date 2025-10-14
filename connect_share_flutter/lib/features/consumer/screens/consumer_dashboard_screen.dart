// consumer_dashboard_screen.dart
import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:async';
// import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart';
import '../../../src/serverpod_client.dart';
import '../../shared/services/location_service.dart'; // Adjust path
import 'hotspot_detail_screen.dart';

class ConsumerDashboardScreen extends StatefulWidget {
  const ConsumerDashboardScreen({super.key});

  @override
  State<ConsumerDashboardScreen> createState() =>
      _ConsumerDashboardScreenState();
}

class _ConsumerDashboardScreenState extends State<ConsumerDashboardScreen> {
  List<HotspotConfig> _hotspots = [];
  bool _isLoading = true;
  String? _errorMessage;
  LatLng? _initialCenter; // For current location

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final locationService = LocationService();
      final geoPoint = await locationService.getCurrentLocation();
      if (geoPoint == null) {
        // Fallback or keep default (Lagos)
        _initialCenter = const LatLng(6.5244, 3.3792); // Lagos
        if (mounted) {
          setState(() {
            _errorMessage =
                'Could not get current location. Showing default area.';
            // Proceed to fetch hotspots for default area or handle differently
          });
        }
      } else {
        _initialCenter = LatLng(geoPoint.latitude, geoPoint.longitude);
      }
      await _fetchHotspots(useCurrentLocation: geoPoint != null);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Initialization error: $e';
          _isLoading = false;
          _initialCenter ??=
              const LatLng(6.5244, 3.3792); // Ensure initialCenter is set
        });
      }
    }
  }

  Future<void> _fetchHotspots({bool useCurrentLocation = true}) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true; // Show loading for fetch specifically
    });
    try {
      LatLng locationToFetch = _initialCenter ?? const LatLng(6.5244, 3.3792);

      if (useCurrentLocation && _initialCenter != null) {
        locationToFetch = _initialCenter!;
      }
      // else use default or last known good, already set to locationToFetch

      final hotspots = await client.hotspot.listNearbyHotspots(
          locationToFetch.latitude,
          locationToFetch.longitude,
          10.0); // 10km radius
      if (mounted) {
        setState(() {
          _hotspots = hotspots;
          _isLoading = false;
          if (hotspots.isEmpty && _errorMessage == null) {
            // Don't overwrite location error
            _errorMessage = "No hotspots found nearby.";
          } else if (hotspots.isNotEmpty) {
            _errorMessage =
                null; // Clear "no hotspots" message if some are found
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Failed to load hotspots: ${e.toString().split(":").last.trim()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // The AppBar will use AppTheme's default styling
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Hotspots'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _isLoading ? null : _initializeScreen,
            tooltip: "Refresh",
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _initialCenter == null) {
      // Initial loading (getting location etc)
      return buildLoadingWidget(message: "Finding your location...");
    }
    if (_initialCenter == null && _errorMessage != null) {
      // Failed to get location critical error
      return buildErrorWidget(context, _errorMessage,
          onRetry: _initializeScreen);
    }

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter:
                _initialCenter ?? const LatLng(6.5244, 3.3792), // Fallback
            initialZoom: 13.0,
            // onTap: (tapPosition, point) {},
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              // For modern look, consider other tile providers like Mapbox, Stadia, Jawg with custom styles
              // urlTemplate: "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png", // Example: CartoDB Voyager
              // subdomains: ['a', 'b', 'c', 'd'],
              userAgentPackageName:
                  'com.example.connect_share', // Replace with your package name
            ),
            MarkerLayer(
              markers: _hotspots.map((hotspot) {
                return Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(hotspot.latitude, hotspot.longitude),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HotspotDetailScreen(hotspot: hotspot),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.matcha.withAlpha(229),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(52),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.wifi_rounded,
                            color: AppColors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hotspot.name.length > 10
                              ? '${hotspot.name.substring(0, 8)}...'
                              : hotspot.name,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepArmyDark,
                              backgroundColor: AppColors.white.withAlpha(128)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        // Show loading indicator on top of map if fetching hotspots
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(26),
              child: buildLoadingWidget(message: "Fetching hotspots..."),
            ),
          ),
        // Show "No hotspots found" or error message on top of map
        if (!_isLoading && _errorMessage != null && _hotspots.isEmpty)
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Material(
              // Material for shadow and theming
              elevation: 2,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                    color: _errorMessage!.contains("Failed")
                        ? AppColors.error.withAlpha(26)
                        : AppColors.warning.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: _errorMessage!.contains("Failed")
                            ? AppColors.error
                            : AppColors.warning)),
                child: Row(
                  children: [
                    Icon(
                      _errorMessage!.contains("Failed")
                          ? Icons.error_outline
                          : Icons.info_outline,
                      color: _errorMessage!.contains("Failed")
                          ? AppColors.error
                          : AppColors.warning.withAlpha(204),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(_errorMessage!,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSurface))),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
