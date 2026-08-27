// manage_hotspot_screen.dart
import 'dart:async';
import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

import '../../../core/captive_portal_service.dart';
import '../../../core/hotspot_service.dart';
import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart';
import 'location_picker.dart'; // For client

class ManageHotspotScreen extends StatefulWidget {
  final SessionManager sessionManager;
  final bool openCreateDialog; // To open dialog on navigate
  final int? initialHotspotId; // To highlight or scroll to a specific hotspot

  const ManageHotspotScreen({
    super.key,
    required this.sessionManager,
    this.openCreateDialog = false,
    this.initialHotspotId,
  });

  @override
  State<ManageHotspotScreen> createState() => _ManageHotspotScreenState();
}

class _ManageHotspotScreenState extends State<ManageHotspotScreen> {
  final _hotspotService = HotspotService();
  CaptivePortalService? _captivePortalService;

  List<HotspotConfig> _hotspots = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _successMessage;

  // Active hotspot tracking
  HotspotConfig?
      _activeHotspotConfigOnDevice; // Hotspot physically active on device
  bool _isDeviceHotspotActive = false;
  int _isToggleLoadingForHotspotId = -1; // Track loading per hotspot
  String? _activeHotspotPassword;
  final int _port = 8080; // Captive portal port

  // Form controllers for dialogs
  final _nameController = TextEditingController();
  final _ssidController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _passwordController = TextEditingController(); // For activation dialog
  final _formKey = GlobalKey<FormState>();

  // Location tracking
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _initialize();
    if (widget.openCreateDialog) {
      // Open dialog after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showHotspotDialog();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ssidController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _passwordController.dispose();
    // Ensure captive portal and hotspot are stopped if active by this screen
    if (_isDeviceHotspotActive) {
      _captivePortalService?.stop();
      _hotspotService.stopHotspot();
    }
    super.dispose();
  }

  Future<void> _initialize() async {
    await _fetchHotspots();
    // Captive portal service will be initialized when a hotspot is activated.
    // Check current device hotspot status (if possible, platform-dependent)
    // For simplicity, we assume no hotspot is active on init unless tracked by this screen.
  }

