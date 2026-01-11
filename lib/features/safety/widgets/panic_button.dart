import 'package:flutter/material.dart';
import 'dart:async';

import '../../../core/theme/app_theme.dart';
import '../services/panic_service.dart';

/// Panic Button Widget with countdown confirmation
class PanicButton extends StatefulWidget {
  final String userId;
  final VoidCallback? onPanicTriggered;

  const PanicButton({
    super.key,
    required this.userId,
    this.onPanicTriggered,
  });

  @override
  State<PanicButton> createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton> {
  final PanicService _panicService = PanicService();

  void _showPanicConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PanicConfirmationDialog(
        userId: widget.userId,
        panicService: _panicService,
        onTriggered: widget.onPanicTriggered,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showPanicConfirmation,
      backgroundColor: AppColors.error,
      child: const Icon(Icons.warning, color: Colors.white, size: 28),
    );
  }
}

/// Panic confirmation dialog with countdown
class _PanicConfirmationDialog extends StatefulWidget {
  final String userId;
  final PanicService panicService;
  final VoidCallback? onTriggered;

  const _PanicConfirmationDialog({
    required this.userId,
    required this.panicService,
    this.onTriggered,
  });

  @override
  State<_PanicConfirmationDialog> createState() => _PanicConfirmationDialogState();
}

class _PanicConfirmationDialogState extends State<_PanicConfirmationDialog> {
  int _countdown = 3;
  Timer? _timer;
  bool _isTriggering = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _timer?.cancel();
        _triggerPanic();
      }
    });
  }

  Future<void> _triggerPanic() async {
    setState(() => _isTriggering = true);

    try {
      await widget.panicService.triggerPanic(widget.userId);

      if (mounted) {
        Navigator.pop(context);
        widget.onTriggered?.call();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Emergency contacts have been notified'),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send alert: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _cancel() {
    _timer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlRadius),
      backgroundColor: AppColors.error,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isTriggering) ...[
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              'Sending emergency alerts...',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.warning, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            const Text(
              'PANIC ALERT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Emergency contacts will be notified with your location',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      actions: _isTriggering
          ? null
          : [
              TextButton(
                onPressed: _cancel,
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
    );
  }
}
