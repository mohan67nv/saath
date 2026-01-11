import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/supabase_config.dart';

/// SMS OTP Service using Supabase Edge Function (bypasses CORS for web)
class SmsOtpService {
  final String _edgeFunctionUrl = 
      '${SupabaseConfig.supabaseUrl}/functions/v1/sms-otp';

  /// Send OTP to phone number
  Future<Map<String, dynamic>> sendOTP(String phoneNumber, {String? template}) async {
    try {
      final response = await http.post(
        Uri.parse(_edgeFunctionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SupabaseConfig.supabaseAnonKey}',
        },
        body: json.encode({
          'action': 'send',
          'phoneNumber': phoneNumber,
          'template': template,
        }),
      );

      print('Send OTP Response: ${response.statusCode}');
      print('Send OTP Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': data['success'] ?? false,
          'sessionId': data['sessionId'],
          'message': data['message'] ?? 'OTP sent successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to send OTP: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Error sending OTP: $e');
      return {
        'success': false,
        'message': 'Error sending OTP: $e',
      };
    }
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOTP(String sessionId, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(_edgeFunctionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SupabaseConfig.supabaseAnonKey}',
        },
        body: json.encode({
          'action': 'verify',
          'sessionId': sessionId,
          'otp': otp,
        }),
      );

      print('Verify OTP Response: ${response.statusCode}');
      print('Verify OTP Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': data['success'] ?? false,
          'message': data['message'] ?? 'OTP verified successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid OTP',
        };
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      return {
        'success': false,
        'message': 'Error verifying OTP: $e',
      };
    }
  }
}
