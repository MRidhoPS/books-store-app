import 'package:book_store_app/components/cart_book.dart';
import 'package:book_store_app/components/list_book.dart';
import 'package:book_store_app/view/add_book_page.dart';
import 'package:book_store_app/view/history_transaction.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 321;
    // print(MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              title: const Text('Add Book'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddBookPage(),
                    ));
              },
            ),
            ListTile(
              title: const Text('History Transaction'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryTransaction(),
                    ));
              },
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: ListBookWidget(),
          ),
          Expanded(
            flex: 1,
            child: ChartBookWidget(),
          )
        ],
      ),
    );
  }
}

const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
final actionColor = const Color.fromARGB(159, 95, 95, 167);
