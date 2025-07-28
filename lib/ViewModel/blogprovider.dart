import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wordsview/models/blog/blogmodel.dart';
import 'package:wordsview/service/blog/blog_search_service.dart';
import 'package:wordsview/service/blog/blogservice.dart';
import 'package:wordsview/service/blog/favorite_service.dart';

class BlogProvider extends ChangeNotifier {
//
//ALL BLOGS
  final List<BlogModel> _blogs = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetching = false;
  bool get hasMore => _hasMore;
  List<BlogModel> get blogs => _blogs;
  bool get isfetching => _isFetching;

  Future<void> resetAndFetchAllBlogs() async {
    _currentPage = 1;
    _hasMore = true;
    _blogs.clear();
    notifyListeners();
    await loadMoreBlogs();
  }

  Future<void> loadMoreBlogs() async {
    if (_isFetching || !_hasMore) return;
    _isFetching = true;

    final newBlogs = await Blogservice().getAllBlogs(page: _currentPage);

    if (newBlogs != null && newBlogs.isNotEmpty) {
      _blogs.addAll(newBlogs);
      _currentPage++;
      if (newBlogs.length < 10) {
        _hasMore = false;
      }
    } else {
      _hasMore = false;
    }

    _isFetching = false;
    notifyListeners();
  }

//
//SEARCH

  final List<BlogModel> _searchedBlogs = [];
  int _searchPage = 1;
  bool _searchHasMore = true;
  bool _isFetchingSearch = false;
  bool get searchhasmore => _searchHasMore;
  bool get searchloading => _isFetchingSearch;
  List<BlogModel> get searchedblogs => _searchedBlogs;

  Future<List<BlogModel>?> loadSearchedBlogs(String query,
      {bool reset = false}) async {
    if (reset) {
      _searchPage = 1;
      _searchHasMore = true;
      _searchedBlogs.clear();
    }

    if (_isFetchingSearch || !_searchHasMore) return null;

    _isFetchingSearch = true;
    final newblogs =
        await BlogSearchService().searchBlogs(query, page: _searchPage);

    if (newblogs != null && newblogs.isNotEmpty) {
      _searchedBlogs.addAll(newblogs);
      _searchPage++;
    } else {
      _searchHasMore = false;
    }
    _isFetchingSearch = false;
    notifyListeners();
  }

  Future<void> resetAndFetchSearchBlogs(String query) async {
    _searchedBlogs.clear();
    _searchPage = 1;
    _searchHasMore = true;
    notifyListeners();
    await loadSearchedBlogs(query);
  }

//
//MY BLOGS
  final List<BlogModel> _myBlogs = [];
  int _myPage = 1;
  bool _myHasMore = true;
  bool _isFetchingMy = false;
  bool get myhasMore => _myHasMore;
  List<BlogModel> get myBlogs => _myBlogs;
  bool get isloadingMy => _isFetchingMy;

  Future<List<BlogModel>?> loadMyBlogs({bool reset = false}) async {
    if (reset) {
      _myPage = 1;
      _myHasMore = true;
      _myBlogs.clear();

      notifyListeners();
    }

    if (_isFetchingMy || !_myHasMore) return null;
    _isFetchingMy = true;

    final newblogs = await Blogservice().getMyBlogs(page: _myPage);

    if (newblogs != null && newblogs.isNotEmpty) {
      _myBlogs.addAll(newblogs);
      _myPage++;
    } else {
      _myHasMore = false;
    }
    _isFetchingMy = false;
    notifyListeners();
    return null;
  }

  Future<void> resetAndFetchMyBlogs(String query) async {
    _myBlogs.clear();
    _myPage = 1;
    _myHasMore = true;

    await loadMyBlogs();
    notifyListeners();
  }

//
//RECOMMENTED BLOGS

  final List<BlogModel> _recblogs = [];
  int _recBlogsPage = 1;
  bool _recHasMore = true;
  bool _isFetchingRec = false;

  bool get loadingRec => _isFetchingRec;
  List<BlogModel> get recBlogs => _recblogs;
  bool get rechasmore => _recHasMore;

  Future<List<BlogModel>?> loadRecommentedblogs({bool reset = false}) async {
    if (reset) {
      _recBlogsPage = 1;
      _recHasMore = true;
      _recblogs.clear();
    }

    if (_isFetchingRec || !_recHasMore) return null;
    _isFetchingRec = true;

    final newblogs =
        await Blogservice().getBlogsByuserCategory(page: _recBlogsPage);

    if (newblogs != null && newblogs.isNotEmpty) {
      _recblogs.addAll(newblogs);
      _recBlogsPage++;
    } else {
      _recHasMore = false;
    }
    _isFetchingRec = false;
    notifyListeners();
    return null;
  }

  Future<void> resetAndFetchRecommented() async {
    _recBlogsPage = 1;
    _recHasMore = true;
    _recblogs.clear();
    notifyListeners();
    await loadRecommentedblogs();
  }

//
//

  List<BlogModel> _userpreferedblogs = [];
  List<BlogModel> get userprefblogs => _userpreferedblogs;

  List<BlogModel> _favoriteBlogs = [];
  List<BlogModel> get favoriteBlogs => _favoriteBlogs;

  final List<BlogModel> _filteredBlogs = [];
  List<BlogModel> get filteredblogs => _filteredBlogs;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

//getaallblogs
  // Future<void> fetchBlogs() async {

  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     List<BlogModel>? fetchedBlogs = await Blogservice().getAllBlogs();
  //     _blogs = fetchedBlogs ?? [];
  //   } catch (e) {
  //     _error = "Failed to fetch blogs: $e";
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  //get Specific Blogs
  List<BlogModel> getMyBlogs(String name) {
    return _blogs
        .where((blog) =>
            blog.author?.trim().toLowerCase() == name.trim().toLowerCase())
        .toList();
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
      _blogs.removeWhere((b) => b.id == blogModel.id);
      _myBlogs.removeWhere((b) => b.id == blogModel.id);
      _recblogs.removeWhere((b) => b.id == blogModel.id);
      notifyListeners();
      await refreshblogs();
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

      _filteredBlogs.clear();
      _filteredBlogs.addAll(newblogs ?? []);
    } catch (e) {
      _error = "❌ Failed to fetch blogs: $e";
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
    resetAndFetchAllBlogs();
    resetAndFetchRecommented();

    notifyListeners();
  }

  Future<void> refreshfavoriites() async {
    await getfavBlogs();
  }
}
