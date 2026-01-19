class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.ssid.xtagna.com/api/';

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String acceptJson = 'application/json';

  // Auth Endpoints
  static const String login = 'Auth/Login';
  static const String resetPassword = 'Auth/ResetPassword';
  static const String changePassword = 'Auth/ChangePasswordDto';
  static const String forgetPassword = 'Auth/ForgetPassword';
  static const String checkTokenValidate = 'Auth/CheckTokenValidate';
  static const String registerFirebaseToken = 'Auth/RegisterFirebaseToken';
  static const String logout = 'Auth/Logout';

  // Students Endpoints
  static const String createStudent = 'Students/CreateStudent';
  static const String updateStudent = 'Students/UpdateStudent';
  static const String getAllStudents = 'Students/GetAllStudents';
  static const String getGuardianStudents = 'Students/GetGuardianStudents';
  static const String getStudentDetails = 'Students/GetStudentDetails';
  static const String getStudentFormData = 'Students/GetStudentFormData';
  static const String deleteStudent = 'Students/DeleteStudent';

  // Guardians Endpoints
  static const String createGuardian = 'Guardians/CreateGuardian';
  static const String guardiansList = 'Guardians/GuardiansList';

  // Student Wallets Endpoints
  static const String updateWalletConfig = 'StudentWallets/UpdateWalletConfig';
  static const String walletDetails = 'StudentWallets/WalletDetails';
  static const String walletActivation = 'StudentWallets/WalletActivation';

  // Student Wallet Transactions Endpoints
  static const String deposit = 'StudentWalletTransactions/Deposit';
  static const String withdraw = 'StudentWalletTransactions/Withdraw';
  static const String refund = 'StudentWalletTransactions/Refund';
  static const String getTransactionByRefNumber =
      'StudentWalletTransactions/GetTransactionByRefNumber';
  static const String getStudentTransactions =
      'StudentWalletTransactions/GetStudentTransactions';

  // Student Attendances Endpoints
  static const String saveStudentAttendance =
      'StudentAttendances/SaveStudentAttendance';
  static const String getStudentAttendances =
      'StudentAttendances/GetStudentAttendances';

  // Lookups Endpoints
  static const String getLookupsData = 'Lookups/GetLookupsData';

  // Attachments Endpoints
  static const String saveUserPhoto = 'Attachments/SaveUserPhoto';
  static const String saveSchoolLogo = 'Attachments/SaveSchoolLogo';

  // Helper method to build full URL
  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }

  // Authorization header
  static Map<String, String> authHeader(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': contentTypeJson,
      'Accept': acceptJson,
    };
  }

  // Default headers without auth
  static Map<String, String> get defaultHeaders => {
    'Content-Type': contentTypeJson,
    'Accept': acceptJson,
  };

  // Cleaner endpoint accessors for repository pattern
  static String get loginEndpoint => login;

  static String get resetPasswordEndpoint => resetPassword;

  static String get changePasswordEndpoint => changePassword;

  static String get logoutEndpoint => logout;

  static String get studentsEndpoint => getAllStudents;

  static String get studentWalletsEndpoint => walletDetails;

  static String get studentWalletTransactionsEndpoint => getStudentTransactions;
}
