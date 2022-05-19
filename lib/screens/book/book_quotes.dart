import 'package:flutter/material.dart';
import 'package:readerdatabase/models/book.dart';
import 'package:readerdatabase/screens/book/add_qcu.dart';
import '../../db/operations.dart';
import '../../models/quotes.dart';

class BookQuotes extends StatefulWidget {
  const BookQuotes({Key? key}) : super(key: key);

  @override
  State<BookQuotes> createState() => Book_QuotesState();
}

class Book_QuotesState extends State<BookQuotes> {
  List<Quotes> quotes = []; //Used with the ListView.builder
  Book _book = Book(title: "", author: "", briefIntroduction: "");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _retrieveQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "addBook",
          backgroundColor: Colors.black,
          label: const Text("Add a new quote"),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddQCU(),
                        settings:
                            RouteSettings(arguments: ['Quote', _book.id])))
                .then((value) => setState(() {
                      _retrieveQuotes();
                    }));
          },
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'hereIs',
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _book.title,
                    style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.italic,
                        fontSize: 36,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(top: 48, left: 20, right: 20),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  (quotes.isEmpty) ? "Add a new Quote" : "Quotes",
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontSize: 36,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                padding: const EdgeInsets.only(left: 32),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return Dismissible(
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: const Icon(Icons.delete_forever),
                      ),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) async {
                        await Operation.deleteQuote(quotes[index].id!);
                        _retrieveQuotes();
                      },
                      child: Card(
                          shadowColor: const Color.fromARGB(255, 139, 139, 139),
                          child: ListTile(
                            title: Text(
                              quotes[index].content,
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddQCU(),
                                      settings: RouteSettings(arguments: [
                                        'Quote',
                                        _book.id,
                                        quotes[index].id,
                                        quotes[index].content
                                      ]))).then((value) => setState(() {
                                    _retrieveQuotes();
                                  }));
                            },
                          ),
                          color: Colors.black));
                },
                itemCount: quotes.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(left: 32, right: 32),
                scrollDirection: Axis.vertical,
              ))
            ]));
  }

  _retrieveQuotes() async {
    if (mounted) {
      var bookId = ModalRoute.of(context)?.settings.arguments as int;
      var _listQuotes = await Operation.quotes(bookId);
      var book = await Operation.book(bookId);
      setState(() {
        quotes = _listQuotes;
        _book = book;
      });
    }
  }
}
