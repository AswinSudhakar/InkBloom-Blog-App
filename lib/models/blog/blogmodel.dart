class BlogModel {
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
      author: json['author'],
      authorEmail: json['author_email'],
      category: json['category'],
      topic: json['topic'],
      title: json['title'],
      readTime: json['read_time'], // Fixed key naming
      avatar: json['avatar'],
      imageUrl: json['image_url'], // Fixed key naming
      content: json['content'],

      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'author_email': authorEmail,
      'category': category,
      'topic': topic,
      'title': title,
      'read_time': readTime, // Fixed key naming
      'avatar': avatar,
      'image_url': imageUrl, // Fixed key naming
      'content': content,

      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
