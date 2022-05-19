import 'package:flutter/material.dart';
import 'package:readerdatabase/models/book.dart';
import 'package:readerdatabase/screens/book/add_qcu.dart';
import '../../db/operations.dart';
import '../../models/comments.dart';

class BookComments extends StatefulWidget {
  const BookComments({Key? key}) : super(key: key);

  @override
  State<BookComments> createState() => Book_CommentsState();
}

class Book_CommentsState extends State<BookComments> {
  List<Comments> comments = []; //Used with the ListView.builder
  Book _book = Book(title: "", author: "", briefIntroduction: "");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _retrieveComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "addBook",
          backgroundColor: Colors.black,
          label: const Text("New comment"),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddQCU(),
                        settings:
                            RouteSettings(arguments: ['Comment', _book.id])))
                .then((value) => setState(() {
                      _retrieveComments();
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
                  (comments.isEmpty) ? "Add a Comment" : "Comments",
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
                        await Operation.deleteComment(comments[index].id!);
                        _retrieveComments();
                      },
                      child: Card(
                          shadowColor: const Color.fromARGB(255, 139, 139, 139),
                          child: ListTile(
                            title: Text(
                              comments[index].content,
                              style: const TextStyle(
                                fontSize: 20,
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
                                        'Comment',
                                        _book.id,
                                        comments[index].id,
                                        comments[index].content
                                      ]))).then((value) => setState(() {
                                    _retrieveComments();
                                  }));
                            },
                          ),
                          color: Colors.black));
                },
                itemCount: comments.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(left: 32, right: 32),
                scrollDirection: Axis.vertical,
              ))
            ]));
  }

  _retrieveComments() async {
    if (mounted) {
      var bookId = ModalRoute.of(context)?.settings.arguments as int;
      var _listComments = await Operation.comments(bookId);
      var book = await Operation.book(bookId);
      setState(() {
        comments = _listComments;
        _book = book;
      });
    }
  }
}
