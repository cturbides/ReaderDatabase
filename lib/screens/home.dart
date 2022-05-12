import 'package:flutter/material.dart';
import 'package:readerdatabase/add-book.dart';
import 'package:readerdatabase/db/operations.dart';
import 'package:readerdatabase/models/book.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "Carlos"; //Change
  int index = 5;
  List<Book> booksDB = [];
  //Function executed when the screen is initializing
  @override
  void initState() {
    _retrieveBookData(); //Saving all books data into booksDB
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "addBook",
          splashColor: Colors.amber,
          label: const Text(
            "Add a book",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          onPressed: () async {
            final _ = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddBook()));
            setState(() {
              _retrieveBookData();
            });
          }),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "Welcome $name",
              style: const TextStyle(
                  fontSize: 36,
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
            ),
            padding: const EdgeInsets.only(top: 48, left: 26),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Color.fromARGB(255, 119, 119, 119),
                Color.fromARGB(16, 1, 1, 1)
              ], end: FractionalOffset(0.0, 0.9999999))),
              height: 200,
              width: 342,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 110, top: 19),
                    child: Text(
                      "Last Read",
                      style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    (booksDB.isNotEmpty)
                        ? (booksDB[booksDB.length - 1].title.length > 30) 
                          ? "${booksDB[booksDB.length - 1].title.characters.take(30)}.."
                          : booksDB[booksDB.length - 1].title
                        : "Add a new read",
                    style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    (booksDB.isNotEmpty)
                        ? "by ${booksDB[booksDB.length - 1].author}"
                        : "There's no last author",
                    style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            onTap: () {},
          ),
          const SizedBox(
            height: 22,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 22),
            child: Text(
              (booksDB.isNotEmpty) ? "Titles" : "There's no books!",
              style: const TextStyle(
                  fontSize: 36, fontFamily: 'Roboto', color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          ListView.builder(
            itemBuilder: ((context, index) {
              return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(booksDB[index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await Operation.deleteBook(booksDB[index].id!);
                    setState(() {
                      _retrieveBookData();
                    });
                  },
                  child: Card(
                      shadowColor: const Color.fromARGB(255, 139, 139, 139),
                      child: ListTile(
                        title: Text(
                          booksDB[index].title,
                          style: const TextStyle(
                              fontSize: 26,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "by ${booksDB[index].author}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onTap: () {},
                      ),
                      color: Colors.black));
            }),
            itemCount: booksDB.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 32, right: 32),
            scrollDirection: Axis.vertical,
          )
        ],
      ),
    );
  }

  //Retrieving data from a future func
  _retrieveBookData() async {
    var _booksData = await Operation.books();
    setState(() {
      booksDB = _booksData;
    });
  }
}
