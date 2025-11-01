import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Error Widget - Shows error message with retry option
class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final String? retryText;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorDisplayWidget({
    super.key,
    required this.message,
    this.retryText,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64.sp,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (retryText != null && onRetry != null) ...[
              SizedBox(height: 24.h),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                ),
                child: Text(retryText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
