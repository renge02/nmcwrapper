class ApiEndPoints {
  //base url staging
  static String baseAPIUrl = "https://dev-upyog.nmc.gov.in";
  //static String baseAPIUrl = "https://staging-upyog.nmc.gov.in";

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


//https://dev-upyog.nmc.gov.in/nmc/en/auth/bap/logout

//https://dev-upyog.nmc.gov.in/bap/auth/register-otp/send
//{mobile: "9637202243", tenant: "nmc"}
//{"success":true,"message":"OTP sent successfully"}


//https://dev-upyog.nmc.gov.in/bap/auth/register-otp/verify
//{mobile: "9637202243", otp: "139957", tenant: "nmc"}
//{
//     "success": true,
//     "message": "OTP verified successfully",
//     "data": {
//         "otpVerificationToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwdXJwb3NlIjoiTk1DX1JFR0lTVEVSX09UUCIsInRlbmFudCI6Im5tYyIsIm1vYmlsZSI6Ijk2MzcyMDIyNDMiLCJvdHAiOiIxMzk5NTciLCJpYXQiOjE3ODA5OTU2MjAsImV4cCI6MTc4MDk5NjIyMH0.CBpvni6JHhiOjlgjcq4uLIEDDjKfg8pFz8PTrz4V0Mo"
//     }
// }


//https://dev-upyog.nmc.gov.in/bap/auth/register
//{"email":"rutujarenge02@gmail.com","password":"Nmc@4321","firstName":"Rutu","lastName":".","mobile":"9637202243","address":"",
// "stakeholderType":"applicant","roleId":2,"tenant":"nmc","username":"rutu_02","gender":"FEMALE",
// "dateOfBirth":"1996-03-02",
// "otpVerificationToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwdXJwb3NlIjoiTk1DX1JFR0lTVEVSX09UUCIsInRlbmFudCI6Im5tYyIsIm1vYmlsZSI6Ijk2MzcyMDIyNDMiLCJvdHAiOiIxMzk5NTciLCJpYXQiOjE3ODA5OTU2MjAsImV4cCI6MTc4MDk5NjIyMH0.CBpvni6JHhiOjlgjcq4uLIEDDjKfg8pFz8PTrz4V0Mo"}


//https://dev-upyog.nmc.gov.in/user-otp/v1/_send?_=1781000916809

//https://dev-upyog.nmc.gov.in/user/password/nologin/_update?tenantId=pg.cityb&_=1781000976550
// {"username":"rutu_02","newPassword":"Nmc@4321","confirmPassword":"Nmc@4321","otpReference":"631630","tenantId":"pg","type":"CITIZEN","RequestInfo":{"apiId":"Rainmaker","authToken":null,"msgId":"1781000978217|en_IN","plainAccessRequest":{}}}