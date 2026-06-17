import 'package:dio/dio.dart';
import 'package:nmc_wrapper/data/remote/network/api.end.points.dart';
import 'package:nmc_wrapper/data/remote/network/dio.client.dart';

class LoginService {
  final dioClient = DioClient();

  Future<Response> login(String userName, String password) async {
    return await dioClient.post(
      ApiEndPoints.authEndPoint,
      queryParams: {
        "_": DateTime.now().millisecondsSinceEpoch,
      },
      headers: {
        "Authorization": "Basic ZWdvdi11c2VyLWNsaWVudDo=",
      },
      data: {
        "userName": "",
        "password": password,
        "username": userName,
        "userType": "CITIZEN",
        "tenantId": "pg.cityb",
        "scope": "read",
        "grant_type": "password",
      },
      isFormData: true,
    );
  }


  Future<Response> logout(String accessToken) async {
    return await dioClient.post(
      ApiEndPoints.logoutEndPoint,
      queryParams: {
        "_": DateTime.now().millisecondsSinceEpoch,
      },
      headers: {
        "Authorization": "Basic ZWdvdi11c2VyLWNsaWVudDo=",
      },
      data: {
        "accessToken": accessToken,

      },
      isFormData: false,
    );
  }

}
