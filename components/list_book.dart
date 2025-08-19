import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/provider/book_provider.dart';
import 'package:book_store_app/provider/chart_provider.dart';
import 'package:book_store_app/utils/format.dart';
import 'package:book_store_app/utils/size.dart';
import 'package:book_store_app/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListBookWidget extends StatelessWidget {
  const ListBookWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.bookModelError.isNotEmpty) {
          return Center(child: Text(provider.bookModelError));
        }

        final books = provider.bookModel?.books ?? [];

        if (books.isEmpty) {
          return const Center(child: Text("Tidak ada buku"));
        }

        return context.isMediumScreen
            ? listBookCard(books)
            : gridBookCard(books, context);
      },
    );
  }

  ListView listBookCard(List<BookItem> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(bottom: 10),
          width: context.autoWidth,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Image.network(
                    book.image,
                    scale: 0.5,
                    width: context.screenWidth,
                    height: context.autoHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(book.title),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(Format().formatNumber(book.price, 'rp')),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: context.screenWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canvasColor,
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  GridView gridBookCard(List<BookItem> books, BuildContext context) {
    return GridView.builder(
      itemCount: books.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 1,
        crossAxisCount: 3,
        childAspectRatio: context.dynamicAspectRatio(
          itemWidthFraction: 1 / 3,
          itemHeightFraction: 0.78,
        ),
      ),
      itemBuilder: (context, index) {
        final book = books[index];

        return Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(bottom: 5),
          width: context.autoWidth,
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Image.network(
                    book.image,
                    scale: 0.8,
                    width: context.screenWidth,
                    height: context.isLargeScreen ? 200 : 138,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    book.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(Format().formatNumber(book.price, 'rp')),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: context.screenWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canvasColor,
                      ),
                      onPressed: () {
                        context.read<ChartProvider>().addItem(book);
                      },
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
