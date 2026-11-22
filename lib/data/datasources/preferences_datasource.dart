import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class PreferencesDataSource {
  final SharedPreferences _prefs;

  PreferencesDataSource(this._prefs);

  static Future<PreferencesDataSource> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesDataSource(prefs);
  }

  int getCurrentUserId() {
    return _prefs.getInt(AppConstants.prefKeyCurrentUserId) ?? 1;
  }

  Future<bool> setCurrentUserId(int userId) {
    return _prefs.setInt(AppConstants.prefKeyCurrentUserId, userId);
  }

  String getUserName() {
    return _prefs.getString(AppConstants.prefKeyUserName) ?? 'Smriti Rawat';
  }

  Future<bool> setUserName(String name) {
    return _prefs.setString(AppConstants.prefKeyUserName, name);
  }

  String getUserEmail() {
    return _prefs.getString(AppConstants.prefKeyUserEmail) ?? 'smriti.rawat@example.com';
  }

  Future<bool> setUserEmail(String email) {
    return _prefs.setString(AppConstants.prefKeyUserEmail, email);
  }

  String getUserPhone() {
    return _prefs.getString(AppConstants.prefKeyUserPhone) ?? '9876543210';
  }

  Future<bool> setUserPhone(String phone) {
    return _prefs.setString(AppConstants.prefKeyUserPhone, phone);
  }
}
