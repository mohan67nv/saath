/// Razorpay Configuration
/// 
/// To use Razorpay:
/// 1. Sign up at https://razorpay.com
/// 2. Get your API keys from Dashboard → Settings → API Keys
/// 3. Replace the values below with your keys
/// 
/// IMPORTANT: Keep your key_secret secure! Never commit it to version control.
/// For production, use environment variables or secure key management.

class RazorpayConfig {
  // Test Mode Keys (use for development)
  static const String testKeyId = 'rzp_test_YOUR_KEY_ID';
  static const String testKeySecret = 'YOUR_TEST_KEY_SECRET';

  // Live Mode Keys (use for production)
  static const String liveKeyId = 'rzp_live_YOUR_KEY_ID';
  static const String liveKeySecret = 'YOUR_LIVE_KEY_SECRET';

  // Current mode
  static const bool isTestMode = true; // Set to false for production

  // Active keys
  static String get keyId => isTestMode ? testKeyId : liveKeyId;
  static String get keySecret => isTestMode ? testKeySecret : liveKeySecret;

  // Razorpay settings
  static const String currency = 'INR';
  static const String companyName = 'Saath Technologies';
  static const String companyLogo = 'https://saath.app/logo.png'; // Update with your logo URL

  // Webhook secret for verifying Razorpay callbacks
  static const String webhookSecret = 'YOUR_WEBHOOK_SECRET';

  // Check if configured
  static bool get isConfigured =>
      keyId != 'rzp_test_YOUR_KEY_ID' && keyId != 'rzp_live_YOUR_KEY_ID';
}
