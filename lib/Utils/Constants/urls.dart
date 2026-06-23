class AppEndPoints {
  static var baseUrl = 'https://mis.faisaltown.com.pk/';
  /// Auth
  static String get login => '${baseUrl}login';
  static String get verifyOtp => '${baseUrl}verify_otp';

/// profile screens
  static String get profile=> '${baseUrl}user_profile';
  static String get transfers=> '${baseUrl}member_history';

  // https://faisaltown.com.pk/portal/members_portal/payonline.php?payfrom_phone=true&project=0&id=2


}