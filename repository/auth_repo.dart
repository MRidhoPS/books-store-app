import 'package:book_store_app/repository/url_address.dart';
import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;

import 'package:jwt_decoder/jwt_decoder.dart';

class AuthRepo {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  void setupDio() {
    (_dio.httpClientAdapter as BrowserHttpClientAdapter).withCredentials = true;
  }


  Future<String?> registerUsers(String username, String password) async {
    try {
      final response = await _dio.post(
        registerUrl,
        data: {
          'username': username,
          'password': password,
        },
      );

      print(response.data['message']);

      if (response.statusCode == 201) {
        return response.data['message'];
      }
      return response.data['message'];
    } on DioException catch (e) {
      print(e.message);
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat register';
      throw errorMessage;
    } catch (e) {
      throw Exception('Registrasi gagal: ${e.toString()}');
    }
  }

  Future<String?> loginUsers(String username, String password) async {
    try {
      final response = await _dio.post(loginUrl,
          data: {
            'username': username,
            'password': password,
          },
          options: Options(extra: {'withCredentials': true}));

      if (response.statusCode == 200) {
        window.localStorage['token'] = response.data['token'];

        Map<String, dynamic> decodedToken = JwtDecoder.decode(response.data['token']);
        window.localStorage['id'] = decodedToken['userId'].toString();

        return response.data['token'];
      } else {
        return response.data['message'];
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat login';
      throw errorMessage;
    } catch (e) {
      throw Exception('Login gagal: ${e.toString()}');
    }
  }

  Future<bool> checkUser() async {
    final token = window.localStorage['token'];

    if (token != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logoutUser() async {
    window.localStorage.remove('token');
  }

  
}
