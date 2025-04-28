import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/repository/book_repo.dart';
import 'package:book_store_app/utils/format.dart';
import 'package:book_store_app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateBookPage extends StatefulWidget {
  const UpdateBookPage({super.key, required this.data});

  final BookItem data;

  @override
  State<UpdateBookPage> createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  late TextEditingController titleController = TextEditingController(
    text: widget.data.title,
  );
  late TextEditingController priceController = TextEditingController(
    text: Format().formatNumber(widget.data.price, ''),
  );
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Update Book"),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(20.0),
    //     child: Column(
    //       children: [
    //         TextFormField(
    //           controller: titleController,
    //           decoration: InputDecoration(
    //             hintText: 'Title',
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 20,
    //         ),
    //         TextFormField(
    //           controller: priceController,
    //           inputFormatters: [
    //              CurrencyInputFormatter(
    //               thousandSeparator: ThousandSeparator.Period,
    //               mantissaLength: 0, // supaya tanpa koma
    //             ),
    //           ],
    //           decoration: InputDecoration(
    //             hintText: 'Price',
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 20,
    //         ),
    //         ElevatedButton(
    //           onPressed: () async {
    //             try {
    //               final data = await BookRepo().updateBook(
    //                 widget.data.id,
    //                 titleController.text,
    //                 priceController.text,
    //               );

    //               if (data != null) {
    //                 if (context.mounted) {
    //                   ScaffoldMessenger.of(context).showSnackBar(
    //                     SnackBar(
    //                       content: Text(
    //                         data['message'],
    //                       ),
    //                     ),
    //                   );

    //                   Navigator.of(context).pushAndRemoveUntil(
    //                       MaterialPageRoute(
    //                         builder: (context) => HomePage(),
    //                       ),
    //                       (route) => false);
    //                 }
    //               }
    //             } catch (e) {
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 SnackBar(content: Text(e.toString())),
    //               );
    //             }
    //           },
    //           child: Text('Update Book'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Update Book",
              style: GoogleFonts.playfair(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: priceController,
              inputFormatters: [
                CurrencyInputFormatter(
                  thousandSeparator: ThousandSeparator.Period,
                  mantissaLength: 0, // supaya tanpa koma
                ),
              ],
              decoration: InputDecoration(
                hintText: 'Price',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  backgroundColor: const Color.fromARGB(255, 10, 25, 51),
                ),
                onPressed: () async {
                  try {
                    final data = await BookRepo().updateBook(
                      widget.data.id,
                      titleController.text,
                      priceController.text,
                    );

                    if (data != null) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              data['message'],
                            ),
                          ),
                        );

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false);
                      }
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: const Text(
                  "Update Buku",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
