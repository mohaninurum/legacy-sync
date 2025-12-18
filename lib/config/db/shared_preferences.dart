import 'package:shared_preferences/shared_preferences.dart';
import 'package:legacy_sync/config/db/encryption_service.dart';

class AppPreference {
  static String KEY_USER_IS_ADMIN = "KEY_USER_IS_ADMIN";
  static String KEY_USER_ID = "KEY_USER_ID";
  static String KEY_ATTENDANCE_LOGIN = "KEY_ATTENDANCE_LOGIN";
  static String KEY_USER_ROLE = "KEY_USER_ROLE";
  static String KEY_SELECTED_UID = "KEY_SELECTED_UID";
  static String KEY_USER_FIRST_NAME = "KEY_USER_FIRST_NAME";
  static String KEY_USER_LAST_NAME = "KEY_USER_LAST_NAME";
  static String KEY_USER_TOKEN = "KEY_USER_TOKEN";
  static String KEY_USER_DOB = "KEY_USER_DOB";
  static String KEY_LOGIN_TYPE_IS_SOCIAL = "KEY_LOGIN_TYPE_IS_SOCIAL";
  static String KEY_REFERRAL_CODE = "KEY_REFERRAL_CODE";
  static String KEY_SOCIAL_LOGIN_PROVIDER = "KEY_SOCIAL_LOGIN_PROVIDER";
  static String KEY_USER_IMAGE = "KEY_USER_IMAGE";
  static String KEY_USER_COMPANY_NAME = "KEY_USER_COMPANY_NAME";
  static String KEY_USER_MOBILE = "KEY_USER_MOBILE";
  static String KEY_USER_WORKLOCATION = "KEY_USER_WORKLOCATION";
  static String KEY_USER_MACHINE = "KEY_USER_MACHINE";
  static String KEY_USER_Email = "KEY_USER_Email";
  static String LEGACY_STARTED = "legacy_started";
  static String MEMORIES_CAPTURED = "memories_captured";
  static String KEY_GRADIENT_INDEX = "gradientIndex";
  static String KEY_INTERNET_STATUS = "KEY_INTERNET_STATUS";
  static String KEY_BLE_MAC = "KEY_BLE_MAC";
  static String KEY_BLE_CONNECTED = "KEY_BLE_CONNECTED";
  static String KEY_BLE_NAME = "KEY_BLE_NAME";
  static String KEY_STEPS = "KEY_STEPS";
  static String KEY_HEARTRATE = "KEY_HEARTRATE";
  static String KEY_O2 = "KEY_O2";
  static String KEY_BATTERY = "KEY_BATTERY";
  static String KEY_CALORIES = "KEY_CALORIES";
  static String KEY_SLEEP_TIME = "KEY_SLEEP_TIME";
  static String KEY_DURATION = "KEY_DURATION";
  static String KEY_DURATION_IN_SECONDS = "KEY_DURATION_IN_SECONDS";
  static String KEY_LAST_SYNC_TIMESTAMP = "KEY_LAST_SYNC_TIMESTAMP";
  static String KEY_LAST_CONNECTED_TIMESTAMP = "KEY_LAST_CONNECTED_TIMESTAMP";
  static String KEY_SELECTED_HEIGHT = "KEY_SELECTED_HEIGHT";
  static String KEY_SELECTED_WEIGHT = "KEY_SELECTED_WEIGHT";
  static String KEY_LOGIN_AS_GUEST = "KEY_LOGIN_AS_GUEST";
  static String KEY_DEVICE_NAME = "KEY_DEVICE_NAME";
  static String KEY_DEVICE_MAC = "KEY_DEVICE_MAC";
  static String KEY_SURVEY_SUBMITTED = "KEY_SURVEY_SUBMITTED";
  static String KEY_USER_FIRST_VISIT = "KEY_USER_FIRST_VISIT";
  // Notification preference keys
  static String KEY_ENABLE_NOTIFICATIONS = "KEY_ENABLE_NOTIFICATIONS";
  static String KEY_NEW_FEATURED_POSTS = "KEY_NEW_FEATURED_POSTS";
  static String KEY_ALL_NEW_POSTS = "KEY_ALL_NEW_POSTS";
  static String congratulation = "congratulation";


