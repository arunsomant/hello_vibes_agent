class ApiEndpoints {
  ApiEndpoints._();

  static const String firebaseLogin = '/agent/firebase/login';

  static const String fcmToken = '/agent/fcm';

  static const String otpSend = '/agent/otp/send';

  static const String otpVerify = '/agent/otp/verify';

  static const String profile = '/agent/profile';

  static const String avatars = '/avatars';

  static const String profileUpdate = '/agent/profile/update';

  static const String bankDetails = '/agent/bank-details';

  static const String requestWithdrawal = '/agent/withdrawals/request';

  static const String languages = '/languages';

  static const String updateOnlineStatus = '/agent/toggle-availability';

  static const String logout = '/agent/logout';

  static const String transactions = '/wallet/transactions';

  static const String calls = '/calls';

  static const String callHistory = '$calls/history';

  static const String callInitiate = '$calls/initiate';

  static const String callEnd = '/terminate';

  static const String callReject = '/reject';

  static const String callAccept = '/accept';

  static const String callStart = '/start';
}
