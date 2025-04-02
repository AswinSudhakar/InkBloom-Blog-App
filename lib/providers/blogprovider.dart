import 'package:flutter/material.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/service/blogservice.dart';

class BlogProvider extends ChangeNotifier {
  List<BlogModel> _blogs = [];
  bool _isLoading = false;
  String? _error;

  List<BlogModel> get blogs => _blogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBlogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<BlogModel>? fetchedBlogs = await Blogservice().getAllBlogs();
      _blogs = fetchedBlogs ?? []; // Ensuring non-null list
    } catch (e) {
      _error = "Failed to fetch blogs: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a New Blog
  Future<void> addBlog(BlogModel newBlog) async {
    try {
      String? response = await Blogservice().AddBlog(newBlog);
      if (response != null) {
        _blogs.insert(0, newBlog); // Insert new blog at the top
        notifyListeners();
      }
    } catch (e) {
      _error = "Failed to add blog: $e";
      notifyListeners();
    }
  }
}
