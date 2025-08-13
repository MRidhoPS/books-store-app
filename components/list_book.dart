import 'package:book_store_app/model/book_model.dart';
import 'package:book_store_app/utils/format.dart';
import 'package:book_store_app/utils/size.dart';
import 'package:book_store_app/view/home_page.dart';
import 'package:flutter/material.dart';

class ListBookWidget extends StatelessWidget {
  const ListBookWidget({
    super.key,
    required Future<BookModel> bookFuture,
  }) : _bookFuture = bookFuture;

  final Future<BookModel> _bookFuture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: FutureBuilder(
        future: _bookFuture,
        builder: (context, snapshot) {
          return context.isMediumScreen
              ? listBookCard(snapshot)
              : gridBookCard(snapshot, context);
        },
      ),
    );
  }

  GridView gridBookCard(
      AsyncSnapshot<BookModel> snapshot, BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 1,
        crossAxisCount: 3,
        childAspectRatio: context.dynamicAspectRatio(
          itemWidthFraction: 1 / 3, 
          itemHeightFraction: 0.55, 
        ),
      ),
      itemCount: snapshot.data!.books.length,
      itemBuilder: (BuildContext context, int index) {
        final data = snapshot.data!.books[index];

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
                    data.image,
                    scale: 0.8,
                    width: context.screenWidth,
                    height: context.autoHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(data.title),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(Format().formatNumber(data.price, 'rp')),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: context.screenWidth,
                    // height: context.screenHeight * 0.06,
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

  ListView listBookCard(AsyncSnapshot<BookModel> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.books.length,
      itemBuilder: (BuildContext context, int index) {
        final data = snapshot.data!.books[index];

        return ListCardWidget(data: data);
      },
    );
  }
}

class ListCardWidget extends StatelessWidget {
  const ListCardWidget({
    super.key,
    required this.data,
  });

  final BookItem data;

  @override
  Widget build(BuildContext context) {
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
                data.image,
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
              child: Text(data.title),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(Format().formatNumber(data.price, 'rp')),
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
  }
}
