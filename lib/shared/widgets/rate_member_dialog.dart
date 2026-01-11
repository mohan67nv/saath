import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Rate Member Dialog - Shows star rating and optional comment
class RateMemberDialog extends StatefulWidget {
  final String memberName;
  final String eventName;
  final Function(int rating, String? comment) onSubmit;

  const RateMemberDialog({
    super.key,
    required this.memberName,
    required this.eventName,
    required this.onSubmit,
  });

  @override
  State<RateMemberDialog> createState() => _RateMemberDialogState();
}

class _RateMemberDialogState extends State<RateMemberDialog> {
  int _selectedRating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitRating() async {
    if (_selectedRating == 0) return;
    
    setState(() => _isSubmitting = true);
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    widget.onSubmit(_selectedRating, _commentController.text.isEmpty ? null : _commentController.text);
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            'Rate ${widget.memberName}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'From: ${widget.eventName}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return GestureDetector(
                onTap: () => setState(() => _selectedRating = starIndex),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    starIndex <= _selectedRating ? Icons.star : Icons.star_border,
                    color: starIndex <= _selectedRating ? Colors.amber : AppColors.textLight,
                    size: 36,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            _getRatingLabel(),
            style: TextStyle(
              color: _selectedRating > 0 ? AppColors.primary : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          // Quick Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildTag('Friendly'),
              _buildTag('Punctual'),
              _buildTag('Great Conversationalist'),
              _buildTag('Would meet again'),
            ],
          ),
          const SizedBox(height: 16),
          // Comment Field
          TextField(
            controller: _commentController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Add a comment (optional)',
              hintStyle: TextStyle(color: AppColors.textLight),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Skip'),
        ),
        ElevatedButton(
          onPressed: _selectedRating > 0 && !_isSubmitting ? _submitRating : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isSubmitting
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return GestureDetector(
      onTap: () {
        final currentText = _commentController.text;
        if (currentText.isEmpty) {
          _commentController.text = label;
        } else if (!currentText.contains(label)) {
          _commentController.text = '$currentText, $label';
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _getRatingLabel() {
    switch (_selectedRating) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Great';
      case 5: return 'Excellent!';
      default: return 'Tap to rate';
    }
  }
}

/// Helper function to show the rating dialog
void showRateMemberDialog({
  required BuildContext context,
  required String memberName,
  required String eventName,
  required Function(int rating, String? comment) onSubmit,
}) {
  showDialog(
    context: context,
    builder: (context) => RateMemberDialog(
      memberName: memberName,
      eventName: eventName,
      onSubmit: onSubmit,
    ),
  );
}
