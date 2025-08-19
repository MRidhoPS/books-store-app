import 'dart:typed_data';

import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/model/transaction_items.dart';
import 'package:book_store_app/repository/book_repo.dart';
import 'package:flutter/material.dart';

class BookProvider extends ChangeNotifier {
  
  // final bookRepo = BookRepo();
  final BookRepo bookRepo;
  BookProvider({required this.bookRepo}){
    listBook();
  }


  BookModel? _bookModel;
  BookModel? get bookModel => _bookModel;

  String _bookModelError = '';
  String get bookModelError => _bookModelError;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TransactionItem>? _transactionItem;
  List<TransactionItem>? get transactionItem => _transactionItem;


  Future<void> listBook() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await bookRepo.getListBook();

      if (res.books.isNotEmpty) {
        _bookModel = res;
      } else {
        _bookModelError = 'Error in provider else';
      }
    } catch (e) {
      _bookModelError = 'Error in provider: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBook(
    String title,
    String price,
    Uint8List imageBytes,
    String fileName,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await bookRepo.addNewBook(
        title,
        price,
        imageBytes,
        fileName,
      );
      await listBook();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  

  Future<void> updateBook(int id, String title, String price) async{
    _isLoading = true;
    notifyListeners();

    try {
      await bookRepo.updateBook(id, title, price);
      await listBook();
    } catch (e) {
      print(e);
    } finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBook(int id) async{
    _isLoading = true;
    notifyListeners();

    try {
      await bookRepo.deleteBook(id);
      await listBook();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
