import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../services/icebreaker_service.dart';

/// Icebreaker Selector Dialog
class IcebreakerSelector extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final Function(String message) onSelect;

  const IcebreakerSelector({
    super.key,
    required this.recipientId,
    required this.recipientName,
    required this.onSelect,
  });

  @override
  State<IcebreakerSelector> createState() => _IcebreakerSelectorState();
}

class _IcebreakerSelectorState extends State<IcebreakerSelector> {
  final IcebreakerService _service = IcebreakerService();
  List<Map<String, dynamic>> _templates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    try {
      final templates = await _service.getTemplates();
      setState(() {
        _templates = templates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _selectTemplate(Map<String, dynamic> template) {
    String message = template['message_text'];
    
    // Personalize with recipient name
    message = _service.personalizeMessage(message, {
      'name': widget.recipientName,
    });

    widget.onSelect(message);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.warning),
                const SizedBox(width: 8),
                const Text(
                  'Icebreaker Messages',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Start the conversation with a fun opener',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final template = _templates[index];
                    final isPremium = template['is_premium'] ?? false;

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.mdRadius,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        title: Text(
                          template['message_text'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: isPremium
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: AppRadius.smRadius,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, size: 12, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Icon(Icons.arrow_forward, size: 18),
                        onTap: () => _selectTemplate(template),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
