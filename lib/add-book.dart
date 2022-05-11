import 'package:flutter/material.dart';
import 'package:readerdatabase/db/operations.dart';

class AddBook extends StatefulWidget {
  const AddBook({Key? key}) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  //Global key to use when validating form
  final _formKey = GlobalKey<FormState>();

  //TextEditingController used to retrieve values from each TextFormField
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _authorBio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "addBook",
          backgroundColor: Colors.black,
          label: Row(
            children: const [Icon(Icons.save_alt), Text(" Save")],
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              //Add Create Book function
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
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
              child: const Text(
                "New Book",
                style: TextStyle(
                    fontSize: 36,
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic),
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
                            fontStyle: FontStyle.italic),
                      ),
                      padding: const EdgeInsets.only(left: 36),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: TextFormField(
                        controller: _title,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter some title";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: "Write book's title"),
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
                            fontStyle: FontStyle.italic),
                      ),
                      padding: const EdgeInsets.only(left: 36),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: TextFormField(
                        controller: _author,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter some author";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: "Write book's author"),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Short Author Biography",
                        style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.italic),
                      ),
                      padding: const EdgeInsets.only(left: 36),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      height: 5 * 24.0, //5 lines
                      child: TextFormField(
                        controller: _authorBio,
                        maxLines: 5,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter author's bio";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Write book's author bio"),
                      ),
                    )
                  ],
                ))
          ],
        )));
  }
}
