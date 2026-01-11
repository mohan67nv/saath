import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/config/supabase_config.dart';
import '../services/emergency_contact_service.dart';

/// Service for handling panic button functionality
class PanicService {
  final EmergencyContactService _contactService = EmergencyContactService();
  final SupabaseConfig _supabase = SupabaseConfig();

  /// Trigger panic mode
  Future<void> triggerPanic(String userId) async {
    try {
      // Get emergency contacts
      final contacts = await _contactService.getEmergencyContacts(userId);

      if (contacts.isEmpty) {
        throw Exception('No emergency contacts configured');
      }

      // Get current location
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (e) {
        // Continue without location if permission denied or timeout
        print('Could not get location: $e');
      }

      // Create panic event log
      await _logPanicEvent(userId, position);

      // Send SMS to all emergency contacts
     await _sendEmergencySMS(contacts, position);
    } catch (e) {
      throw Exception('Failed to trigger panic: $e');
    }
  }

  /// Log panic event to database
  Future<void> _logPanicEvent(String userId, Position? position) async {
    try {
      await SupabaseConfig.client!.from('panic_events').insert({
        'user_id': userId,
        'triggered_at': DateTime.now().toIso8601String(),
        'latitude': position?.latitude,
        'longitude': position?.longitude,
      });
    } catch (e) {
      print('Failed to log panic event: $e');
    }
  }

  /// Send SMS to emergency contacts
  Future<void> _sendEmergencySMS(List contacts, Position? position) async {
    final message = _buildEmergencyMessage(position);

    for (final contact in contacts) {
      try {
        final smsUri = Uri(
          scheme: 'sms',
          path: contact.phone,
          queryParameters: {'body': message},
        );

        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
        }
      } catch (e) {
        print('Failed to send SMS to ${contact.name}: $e');
      }
    }
  }

  /// Build emergency message with location
  String _buildEmergencyMessage(Position? position) {
    final String locationPart = position != null
        ? 'Location: https://maps.google.com/?q=${position.latitude},${position.longitude}'
        : 'Location: Unable to determine';

    return '''🚨 EMERGENCY ALERT from Saath App 🚨

I need help! This is an automated emergency message.

$locationPart

Please check on me immediately.

- Sent from Saath Safety Network''';
  }
}
