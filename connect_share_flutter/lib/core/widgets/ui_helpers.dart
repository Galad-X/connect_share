// lib/core/widgets/ui_helpers.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart'; // Assuming your AppColors path

// Glassmorphic Card Widget
class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double blurSigma;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(20.0)),
    this.backgroundColor,
    this.borderColor,
    this.blurSigma = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.glassBackgroundColor,
            borderRadius: borderRadius,
            border: Border.all(
                color: borderColor ?? AppColors.glassBorderColor, width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}

// Background Builder for Screens
Widget buildGlassmorphicBackground(BuildContext context,
    {bool useThemeBackground = false}) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  final theme = Theme.of(context);

  return Stack(
    fit: StackFit.expand,
    children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: useThemeBackground
                ? [
                    theme.colorScheme.surface,
                    theme.colorScheme.surface
                  ] // Simpler gradient from theme
                : [
                    // More decorative gradient
                    AppColors.matcha.withAlpha(152),
                    theme.colorScheme.surface
                        .withAlpha(204), // Blend with theme background
                    AppColors.lemonTwist.withAlpha(77),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: useThemeBackground ? null : const [0.0, 0.6, 1.0],
          ),
        ),
      ),
      // Decorative Blurred Shapes (can be conditional)
      if (!useThemeBackground) ...[
        Positioned(
          top: screenHeight * 0.1,
          left: screenWidth * -0.25,
          child: _buildBlurredCircle(
              AppColors.matchaVeryLight.withAlpha(39), screenWidth * 0.6),
        ),
        Positioned(
          bottom: screenHeight * 0.05,
          right: screenWidth * -0.2,
          child: _buildBlurredCircle(
              AppColors.lemonTwist.withAlpha(52), screenWidth * 0.7),
        ),
        Positioned(
          top: screenHeight * 0.4,
          right: screenWidth * 0.1,
          child: _buildBlurredCircle(
              AppColors.white.withAlpha(13), screenWidth * 0.4),
        ),
      ]
    ],
  );
}

Widget _buildBlurredCircle(Color color, double size) {
  // These are just colored circles, the "blur" is conceptual for background depth.
  // The actual BackdropFilter is on the cards themselves.
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
  );
}

// Common Loading Widget
Widget buildLoadingWidget({String message = "Loading data..."}) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.matcha),
          strokeWidth: 3,
        ),
        const SizedBox(height: 20),
        Text(
          message,
          style: TextStyle(
            color: AppColors
                .textSecondary, // Or AppColors.textColor if on a glass background
            fontSize: 16,
          ),
        ),
      ],
    ),
  );
}

// Common Error Widget (Glassmorphic)
Widget buildErrorWidget(BuildContext context, String? errorMessage,
    {VoidCallback? onRetry}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: GlassmorphicCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              SelectableText(
                "Oops! Something Went Wrong",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor, // Text on glass
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              SelectableText(
                errorMessage ?? "An unknown error occurred. Please try again.",
                style: TextStyle(
                    color: AppColors.hintColor, fontSize: 14), // Text on glass
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text("Retry"),
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.matcha.withAlpha(204),
                    foregroundColor: AppColors.white,
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    ),
  );
}

// Helper for modern AppBar (transparent with optional title)
AppBar buildModernAppBar(BuildContext context, String title, 
    {List<Widget>? actions, bool showBackButton = true, Widget? leading
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0, // For M3, prevents color change on scroll
    title: Text(title,
        style: TextStyle(
            color: AppColors.textColor,
            fontWeight:
                FontWeight.w600)), // White text for glassmorphic context
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.textColor), // Back button color
    leading:  showBackButton && Navigator.canPop(context)
        ? IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          )
        : leading,
    actions: actions,
  );
}
extension StringExtension on String {
  // For FeedbackStatus and FeedbackType
  String capitalizeFirst() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
