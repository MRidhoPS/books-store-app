import 'dart:io';
import 'dart:typed_data';

import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/repository/url_address.dart';
import 'package:dio/dio.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;

class BookRepo {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  // Future<Map<String, dynamic>?> addNewBook(
  //   String title,
  //   String price,
  //   File imageFile,
  // ) async {
  //   final token = window.localStorage['token'];

  //   String fileName = imageFile.path.split('/').last;

  //   try {
  //     FormData formData = FormData.fromMap({
  //       'title': title,
  //       'price': price,
  //       'gambar': await MultipartFile.fromFile(
  //         imageFile.path,
  //         filename: fileName,
  //       ),
  //     });

  //     Response response = await _dio.post(
  //       addBookUrl,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //            'Content-Type': 'multipart/form-data',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else {
  //       return {'message': response.data['message']};
  //     }
  //   } on DioException catch (e) {
  //     print(e.message);
  //     final errorMessage =
  //         e.response?.data['message'] ?? 'Terjadi kesalahan saat add book';
  //     return {'message': errorMessage};
  //   } catch (e) {
  //     print(e.toString());
  //     return {'message': 'Add book gagal: ${e.toString()}'};
  //   }
  // }

Future<Map<String, dynamic>?> addNewBook(
    String title,
    String price,
    Uint8List imageBytes,
    String fileName,
  ) async {
    final token = window.localStorage['token'];

    try {
      final formData = FormData.fromMap({
        'title': title,
        'price': price,
        'gambar': MultipartFile.fromBytes(
          imageBytes,
          filename: fileName,
          // contentType: MediaType('image', 'jpeg'), // ganti jika bukan jpeg
        ),
      });

      final response = await _dio.post(
        addBookUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {'message': response.data['message']};
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat add book';
      return {'message': errorMessage};
    } catch (e) {
      return {'message': 'Add book gagal: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>?> updateBook(
      int id, String title, String price) async {
    final token = window.localStorage['token'];

    try {
      Response response = await _dio.put(
        '$updateBookUrl/$id',
        data: {
          'title': title,
          'price': price,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      print(e.message);
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat update book';
      throw errorMessage;
    } catch (e) {
      print(e);
      throw Exception('Update book gagal: ${e.toString()}');
    }
  }

  Future<String?> deleteBook(int id) async {
    try {
      final token = window.localStorage['token'];

      Response response = await _dio.delete('$deleteBookUrl/$id',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        return response.data['message'];
      }
    } on DioException catch (e) {
      print(e.message);
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat Delete book';
      throw errorMessage;
    } catch (e) {
      print(e);
      throw Exception('Delete book gagal: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> checkoutCart({
    required dynamic bayar,
    required List<CartItem> cartItems,
  }) async {
    try {
      final token = window.localStorage['token'];
      final id = window.localStorage['id'];

      final response = await _dio.post(
        buyBookUrl,
        data: {
          "user_id": id,
          "bayar": bayar,
          "items": cartItems.map((e) => e.toJson()).toList(),
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      print(e.message);
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat checkout book';
      throw errorMessage;
    } catch (e) {
      print(e);
      throw Exception('Chekout book gagal: ${e.toString()}');
    }
  }
}
