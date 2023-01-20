class Book {
  String title;
  String author;
  String description;
  String image;
  String url;
  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.image,
    required this.url,
  });
  //from json
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      description: json['description'],
      image: json['image'],
      url: json['url'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'image': image,
      'url': url,
    };
  }
}
