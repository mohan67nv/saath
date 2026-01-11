/// Gender Verification Service
class GenderVerificationService {
  /// Check if user can join a gendered event
  static Future<Map<String, dynamic>> canJoinGenderedEvent({
    required String userGender,
    required bool isWomenOnly,
  }) async {
    if (!isWomenOnly) {
      return {'canJoin': true};
    }

    // Women-only event: only allow women
    if (userGender.toLowerCase() == 'female' || userGender.toLowerCase() == 'woman') {
      return {'canJoin': true};
    }

    return {
      'canJoin': false,
      'message': 'This is a women-only event. Only women can join.',
    };
  }

   /// Get gender badge for event
  static String? getGenderBadge(bool isWomenOnly) {
    return isWomenOnly ? '👩 Women Only' : null;
  }
}
