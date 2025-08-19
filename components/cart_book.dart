import 'package:book_store_app/provider/chart_provider.dart';
import 'package:book_store_app/utils/format.dart';
import 'package:book_store_app/utils/size.dart';
import 'package:book_store_app/view/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartBookWidget extends StatelessWidget {
  const ChartBookWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<ChartProvider>().chartItems;
    return Container(
      width: 100,
      height: context.screenHeight,
      decoration: BoxDecoration(color: Colors.amber),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: context.screenWidth,
              height: 400,
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  return ListTile(
                    title: Text(cartItem.book.title),
                    subtitle: Text(
                        '${Format().formatNumber(cartItem.book.price, 'Rp')} × ${cartItem.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => context
                              .read<ChartProvider>()
                              .decreaseQuantity(cartItem.book),
                        ),
                        Text('${cartItem.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => context
                              .read<ChartProvider>()
                              .addItem(cartItem.book),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            cartItems.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              cartItems: cartItems,
                            ),
                          ),
                        );
                      },
                      child: Text("Continue"),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
