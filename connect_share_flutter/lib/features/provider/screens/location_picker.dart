// location_picker_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/theme/app_colors.dart';

class LocationPickerWidget extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng) onLocationSelected;
  final String title;

  const LocationPickerWidget({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
    this.title = 'Select Location',
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  late MapController _mapController;
  LatLng? _selectedLocation;
  bool _isLoading = false;
  String? errorMessage;

  // Default location (Abuja, Nigeria)
  static const LatLng _defaultLocation = LatLng(9.0765, 7.3986);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedLocation = widget.initialLocation;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
            'Location services are disabled. Please enable location services.');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied. Please enable them in settings.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final currentLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLocation = currentLocation;
      });

      // Move map to current location
      _mapController.move(currentLocation, 15.0);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });

      // Show error in snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: ${e.toString()}'),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Settings',
              textColor: AppColors.white,
              onPressed: () => Geolocator.openAppSettings(),
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapTapped(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedLocation = point;
      errorMessage = null;
    });
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      widget.onLocationSelected(_selectedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.deepArmyDark.withAlpha(229),
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: AppColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_selectedLocation != null)
            TextButton.icon(
              icon: Icon(Icons.check_rounded, color: AppColors.matcha),
              label: Text(
                'Confirm',
                style: TextStyle(
                  color: AppColors.matcha,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _confirmLocation,
            ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation ??
                  widget.initialLocation ??
                  _defaultLocation,
              initialZoom: _selectedLocation != null ? 15.0 : 10.0,
              onTap: _onMapTapped,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              // Tile layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yourapp.hotspot',
                maxZoom: 18,
              ),
              // Marker layer
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.matcha.withAlpha(52),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.matcha,
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.location_pin,
                          color: AppColors.matcha,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Instructions overlay
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.deepArmyDark.withAlpha(229),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.glassBorderColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.lemonTwist,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tap anywhere on the map to select hotspot location',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Current location button
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: AppColors.matcha,
              foregroundColor: AppColors.white,
              onPressed: _isLoading ? null : _getCurrentLocation,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    )
                  : Icon(Icons.my_location_rounded),
            ),
          ),

          // Coordinates display
          if (_selectedLocation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.deepArmyDark.withAlpha(244),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.glassBorderColor,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.place_rounded,
                          color: AppColors.matcha,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Selected Location',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Latitude',
                                style: TextStyle(
                                  color: AppColors.hintColor,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _selectedLocation!.latitude.toStringAsFixed(6),
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Longitude',
                                style: TextStyle(
                                  color: AppColors.hintColor,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _selectedLocation!.longitude.toStringAsFixed(6),
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 13,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.check_circle_rounded),
                        label: Text('Use This Location'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.matcha,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _confirmLocation,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
