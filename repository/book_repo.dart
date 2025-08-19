import 'dart:typed_data';

import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/model/transaction_items.dart';
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

  Future<BookModel> getListBook() async {
    final token = window.localStorage['token'];

    try {
      final response = await _dio.get(
        adminBookUrl,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        return BookModel.fromJson(
          response.data['data'],
        );
      }

      return response.data['message'];
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat get data';
      throw errorMessage;
    } catch (e) {
      throw Exception('Get data gagal: ${e.toString()}');
    }
  }

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
        adminBookUrl,
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
        '$adminBookUrl/$id',
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
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat update book';
      throw errorMessage;
    } catch (e) {
      throw Exception('Update book gagal: ${e.toString()}');
    }
  }

  Future<String?> deleteBook(int id) async {
    try {
      final token = window.localStorage['token'];

      Response response = await _dio.delete('$adminBookUrl/$id',
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
        transactionUrl,
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
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat checkout book';
      throw "Throw Error $errorMessage";
    } catch (e) {
      throw Exception('Chekout book gagal: ${e.toString()}');
    }
  }

  Future<List<TransactionItem>> getTransactionItems() async {
    final token = window.localStorage['token'];

    try {
      final response = await _dio.get(
        transactionUrl, // ganti URL sesuai endpoint kamu
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      print("Response transaction items: $response");

      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data['data'];

        return rawData.map((item) => TransactionItem.fromJson(item)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Terjadi kesalahan saat get data';
      throw errorMessage;
    } catch (e) {
      throw Exception('Get transaction items gagal: ${e.toString()}');
    }
  }
}
