class TransactionItem {
  final int id;
  final int transactionId;
  final int bookId;
  final int quantity;
  final double price;
  final double subtotal;

  TransactionItem({
    required this.id,
    required this.transactionId,
    required this.bookId,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'],
      transactionId: json['transaction_id'],
      bookId: json['book_id'],
      quantity: json['quantity'],
      price: double.parse(json['price']),
      subtotal: double.parse(json['subtotal']),
    );
  }
}
