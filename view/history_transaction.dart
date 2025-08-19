import 'package:book_store_app/provider/transaction_provider.dart';
import 'package:book_store_app/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryTransaction extends StatelessWidget {
  const HistoryTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction History", style: TextStyle(color: Colors.white),),),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Consumer<TransactionProvider>(
          builder: (context, historyTransaction, child) {
            if (historyTransaction.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final book = historyTransaction.transactionItem;

            if (book == null || book.isEmpty) {
              return const Center(child: Text("Belum ada transaksi"));
            }

            return ListView.builder(
              itemCount: book.length,
              itemBuilder: (context, index) {
                final transaction = book[index];
                return ListTile(
                  title: Text(
                    "Book Id: ${transaction.bookId.toString()}",
                  ),
                  subtitle: Text(
                    "${Format().formatNumber(transaction.price.toString(), 'Rp')} x ${transaction.quantity}",
                  ),
                  trailing: Text(
                    Format()
                        .formatNumber(transaction.subtotal.toString(), 'Rp'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
