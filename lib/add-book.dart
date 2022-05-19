import 'package:flutter/material.dart';
import 'package:readerdatabase/db/operations.dart';
import 'package:readerdatabase/models/book.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  String title = "New Book";
  var _value;
  //Global key to use when validating form
  final _formKey = GlobalKey<FormState>();

  //TextEditingController used to retrieve values from each TextFormField
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _briefIntro = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _retrievingSettingsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "addBook",
          backgroundColor: Colors.black,
          label: Row(
            children: const [Icon(Icons.save_alt), Text(" Save")],
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              //Add Create Book function
              String title = _title.text;
              String author = _author.text;
              String briefIntro = _briefIntro.text;
              if (_value == Null) {
                Book newBook = Book(
                    title: title,
                    author: author,
                    briefIntroduction: briefIntro);
                Operation.insertBookDB(newBook);
              } else {
                Book bookToUpdate = Book(
                    id: _value as int,
                    title: title,
                    author: author,
                    briefIntroduction: briefIntro);
                Operation.updateBook(bookToUpdate);
              }
              //Showing up an little snackbar
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                      duration: const Duration(milliseconds: 10),
                      content: WillPopScope(
                          child: const Text("Saving.."),
                          onWillPop: () async {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            return true;
                          })))
                  .closed
                  .then((value) {
                Navigator.pop(context);
              });
            }
          },
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 36,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
              padding: const EdgeInsets.only(top: 48, left: 36),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Book Title",
                        style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      ),
                      padding: const EdgeInsets.only(left: 36),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(left: 36, right: 36, top: 20),
                      child: TextFormField(
                        controller: _title,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a title";
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: "Write book's title",
                            fillColor: Colors.white,
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        cursorColor: Colors.amberAccent,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Book Author",
                        style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      ),
                      padding: const EdgeInsets.only(left: 36),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(left: 36, right: 36, top: 20),
                      child: TextFormField(
                        controller: _author,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter an author";
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: "Write book's author",
                            fillColor: Colors.white,
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        cursorColor: Colors.amberAccent,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "A brief intro",
                        style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic,
                            color: Colors.white),
                      ),
                      padding: const EdgeInsets.only(left: 36),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding:
                          const EdgeInsets.only(left: 36, right: 36, top: 20),
                      child: TextFormField(
                        controller: _briefIntro,
                        maxLines: 14,
                        maxLength: 500,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please write something";
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            labelText: "Write book's brief introduction",
                            fillColor: Colors.white,
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white))),
                        cursorColor: Colors.amberAccent,
                      ),
                    )
                  ],
                ))
          ],
        )));
  }

  _retrievingSettingsData() async {
    if (mounted) {
      _value = (ModalRoute.of(context)!.settings.arguments != null)
          ? ModalRoute.of(context)!.settings.arguments as int
          : Null;
      if (_value != Null) {
        Book book = await Operation.book(_value as int);
        setState(() {
          title = "Update Book";
          _title.text = book.title;
          _author.text = book.author;
          _briefIntro.text = book.briefIntroduction;
        });
      }
    }
  }
}
