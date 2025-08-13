import 'package:book_store_app/components/list_book.dart';
import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/model/transaction_items.dart';
import 'package:book_store_app/repository/auth_repo.dart';
import 'package:book_store_app/repository/book_repo.dart';
import 'package:book_store_app/utils/format.dart';
import 'package:book_store_app/view/add_book_page.dart';
import 'package:book_store_app/view/checkout_page.dart';
import 'package:book_store_app/view/login_page.dart';
import 'package:book_store_app/view/update_book_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CartItem> listCart = [];

  late Future<BookModel> _bookFuture;

  @override
  void initState() {
    super.initState();
    _bookFuture = BookRepo().getListBook(); 
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 321;
    print(MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cashier",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: isSmallScreen ? true : false,
        backgroundColor: canvasColor,
      ),
      drawerScrimColor: Colors.white54,
      drawer: Drawer(
        width: isSmallScreen ? 200 : 500,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: canvasColor),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Add Book'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddBookPage(),
                    ));
              },
            ),
          ],
        ),
      ),
      body: ListBookWidget(bookFuture: _bookFuture),
    );

    // return Scaffold(
    //   key: _scaffoldKey,
    //   appBar: isSmallScreen
    //       ? AppBar(
    //           backgroundColor: canvasColor,
    //           title: const Text(
    //             'Cashier-Ku',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //           leading: IconButton(
    //             icon: const Icon(Icons.menu),
    //             onPressed: () => _scaffoldKey.currentState?.openDrawer(),
    //           ),
    //           actions: [
    //             IconButton(
    //               onPressed: () {
    //                 AuthRepo().logoutUser();
    //                 ScaffoldMessenger.of(context).showSnackBar(
    //                     const SnackBar(content: Text("Berhasil Logout")));
    //                 Navigator.of(context).pushReplacement(MaterialPageRoute(
    //                   builder: (context) => const LoginPage(),
    //                 ));
    //               },
    //               icon: const Icon(Icons.logout_rounded),
    //             ),
    //           ],
    //         )
    //       : null,
    //   drawer: isSmallScreen ? _buildSidebarX() : null,
    //   body: Row(
    //     children: [
    //       if (!isSmallScreen) _buildSidebarX(),
    //       Expanded(
    //         flex: 3,
    //         child: IndexedStack(
    //           index: selectedIndex,
    //           children: [
    //             _buildContent(),
    //             _buildListofProducts(),
    //             const AddBookPage(),
    //             _buildListOfTransactionItems(),
    //           ],
    //         ),
    //       ),
    //       selectedIndex == 0
    //           ? Expanded(
    //               flex: 1,
    //               child: Container(
    //                 padding: const EdgeInsets.symmetric(
    //                     vertical: 20, horizontal: 20),
    //                 decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   boxShadow: [
    //                     BoxShadow(
    //                       color: const Color.fromARGB(255, 236, 236, 236),
    //                       offset: const Offset(-5, 6),
    //                       blurRadius: 4,
    //                       blurStyle: BlurStyle.solid,
    //                     )
    //                   ],
    //                   borderRadius: const BorderRadius.only(
    //                     topLeft: Radius.circular(20),
    //                     bottomLeft: Radius.circular(20),
    //                   ),
    //                 ),
    //                 child: Builder(builder: (context) {
    //                   return Expanded(
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           "Order details",
    //                           style: GoogleFonts.playfair(
    //                             color: Colors.black,
    //                             fontSize: 26,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                         Divider(
    //                           thickness: 2,
    //                         ),
    //                         SizedBox(
    //                           height: 480,
    //                           child: listCart.isEmpty
    //                               ? Center(
    //                                   child: Text(
    //                                   "Keranjang kosong",
    //                                   style: GoogleFonts.playfair(),
    //                                 ))
    //                               : Padding(
    //                                   padding: const EdgeInsets.symmetric(
    //                                       vertical: 20),
    //                                   child: Column(
    //                                     children: [
    //                                       Expanded(
    //                                         child: ListView.builder(
    //                                           itemCount: listCart.length,
    //                                           itemBuilder: (context, index) {
    //                                             final item = listCart[index];
    //                                             return ListTile(
    //                                               title: Text(
    //                                                 item.book.title,
    //                                                 style: GoogleFonts.playfair(
    //                                                     fontWeight:
    //                                                         FontWeight.bold,
    //                                                     fontSize: 14),
    //                                               ),
    //                                               subtitle: Text(
    //                                                 style: GoogleFonts.inter(
    //                                                     fontSize: 10),
    //                                                 "${Format().formatNumber(item.book.price, 'Rp. ')} × ${item.quantity}",
    //                                               ),
    //                                               trailing: Row(
    //                                                 mainAxisSize:
    //                                                     MainAxisSize.min,
    //                                                 children: [
    //                                                   IconButton(
    //                                                     icon: const Icon(
    //                                                         Icons.remove),
    //                                                     onPressed: () {
    //                                                       setState(() {
    //                                                         if (item.quantity >
    //                                                             1) {
    //                                                           item.quantity -=
    //                                                               1;
    //                                                         } else {
    //                                                           listCart.removeAt(
    //                                                               index);
    //                                                         }
    //                                                       });
    //                                                     },
    //                                                   ),
    //                                                   Text('${item.quantity}'),
    //                                                   IconButton(
    //                                                     icon: const Icon(
    //                                                       Icons.add,
    //                                                       color: Colors.black,
    //                                                     ),
    //                                                     onPressed: () {
    //                                                       setState(() {
    //                                                         item.quantity += 1;
    //                                                       });
    //                                                     },
    //                                                   ),
    //                                                 ],
    //                                               ),
    //                                             );
    //                                           },
    //                                         ),
    //                                       ),
    //                                       SizedBox(
    //                                         width: double.infinity,
    //                                         child: ElevatedButton(
    //                                           style: ElevatedButton.styleFrom(
    //                                             padding: EdgeInsets.all(20),
    //                                             backgroundColor:
    //                                                 const Color.fromARGB(
    //                                                     255, 10, 25, 51),
    //                                           ),
    //                                           onPressed: () {
    //                                             Navigator.of(context)
    //                                                 .push(MaterialPageRoute(
    //                                               builder: (_) => CheckoutPage(
    //                                                 userId: 1,
    //                                                 cartItems: listCart,
    //                                               ),
    //                                             ));
    //                                           },
    //                                           child: const Text(
    //                                             "Continue",
    //                                             style: TextStyle(
    //                                                 color: Colors.white),
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                         ),
    //                       ],
    //                     ),
    //                   );
    //                 }),
    //               ),
    //             )
    //           : SizedBox(),
    //     ],
    //   ),
    // );
  }

  Widget _buildContent() {
    return FutureBuilder<BookModel>(
      future: _bookFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final books = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Cashier-Ku",
                  style: GoogleFonts.playfair(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 40,
                            childAspectRatio: 3 / 5),
                    itemCount: books.books.length,
                    itemBuilder: (BuildContext context, int index) {
                      final book = books.books[index];
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 10,
                                  color: Colors.black26)
                            ]),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.all(20),
                                    width: double.infinity,
                                    height: 250,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            book.image,
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: const Color.fromARGB(255, 10, 25, 51),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: GoogleFonts.playfair(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      Format().formatNumber(book.price, 'Rp. '),
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            final i = listCart.indexWhere(
                                                (item) =>
                                                    item.book.id == book.id);
                                            if (i != -1) {
                                              listCart[i].quantity += 1;
                                            } else {
                                              listCart
                                                  .add(CartItem(book: book));
                                            }
                                          });
                                        },
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                              255,
                                              10,
                                              25,
                                              51,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Tidak ada data');
        }
      },
    );
  }

  Widget _buildListOfTransactionItems() {
    return FutureBuilder<List<TransactionItem>>(
      future: BookRepo().getTransactionItems(), // Ganti dengan metode kamu
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final items = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "List of Transaction Items",
                  style: GoogleFonts.playfair(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text("Transaction ID: ${item.transactionId}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Book ID: ${item.bookId}"),
                              Text("Quantity: ${item.quantity}"),
                              Text(
                                  "Price: Rp. ${item.price.toStringAsFixed(0)}"),
                              Text(
                                  "Subtotal: Rp. ${item.subtotal.toStringAsFixed(0)}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Tidak ada data transaksi');
        }
      },
    );
  }

  Widget _buildListofProducts() {
    return FutureBuilder<BookModel>(
      future: BookRepo().getListBook(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final books = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "List of Products",
                  style: GoogleFonts.playfair(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: books.books.length,
                    itemBuilder: (context, index) {
                      final book = books.books[index];
                      return ListTile(
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UpdateBookPage(data: book),
                            ));
                          },
                        ),
                        leading: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final res = await BookRepo().deleteBook(book.id);
                            if (res != null && context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(res)));
                              setState(() {});
                            }
                          },
                        ),
                        title: Text(book.title),
                        subtitle:
                            Text(Format().formatNumber(book.price, 'Rp. ')),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Tidak ada data');
        }
      },
    );
  }
}



const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);