  Future<void> _fetchHotspots() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final hotspots = await client.hotspot.listHotspotsForProvider();
      if (!mounted) return;
      setState(() {
        _hotspots = hotspots;
        _isLoading = false;
        _errorMessage = hotspots.isEmpty
            ? "No hotspots configured. Create one to get started!"
            : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load hotspots: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleHotspotOnDevice(
      HotspotConfig hotspot, String? password) async {
    if (!mounted) return;
    setState(() {
      _isToggleLoadingForHotspotId = hotspot.id ?? -1;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      if (_isDeviceHotspotActive &&
          _activeHotspotConfigOnDevice?.id == hotspot.id) {
        // Stop the currently active hotspot
        await _captivePortalService?.stop();
        final stopped = await _hotspotService.stopHotspot();
        if (stopped) {
          if (!mounted) return;
          // Update the backend status of the hotspot to inactive
          await client.hotspot.updateHotspotStatus(hotspot.id!, false);
          setState(() {
            _isDeviceHotspotActive = false;
            _activeHotspotConfigOnDevice = null;
            _activeHotspotPassword = null;
            _successMessage = "${hotspot.name} deactivated successfully.";
          });
          _fetchHotspots(); // Refresh list to show updated status
        } else {
          throw Exception('Failed to stop hotspot on device.');
        }
      } else {
        // Stop any currently active hotspot on device first
        if (_isDeviceHotspotActive && _activeHotspotConfigOnDevice != null) {
          await _captivePortalService?.stop();
          await _hotspotService.stopHotspot();
          await client.hotspot
              .updateHotspotStatus(_activeHotspotConfigOnDevice!.id!, false);
          setState(() {
            // Clear previous active state immediately
            _isDeviceHotspotActive = false;
            _activeHotspotConfigOnDevice = null;
          });
        }

        // Initialize captive portal service for this specific hotspot
        _captivePortalService =
            CaptivePortalService(_hotspotService, hotspot.id!);
        await _captivePortalService!.initialize();

        // Start the new hotspot
        final started = await _hotspotService.startHotspot(hotspot.ssid!,
            password: password);
        if (started) {
          final portalStarted = await _captivePortalService!.start(_port);
          if (portalStarted) {
            if (!mounted) return;
            // Update the backend status of the hotspot to active
            await client.hotspot.updateHotspotStatus(hotspot.id!, true);
            setState(() {
              _isDeviceHotspotActive = true;
              _activeHotspotConfigOnDevice = hotspot;
              _activeHotspotPassword = password;
              _successMessage =
                  "${hotspot.name} activated using Android's system hotspot. Use the system hotspot credentials, then open the portal from the connected device.";
            });
            _fetchHotspots(); // Refresh list
          } else {
            await _hotspotService.stopHotspot(); // Cleanup
            throw Exception('Failed to start captive portal service.');
          }
        } else {
          throw Exception(
              'Failed to start hotspot on device. Check permissions and settings.');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Operation Failed: ${e.toString().split(":").last.trim()}';
      });
    } finally {
      if (mounted) setState(() => _isToggleLoadingForHotspotId = -1);
    }
  }

  void _clearFormControllers() {
    _nameController.clear();
    _ssidController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
  }

  void _openLocationPicker({HotspotConfig? hotspotToEdit}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: LocationPickerWidget(
              title: hotspotToEdit == null
                  ? 'Select Hotspot Location'
                  : 'Update Location',
              initialLocation: _selectedLocation ??
                  (hotspotToEdit != null
                      ? LatLng(hotspotToEdit.latitude, hotspotToEdit.longitude)
                      : null),
              onLocationSelected: (location) {
                setState(() {
                  _selectedLocation = location;
                  _latitudeController.text =
                      location.latitude.toStringAsFixed(6);
                  _longitudeController.text =
                      location.longitude.toStringAsFixed(6);
                });
              },
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        opaque: false,
        barrierColor: Colors.black.withAlpha(128),
        barrierDismissible: true,
      ),
    );
  }

  void _showHotspotDialog({HotspotConfig? hotspotToEdit}) {
    _clearFormControllers();
    if (hotspotToEdit != null) {
      _nameController.text = hotspotToEdit.name;
      _ssidController.text = hotspotToEdit.ssid!;
      _latitudeController.text = hotspotToEdit.latitude.toString();
      _longitudeController.text = hotspotToEdit.longitude.toString();
      _selectedLocation =
          LatLng(hotspotToEdit.latitude, hotspotToEdit.longitude);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepArmyDark.withAlpha(212), // Glassy dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          hotspotToEdit == null ? 'Create New Hotspot' : 'Edit Hotspot',
          style: TextStyle(
              color: AppColors.textColor, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          // Important for smaller screens
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(_nameController, 'Hotspot Name',
                    Icons.label_important_outline),
                _buildDialogTextField(
                    _ssidController, 'Network Name (SSID)', Icons.wifi_rounded),

                // Location Section
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.textFieldFillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.place_rounded,
                              color: AppColors.hintColor.withAlpha(178),
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Location',
                            style: TextStyle(
                              color: AppColors.hintColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_selectedLocation != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Latitude',
                                    style: TextStyle(
                                      color: AppColors.hintColor.withAlpha(204),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _selectedLocation!.latitude
                                        .toStringAsFixed(6),
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
                                      color: AppColors.hintColor.withAlpha(204),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _selectedLocation!.longitude
                                        .toStringAsFixed(6),
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
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Icon(
                            _selectedLocation != null
                                ? Icons.edit_location_rounded
                                : Icons.map_rounded,
                            size: 18,
                          ),
                          label: Text(
                            _selectedLocation != null
                                ? 'Change Location'
                                : 'Pick Location on Map',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.matcha,
                            side: BorderSide(color: AppColors.matcha),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () =>
                              _openLocationPicker(hotspotToEdit: hotspotToEdit),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.hintColor)),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save_rounded),
            label: Text(hotspotToEdit == null ? 'Create' : 'Save Changes'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lemonTwist,
                foregroundColor: AppColors.deepArmyDark),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              if (_selectedLocation == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a location on the map.'),
                    backgroundColor: AppColors.warning,
                  ),
                );
                return;
              }

              try {
                final name = _nameController.text.trim();
                final ssid = _ssidController.text.trim();
                final latitude = _selectedLocation!.latitude;
                final longitude = _selectedLocation!.longitude;

                if (hotspotToEdit == null) {
                  // Create
                  await client.hotspot
                      .createHotspot(name, ssid, latitude, longitude);
                  _successMessage = "Hotspot '$name' created successfully!";
                } else {
                  // Update
                  await client.hotspot.updateHotspot(
                    hotspotToEdit.id!, name, ssid, latitude, longitude,
                    hotspotToEdit
                        .isActive, // Preserve current active status from DB
                  );
                  _successMessage = "Hotspot '$name' updated successfully!";
                }
                if (!context.mounted) return;
                Navigator.pop(context);
                _fetchHotspots(); // Refresh the list
                if (mounted && _successMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(_successMessage!),
                      backgroundColor: AppColors.success));
                  _successMessage = null; // Clear after showing
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Failed: ${e.toString().split(":").last.trim()}'),
                      backgroundColor: AppColors.error),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: AppColors.textColor),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.hintColor),
          prefixIcon: Icon(icon, color: AppColors.hintColor.withAlpha(178)),
          filled: true,
          fillColor: AppColors.textFieldFillColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glassBorderColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glassBorderColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.matcha, width: 1.5)),
          errorStyle: TextStyle(
              color: AppColors.error.withAlpha(228),
              fontWeight: FontWeight.w500),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label cannot be empty.';
          }
          if ((label.contains("Latitude") || label.contains("Longitude")) &&
              double.tryParse(value) == null) {
            return 'Invalid number format.';
          }
          return null;
        },
      ),
    );
  }

  void _showActivateHotspotDialog(HotspotConfig hotspot) {
    _passwordController.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepArmyDark.withAlpha(212),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Activate ${hotspot.name}',
            style: TextStyle(
                color: AppColors.textColor, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SSID: ${hotspot.ssid}',
                style: TextStyle(color: AppColors.hintColor)),
            const SizedBox(height: 16),
            _buildDialogTextField(_passwordController,
                "Password (optional, min 8 chars)", Icons.lock_outline_rounded),
            Text("Leave empty for an open network.",
                style: TextStyle(
                    color: AppColors.hintColor.withAlpha(178), fontSize: 12)),
          ],
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.hintColor)),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_circle_fill_rounded),
            label: const Text('Activate Now'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.matcha,
                foregroundColor: AppColors.white),
            onPressed: () {
              final password = _passwordController.text.trim();
              if (password.isNotEmpty && password.length < 8) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Password must be at least 8 characters or empty.'),
                      backgroundColor: AppColors.warning),
                );
                return;
              }
              Navigator.pop(context);
              _toggleHotspotOnDevice(
                  hotspot, password.isEmpty ? null : password);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = widget.sessionManager.signedInUser;
    if (userInfo == null || !userInfo.scopeNames.contains('provider')) {
      return Scaffold(
        body: Stack(children: [
          buildGlassmorphicBackground(context),
          buildErrorWidget(context,
              'Provider access required. Please sign in as a provider.',
              onRetry: () => Navigator.pop(context) /* or sign out */)
        ]),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildModernAppBar(
        context,
        'Manage My Hotspots',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: AppColors.textColor.withAlpha(204)),
            onPressed: _isLoading ? null : _fetchHotspots,
            tooltip: 'Refresh List',
          ),
        ],
      ),
      body: Stack(
        children: [
          buildGlassmorphicBackground(context),
          SafeArea(
            child: Column(
              children: [
                _buildActiveHotspotStatusCard(),
                if (_errorMessage != null &&
                    _hotspots.isEmpty) // Show error only if list is empty
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: buildErrorWidget(context, _errorMessage,
                        onRetry: _fetchHotspots),
                  )
                else if (_errorMessage !=
                    null) // Show as a banner if list has items
                  _buildMessageBanner(_errorMessage!, isError: true),
                if (_successMessage != null)
                  _buildMessageBanner(_successMessage!, isError: false),
                Expanded(
                  child: _isLoading && _hotspots.isEmpty
                      ? buildLoadingWidget(message: "Loading your hotspots...")
                      : _hotspots.isEmpty &&
                              _errorMessage == null &&
                              !_isLoading
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: _fetchHotspots,
                              color: AppColors.matcha,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                itemCount: _hotspots.length,
                                itemBuilder: (context, index) {
                                  final hotspot = _hotspots[index];
                                  return _buildHotspotCard(hotspot);
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showHotspotDialog(),
        backgroundColor: AppColors.lemonTwist,
        foregroundColor: AppColors.deepArmyDark,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Hotspot',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildActiveHotspotStatusCard() {
    if (!_isDeviceHotspotActive || _activeHotspotConfigOnDevice == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: GlassmorphicCard(
        backgroundColor: AppColors.matcha.withAlpha(52),
        borderColor: AppColors.matcha,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings_input_antenna_rounded,
                    color: AppColors.matcha, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Device Hotspot Active: ${_activeHotspotConfigOnDevice!.name}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.matcha),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('SSID: ${_activeHotspotConfigOnDevice!.ssid}',
                style: TextStyle(color: AppColors.hintColor, fontSize: 13)),
            Text('Portal: http://192.168.43.1:$_port',
                style: TextStyle(color: AppColors.hintColor, fontSize: 13)),
            if (_activeHotspotPassword != null &&
                _activeHotspotPassword!.isNotEmpty)
              Text('Password: $_activeHotspotPassword',
                  style: TextStyle(color: AppColors.hintColor, fontSize: 13)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _isToggleLoadingForHotspotId ==
                        _activeHotspotConfigOnDevice!.id
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.white))
                    : const Icon(Icons.stop_circle_outlined, size: 20),
                label: const Text('Deactivate Device Hotspot'),
                onPressed: _isToggleLoadingForHotspotId != -1
                    ? null
                    : () => _toggleHotspotOnDevice(
                        _activeHotspotConfigOnDevice!, _activeHotspotPassword),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withAlpha(204),
                    foregroundColor: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBanner(String message, {required bool isError}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: (isError ? AppColors.error : AppColors.success).withAlpha(39),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
                (isError ? AppColors.error : AppColors.success).withAlpha(128)),
      ),
      child: Row(
        children: [
          Icon(
            isError
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            color: isError ? AppColors.error : AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
              child: SelectableText(message,
                  style: TextStyle(
                      color: AppColors.textColor.withAlpha(228),
                      fontSize: 13))),
          IconButton(
            icon: Icon(Icons.close_rounded,
                size: 18, color: AppColors.textColor.withAlpha(178)),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              setState(() {
                if (isError) {
                  _errorMessage = null;
                } else {
                  _successMessage = null;
                }
              });
            },
          )
        ],
      ),
    );
  }

  Widget _buildHotspotCard(HotspotConfig hotspot) {
    final bool isThisHotspotActiveOnDevice = _isDeviceHotspotActive &&
        _activeHotspotConfigOnDevice?.id == hotspot.id;
    final bool isAnotherHotspotActiveOnDevice = _isDeviceHotspotActive &&
        _activeHotspotConfigOnDevice?.id != hotspot.id;
    final bool isLoadingThis = _isToggleLoadingForHotspotId == hotspot.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassmorphicCard(
        backgroundColor: isThisHotspotActiveOnDevice
            ? AppColors.matcha.withAlpha(26)
            : AppColors.glassBackgroundColor.withAlpha(26),
        borderColor: isThisHotspotActiveOnDevice
            ? AppColors.matcha.withAlpha(128)
            : AppColors.glassBorderColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isThisHotspotActiveOnDevice
                      ? Icons.wifi_tethering_rounded
                      : hotspot.isActive
                          ? Icons.network_wifi_rounded
                          : Icons.wifi_off_rounded, // DB active status
                  color: isThisHotspotActiveOnDevice
                      ? AppColors.matcha
                      : hotspot.isActive
                          ? AppColors.lemonTwist
                          : AppColors.hintColor.withAlpha(178),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hotspot.name,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor),
                  ),
                ),
                Chip(
                  label: Text(
                    isThisHotspotActiveOnDevice
                        ? 'DEVICE ACTIVE'
                        : (hotspot.isActive ? 'DB ACTIVE' : 'INACTIVE'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isThisHotspotActiveOnDevice
                          ? AppColors.deepArmyDark
                          : (hotspot.isActive
                              ? AppColors.deepArmyDark
                              : AppColors.textColor.withAlpha(178)),
                    ),
                  ),
                  backgroundColor: isThisHotspotActiveOnDevice
                      ? AppColors.matcha
                      : (hotspot.isActive
                          ? AppColors.lemonTwist.withAlpha(178)
                          : AppColors.inactive.withAlpha(77)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  labelPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 34.0, top: 2, bottom: 8), // Align with text
              child: Text('SSID: ${hotspot.ssid}',
                  style: TextStyle(color: AppColors.hintColor, fontSize: 13)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit button (always available if not active on device)
                TextButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.hintColor.withAlpha(228)),
                  onPressed: isThisHotspotActiveOnDevice || isLoadingThis
                      ? null
                      : () => _showHotspotDialog(hotspotToEdit: hotspot),
                ),
                const SizedBox(width: 8),
                // Activate/Deactivate button
                ElevatedButton.icon(
                  icon: isLoadingThis
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.white))
                      : Icon(
                          isThisHotspotActiveOnDevice
                              ? Icons.stop_rounded
                              : Icons.play_arrow_rounded,
                          size: 18),
                  label: Text(
                      isThisHotspotActiveOnDevice ? 'Deactivate' : 'Activate'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isThisHotspotActiveOnDevice
                          ? AppColors.error.withAlpha(178)
                          : AppColors.matcha,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500)),
                  onPressed: isLoadingThis ||
                          (isAnotherHotspotActiveOnDevice &&
                              !isThisHotspotActiveOnDevice)
                      ? null
                      : () {
                          // Disable if another hotspot is active and this one is not
                          if (isThisHotspotActiveOnDevice) {
                            _toggleHotspotOnDevice(
                                hotspot, _activeHotspotPassword);
                          } else {
                            _showActivateHotspotDialog(hotspot);
                          }
                        },
                ),
              ],
            ),
            if (isAnotherHotspotActiveOnDevice && !isThisHotspotActiveOnDevice)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Deactivate '${_activeHotspotConfigOnDevice?.name}' first to activate this one.",
                  style: TextStyle(
                      fontSize: 11, color: AppColors.warning.withAlpha(204)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GlassmorphicCard(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_find_rounded,
                  size: 48, color: AppColors.hintColor.withAlpha(178)),
              const SizedBox(height: 16),
              Text(
                "No Hotspots Yet",
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                "Click the '+' button to create your first Wi-Fi hotspot configuration.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
