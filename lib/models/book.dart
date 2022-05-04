class Book {
  final int? id;
  final String title;
  final String author;
  final String authorShortBio;
  int? calification; //Can change
  String? finalOpinion; //Can change

  //Constructor
  Book({
      this.id,
      required this.title,
      required this.author,
      required this.authorShortBio,
      this.calification,
      this.finalOpinion
      });
  
  //Function that will return a map form of a book
  Map<String, Object?> toMap(){
    return {
      'id':id,
      'title':title,
      'author':author,
      'authorShortBio':authorShortBio,
      'calification':calification,
      'finalOpinion':finalOpinion
    };
  }

  //Function that will retrieve data from a map from of a book
  Book.fromMap(Map<String, dynamic> result)
    : id = result["id"],
      title = result["title"],
      author = result["author"],
      authorShortBio = result["authorShortBio"],
      calification = result["calification"],
      finalOpinion = result["finalOpinion"];
}
