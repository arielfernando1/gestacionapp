class Post {
  String id;
  int postType; // 1 = image, 2 = audio, 3 = text
  String uuid;
  String title;
  String description;
  String file;
  DateTime date;

  Post({
    required this.id,
    required this.postType,
    required this.uuid,
    required this.title,
    required this.description,
    required this.file,
    required this.date,
  });

  // from json
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: '',
      postType: json['postType'],
      uuid: json['uuid'],
      title: json['title'],
      description: json['description'],
      file: json['file'],
      date: json['date_created'].toDate(),
    );
  }
  // to json
  Map<String, dynamic> toJson() {
    return {
      'postType': postType,
      'uuid': uuid,
      'title': title,
      'description': description,
      'file': file,
      'date_created': date,
    };
  }
}
