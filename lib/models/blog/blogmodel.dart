class BlogModel {
  String? id;
  String? author;
  String? authorEmail;
  String? category;
  String? topic;
  String? title;
  String? readTime;
  String? avatar;
  String? imageUrl;
  String? content;

  String? createdAt;
  String? updatedAt;

  BlogModel({
    this.id,
    this.author,
    this.authorEmail,
    required this.category,
    required this.topic,
    required this.title,
    required this.readTime,
    this.avatar,
    this.imageUrl,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      author: json['author'],
      authorEmail: json['author_email'],
      category: json['category'],
      topic: json['topic'],
      title: json['title'],
      readTime: json['readTime'],
      avatar: json['avatar'],
      imageUrl: json['imageUrl'],
      content: json['content'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'author_email': authorEmail,
      'category': category,
      'topic': topic,
      'title': title,
      'readTime': readTime,
      'avatar': avatar,
      'imageUrl': imageUrl,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
