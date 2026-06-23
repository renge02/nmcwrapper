import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:nmc_wrapper/repository/loginRepo/login.service.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/logger.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';

class LoginProvider extends ChangeNotifier {
  final LoginService _service = LoginService();

  bool isLoading = false;
  String? error;
  dynamic data;

  Future<void> login(String userName, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.login(userName, password);
      logger("Login Response....: ${response}");

      data = response.data;
      logger("Login Response: ${jsonEncode(data)}");
      // check if data is valid save in local storage
      await getIt<SecureStorage>().saveUserIds(data['UserRequest']['uuid']);
      await getIt<SecureStorage>().saveUserName(data['UserRequest']['name']);
      await getIt<SecureStorage>().saveUserMobileNumber(data['UserRequest']['mobileNumber']);
      await getIt<SecureStorage>().saveToken(data['access_token']);
      await getIt<SecureStorage>().saveRefreshToken(data['refresh_token']);
      if(data['UserRequest']!=null) {
        await getIt<SecureStorage>().saveRole(data['UserRequest']['roles'][0]['name']);
      }

      await getIt<SecureStorage>()
          .saveUserData(jsonEncode(data['UserRequest']));

    }on DioException catch (e) {

      logger("Status Code : ${e.response?.statusCode}");
      logger("Error Response : ${e.response?.data}");

      if (e.response != null) {
        error = e.response?.data['error_description'] ??
            e.response?.data['error'] ??
            'Something went wrong';
      } else {
        error = e.message;
      }

    }  catch (e) {
      error = e.toString();
      logger("Login Error: ${error}");

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      String? accessToken = await getIt<SecureStorage>().getToken();
      final response = await _service.logout(
        accessToken!,
      );

      data = response.data;
      logger("Login Response: ${jsonEncode(data)}");
      // check if data is valid save in local storage
      await getIt<SecureStorage>().delete(data['access_token']);
      await getIt<SecureStorage>().delete(data['refresh_token']);
      await getIt<SecureStorage>().delete(jsonEncode(data['UserRequest']));
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