  // Cache keys for question data
  static String KEY_CACHED_QUESTION_DATA = "KEY_CACHED_QUESTION_DATA_";
  static String KEY_CACHE_TIMESTAMP = "KEY_CACHE_TIMESTAMP_";
  static const int CACHE_EXPIRY_HOURS = 720; // Cache expires after 720 hours

  static SharedPreferences? prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }



  Future<String> get({required String key}) async {
    String? value = prefs?.getString(key);
    return value ?? "";
  }

  Future set({required String key, required String value}) async {
    prefs?.setString(key, value);
    return true;
  }

  Future<bool> getBool({required String key}) async {
    var value = prefs?.getBool(key);
    return value ?? false;
  }

  Future setBool({required bool value, required String key}) async {

    prefs?.setBool(key, value);
    return true;
  }

  Future<bool> getBoolFW({required String key}) async {

    var value = prefs?.getBool(key);
    return value ?? true;
  }

  Future setBoolFW({required bool value, required String key}) async {

    prefs?.setBool(key, value);
    return true;
  }

  Future<int> getInt({required String key}) async {

    var value = prefs?.getInt(key);
    return value ?? 0;
  }

  Future setInt({required int value, required String key}) async {

    prefs?.setInt(key, value);
    return true;
  }

  Future<double> getDouble({required String key}) async {

    var value = prefs?.getDouble(key);
    return value ?? 0.0;
  }

  Future setDouble({required double value, required String key}) async {

    prefs?.setDouble(key, value);
    return true;
  }

  Future<void> clearAll() async {

    prefs?.clear();
  }

  static Future<void> remove({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<void> clearByKey({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  /// Cache question data with encryption
  Future<void> cacheQuestionData({
    required int moduleId,
    required int userId,
    required Map<String, dynamic> questionData,
  }) async {
    try {
      final cacheKey = "${KEY_CACHED_QUESTION_DATA}${moduleId}_$userId";
      final timestampKey = "${KEY_CACHE_TIMESTAMP}${moduleId}_$userId";

      // Add timestamp to the data
      final dataWithTimestamp = {
        ...questionData,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      };

      // Encrypt the data
      final encryptedData = EncryptionService.encryptJson(dataWithTimestamp);

      // Store encrypted data and timestamp
      await set(key: cacheKey, value: encryptedData);
      await setInt(
        key: timestampKey,
        value: DateTime.now().millisecondsSinceEpoch,
      );

      print('Question data cached for module: $moduleId, user: $userId');
    } catch (e) {
      print('Error caching question data: $e');
    }
  }

  /// Get cached question data with decryption
  Future<Map<String, dynamic>?> getCachedQuestionData({
    required int moduleId,
    required int userId,
  }) async {
    try {
      final cacheKey = "${KEY_CACHED_QUESTION_DATA}${moduleId}_$userId";
      final timestampKey = "${KEY_CACHE_TIMESTAMP}${moduleId}_$userId";

      // Check if cache exists
      final encryptedData = await get(key: cacheKey);
      if (encryptedData.isEmpty) {
        print('No cached data found for module: $moduleId, user: $userId');
        return null;
      }

      // Check cache expiry
      final cacheTimestamp = await getInt(key: timestampKey);
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = currentTime - cacheTimestamp;
      final maxAge =
          CACHE_EXPIRY_HOURS * 60 * 60 * 1000; // Convert hours to milliseconds

      if (cacheAge > maxAge) {
        print('Cache expired for module: $moduleId, user: $userId');
        // Clear expired cache
        await clearCachedQuestionData(moduleId: moduleId, userId: userId);
        return null;
      }

      // Decrypt and return data
      final decryptedData = EncryptionService.decryptJson(encryptedData);
      if (decryptedData != null) {
        print('Cached data retrieved for module: $moduleId, user: $userId');
        // Remove the timestamp before returning
        decryptedData.remove('cached_at');
        return decryptedData;
      }

      return null;
    } catch (e) {
      print('Error retrieving cached question data: $e');
      return null;
    }
  }

  /// Check if cached data exists and is valid
  Future<bool> isCacheValid({
    required int moduleId,
    required int userId,
  }) async {
    try {
      final cacheKey = "${KEY_CACHED_QUESTION_DATA}${moduleId}_$userId";
      final timestampKey = "${KEY_CACHE_TIMESTAMP}${moduleId}_$userId";

      // Check if cache exists
      final encryptedData = await get(key: cacheKey);
      if (encryptedData.isEmpty) return false;

      // Check cache expiry
      final cacheTimestamp = await getInt(key: timestampKey);
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = currentTime - cacheTimestamp;
      final maxAge = CACHE_EXPIRY_HOURS * 60 * 60 * 1000;

      return cacheAge <= maxAge;
    } catch (e) {
      print('Error checking cache validity: $e');
      return false;
    }
  }

  /// Clear cached question data for specific module and user
  Future<void> clearCachedQuestionData({
    required int moduleId,
    required int userId,
  }) async {
    try {
      final cacheKey = "${KEY_CACHED_QUESTION_DATA}${moduleId}_$userId";
      final timestampKey = "${KEY_CACHE_TIMESTAMP}${moduleId}_$userId";

      await clearByKey(key: cacheKey);
      await clearByKey(key: timestampKey);

      print('Cleared cached data for module: $moduleId, user: $userId');
    } catch (e) {
      print('Error clearing cached question data: $e');
    }
  }

  /// Clear all cached question data
  Future<void> clearAllCachedQuestionData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (String key in keys) {
        if (key.startsWith(KEY_CACHED_QUESTION_DATA) ||
            key.startsWith(KEY_CACHE_TIMESTAMP)) {
          await prefs.remove(key);
        }
      }

      print('Cleared all cached question data');
    } catch (e) {
      print('Error clearing all cached question data: $e');
    }
  }


  /// Generic cache service for any model type
  /// Save any model data to cache with encryption
  Future<bool> saveCachedModel<T>({
    required String cacheKey,
    required T model,
    required Map<String, dynamic> Function(T) toJson,
    int? expiryHours,
  }) async {
    try {
      // Convert model to JSON
      final jsonData = toJson(model);

      // Add timestamp
      jsonData['cached_at'] = DateTime.now().toIso8601String();

      // Encrypt the data
      final encryptedData = EncryptionService.encryptJson(jsonData);
      if (encryptedData == null) {
        print('Failed to encrypt model data for key: $cacheKey');
        return false;
      }

      // Save encrypted data
      await set(key: cacheKey, value: encryptedData);

      // Save timestamp for expiry check
      final timestampKey = "${KEY_CACHE_TIMESTAMP}$cacheKey";
      await setInt(
        key: timestampKey,
        value: DateTime.now().millisecondsSinceEpoch,
      );

      print('Model data cached successfully with key: $cacheKey');
      return true;
    } catch (e) {
      print('Error saving cached model data: $e');
      return false;
    }
  }

  /// Get cached model data with decryption
  Future<T?> getCachedModel<T>({
    required String cacheKey,
    required T Function(Map<String, dynamic>) fromJson,
    int? expiryHours,
  }) async {
    try {
      // Check if cache exists
      final encryptedData = await get(key: cacheKey);
      if (encryptedData.isEmpty) {
        print('No cached data found for key: $cacheKey');
        return null;
      }

      // Check cache expiry
      final timestampKey = "${KEY_CACHE_TIMESTAMP}$cacheKey";
      final cacheTimestamp = await getInt(key: timestampKey);
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = currentTime - cacheTimestamp;
      final maxAge = (expiryHours ?? CACHE_EXPIRY_HOURS) * 60 * 60 * 1000;

      if (cacheAge > maxAge) {
        print('Cache expired for key: $cacheKey');
        // Clear expired cache
        await clearCachedModel(cacheKey: cacheKey);
        return null;
      }

      // Decrypt data
      final decryptedData = EncryptionService.decryptJson(encryptedData);
      if (decryptedData != null) {
        print('Cached data retrieved for key: $cacheKey');
        // Remove timestamp before converting to model
        decryptedData.remove('cached_at');

        // Convert to model
        return fromJson(decryptedData);
      }

      return null;
    } catch (e) {
      print('Error retrieving cached model data: $e');
      return null;
    }
  }

  /// Check if cached model exists and is valid
  Future<bool> isModelCacheValid({
    required String cacheKey,
    int? expiryHours,
  }) async {
    try {
      // Check if cache exists
      final encryptedData = await get(key: cacheKey);
      if (encryptedData.isEmpty) return false;

      // Check cache expiry
      final timestampKey = "${KEY_CACHE_TIMESTAMP}$cacheKey";
      final cacheTimestamp = await getInt(key: timestampKey);
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = currentTime - cacheTimestamp;
      final maxAge = (expiryHours ?? CACHE_EXPIRY_HOURS) * 60 * 60 * 1000;

      return cacheAge <= maxAge;
    } catch (e) {
      print('Error checking cache validity: $e');
      return false;
    }
  }

  /// Clear cached model data
  Future<void> clearCachedModel({
    required String cacheKey,
  }) async {
    try {
      final timestampKey = "${KEY_CACHE_TIMESTAMP}$cacheKey";

      await clearByKey(key: cacheKey);
      await clearByKey(key: timestampKey);

      print('Cleared cached data for key: $cacheKey');
    } catch (e) {
      print('Error clearing cached model data: $e');
    }
  }

  /// Save list of models to cache
  Future<bool> saveCachedModelList<T>({
    required String cacheKey,
    required List<T> modelList,
    required Map<String, dynamic> Function(T) toJson,
    int? expiryHours,
  }) async {
    try {
      // Convert list to JSON
      final jsonList = modelList.map((model) => toJson(model)).toList();
      final jsonData = {
        'data': jsonList,
        'cached_at': DateTime.now().toIso8601String(),
      };

      // Encrypt the data
      final encryptedData = EncryptionService.encryptJson(jsonData);
      if (encryptedData == null) {
        print('Failed to encrypt model list data for key: $cacheKey');
        return false;
      }

      // Save encrypted data
      await set(key: cacheKey, value: encryptedData);

      // Save timestamp
      final timestampKey = "${KEY_CACHE_TIMESTAMP}$cacheKey";
      await setInt(
        key: timestampKey,
        value: DateTime.now().millisecondsSinceEpoch,
      );

      print('Model list cached successfully with key: $cacheKey');
      return true;
    } catch (e) {
      print('Error saving cached model list: $e');
      return false;
    }
  }

  /// Get cached list of models
  Future<List<T>?> getCachedModelList<T>({
    required String cacheKey,
    required T Function(Map<String, dynamic>) fromJson,
    int? expiryHours,
  }) async {
    try {
      // Check if cache exists
      final encryptedData = await get(key: cacheKey);
      if (encryptedData.isEmpty) {
        print('No cached list data found for key: $cacheKey');
        return null;
      }

      // Check cache expiry
      final timestampKey = "${KEY_CACHE_TIMESTAMP}$cacheKey";
      final cacheTimestamp = await getInt(key: timestampKey);
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final cacheAge = currentTime - cacheTimestamp;
      final maxAge = (expiryHours ?? CACHE_EXPIRY_HOURS) * 60 * 60 * 1000;

      if (cacheAge > maxAge) {
        print('Cache expired for key: $cacheKey');
        await clearCachedModel(cacheKey: cacheKey);
        return null;
      }

      // Decrypt data
      final decryptedData = EncryptionService.decryptJson(encryptedData);
      if (decryptedData != null && decryptedData['data'] is List) {
        print('Cached list data retrieved for key: $cacheKey');

        // Convert to model list
        final List<dynamic> jsonList = decryptedData['data'];
        return jsonList
            .map((json) => fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return null;
    } catch (e) {
      print('Error retrieving cached model list: $e');
      return null;
    }
  }
}
