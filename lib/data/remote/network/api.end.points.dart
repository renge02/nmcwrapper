class ApiEndPoints {
  // static String baseAPIUrl = "https://dev-upyog.nmc.gov.in"; //dev url
 static String baseAPIUrl = "https://mynashik.nmc.gov.in";   //production url
  //static String baseAPIUrl = "https://staging-upyog.nmc.gov.in";   //staging url

  // auth
  static final String authEndPoint = "/user/oauth/token";
  static final String requestCountEndPoint = "/pgr-services/v2/request/_count";
  static final String sendOtpEndPoint = '/user-otp/v1/_send';
  static final String checkRegistrationEndPoint =
      '/bap/auth/check-registration';
  static final String sendOTPRegistrationEndPoint =
      '/bap/auth/register-otp/send';
  static final String verifyOTPRegistrationEndPoint =
      '/bap/auth/register-otp/verify';
  static final String registrationUserEndPoint = '/bap/auth/register';
  static final String validateOtpEndPoint = '/user/otp/validate';
  static final String confirmForgetPWDEndPoint =
      '/user/password/nologin/_update';
  static final String createUserEndPoint = '/user/users/_createnovalidate';
  static final String mdmsEndPoint = '/egov-mdms-service/v1/_search';
  static final String fetchZonesEndPoint =
      '/egov-location/location/v11/boundarys/_search';
  static final String logoutEndPoint = '/nmc/en/auth/bap/logout';
  static final String grievanceListEndPoint =
      '/pgr-services/v2/request/_search';
  static final String processSearchEndPoint =
      '/egov-workflow-v2/egov-wf/process/_search';
  static final String businessProcessSearchEndPoint =
      '/egov-workflow-v2/egov-wf/businessservice/_search';
  static final String createPGREndPoint = '/pgr-services/v2/request/_create';
  static final String fileStoreEndPoint = '/filestore/v1/files/url';
  static final String fileUploadEndPoint = '/filestore/v1/files';
  static const String mdmsSearchEndPoint =
      "/egov-mdms-service/v1/_search";
  static const String localizationSearchEndPoint =
      "/localization/messages/v1/_search";
}

