import 'package:flutter/material.dart';
import 'package:readerdatabase/add-book.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "addBook",
        splashColor: Colors.amber,
        label: const Text("Add a book"),
        backgroundColor: Colors.black,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddBook()))
        ),
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
                  fontStyle: FontStyle.italic),
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
              height: 168,
              width: 342,
              child: Column(
                children: const [
                  Padding(
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
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Some book title",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "by some book author",
                    style: TextStyle(
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
            child: const Text(
              "Titles",
              style: TextStyle(fontSize: 36, fontFamily: 'Roboto'),
            ),
          ),


          InkWell(
            child: Row(children: [
              Column(
                children: const [
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Some book title",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "by some book author",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Roboto',
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ]),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
