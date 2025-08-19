import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/repository/book_repo.dart';
import 'package:flutter/material.dart';

class BookProvider extends ChangeNotifier {

  final bookRepo = BookRepo();

  BookModel? _bookModel;
  BookModel? get bookModel => _bookModel;

  String _bookModelError = '';
  String get bookModelError => _bookModelError;


  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> listBook() async{
    _isLoading = true;
    notifyListeners();

    try {
      final res = await bookRepo.getListBook();

      if (res.books.isNotEmpty){
        _bookModel = res;
      } else {
        _bookModelError = 'Error in provider else';
      }

    } catch (e) {
      _bookModelError = 'Error in provider: $e';
    } finally{
      _isLoading= false;
      notifyListeners();
    }
  }


}
