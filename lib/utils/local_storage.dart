import 'package:shared_preferences/shared_preferences.dart';
import 'package:zedbee_bms/utils/secure_storage.dart';

class LocalStorage {
  static const String themeKey = "app_theme";
  static const String isSplashKey = "is_splash_opened";
  static const String profileImageKey = "profile_image_path";
  static const String _keyDomain = 'custDomainKey';
  static const String roleKey = 'user_role';
  static const String groupNameKey = 'group_name';
  static const String areaNameKey = 'area_name';
  static const String floorIdKey = 'floor_id';
  static const String roomIdKey = 'room_id';
  // save Theme colour
  Future<void> saveTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, themeName);
  }

  // Get the stored Theme color
  Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(themeKey);
  }

  // save profile image path
  static Future<void> savedProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(profileImageKey, path);
  }

  // Load profile image path
  static Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(profileImageKey);
  }

  // remove saved profile image after changed
  static Future<void> clearProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(profileImageKey);
  }

  // save user details
  Future<void> saveUserDetails(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setBool('rememberMe', true);
    // Save password securely
    await SecureStorage.savePassword(password);
  }

  // Get user details
  Future<Map<String, dynamic>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    final password = await SecureStorage.getPassword();
    return {'email': email, 'password': password, 'rememberMe': rememberMe};
  }

  // clear user details
  Future<void> clearUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('rememberMe');
    await SecureStorage.clearPassword();
  }

  // Save custDomainKey
  static Future<void> saveDomainKey(String domainKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDomain, domainKey);
  }

  // Get the DomainKey
  static Future<String?> getDomainKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDomain);
  }

  // Clear the Domainkey
  static Future<void> clearDomainKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDomain);
  }

  // save session token
  Future<void> sessionToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionToken', token);
  }

  // Get the session Token
  Future<String?> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionToken');
  }

  // save location filters
  Future<void> saveLocationFilters({
    String? country,
    String? state,
    String? city,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedCountry", country ?? "");
    await prefs.setString("selectedState", state ?? "");
    await prefs.setString("selectedCity", city ?? "");
  }

  // Get stored location
  Future<Map<String, String?>> getLocationFilters() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "country": prefs.getString("selectedCountry"),
      "state": prefs.getString("selectedState"),
      "city": prefs.getString("selectedCity"),
    };
  }

  // clear filters
  static Future<void> clearLocationFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("selectedCountry");
    await prefs.remove("selectedState");
    await prefs.remove("selectedCity");
  }

  static Future<void> saveLocationData({
    required String groupName,
    required String areaName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(groupNameKey, groupName);
    await prefs.setString(areaNameKey, areaName);
  }

  static Future<String?> getGroupName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(groupNameKey);
  }

  static Future<String?> getAreaName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(areaNameKey);
  }

  static Future<void> clearLocationData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(groupNameKey);
    await prefs.remove(areaNameKey);
  }

  // Save selected floor ID
  static Future<void> saveFloorId(String floorId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(floorIdKey, floorId);
  }

  // Get selected floor ID
  static Future<String?> getFloorId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(floorIdKey);
  }

  // Clear floor ID (optional)
  static Future<void> clearFloorId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(floorIdKey);
  }

  // Save selected room ID
  static Future<void> saveRoomId(String roomId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(roomIdKey, roomId);
  }

  // Get selected room ID
  static Future<String?> getRoomId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(roomIdKey);
  }

  // Clear saved room ID (optional)
  static Future<void> clearRoomId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(roomIdKey);
  }

  // Save user role
  static Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(roleKey, role);
  }

  // Get user role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(roleKey);
  }

  // Clear saved role
  static Future<void> clearUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(roleKey);
  }

  
}
