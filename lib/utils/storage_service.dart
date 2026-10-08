import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyEncryptedRegNo = 'encrypted_reg_no';
  static const String _keyRegNo = 'reg_no';
  static const String _keyHeadOfHousehold = 'head_of_household';

  // Save job card details
  static Future<void> saveJobCardDetails({
    required String encryptedRegNo,
    required String regNo,
    required String headOfHousehold,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEncryptedRegNo, encryptedRegNo);
    await prefs.setString(_keyRegNo, regNo);
    await prefs.setString(_keyHeadOfHousehold, headOfHousehold);
  }

  // Get saved job card details
  static Future<Map<String, String?>> getSavedJobCardDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'encryptedRegNo': prefs.getString(_keyEncryptedRegNo),
      'regNo': prefs.getString(_keyRegNo),
      'headOfHousehold': prefs.getString(_keyHeadOfHousehold),
    };
  }

  // Check if user has saved job card
  static Future<bool> hasSavedJobCard() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyEncryptedRegNo);
  }

  // Clear saved job card details (logout)
  static Future<void> clearJobCardDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEncryptedRegNo);
    await prefs.remove(_keyRegNo);
    await prefs.remove(_keyHeadOfHousehold);
  }
}
