class Quotes {
  final int? id;
  final int bookId; //FK
  final String content; //Quote
  
  //Constructor
  Quotes({this.id, required this.bookId, required this.content});

  //Returning a Quotes instance into a map
  Map<String, Object?> toMap(){
    return {
      'id':id,
      'bookId':bookId,
      'content':content 
    };
  }
   
  //Function that will retrieve data from a map from of a book
  Quotes.fromMap(Map<String, dynamic> result)
    : id = result["id"],
      bookId = result["bookId"],
      content = result["content"];
}