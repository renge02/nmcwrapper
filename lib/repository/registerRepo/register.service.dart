import 'package:dio/dio.dart';

import 'package:nmc_wrapper/data/remote/network/api.end.points.dart';
import 'package:nmc_wrapper/data/remote/network/dio.client.dart';

class RegisterService {
  final dioClient = DioClient();

  Future<Response> sendOtp(String mobileNo) async {
    return await dioClient.post(
      '${ApiEndPoints.sendOtpEndPoint}?_=${DateTime.now().millisecondsSinceEpoch}',
      queryParams: {
        '_': DateTime.now().millisecondsSinceEpoch.toString(),
      },
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      data: {
        "otp": {
          "mobileNumber": mobileNo,
          "userType": "citizen",
          "type": "passwordreset",
          "tenantId": "pg",
        },
        "RequestInfo": {
          "apiId": "Rainmaker",
          "msgId": "${DateTime.now().millisecondsSinceEpoch}|en_IN",
          "plainAccessRequest": {},
        },
      },
      isFormData: false,
    );
  }

  Future<Response> confirmForgetPassword( String username,
        String newPassword,
        String confirmPassword,
        String otpReference) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return await dioClient.post(
      '${ApiEndPoints.confirmForgetPWDEndPoint}?tenantId=pg.cityb&_=$timestamp',
      queryParams: {
        "tenantId":"pg.cityb",
        '_': DateTime.now().millisecondsSinceEpoch.toString(),
      },
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      data: {
        "username": username,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
        "otpReference": otpReference,
        "tenantId": "pg",
        "type": "CITIZEN",
        "RequestInfo": {
          "apiId": "Rainmaker",
          "authToken": null,
          "msgId": "$timestamp|en_IN",
          "plainAccessRequest": {},

        },
      },
      isFormData: false,
    );
  }


  Future<Response> sendOtpRegistration(String mobileNo) async {
    return await dioClient.post(
      ApiEndPoints.sendOTPRegistrationEndPoint,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      data: {"mobile": mobileNo, "tenant": "nmc"},
    );
  }

  Future<Response> checkRegistrationMobile(String mobileNo) async {
    return await dioClient.post(
      ApiEndPoints.checkRegistrationEndPoint,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      data: {"mobile": mobileNo},
    );
  }

  Future<Response> checkRegistrationEmail(String email) async {
    return await dioClient.post(
      ApiEndPoints.checkRegistrationEndPoint,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      data: {"email": email},
    );
  }

  Future<Response> validateOtp(String mobile, String otp) async {
    final dioClient = DioClient();

    return await dioClient.post(
      ApiEndPoints.validateOtpEndPoint,
      queryParams: {
        "tenantId": "pg",
        "_": DateTime.now().millisecondsSinceEpoch,
      },
      data: {
        "mobileNumber": mobile,
        "otpReference": otp,
        "tenantId": "pg",
        "type": "register",
        "RequestInfo": {
          "apiId": "Rainmaker",
          "msgId": "${DateTime.now().millisecondsSinceEpoch}|en_IN",
          "plainAccessRequest": {},
        }
      },
      isFormData: false,
    );
  }

  Future<Response> validateOtpRegistration(String mobile, String otp) async {
    final dioClient = DioClient();

    return await dioClient.post(
      ApiEndPoints.verifyOTPRegistrationEndPoint  ,
      data: {
        "mobile": mobile,
        "otp": otp,
        "tenant": "nmc",
      },
      isFormData: false,
    );
  }

  Future<Response> createUser(
      Map<String, dynamic> requestBody) async {
    return dioClient.post(ApiEndPoints.registrationUserEndPoint,

        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        data: requestBody,
        isFormData: false);
  }
}
