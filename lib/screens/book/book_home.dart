import 'package:flutter/material.dart';
import 'package:readerdatabase/add-book.dart';
import 'package:readerdatabase/db/operations.dart';
import 'package:readerdatabase/models/comments.dart';
import 'package:readerdatabase/models/quotes.dart';
import 'package:readerdatabase/models/unknow_words.dart';
import 'package:readerdatabase/screens/book/book_comments.dart';
import 'package:readerdatabase/screens/book/book_quotes.dart';
import 'package:readerdatabase/screens/book/book_unknowWords.dart';
import '../../models/book.dart';

class BookHome extends StatefulWidget {
  const BookHome({Key? key}) : super(key: key);

  @override
  State<BookHome> createState() => _BookHomeState();
}

class _BookHomeState extends State<BookHome> {
  Quotes lastQuote = Quotes(bookId: 0, content: "content");
  Comments lastComment = Comments(bookId: 0, content: "content");
  UnknowWords lastUnknowWords = UnknowWords(bookId: 0, name: "a", content: "H");
  Book _book = Book(
      title: "title", author: "author", briefIntroduction: "briefIntroduction");
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      _retrieveBook();
    });
  }

  @override
  Widget build(BuildContext context) {
    var bookId = _book.id;
    if (bookId != null) {
      _retrieveLastComment(bookId);
      _retrieveLastQuote(bookId);
      _retrieveLastUnknowWord(bookId);
    }
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "addBook",
        splashColor: Colors.amberAccent,
        label: const Text(
          "Export Google Keep",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        onPressed: () async {}, //Complete
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 48,
          ),
          InkWell(
            child: Column(children: <Widget>[
              Column(children: <Widget>[
                Center(
                    child: Text(
                  _book.title,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Roboto', fontSize: 32),
                  textAlign: TextAlign.center,
                )),
                Center(
                    child: Text(
                  "by ${_book.author}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 32,
                      fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                ))
              ]),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _book.briefIntroduction,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
              )
            ]),
            onLongPress: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddBook(),
                          settings: RouteSettings(arguments: _book.id)))
                  .then((value) => setState(() {
                        _retrieveBook();
                      }));
            },
            splashColor: Colors.transparent,
          ),
          const SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              InkWell(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Quotes",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 32,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                        child: Text(
                          "\"${lastQuote.content}\"",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    )
                  ],
                ),
                onLongPress: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookQuotes(),
                              settings: RouteSettings(arguments: _book.id!)))
                      .then((value) => setState(() {
                            _retrieveLastQuote(_book.id!);
                          }));
                },
                splashColor: Colors.transparent,
              ),
              const SizedBox(
                height: 26,
              ),
              InkWell(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Comments",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 32,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, top: 5, right: 30),
                        child: Text(
                          (lastComment.content.length > 140)
                              ? "\"${lastComment.content.characters.take(140)}...\""
                              : "\"${lastComment.content}\"",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    )
                  ],
                ),
                onLongPress: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookComments(),
                              settings: RouteSettings(arguments: _book.id!)))
                      .then((value) => setState(() {
                            _retrieveLastComment(_book.id!);
                          }));
                },
                splashColor: Colors.transparent,
              ),
              const SizedBox(
                height: 26,
              ),
              InkWell(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Unknow Words",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 32,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, top: 5, right: 30 ),
                        child: Text(
                          (lastUnknowWords.content.length > 50)
                              ? "${lastUnknowWords.name}: ${lastUnknowWords.content.characters.take(50)}.."
                              : "${lastUnknowWords.name}: ${lastUnknowWords.content}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                    )
                  ],
                ),
                onLongPress: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BookUnknowWords(),
                              settings: RouteSettings(arguments: _book.id!)))
                      .then((value) => setState(() {
                            _retrieveLastUnknowWord(_book.id!);
                          }));
                },
                splashColor: Colors.transparent,
              ),
            ]),
          )
        ],
      ),
    );
  }

  _retrieveBook() async {
    int bookId = ModalRoute.of(context)!.settings.arguments as int;
    Book book = await Operation.book(bookId);
    if (mounted) {
      setState(() {
        _book = book;
      });
    }
  }

  _retrieveLastQuote(int bookId) async {
    Quotes quote = await Operation.lastQuote(bookId);
    if (mounted) {
      setState(() {
        lastQuote = quote;
      });
    }
  }

  _retrieveLastComment(int bookId) async {
    Comments comment = await Operation.lastComment(bookId);
    if (mounted) {
      setState(() {
        lastComment = comment;
      });
    }
  }

  _retrieveLastUnknowWord(int bookId) async {
    UnknowWords unknowWord = await Operation.lastUnknowWord(bookId);
    if (mounted) {
      setState(() {
        lastUnknowWords = unknowWord;
      });
    }
  }
}
