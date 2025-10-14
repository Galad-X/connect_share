// complaints_and_suggestions_screen.dart
import 'package:connect_share_client/connect_share_client.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart'; // Adjust path
import '../../../core/widgets/ui_helpers.dart'; // Adjust path
import '../../../src/serverpod_client.dart'; // For client

// Define the enums based on your schema
enum FeedbackStatus {
  open,
  responded,
  closed,
}

enum FeedbackType {
  complaint,
  suggestion,
}

class ComplaintsAndSuggestionsScreen extends StatefulWidget {
  const ComplaintsAndSuggestionsScreen({super.key});

  @override
  State<ComplaintsAndSuggestionsScreen> createState() =>
      _ComplaintsAndSuggestionsScreenState();
}

class _ComplaintsAndSuggestionsScreenState
    extends State<ComplaintsAndSuggestionsScreen> {
  List<Feedback> _feedbacks = [];
  bool _isLoading = true;
  String? _errorMessage;
  FeedbackStatus? _filterStatus; // For filtering

  final _responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFeedback();
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  Future<void> _fetchFeedback() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Convert enum to string for the API call
      final statusString = _filterStatus?.name;
      final feedbacks = await client.admin.listFeedback(status: statusString);
      if (!mounted) return;
      setState(() {
        _feedbacks = feedbacks;
        _isLoading = false;
        if (feedbacks.isEmpty) {
          _errorMessage = _filterStatus == null
              ? "No feedback submissions found."
              : "No feedback found with status: ${_filterStatus!.name.capitalizeFirst()}.";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Failed to load feedback: ${e.toString().split(":").last.trim()}';
        _isLoading = false;
      });
    }
  }

  // Helper method to convert string status to enum
  FeedbackStatus _stringToFeedbackStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return FeedbackStatus.open;
      case 'responded':
        return FeedbackStatus.responded;
      case 'closed':
        return FeedbackStatus.closed;
      default:
        return FeedbackStatus.open;
    }
  }

  // Helper method to convert string type to enum
  FeedbackType _stringToFeedbackType(String type) {
    switch (type.toLowerCase()) {
      case 'complaint':
        return FeedbackType.complaint;
      case 'suggestion':
        return FeedbackType.suggestion;
      default:
        return FeedbackType.complaint;
    }
  }

  Future<void> _showRespondDialog(Feedback feedbackItem) async {
    _responseController.text = feedbackItem.response ?? '';
    final String? newResponse = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepArmyDark.withAlpha(229),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
            'Respond to ${_stringToFeedbackType(feedbackItem.type).name.capitalizeFirst()}',
            style: TextStyle(color: AppColors.textColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("From User ID: ${feedbackItem.userId}",
                  style: TextStyle(color: AppColors.hintColor, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                  "Submitted: ${DateFormat('MMM dd, yyyy HH:mm').format(feedbackItem.submittedAt.toLocal())}",
                  style: TextStyle(color: AppColors.hintColor, fontSize: 13)),
              const SizedBox(height: 12),
              Text("Content:",
                  style: TextStyle(
                      color: AppColors.hintColor, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.textFieldFillColor.withAlpha(128),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(feedbackItem.content,
                    style: TextStyle(color: AppColors.textColor, fontSize: 14)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _responseController,
                style: TextStyle(color: AppColors.textColor),
                decoration: InputDecoration(
                  labelText: 'Your Response',
                  labelStyle: TextStyle(color: AppColors.hintColor),
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: AppColors.glassBorderColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: AppColors.glassBorderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: AppColors.matcha, width: 1.5)),
                ),
                maxLines: 4,
                minLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  Text('Cancel', style: TextStyle(color: AppColors.hintColor))),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, _responseController.text.trim()),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.matcha),
            child: const Text('Send Response & Close Ticket'),
          ),
        ],
      ),
    );

    if (newResponse != null && newResponse.isNotEmpty) {
      try {
        await client.admin.respondToFeedback(feedbackItem.id!, newResponse);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Response sent and ticket closed.'),
              backgroundColor: AppColors.success),
        );
        _fetchFeedback(); // Refresh list
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to send response: ${e.toString().split(":").last.trim()}'),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildGlassmorphicBackground(context),
        SafeArea(
          child: Column(
            children: [
              _buildFilterChips(),
              Expanded(
                child: _isLoading
                    ? buildLoadingWidget(message: "Loading feedback...")
                    : _errorMessage != null && _feedbacks.isEmpty
                        ? buildErrorWidget(context, _errorMessage,
                            onRetry: _fetchFeedback)
                        : _buildFeedbackList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(null, "All Feedback"),
            ...FeedbackStatus.values
                .map((status) =>
                    _buildFilterChip(status, status.name.capitalizeFirst()))
                ,
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(FeedbackStatus? status, String label) {
    final bool isSelected = _filterStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _filterStatus = selected ? status : null;
          });
          _fetchFeedback();
        },
        backgroundColor: AppColors.glassBackgroundColor.withAlpha(52),
        selectedColor: AppColors.matcha.withAlpha(104),
        labelStyle: TextStyle(
            color: isSelected ? AppColors.textColor : AppColors.hintColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isSelected
                  ? AppColors.matcha
                  : AppColors.glassBorderColor.withAlpha(128)),
        ),
      ),
    );
  }

  Widget _buildFeedbackList() {
    if (_feedbacks.isEmpty) {
      return buildErrorWidget(
          context, _errorMessage ?? "No feedback entries for this filter.",
          onRetry: _fetchFeedback);
    }
    return RefreshIndicator(
      onRefresh: _fetchFeedback,
      color: AppColors.matcha,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _feedbacks.length,
        itemBuilder: (context, index) {
          final feedbackItem = _feedbacks[index];
          return _buildFeedbackCard(feedbackItem);
        },
      ),
    );
  }

  Widget _buildFeedbackCard(Feedback feedbackItem) {
    // Convert string status to enum for proper handling
    final feedbackStatus = _stringToFeedbackStatus(feedbackItem.status);
    final feedbackType = _stringToFeedbackType(feedbackItem.type);

    // Initialize with default values to prevent null safety issues
    Color statusColor = AppColors.warning;
    IconData statusIcon = Icons.pending_actions_rounded;

    switch (feedbackStatus) {
      case FeedbackStatus.open:
        statusColor = AppColors.warning;
        statusIcon = Icons.pending_actions_rounded;
        break;
      case FeedbackStatus.responded:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      case FeedbackStatus.closed:
        statusColor = AppColors.inactive;
        statusIcon = Icons.inventory_2_outlined;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassmorphicCard(
        backgroundColor: AppColors.glassBackgroundColor.withAlpha(39),
        child: InkWell(
          // Make card tappable
          onTap: () => _showRespondDialog(feedbackItem),
          borderRadius:
              BorderRadius.circular(20), // From GlassmorphicCard default
          child: Padding(
            // Add padding inside InkWell for tap area
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      feedbackType == FeedbackType.complaint
                          ? Icons.error_outline_rounded
                          : feedbackType == FeedbackType.suggestion
                              ? Icons.lightbulb_outline_rounded
                              : Icons.help_outline_rounded,
                      color: AppColors.textColor.withAlpha(204),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feedbackType.name.capitalizeFirst(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor),
                      ),
                    ),
                    Chip(
                      avatar: Icon(statusIcon, color: statusColor, size: 14),
                      label: Text(feedbackStatus.name.capitalizeFirst(),
                          style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500)),
                      backgroundColor: statusColor.withAlpha(39),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  feedbackItem.content,
                  style: TextStyle(color: AppColors.hintColor, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'User ID: ${feedbackItem.userId}',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.hintColor.withAlpha(178)),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy')
                          .format(feedbackItem.submittedAt.toLocal()),
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.hintColor.withAlpha(178)),
                    ),
                  ],
                ),
                if (feedbackItem.response != null &&
                    feedbackItem.response!.isNotEmpty) ...[
                  Divider(height: 16, color: AppColors.glassBorderColor),
                  Text("Admin Response:",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.hintColor,
                          fontWeight: FontWeight.w500)),
                  Text(feedbackItem.response!,
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textColor.withAlpha(229),
                          fontStyle: FontStyle.italic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
