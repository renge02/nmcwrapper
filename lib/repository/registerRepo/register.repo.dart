import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
 import 'package:nmc_wrapper/repository/registerRepo/register.service.dart';
import 'package:nmc_wrapper/utils/logger.dart';

class RegisterProvider extends ChangeNotifier {
  final RegisterService _service = RegisterService();

  bool isLoading = false;
  String? error;
  dynamic data;




  Future<bool> sendOtp(String mobile,String userType) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.sendOtp(mobile,userType);

      data = response.data;

      return response.data["isSuccessful"] == true;
    }
    catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> confirmForgetPassword({
    required String username,
    required String newPassword,
    required String confirmPassword,
    required String otpReference,
    required String userType,
  }) async
  {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.confirmForgetPassword(
         username,
          newPassword,
        confirmPassword,
         otpReference,
          userType
      );

      data = response.data;

      return response.statusCode == 200;
    } on DioException catch (e) {

      logger("Status Code : ${e.response?.statusCode}");
      logger("Error Response confirmForgetPassword: ${e.response?.data}");

      if (e.response != null) {
        error =
            e.response?.data['error']['message'] ??
            'Something went wrong';
      } else {
        error = e.message;
      }
      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
Future<bool> sendOtpRegistration(String mobile) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.sendOtpRegistration(mobile);

      data = response.data;
      print("registration     $data");
      return true;
    } catch (e) {
      print("registration catch    $e");
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkRegistrationMobile(String mobile) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final response = await _service.checkRegistrationMobile(mobile);

      data = response.data;
      return response.data["mobile"]["status"] == "AVAILABLE";

    } catch (e) {
      error = e.toString();
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> checkRegistrationEmail(String email) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final response = await _service.checkRegistrationEmail(email);

      data = response.data;
      return response.data["email"]["status"] == "AVAILABLE";

    } catch (e) {
      error = e.toString();
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkUserNameRegistration(String userName) async {
    try {
      isLoading = true;
      error = null;
      data = null;
      notifyListeners();

      final response =
      await _service.checkUsernameRegistration(userName);

      debugPrint('Provider response: ${response.data}');
      debugPrint('Provider type: ${response.data.runtimeType}');

      data = response.data;

      final responseData =
      Map<String, dynamic>.from(response.data);

      final bool valid = responseData['valid'] == true;

      final String? message =
      responseData['message']?.toString();

      debugPrint('Username valid: $valid');
      debugPrint('Username message: $message');

      if (valid) {
        error = null;
        return true;
      }

      error = message ?? 'Username is not available';
      return false;

    } on DioException catch (e) {
      error = e.response?.data is Map
          ? e.response?.data['message']?.toString() ??
          'Something went wrong'
          : e.message ?? 'Something went wrong';

      debugPrint('Username API exception: $error');

      return false;
    } catch (e, stackTrace) {
      error = e.toString();

      debugPrint('Username unexpected error: $e');
      debugPrint('$stackTrace');

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> verifyOtp(String mobile, String otp) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.validateOtp(mobile, otp);

      data = response.data;
      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtpRegistration(String mobile, String otp) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.validateOtpRegistration(mobile, otp);

      data = response.data;
      if (response.statusCode == 200||response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser(Map<String, dynamic> requestBody) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response =
      await _service.createUser(requestBody);

      data = response.data;

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }}
