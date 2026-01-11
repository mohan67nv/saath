import '../../../core/config/supabase_config.dart';
import '../models/emergency_contact.dart';

/// Service for managing emergency contacts
class EmergencyContactService {
  /// Fetch all emergency contacts for the current user
  Future<List<EmergencyContact>> getEmergencyContacts(String userId) async {
    try {
      final response = await SupabaseConfig.client!
          .from('emergency_contacts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => EmergencyContact.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch emergency contacts: $e');
    }
  }

  /// Add a new emergency contact
  Future<EmergencyContact> addContact(EmergencyContact contact) async {
    try {
      await SupabaseConfig.client!.from('emergency_contacts').insert(contact.toJson());
      return contact;
    } catch (e) {
      throw Exception('Failed to add emergency contact: $e');
    }
  }

  /// Update an existing emergency contact
  Future<void> updateContact(EmergencyContact contact) async {
    try {
      await SupabaseConfig.client!
          .from('emergency_contacts')
          .update(contact.toJson())
          .eq('id', contact.id);
    } catch (e) {
      throw Exception('Failed to update emergency contact: $e');
    }
  }

  /// Delete an emergency contact
  Future<void> deleteContact(String contactId) async {
    try {
      await SupabaseConfig.client!.from('emergency_contacts').delete().eq('id', contactId);
    } catch (e) {
      throw Exception('Failed to delete emergency contact: $e');
    }
  }

  /// Get count of emergency contacts
  Future<int> getContactCount(String userId) async {
    try {
      final contacts = await getEmergencyContacts(userId);
      return contacts.length;
    } catch (e) {
      return 0;
    }
  }
}
