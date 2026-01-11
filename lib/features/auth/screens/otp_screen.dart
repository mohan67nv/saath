import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/gradient_button.dart';

/// OTP Verification Screen
class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  bool _isLoading = false;
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Check if all fields are filled
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      _verifyOtp(otp);
    }
  }

  void _onKeyDown(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _focusNodes[index - 1].requestFocus();
        }
      }
    }
  }

  Future<void> _verifyOtp(String otp) async {
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo, accept any 6-digit OTP
    if (mounted) {
      context.go(AppRoutes.profileSetup);
    }
    
    setState(() => _isLoading = false);
  }

  void _resendOtp() {
    if (_resendTimer == 0) {
      _startResendTimer();
      // TODO: Implement actual OTP resend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              
              // Header
              _buildHeader()
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.2, end: 0),
              
              const SizedBox(height: AppSpacing.xxl),
              
              // OTP Input
              _buildOtpInput()
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Resend Timer
              _buildResendButton()
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Verify Button
              GradientButton(
                onPressed: _isLoading ? null : () {
                  final otp = _controllers.map((c) => c.text).join();
                  if (otp.length == 6) {
                    _verifyOtp(otp);
                  }
                },
                isLoading: _isLoading,
                child: const Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ).animate()
                .fadeIn(delay: 400.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.message,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Verify Your Number',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Enter the 6-digit code sent to',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.phoneNumber,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) => _onKeyDown(index, event),
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.mdRadius,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.mdRadius,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.mdRadius,
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) => _onOtpChanged(index, value),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildResendButton() {
    return Center(
      child: _resendTimer > 0
        ? Text(
            'Resend code in ${_resendTimer}s',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        : TextButton(
            onPressed: _resendOtp,
            child: const Text('Resend Code'),
          ),
    );
  }
}
