import 'package:flutter/material.dart';
import 'package:readerdatabase/db/operations.dart';
import 'package:flutter/services.dart';
import '../../models/book.dart';

class ExportGK extends StatefulWidget {
  const ExportGK({Key? key}) : super(key: key);

  @override
  State<ExportGK> createState() => _ExportGKState();
}

class _ExportGKState extends State<ExportGK> {
  Book _book =
      Book(title: "", author: "", briefIntroduction: "briefIntroduction");
  final _finalController = TextEditingController();
  String author = "", title = "";
  int _rating = 0;
  String message = "Export";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _retrieveBook();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Hero(
          tag: 'addBook',
          child: Material(
            color: Colors.black,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Center(
                          child: Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 32),
                        textAlign: TextAlign.center,
                      )),
                      Center(
                          child: Text(
                        (_book.author.characters.isEmpty)
                            ? ""
                            : "by $author",
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                            fontSize: 32,
                            fontWeight: FontWeight.w200),
                        textAlign: TextAlign.center,
                      ))
                    ]),
                    const SizedBox(height: 15),
                    const SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Final Thoughts",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write down what you thought",
                          hintStyle: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w100),
                          fillColor: Colors.white,
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(color: Colors.white),
                          focusColor: Colors.white),
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w300),
                      cursorColor: Colors.white,
                      maxLines: 6,
                      controller: _finalController,
                    ),
                    const Text("Book Rate"),
                    Rating(
                        actualRate: _rating,
                        rateSelected: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        }),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    InkWell(
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (_finalController.text.isNotEmpty) {
                          if (_rating != 0) {
                            _book.calification = _rating;
                            _book.finalOpinion = _finalController.text;
                            await Operation.updateBook(_book);
                            String _finalString =
                                await Operation.allBookData(_book.id!);
                            //Copy to clipboard
                            await Clipboard.setData(
                                ClipboardData(text: _finalString));
                            setState(() {
                              message = "Copied!";
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _retrieveBook() async {
    if (mounted) {
      int bookId = ModalRoute.of(context)!.settings.arguments as int;
      Book book = await Operation.book(bookId);
      setState(() {
        _book = book;
        author = _book.author;
        title = _book.title;
        (_book.finalOpinion != null)
            ? _finalController.text = _book.finalOpinion!
            : null;
        (_book.calification != null)
            ? _rating = _book.calification!
            : _rating = 0;
      });
    }
  }
}

//HeroPage class -> A configurated PageRoute
class HeroPageRoute<T> extends PageRoute<T> {
  HeroPageRoute(
      {required WidgetBuilder builder,
      RouteSettings? settings,
      bool fullScreenDialog = false})
      : _builder = builder,
        super(settings: settings, fullscreenDialog: fullScreenDialog);
  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color get barrierColor => Colors.black87; //Background opacity level

  @override
  String get barrierLabel => 'Popup dialog working';

  @override
  bool get maintainState => true;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }
}

//Rating system
class Rating extends StatefulWidget {
  final Function(int) rateSelected;
  final int actualRate;
  final int maxRate;
  const Rating(
      {Key? key,
      required this.rateSelected,
      this.maxRate = 5,
      required this.actualRate})
      : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int rating = 0;

  Widget star(int index) {
    if (index < rating) {
      return const Icon(Icons.star, color: Colors.amberAccent, size: 40);
    }
    return const Icon(
      Icons.star_outline_sharp,
      color: Colors.grey,
      size: 40,
    );
  }

  @override
  Widget _stars() {
    final stars = List<Widget>.generate(widget.maxRate, (index) {
      return GestureDetector(
        child: star(index),
        onTap: () {
          setState(() {
            rating = index + 1;
          });
          widget.rateSelected(rating);
        },
      );
    });
    return Row(
      children: stars,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    rating = widget.actualRate;
    return _stars();
  }
}
