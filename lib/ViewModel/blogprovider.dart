import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/service/blog/blog_search_service.dart';
import 'package:inkbloom/service/blog/blogservice.dart';
import 'package:inkbloom/service/blog/favorite_service.dart';

class BlogProvider extends ChangeNotifier {
  List<BlogModel> _blogs = [];

  List<BlogModel> _userpreferedblogs = [];
  final List<BlogModel> _searchedblogs = [];
  List<BlogModel> _favoriteBlogs = [];

  final List<BlogModel> _filteredBlogs = [];

  bool _isLoading = false;
  String? _error;

  List<BlogModel> get blogs => _blogs;
  List<BlogModel> get favoriteBlogs => _favoriteBlogs;
  List<BlogModel> get filteredblogs => _filteredBlogs;
  List<BlogModel> get userprefblogs => _userpreferedblogs;

  List<BlogModel> get searchedblogs => _searchedblogs;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchBlogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<BlogModel>? fetchedBlogs = await Blogservice().getAllBlogs();
      _blogs = fetchedBlogs ?? [];
    } catch (e) {
      _error = "Failed to fetch blogs: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  //get myBlogs
  List<BlogModel> getMyBlogs(String currentUserName) {
    return _blogs
        .where((blog) =>
            blog.author?.trim().toLowerCase() ==
            currentUserName.trim().toLowerCase())
        .toList();
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
    } catch (e) {
      _error = "Failed to fetch blogs: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add a New Blog
  Future<void> addBlog(BlogModel newBlog) async {
    try {
      String? response = await Blogservice().addBlog(newBlog);
      if (response != null) {
        _blogs.insert(0, newBlog);
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
      String? response = await Blogservice().editBlog(newblog);
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

  //delete blog
  Future<bool?> Deleteblog(BlogModel blogModel) async {
    final success = await Blogservice().deleteBlog(blogModel);
    if (success == true) {
      notifyListeners();
      await fetchBlogs();
    }
    return success;
  }

  //filter by single category
  Future<void> filterCategoryBlogs(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newblogs = await Blogservice().filterBlog(category);
      debugPrint("🔁 filter blogs categorywise: ${newblogs?.length}");

      _filteredBlogs.clear();
      _filteredBlogs.addAll(newblogs ?? []);
    } catch (e) {
      _error = "❌ Failed to fetch blogs: $e";
      debugPrint(_error);
    }

    _isLoading = false;
    notifyListeners();
  }

  //search blogs
  Future<void> SearchBlogs(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newblogs = await BlogSearchService().searchBlogs(query);
      debugPrint("🔁 Search blogs : ${newblogs?.length}");

      _searchedblogs.clear();
      _searchedblogs.addAll(newblogs ?? []);
    } catch (e) {
      _error = "❌ Failed to search blogs: $e";
      debugPrint(_error);
    }

    _isLoading = false;
    notifyListeners();
  }

  String? _favoriteMessage;
  String? get favoriteMessage => _favoriteMessage;

  //add to fav

  Future<void> addToFavorite(String id) async {
    final message = await FavoriteService().addToFavorite(id);
    debugPrint("Favorite message: $message");

    _favoriteMessage = message;
    notifyListeners();
  }

  //getfav blogs
  Future<void> getfavBlogs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      List<BlogModel>? favblogs = await FavoriteService().getFavoriteBlogs();
      _favoriteBlogs = favblogs ?? [];
    } catch (e) {
      _error = "Failed to fetch blogs: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  //delete fav blog
  Future<bool?> deleteFromFav(String id) async {
    final success = await FavoriteService().deletefromFavorite(id);
    if (success == true) {
      notifyListeners();
      await getfavBlogs();
    }
    return success;
  }

  Future<void> refreshblogs() async {
    print("refresh page is called");
    await fetchBlogs();
    await fetchUserCategoryBlogs();
  }

  Future<void> refreshfavoriites() async {
    await getfavBlogs();
  }

  Future<void> refreshuserpref() async {
    await fetchUserCategoryBlogs();
  }
}
