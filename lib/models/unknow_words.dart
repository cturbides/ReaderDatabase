class UnknowWords{
  final int? id; //Auto increment id
  final int bookId; //Foreign key
  final String name; //Word
  final String content; //Definition
  
  //Constructor
  UnknowWords({this.id, required this.bookId, required this.name, required this.content});

  //Function to convert Unknow_Words instance into a Map
  Map<String, Object?> toMap(){
    return {
      'id':id,
      'bookId':bookId,
      'name':name,
      'content':content
    };
  }

  //Function that will retrieve data from a map from of a book
  UnknowWords.fromMap(Map<String, dynamic> result)
    : id = result["id"],
      bookId = result["bookId"],
      name = result["name"],
      content = result["content"];
}

