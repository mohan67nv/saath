import '../../../core/config/supabase_config.dart';

/// Icebreaker Service
class IcebreakerService {
  final SupabaseConfig _supabase = SupabaseConfig();

  /// Get icebreaker templates by category
  Future<List<Map<String, dynamic>>> getTemplates({
    String? category,
    bool premiumOnly = false,
  }) async {
    var query = _supabase.client!
        .from('icebreaker_templates')
        .select()
        .eq('is_active', true);

    if (category != null) {
      query = query.eq('category', category);
    }

    if (premiumOnly) {
      query = query.eq('is_premium', true);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }

  /// Send icebreaker message
  Future<void> sendIcebreaker({
    required String senderId,
    required String recipientId,
    required String templateId,
    required String messageText,
  }) async {
    // Record icebreaker usage
    await _supabase.client!.from('user_icebreakers_sent').insert({
      'sender_id': senderId,
      'recipient_id': recipientId,
      'template_id': templateId,
      'message_text': messageText,
      'sent_at': DateTime.now().toIso8601String(),
    });

    // Increment usage count
    await _supabase.client!.rpc('increment_icebreaker_usage', params: {
      'template_id': templateId,
    });

    // TODO: Actually send the message to the recipient
    // This would integrate with your chat/messaging system
  }

  /// Get personalized icebreaker (replace placeholders)
  String personalizeMessage(String template, Map<String, String> variables) {
    String message = template;
    variables.forEach((key, value) {
      message = message.replaceAll('{{$key}}', value);
    });
    return message;
  }
}
