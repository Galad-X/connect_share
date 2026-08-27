// manage_plans_screen.dart
import 'package:flutter/material.dart';
import 'package:connect_share_client/connect_share_client.dart'; // For Plan, HotspotConfig, Enums
import 'package:intl/intl.dart'; // For currency formatting

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client

class ManagePlansScreen extends StatefulWidget {
  const ManagePlansScreen({super.key});

  @override
  State<ManagePlansScreen> createState() => _ManagePlansScreenState();
}

class _ManagePlansScreenState extends State<ManagePlansScreen> {
  List<HotspotConfig> _hotspots = [];
  HotspotConfig? _selectedHotspot;
  List<Plan> _plans = [];

  bool _isLoadingHotspots = true;
  bool _isLoadingPlans = false;
  String? _errorMessage; // General error message
  String? _plansErrorMessage; // Specific for plans list

  // Form controllers for dialog
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _dataLimitController = TextEditingController();
  PlanType _selectedPlanType = PlanType.unlimited; // Default
  PlanDurationType _selectedDurationType = PlanDurationType.daily; // Default

  final _formKey = GlobalKey<FormState>();
  final _currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    _fetchHotspots();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _dataLimitController.dispose();
    super.dispose();
  }

  Future<void> _fetchHotspots() async {
    if (!mounted) return;
    setState(() {
      _isLoadingHotspots = true;
      _errorMessage = null;
    });
    try {
      final hotspots = await client.hotspot.listHotspotsForProvider();
      if (!mounted) return;
      setState(() {
        _hotspots = hotspots;
        _selectedHotspot = hotspots.isNotEmpty ? hotspots.first : null;
        _isLoadingHotspots = false;
        if (hotspots.isEmpty) {
          _errorMessage = "No hotspots found. Please create a hotspot first.";
        }
      });
      if (_selectedHotspot != null) {
        _fetchPlansForSelectedHotspot();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load hotspots: ${e.toString().split(":").last.trim()}';
        _isLoadingHotspots = false;
      });
    }
  }

  Future<void> _fetchPlansForSelectedHotspot() async {
    if (_selectedHotspot == null) {
      setState(() => _plans = []);
      return;
    }
    if (!mounted) return;
    setState(() {
      _isLoadingPlans = true;
      _plansErrorMessage = null;
    });
    try {
      final plans =
          await client.plan.listPlansForHotspot(_selectedHotspot!.id!);
      if (!mounted) return;
      setState(() {
        _plans = plans;
        _isLoadingPlans = false;
        if (plans.isEmpty) {
          _plansErrorMessage =
              "No plans found for '${_selectedHotspot!.name}'. Create one!";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _plansErrorMessage =
            'Failed to load plans: ${e.toString().split(":").last.trim()}';
        _isLoadingPlans = false;
      });
    }
  }

  void _clearFormControllers() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _durationController.clear();
    _dataLimitController.clear();
    _selectedPlanType = PlanType.unlimited;
    _selectedDurationType = PlanDurationType.daily;
  }

  void _showPlanDialog({Plan? planToEdit}) {
    _clearFormControllers();

    if (planToEdit != null) {
      _nameController.text = planToEdit.name;
      _descriptionController.text = planToEdit.description ?? '';
      _priceController.text = planToEdit.price.toStringAsFixed(2);
      _durationController.text = planToEdit.durationValue.toString();
      _dataLimitController.text = planToEdit.dataLimitGB?.toString() ?? '';
      _selectedPlanType = planToEdit.type;
      _selectedDurationType = planToEdit.durationType;
    } else {
      // Sensible defaults for new plan
      _selectedPlanType = PlanType.unlimited;
      _selectedDurationType = PlanDurationType.daily;
    }

    // Use a StatefulWidget for the dialog content to manage dropdown state locally
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          StatefulBuilder(// Allows dialog content to have its own state
              builder: (BuildContext context, StateSetter setStateDialog) {
        return AlertDialog(
          backgroundColor: AppColors.deepArmyDark.withAlpha(229),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            planToEdit == null ? 'Create New Plan' : 'Edit Plan',
            style: TextStyle(
                color: AppColors.textColor, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDialogTextField(_nameController, 'Plan Name',
                      Icons.label_important_outline),
                  _buildDialogTextField(_descriptionController,
                      'Description (Optional)', Icons.notes_rounded,
                      isOptional: true),
                  Text("Plan Type:",
                      style: TextStyle(
                          color: AppColors.hintColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  _buildDropdown<PlanType>(
                    value: _selectedPlanType,
                    items: PlanType.values,
                    onChanged: (PlanType? newValue) {
                      if (newValue != null) {
                        setStateDialog(() => _selectedPlanType = newValue);
                      }
                    },
                    itemText: (type) => type.name
                        .replaceAllMapped(
                            RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
                        .trim(), // Add space before caps
                  ),
                  const SizedBox(height: 10),
                  _buildDialogTextField(_priceController,
                      'Price (e.g., 100.00)', Icons.attach_money_rounded,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true)),
                  Text("Duration Type:",
                      style: TextStyle(
                          color: AppColors.hintColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  _buildDropdown<PlanDurationType>(
                    value: _selectedDurationType,
                    items: PlanDurationType.values,
                    onChanged: (PlanDurationType? newValue) {
                      if (newValue != null) {
                        setStateDialog(() => _selectedDurationType = newValue);
                      }
                    },
                    itemText: (type) =>
                        type.name[0].toUpperCase() + type.name.substring(1),
                  ),
                  const SizedBox(height: 10),
                  _buildDialogTextField(_durationController,
                      'Duration Value (e.g., 1, 24)', Icons.timer_outlined,
                      keyboardType: TextInputType.number),
                  if (_selectedPlanType == PlanType.metered)
                    _buildDialogTextField(_dataLimitController,
                        'Data Limit (GB,)', Icons.data_usage_outlined,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        isOptional: _selectedPlanType == PlanType.metered),
                ],
              ),
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  Text('Cancel', style: TextStyle(color: AppColors.hintColor)),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save_rounded),
              label: Text(planToEdit == null ? 'Create Plan' : 'Save Changes'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lemonTwist,
                  foregroundColor: AppColors.deepArmyDark),
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                if (_selectedHotspot == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No hotspot selected!'),
                        backgroundColor: AppColors.error),
                  );
                  return;
                }

                try {
                  final name = _nameController.text.trim();
                  final description = _descriptionController.text.trim().isEmpty
                      ? null
                      : _descriptionController.text.trim();
                  final price = double.tryParse(_priceController.text) ?? 0.0;
                  final durationValue =
                      int.tryParse(_durationController.text) ?? 0;
                  final dataLimitGB = _dataLimitController.text.trim().isEmpty
                      ? null
                      : double.tryParse(_dataLimitController.text);

                  if (planToEdit == null) {
                    // Create
                    await client.plan.createPlanForHotspot(
                      _selectedHotspot!.id!, name, description,
                      _selectedPlanType, _selectedDurationType, durationValue,
                      price, 'NGN', // TODO: Make currency dynamic
                      dataLimitGB, null, null, true,
                    );
                  } else {
                    // Update
                    final updatedPlan = planToEdit.copyWith(
                      name: name, description: description, price: price,
                      durationValue: durationValue, dataLimitGB: dataLimitGB,
                      type: _selectedPlanType,
                      durationType: _selectedDurationType,
                      // Retain other fields not being edited
                      currency: planToEdit.currency,
                      isActive: planToEdit.isActive,
                      hotspotId: planToEdit.hotspotId,
                      bandwidthDownMbps: planToEdit.bandwidthDownMbps,
                      bandwidthUpMbps: planToEdit.bandwidthUpMbps,
                    );
                    await client.plan.updatePlan(updatedPlan);
                  }
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  _fetchPlansForSelectedHotspot(); // Refresh the list for the current hotspot
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Plan saved successfully!'),
                        backgroundColor: AppColors.success),
                  );
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
        );
      }),
    );
  }

  Widget _buildDialogTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboardType, bool isOptional = false}) {
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
              color: AppColors.error.withAlpha(229),
              fontWeight: FontWeight.w500),
        ),
        validator: (value) {
          if (!isOptional && (value == null || value.trim().isEmpty)) {
            return '$label cannot be empty.';
          }
          if (keyboardType == TextInputType.number ||
              (keyboardType?.toString().contains("decimal") ?? false)) {
            if (value != null &&
                value.trim().isNotEmpty &&
                double.tryParse(value.trim()) == null) {
              return 'Invalid number format.';
            }
            if (value != null &&
                value.trim().isNotEmpty &&
                (label.contains("Price") || label.contains("Duration")) &&
                (double.tryParse(value.trim()) ?? 0) <= 0) {
              return '$label must be positive.';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown<T extends Enum>(
      {required T value,
      required List<T> items,
      required ValueChanged<T?> onChanged,
      required String Function(T) itemText}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.glassBorderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor:
              AppColors.deepArmyDark.withAlpha(244), // Darker for dropdown
          icon: Icon(Icons.arrow_drop_down_rounded, color: AppColors.hintColor),
          style: TextStyle(color: AppColors.textColor, fontSize: 15),
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemText(item)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildModernAppBar(
        context,
        'Manage Access Plans',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: AppColors.textColor.withAlpha(204)),
            onPressed: _isLoadingHotspots || _isLoadingPlans
                ? null
                : () {
                    _fetchHotspots(); // This will also trigger fetching plans if a hotspot is selected
                  },
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Stack(
        children: [
          buildGlassmorphicBackground(context),
          SafeArea(
            child: Column(
              children: [
                _buildHotspotSelector(),
                if (_isLoadingHotspots)
                  Expanded(
                      child: buildLoadingWidget(message: "Loading hotspots..."))
                else if (_errorMessage != null &&
                    _hotspots.isEmpty) // Critical error if no hotspots
                  Expanded(
                      child: buildErrorWidget(context, _errorMessage,
                          onRetry: _fetchHotspots))
                else if (_selectedHotspot == null && _hotspots.isNotEmpty)
                  Expanded(
                      child: Center(
                          child: Text("Please select a hotspot.",
                              style: TextStyle(color: AppColors.hintColor))))
                else
                  Expanded(child: _buildPlansList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedHotspot == null || _isLoadingHotspots
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showPlanDialog(),
              backgroundColor: AppColors.lemonTwist,
              foregroundColor: AppColors.deepArmyDark,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Plan',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
    );
  }

  Widget _buildHotspotSelector() {
    if (_isLoadingHotspots && _hotspots.isEmpty) {
      return const SizedBox
          .shrink(); // Don't show if still loading initial hotspots
    }
    if (_hotspots.isEmpty && !_isLoadingHotspots) {
      return const SizedBox
          .shrink(); // Don't show if no hotspots and not loading
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GlassmorphicCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<HotspotConfig>(
            value: _selectedHotspot,
            isExpanded: true,
            hint: Text('Select a Hotspot',
                style: TextStyle(color: AppColors.hintColor)),
            dropdownColor: AppColors.deepArmyDark.withAlpha(244),
            icon: Icon(Icons.arrow_drop_down_circle_outlined,
                color: AppColors.hintColor),
            style: TextStyle(
                color: AppColors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
            items: _hotspots.map((hotspot) {
              return DropdownMenuItem(
                value: hotspot,
                child: Text(hotspot.name, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedHotspot = value);
                _fetchPlansForSelectedHotspot();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlansList() {
    if (_isLoadingPlans) {
      return buildLoadingWidget(
          message: "Loading plans for '${_selectedHotspot?.name ?? ''}'...");
    }
    if (_plansErrorMessage != null) {
      // If error, show error message, potentially with a retry for plans only
      return buildErrorWidget(context, _plansErrorMessage,
          onRetry: _fetchPlansForSelectedHotspot);
    }
    if (_plans.isEmpty) {
      // Should be covered by _plansErrorMessage, but as fallback
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GlassmorphicCard(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.playlist_add_check_circle_outlined,
                    size: 48, color: AppColors.hintColor.withAlpha(178)),
                const SizedBox(height: 16),
                Text(
                  "No Plans Yet",
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create a plan for '${_selectedHotspot?.name ?? 'this hotspot'}' using the '+' button.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.hintColor),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPlansForSelectedHotspot,
      color: AppColors.matcha,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _plans.length,
        itemBuilder: (context, index) {
          final plan = _plans[index];
          return _buildPlanCard(plan);
        },
      ),
    );
  }

  Widget _buildPlanCard(Plan plan) {
    String currencySymbol = plan.currency.toUpperCase();
    String dataLimitInfo =
        plan.dataLimitGB != null ? "${plan.dataLimitGB} GB" : "Unlimited Data";
    if (plan.type == PlanType.unlimited) dataLimitInfo = "Time Only";

    String planTypeDisplay = plan.type.name
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
        .trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassmorphicCard(
        backgroundColor: AppColors.glassBackgroundColor.withAlpha(39),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  plan.isActive
                      ? Icons.check_circle_outline_rounded
                      : Icons.cancel_outlined,
                  color: plan.isActive
                      ? AppColors.success
                      : AppColors.error.withAlpha(178),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    plan.name,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_note_rounded,
                      color: AppColors.hintColor.withAlpha(204)),
                  tooltip: "Edit Plan",
                  onPressed: () => _showPlanDialog(planToEdit: plan),
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever_rounded,
                      color: AppColors.error.withAlpha(178)),
                  tooltip: "Delete Plan",
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Confirm Delete',
                            style: TextStyle(color: AppColors.textColor)),
                        content: Text(
                            'Are you sure you want to delete plan "${plan.name}"?',
                            style: TextStyle(color: AppColors.hintColor)),
                        backgroundColor: AppColors.deepArmyDark.withAlpha(229),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: Text('Cancel',
                                  style:
                                      TextStyle(color: AppColors.hintColor))),
                          ElevatedButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error),
                              child: Text('Delete')),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      try {
                        await client.plan.deletePlan(plan.id!);
                        _fetchPlansForSelectedHotspot();
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Plan "${plan.name}" deleted.'),
                              backgroundColor: AppColors.success),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Failed to delete: ${e.toString().split(":").last.trim()}'),
                              backgroundColor: AppColors.error),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            if (plan.description != null && plan.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 30.0, bottom: 6, top: 2),
                child: Text(plan.description!,
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.hintColor.withAlpha(204),
                        fontStyle: FontStyle.italic)),
              ),
            Divider(
                color: AppColors.glassBorderColor.withAlpha(128), height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$currencySymbol ${_currencyFormat.format(plan.price)} • ${plan.durationValue} ${plan.durationType.name.toLowerCase()}',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$planTypeDisplay • Data: $dataLimitInfo',
                    style: TextStyle(fontSize: 12, color: AppColors.hintColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
