import 'dart:html';

class Comments {
  final int? id;
  final int bookId; //FK
  final String content; //Comment

  //Constructor
  Comments({this.id, required this.bookId, required this.content});

  //Returning a Comment instance converted into a map
  Map<String, Object?> toMap(){
    return {
      'id':id,
      'bookId':bookId,
      'content':content
    };
  }

   //Function that will retrieve data from a map from of a book
  Comments.fromMap(Map<String, dynamic> result)
    : id = result["id"],
      bookId = result["bookId"],
      content = result["content"];
}