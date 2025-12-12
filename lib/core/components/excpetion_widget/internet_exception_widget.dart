import 'package:flutter/material.dart';
import 'package:legacy_sync/core/strings/strings.dart';

class InternetExceptionWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final bool showRetryButton;
  final String? retryButtonText;

  const InternetExceptionWidget({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.iconSize = 80.0,
    this.showRetryButton = true,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // No Internet Icon
          Icon(
            Icons.wifi_off_rounded,
            size: iconSize,
            color: iconColor ?? theme.colorScheme.error,
          ),

          const SizedBox(height: 24.0),

          // Title
          Text(
            title ?? AppStrings.noInternetConnection,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: textColor ?? theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12.0),

          // Message
          Text(
            message ?? AppStrings.checkInternetConnection,
            style: theme.textTheme.bodyMedium?.copyWith(
              color:
                  textColor?.withValues(alpha: 0.7) ??
                  theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: 32.0),

            // Retry Button
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(retryButtonText ?? AppStrings.tryAgain),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
