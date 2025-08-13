// import 'package:book_store_app/repository/book_repo.dart';
// import 'package:book_store_app/view/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
// import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AddBookPage extends StatefulWidget {
//   const AddBookPage({super.key});

//   @override
//   State<AddBookPage> createState() => _AddBookPageState();
// }

// class _AddBookPageState extends State<AddBookPage> {
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Add Book",
//               style: GoogleFonts.playfair(
//                   fontSize: 30,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w800),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextFormField(
//               controller: titleController,
//               decoration: InputDecoration(
//                 hintText: 'Title',
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             TextFormField(
//               controller: priceController,
//               inputFormatters: [
//                  CurrencyInputFormatter(
//                   thousandSeparator: ThousandSeparator.Period,
//                   mantissaLength: 0, // supaya tanpa koma
//                 ),
//               ],
//               decoration: InputDecoration(
//                 hintText: 'Price',

//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.all(20),
//                   backgroundColor: const Color.fromARGB(255, 10, 25, 51),
//                 ),
//                 onPressed: () async {
//                   try {
//                     final data = await BookRepo().addNewBook(
//                       titleController.text,
//                       priceController.text,
//                     );

//                     if (data != null) {
//                       if (context.mounted) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               data['message'],
//                             ),
//                           ),
//                         );

//                         Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(
//                             builder: (context) => HomePage(),
//                           ),
//                           (route) => false,
//                         );
//                       }
//                     }
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(e.toString())),
//                     );
//                   }
//                 },
//                 child: const Text(
//                   "Tambah Buku",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';

import 'package:book_store_app/repository/book_repo.dart';
import 'package:book_store_app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_web/image_picker_web.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Uint8List? imageBytes;
  Image? previewImage;
  String fileName = ''; 

Future<void> _pickImage() async {
    final media = await ImagePickerWeb.getImageInfo();

    if (media?.data != null && media?.fileName != null) {
      setState(() {
        imageBytes = media!.data;
        previewImage = Image.memory(media.data!);
        fileName = media.fileName!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memilih gambar')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add Book",
                style: GoogleFonts.playfair(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: priceController,
                inputFormatters: [
                  CurrencyInputFormatter(
                    thousandSeparator: ThousandSeparator.Period,
                    mantissaLength: 0,
                  ),
                ],
                decoration: const InputDecoration(
                  hintText: 'Price',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                ),
                child: const Text(
                  "Pilih Gambar",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              if (previewImage != null)
                SizedBox(height: 150, child: previewImage!),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color.fromARGB(255, 10, 25, 51),
                  ),
                  onPressed: () async {
                    if (imageBytes == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Harap pilih gambar terlebih dahulu.'),
                        ),
                      );
                      return;
                    }

                    try {
                      final data = await BookRepo().addNewBook(
                        titleController.text,
                        priceController.text,
                        imageBytes!,
                        fileName,
                      );

                      if (data != null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(data['message'])),
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: const Text(
                    "Tambah Buku",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
