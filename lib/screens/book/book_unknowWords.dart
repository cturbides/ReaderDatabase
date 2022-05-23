//Imports
import 'package:flutter/material.dart';
import 'package:readerdatabase/models/book.dart';
import 'package:readerdatabase/screens/book/add_qcu.dart';
import '../../db/operations.dart';
import '../../models/unknow_words.dart';

class BookUnknowWords extends StatefulWidget {
  const BookUnknowWords({Key? key}) : super(key: key);

  @override
  State<BookUnknowWords> createState() => BookUnknowWordsState();
}

class BookUnknowWordsState extends State<BookUnknowWords> {
  List<UnknowWords> unknowWords = []; //Used with the ListView.builder
  Book _book = Book(title: "", author: "", briefIntroduction: "");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _retrieveUnknow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "addBook",
          backgroundColor: Colors.black,
          label: const Text("New unknow word"),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddQCU(),
                        settings: RouteSettings(
                            arguments: ['Unknow Word', _book.id])))
                .then((value) => setState(() {
                      _retrieveUnknow();
                    }));
          },
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
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
              const SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  (unknowWords.isEmpty) ? "Add an U-Word" : "Unknow Words",
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
                        await Operation.deleteUnknowWord(unknowWords[index].id!);
                        _retrieveUnknow();
                      },
                      child: Card(
                          shadowColor: const Color.fromARGB(255, 139, 139, 139),
                          child: ListTile(
                            title: Text(
                              unknowWords[index].name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                unknowWords[index].content,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddQCU(),
                                      settings: RouteSettings(arguments: [
                                        'Unknow Word',
                                        _book.id,
                                        unknowWords[index].id,
                                        unknowWords[index].name,
                                        unknowWords[index].content
                                      ]))).then((value) => setState(() {
                                    _retrieveUnknow();
                                  }));
                            },
                          ),
                          color: Colors.black));
                },
                itemCount: unknowWords.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(left: 32, right: 32, bottom: 70),
                scrollDirection: Axis.vertical,
              ))
            ]));
  }

  _retrieveUnknow() async {
    if (mounted) {
      var bookId = ModalRoute.of(context)?.settings.arguments as int;
      var _listUnknowWords = await Operation.unknowWords(bookId);
      var book = await Operation.book(bookId);
      setState(() {
        unknowWords = _listUnknowWords;
        _book = book;
      });
    }
  }
}
