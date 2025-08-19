import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/repository/book_repo.dart';
import 'package:flutter/material.dart';

class ChartProvider extends ChangeNotifier {
  final bookRepo = BookRepo();

  List<CartItem> _chartItems = [];
  List<CartItem> get chartItems => _chartItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _checkoutResSuccess = {};
  Map<String, dynamic> get checkoutResSuccess => _checkoutResSuccess;

  String _checkoutResError = '';
  String get checkoutResError => _checkoutResError;

  void addItem(BookItem book) {
    // Cari item di cart yang punya ID sama
    final index = _chartItems.indexWhere((item) => item.book.id == book.id);

    if (index >= 0) {
      // Kalau sudah ada → tambah quantity
      _chartItems[index].quantity += 1;
    } else {
      // Kalau belum ada → tambahkan sebagai item baru
      _chartItems.add(CartItem(book: book));
    }

    notifyListeners();
    print(_chartItems.map((e) => '${e.book.title} x${e.quantity}').toList());
  }

  void removeItem(BookItem book) {
    _chartItems.removeWhere((item) => item.book.id == book.id);
    notifyListeners();
  }

  void decreaseQuantity(BookItem book) {
    final index = _chartItems.indexWhere((item) => item.book.id == book.id);
    if (index >= 0) {
      if (_chartItems[index].quantity > 1) {
        _chartItems[index].quantity -= 1;
      } else {
        _chartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  Future<void> checkoutBook(dynamic bayar, List<CartItem> cartItems) async {
    _isLoading = true;
    _checkoutResError = '';
    _checkoutResSuccess = {};
    notifyListeners();

    try {
      final res =
          await bookRepo.checkoutCart(bayar: bayar, cartItems: cartItems);

       if (res != null && res.isNotEmpty) {
        _checkoutResSuccess = res;
      } else {
        _checkoutResError = 'Checkout gagal: response kosong';
      }
    } catch (e) {
      _checkoutResError = 'Error in provider: $e';
    } finally {
      _isLoading = false;
      _chartItems = [];
      notifyListeners();
    }
  }
}
