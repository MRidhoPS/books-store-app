import 'package:book_store_app/model/transaction_items.dart';
import 'package:book_store_app/repository/book_repo.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {

  final BookRepo bookRepo;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TransactionItem>? _transactionItem;
  List<TransactionItem>? get transactionItem => _transactionItem;

  TransactionProvider({required this.bookRepo}){
    historyBook();
  }

  Future<void> historyBook() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await bookRepo.getTransactionItems();

      _transactionItem = res;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
 }