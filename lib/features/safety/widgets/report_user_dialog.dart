import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../services/moderation_service.dart';

/// Report User Dialog
class ReportUserDialog extends StatefulWidget {
  final String reportedUserId;
  final String reportingUserId;
  final String reportedUserName;

  const ReportUserDialog({
    super.key,
    required this.reportedUserId,
    required this.reportingUserId,
    required this.reportedUserName,
  });

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  final ModerationService _moderationService = ModerationService();
  String _selectedReason = 'Harassment';
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _reasons = [
    {'value': 'Harassment', 'icon': Icons.report_problem, 'description': 'Unwanted or threatening behavior'},
    {'value': 'Inappropriate Content', 'icon': Icons.block, 'description': 'Offensive or explicit content'},
    {'value': 'Spam', 'icon': Icons.mark_email_unread, 'description': 'Unwanted promotional messages'},
    {'value': 'Fake Profile', 'icon': Icons.person_off, 'description': 'Suspected false identity'},
    {'value': 'Other', 'icon': Icons.more_horiz, 'description': 'Other safety concern'},
  ];

  Future<void> _submitReport() async {
    setState(() => _isSubmitting = true);

    try {
      await _moderationService.reportUser(
        reportedUserId: widget.reportedUserId,
        reportingUserId: widget.reportingUserId,
        reason: _selectedReason,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Report submitted. We\'ll review this within 24 hours.'),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
      title: Row(
        children: [
          const Icon(Icons.flag, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Report ${widget.reportedUserName}'),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please tell us what\'s wrong',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ..._reasons.map((reason) {
              final isSelected = _selectedReason == reason['value'];
              return GestureDetector(
                onTap: () => setState(() => _selectedReason = reason['value']),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.error.withValues(alpha: 0.1)
                        : Colors.grey.shade100,
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(
                      color: isSelected ? AppColors.error : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        reason['icon'],
                        color: isSelected ? AppColors.error : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reason['value'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.error : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              reason['description'],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle, color: AppColors.error),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Additional details (optional)',
                hintText: 'Provide more context...',
                border: OutlineInputBorder(borderRadius: AppRadius.mdRadius),
              ),
              maxLines: 3,
              maxLength: 500,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitReport,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Submit Report'),
        ),
      ],
    );
  }
}

/// Block User Confirmation Dialog
Future<bool?> showBlockUserDialog({
  required BuildContext context,
  required String userName,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
      title: const Row(
        children: [
          Icon(Icons.block, color: AppColors.error),
          SizedBox(width: 12),
          Text('Block User'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to block $userName?'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: AppRadius.mdRadius,
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'They won\'t be able to see your profile, message you, or interact with your events.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Block'),
        ),
      ],
    ),
  );
}
