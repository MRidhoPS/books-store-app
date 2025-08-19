import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/provider/chart_provider.dart';
import 'package:book_store_app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import '../utils/format.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutPage({super.key, required this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController bayarController = TextEditingController();
  double totalHarga = 0;

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

  Future<void> handleCheckout(BuildContext context) async {
    final bayarText = bayarController.text.replaceAll('.', '');
    final bayar = int.tryParse(bayarText);

    if (bayar == null || bayar < totalHarga) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Uang bayar kurang dari total.")),
      );
      return;
    }

    final bookProvider = Provider.of<ChartProvider>(context, listen: false);
    await bookProvider.checkoutBook(bayar, widget.cartItems);

    if (context.mounted) {
      final result = bookProvider.checkoutResSuccess;
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Struk Belanja',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  Text(result['message'].toString()),
                  const SizedBox(height: 5),
                  Text(
                      'Total Belanja : ${Format().formatNumber(result['total'], 'Rp. ')}'),
                  const SizedBox(height: 5),
                  Text(
                      'Total Bayar : ${Format().formatNumber(result['bayar'], 'Rp. ')}'),
                  const SizedBox(height: 5),
                  Text(
                      'Kembalian : ${Format().formatNumber(result['kembalian'], 'Rp. ')}'),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (route) => false,
                      );
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
    } else if (bookProvider.checkoutResError.isNotEmpty && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bookProvider.checkoutResError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Checkout", style: TextStyle(color: Colors.white)),
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
                Text(
                  Format().formatNumber(totalHarga, 'Rp. '),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bayarController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                CurrencyInputFormatter(
                  thousandSeparator: ThousandSeparator.Period,
                  mantissaLength: 0,
                ),
              ],
              decoration: const InputDecoration(
                labelText: "Uang Bayar",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Consumer<ChartProvider>(
              builder: (context, provider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: const Color.fromARGB(255, 10, 25, 51),
                    ),
                    onPressed: provider.isLoading
                        ? null
                        : () => handleCheckout(context),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Checkout",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
