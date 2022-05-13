//Imports
import 'package:path/path.dart';
import 'package:readerdatabase/models/book.dart';
import 'package:readerdatabase/models/comments.dart';
import 'package:readerdatabase/models/quotes.dart';
import 'package:readerdatabase/models/unknow_words.dart';
import 'package:sqflite/sqflite.dart';

class Operation {
  /*
    Function to create and/or open the db
    We will return a Database object but with a Future property (natural in async functions)
    We use a join method (similar to join in python) in which we wrap together
    the getDatabasesPath method with the name of our db.
    If it's the first time we execute this function, it will create the books.db
    file.
    Instead, if it is not the first time, we'll just return the db
  */

  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'books.db'),
        //Now, we will create the tables inside the db
        onCreate: (db, version) {
      db.execute("""
      CREATE TABLE Books (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT NOT NULL, 
      author TEXT NOT NULL, briefIntroduction TEXT NOT NULL, calification INTEGER, finalOpinion TEXT);
      """);
      db.execute("""
      CREATE TABLE Comments (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      bookId INTEGER NOT NULL, content TEXT,
      FOREIGN KEY(bookId) REFERENCES Books(id));
      """);
      db.execute("""
      CREATE TABLE Quotes (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      bookId INTEGER NOT NULL, content TEXT,
      FOREIGN KEY(bookId) REFERENCES Books(id));
      """);
      return db.execute("""
      CREATE TABLE UnknowWords (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      bookId INTEGER NOT NULL, name TEXT NOT NULL, content TEXT NOT NULL,
      FOREIGN KEY(bookId) REFERENCES Books(id));
      """);
    }, version: 1);
  }

  //* CRUD SECTION
  //* 1: Insert
  //* 2: Retrieve
  //* 3: Update
  //* 4: Delete

  //=======================INSERT==========================================
  //Function to insert a new book register
  static Future<void> insertBookDB(Book book) async {
    final Database db = await _openDB(); //Creating an instance from our db
    db.insert('Books', book.toMap());
    return;
  }

  //Function to insert a new comment register
  static Future<void> insertCommentDB(Comments comment) async {
    final Database db = await _openDB(); //Creating an instance from our db
    db.insert('Books', comment.toMap());
    return;
  }

  //Function to insert a new quote register
  static Future<void> insertQuoteDB(Quotes quote) async {
    final Database db = await _openDB(); //Creating an instance from our db
    db.insert('Books', quote.toMap());
    return;
  }

  //Function to insert a new unknow words register
  static Future<void> insertUnknowWordDB(UnknowWords unknowWord) async {
    final Database db = await _openDB(); //Creating an instance from our db
    db.insert('Books', unknowWord.toMap());
    return;
  }
  //=======================================================================

  //=======================RETRIEVE========================================
  //Function to retrieve data from Book table
  static Future<List<Book>> books() async {
    final Database db = await _openDB(); //Creating an instance from our db
    //Getting the whole Books table
    final List<Map<String, Object?>> booksList = await db.query('Books');

    for (var i in booksList) {
      print("-> ${i['title']}");
    }

    //Returning a List<Book> object
    return booksList.map((e) => Book.fromMap(e)).toList();
  }

  //Function to retrieve an specific book from Book table
  static Future<Book> book(int id) async {
    final Database db = await _openDB();
    //Getting the whole Books table
    final List<Map<String, Object?>> bookinMap =
        await db.query('Books', where: 'id = ?', whereArgs: [id]);
    //Returning the book object into a map
    return bookinMap.map((e) => Book.fromMap(e)).first;
  }

  //Function to retrieve data from Comments table
  static Future<List<Comments>> comments() async {
    final Database db = await _openDB(); //Creating an instance from our db
    //Getting the whole Comments table
    final List<Map<String, Object?>> commentList = await db.query('Comments');

    for (var i in commentList) {
      print("-> ${i['content']}");
    }

    //Returning a List<Comments> object
    return commentList.map((e) => Comments.fromMap(e)).toList();
  }

  //Function to retrieve a single comment from Comments table
  static Future<Comments> lastComment(int id) async {
    final Database db = await _openDB();
    //Getting the whole Comments table
    try {
      final List<Map<String, Object?>> commentList =
          await db.query('Comments', where: 'bookId= ?', whereArgs: [id]);
      //Returning the last comment
      return commentList.map((e) => Comments.fromMap(e)).last;
    } catch (e) {
      return Comments(bookId: 0, content: "Add a new Comment");
    }
  }

  //Function to retrieve data from Quotes table
  static Future<List<Quotes>> quotes() async {
    final Database db = await _openDB(); //Creating an instance from our db
    //Getting the whole Quotes table
    final List<Map<String, Object?>> quotesList = await db.query('Quotes');

    for (var i in quotesList) {
      print("-> ${i['content']}");
    }

    //Returning a List<Quotes> object
    return quotesList.map((e) => Quotes.fromMap(e)).toList();
  }

  //Function to retrieve the last Quote of an specific book
  static Future<Quotes> lastQuote(int bookId) async {
    final Database db = await _openDB();

    //Getting the whole table
    try {
      final List<Map<String, Object?>> quotesList =
          await (db.query('Quotes', where: "bookId = ?", whereArgs: [bookId]));
      //Returning the last item
      return quotesList.map((e) => Quotes.fromMap(e)).last;
    } catch (e) {
      return Quotes(bookId: 0, content: "Add a new Quote");
    }
  }

  //Function to retrieve data from UnknowWords table
  static Future<List<UnknowWords>> unknowWords() async {
    final Database db = await _openDB(); //Creating an instance from our db
    //Getting the whole UnknowWords table
    final List<Map<String, Object?>> unknowWordsList =
        await db.query('UnknowWords');

    for (var i in unknowWordsList) {
      print("-> ${i['name']}");
    }

    //Returning a List<UnknowWords> object
    return unknowWordsList.map((e) => UnknowWords.fromMap(e)).toList();
  }

  //Funtion to retrieve the last Unknow Word
  static Future<UnknowWords> lastUnknowWord(int bookId) async {
    final Database db = await _openDB();
    try {
      //Getting the unknow words from specifics books
      final List<Map<String, Object?>> listUnknowWords = await db
          .query('UnknowWords', where: "bookId = ?", whereArgs: [bookId]);
      //Returning the last unknowWord
      return listUnknowWords.map((e) => UnknowWords.fromMap(e)).last;
    } catch (e) {
      return UnknowWords(bookId: 0, name: "Word", content: "Definition");
    }
  }
  //=========================================================================

  //=========================UPDATE==========================================
  //Function to update data from Books table
  static Future<void> updateBook(Book bookToUpdate, int id) async {
    final Database db = await _openDB(); //Creating a instance from our db
    //Updating the matching row
    await db.update('Books', bookToUpdate.toMap(),
        where: "id = ?", whereArgs: [id]);
    return;
  }

  //Function to update data from Comments table
  static Future<void> updateComment(Comments commentToUpdate, int id) async {
    final Database db = await _openDB(); //Creating a instance from our db
    //Updating the matching row
    await db.update('Comments', commentToUpdate.toMap(),
        where: "id = ?", whereArgs: [id]);
    return;
  }

  //Function to update data from Quotes table
  static Future<void> updateQuote(Quotes quoteToUpdate, int id) async {
    final Database db = await _openDB(); //Creating a instance from our db
    //Updating the matching row
    await db.update('Quotes', quoteToUpdate.toMap(),
        where: "id = ?", whereArgs: [id]);
    return;
  }

  //Function to update data from UnknowWords table
  static Future<void> updateUnknowWord(
      UnknowWords unknowWordToUpdate, int id) async {
    final Database db = await _openDB(); //Creating a instance from our db
    //Updating the matching row
    await db.update('UnknowWords', unknowWordToUpdate.toMap(),
        where: "id = ?", whereArgs: [id]);
    return;
  }
  //=========================================================================

  //=========================DELETE==========================================
  //Function to delete data from Books Table
  static Future<void> deleteBook(int id) async {
    final Database db = await _openDB(); //Creating a instance from our db
    //Deleting the row with the match id in all tables
    await db.delete('Quotes', where: 'bookId = ?', whereArgs: [id]);
    await db.delete('Comments', where: 'bookId = ?', whereArgs: [id]);
    await db.delete('UnknowWords', where: 'bookId = ?', whereArgs: [id]);
    await db.delete('Books', where: 'id = ?', whereArgs: [id]);
    return;
  }

  //Function to delete data from Comments Table
  static Future<void> deleteComment(int id) async {
    final Database db = await _openDB(); //Creating a instance from our db
    //Deleting the row with the match id
    await db.delete('Comments', where: 'id = ?', whereArgs: [id]);
    return;
  }

  //Function to delete data from Quotes Table
  static Future<void> deleteQuote(int id) async {
    final Database db = await _openDB(); //Creating a instance from our db
    //Deleting the row with the match id
    await db.delete('Quotes', where: 'id = ?', whereArgs: [id]);
    return;
  }

  //Function to delete data from UnknowWords Table
  static Future<void> deleteUnknowWord(int id) async {
    final Database db = await _openDB(); //Creating a instance from our db
    //Deleting the row with the match id
    await db.delete('UnknowWords', where: 'id = ?', whereArgs: [id]);
    return;
  }
  //=======================================================================
}
