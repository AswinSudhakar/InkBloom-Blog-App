import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/service/blogservice.dart';

class BlogProvider extends ChangeNotifier {
  List<BlogModel> _blogs = [];

  List<BlogModel> _userpreferedblogs = [];
  // List<BlogModel> _userselectedblogs = [];

  final List<BlogModel> _filteredBlogs = [];

  bool _isLoading = false;
  String? _error;

  List<BlogModel> get blogs => _blogs;
  List<BlogModel> get filteredblogs => _filteredBlogs;
  List<BlogModel> get userprefblogs => _userpreferedblogs;

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

  //get user category blogs

  Future<void> fetchUserCategoryBlogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newblogs = await Blogservice().getBlogsByuserCategory();
      print("🔁 fetchUserCategoryBlogs called");

      _userpreferedblogs = newblogs ?? [];
      _filteredBlogs.clear();
      _filteredBlogs.addAll(_userpreferedblogs);
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

  //edit blog

  Future<void> editBlog(BlogModel newblog) async {
    try {
      String? response = await Blogservice().EditBlog(newblog);
      if (response != null) {
        int index = _blogs.indexWhere((blog) => blog.id == newblog.id);
        if (index != -1) {
          _blogs[index] = newblog;
          notifyListeners();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  //edit blog
  Future<bool?> Deleteblog(BlogModel blogModel) async {
    final success = await Blogservice().deleteBlog(blogModel);
    if (success!) {
      notifyListeners();
      await fetchBlogs();
    }
    return success;
  }
}
