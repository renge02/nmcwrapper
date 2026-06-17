import 'package:flutter/material.dart';
 import 'package:nmc_wrapper/repository/registerRepo/register.service.dart';

class RegisterProvider extends ChangeNotifier {
  final RegisterService _service = RegisterService();

  bool isLoading = false;
  String? error;
  dynamic data;




  Future<bool> sendOtp(String mobile) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.sendOtp(mobile);

      data = response.data;

      return response.data["isSuccessful"] == true;
    } catch (e) {
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
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.confirmForgetPassword(
         username,
          newPassword,
        confirmPassword,
         otpReference,
      );

      data = response.data;

      return response.statusCode == 200;
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
      return true;
    } catch (e) {
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
