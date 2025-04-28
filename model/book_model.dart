class BookModel {
  final List<BookItem> books;

  BookModel({required this.books});

  factory BookModel.fromJson(List<dynamic> jsonList) {
    List<BookItem> books =
        jsonList.map((item) => BookItem.fromJson(item)).toList();
    return BookModel(books: books);
  }
}

class BookItem {
  final int id;
  final String title;
  final String price;
  final String image;

  BookItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.image});

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      image: json['gambar_url'],
    );
  }
}

class CartItem {
  final BookItem book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});

  Map<String, dynamic> toJson() => {
        "id": book.id,
        "price": book.price,
        "quantity": quantity,
      };
}
