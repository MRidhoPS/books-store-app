import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/repository/book_repo.dart';
import 'package:book_store_app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../utils/format.dart';

class CheckoutPage extends StatefulWidget {
  final int userId;
  final List<CartItem> cartItems;

  const CheckoutPage(
      {super.key, required this.userId, required this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController bayarController = TextEditingController();
  double totalHarga = 0;
  String? message;

  @override
  void initState() {
    super.initState();
    hitungTotalHarga();
  }

  void hitungTotalHarga() {
    totalHarga = widget.cartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.book.price) ?? 0.0;
      return sum + (price * item.quantity);
    });
  }

  Future<void> handleCheckout() async {
    final bayarText = bayarController.text.replaceAll('.', ''); // Hapus titik
    final bayar = int.tryParse(bayarText);
    if (bayar == null || bayar < totalHarga) {
      setState(() {
        message = "Uang bayar kurang dari total.";
      });
      return;
    }

    final result = await BookRepo().checkoutCart(
      bayar: bayar,
      cartItems: widget.cartItems,
    );

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Struk Belanja',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Text(result!['message'].toString()),
                  const SizedBox(height: 5),
                  Text(
                      'Total Belanja : ${Format().formatNumber(result['total'], 'Rp. ')}'),
                  const SizedBox(height: 5),
                  Text(
                      'Total Bayar : ${Format().formatNumber(result['bayar'], 'Rp. ')}'),
                  const SizedBox(height: 5),
                  Text(
                      'Kembalian : ${Format().formatNumber(result['kembalian'], 'Rp. ')}'),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false);
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Color.fromARGB(255, 10, 25, 51)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Checkout",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 10, 25, 51),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  final price = double.tryParse(item.book.price) ?? 0.0;
                  return ListTile(
                    title: Text(item.book.title),
                    subtitle: Text("Qty: ${item.quantity}"),
                    trailing: Text(
                      Format().formatNumber(price * item.quantity, 'Rp. '),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Total: ",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(Format().formatNumber(totalHarga.toString(), 'Rp. '),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bayarController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                CurrencyInputFormatter(
                  thousandSeparator: ThousandSeparator.Period,
                  mantissaLength: 0, // supaya tanpa koma
                ),
              ],
              decoration: const InputDecoration(
                labelText: "Uang Bayar",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: const Color.fromARGB(255, 10, 25, 51),
                ),
                onPressed: handleCheckout,
                child: const Text(
                  "Checkout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (message != null)
              Text(message!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
