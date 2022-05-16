import 'package:flutter/material.dart';
import 'package:readerdatabase/db/operations.dart';
import 'package:readerdatabase/models/quotes.dart';
import 'package:readerdatabase/models/comments.dart';
import '../../models/unknow_words.dart';

class AddQCU extends StatefulWidget {
  const AddQCU({Key? key}) : super(key: key);

  @override
  State<AddQCU> createState() => _AddQCUState();
}

class _AddQCUState extends State<AddQCU> {
  var _args;
  String option = "";
  int bookId = 0;
  //In order to use this form as a Update Form too
  var _content;
  var _content2;
  var _id;
  final _formKey = GlobalKey<FormState>(); //FormKey
  final _firstTextController = TextEditingController(); //Text Field Controller
  final _secondTextController = TextEditingController(); //Text Field Controller

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _retrieveArgs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
            children: const [Icon(Icons.save_alt_outlined), Text(" Save!")]),
        backgroundColor: Colors.black,
        heroTag: "addBook",
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _content = _firstTextController.text;
            //Quotes
            if (option == "Quote") {
              if (_id != null) {
                Quotes quoteToUpdate =
                    Quotes(bookId: bookId, content: _content, id: _id);
                Operation.updateQuote(quoteToUpdate, _id);
              } else {
                Quotes quote = Quotes(bookId: bookId, content: _content);
                Operation.insertQuoteDB(quote);
              }
            }
            //Comments
            else if (option == "Comment") {
              if (_id != null) {
                Comments commentToUpdate =
                    Comments(bookId: bookId, content: _content, id: _id);
                Operation.updateComment(commentToUpdate, _id);
              } else {
                Comments comment = Comments(bookId: bookId, content: _content);
                Operation.insertCommentDB(comment);
              }
            }
            //Unknow Words
            else if (option == "Unknow Word") {
              _content2 = _secondTextController.text;
              if (_id != null) {
                UnknowWords unknowWordToUpdate = 
                    UnknowWords(bookId: bookId, name: _content, content: _content2, id: _id);
                Operation.updateUnknowWord(unknowWordToUpdate, _id);
              } else {
                UnknowWords unknowWord = UnknowWords(bookId: bookId, name: _content, content: _content2);
                Operation.insertUnknowWordDB(unknowWord);
              }
            }
            //Showing up an little snackbar
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
                    duration: const Duration(seconds: 2),
                    content: WillPopScope(
                        child: const Text("Saving.."),
                        onWillPop: () async {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
                option,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic,
                    fontSize: 36,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              padding: const EdgeInsets.only(top: 48, left: 32),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  (option == "Quote")
                      ? Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(
                              left: 36, right: 36, top: 20),
                          child: TextFormField(
                            controller: _firstTextController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a Quote";
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                labelText: "Write a Quote",
                                fillColor: Colors.white,
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                            cursorColor: Colors.amberAccent,
                            maxLines: 4,
                            maxLength: 140,
                          ),
                        )
                      : (option == "Comment")
                          ? Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(
                                  left: 36, right: 36, top: 20),
                              child: TextFormField(
                                controller: _firstTextController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter a Comment";
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                    labelText: "Write a Comment",
                                    fillColor: Colors.white,
                                    alignLabelWithHint: true,
                                    labelStyle: TextStyle(color: Colors.white),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white))),
                                cursorColor: Colors.amberAccent,
                                maxLines: 18,
                                maxLength: 650,
                              ),
                            )
                          : Column(children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(
                                    left: 36, right: 36, top: 20),
                                child: TextFormField(
                                  controller: _firstTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter a word";
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      labelText: "Write a Word",
                                      fillColor: Colors.white,
                                      alignLabelWithHint: true,
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                  cursorColor: Colors.amberAccent,
                                  maxLines: 1,
                                  maxLength: 36,
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(
                                    left: 36, right: 36, top: 20),
                                child: TextFormField(
                                  controller: _secondTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter a definition";
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      labelText: "Write a definition",
                                      fillColor: Colors.white,
                                      alignLabelWithHint: true,
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white))),
                                  cursorColor: Colors.amberAccent,
                                  maxLines: 4,
                                  maxLength: 150,
                                ),
                              ),
                            ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _retrieveArgs() async {
    if (mounted) {
      var _args = ModalRoute.of(context)?.settings.arguments as List;
      setState(() {
        option = _args[0];
        bookId = _args[1];
        if (_args[0] == "Quote" || _args[0] == "Comment") {
          try {
            _id = _args[2];
            _content = _args[3];
          } catch (e) {
            _content = null;
          }
          (_content != null) ? _firstTextController.text = _content : null;
        } else {
          try {
            _id = _args[2];
            _content = _args[3];
            _content2 = _args[4];
          } catch (e) {
            _content = null;
            _content2 = null;
          }
          if (_content != null && _content2 != null) {
            _firstTextController.text = _content;
            _secondTextController.text = _content2;
          }
        }
      });
    }
  }
}
