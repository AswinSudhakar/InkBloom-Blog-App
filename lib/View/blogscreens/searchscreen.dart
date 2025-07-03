import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/View/widgets/bloglistview.dart';
import 'package:inkbloom/View/widgets/shimmer.dart';
import 'package:inkbloom/service/blog/blog_search_service.dart';
import 'package:provider/provider.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  late TextEditingController _searchController;
  final FocusNode _focusnode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isFocused = false;
  String _currentQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusnode.requestFocus();
    });

    _focusnode.addListener(() {
      setState(() => _isFocused = _focusnode.hasFocus);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          _currentQuery.isNotEmpty) {
        context.read<BlogProvider>().loadSearchedBlogs(_currentQuery);
      }
    });
  }

  void _onSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.length > 3) {
      setState(() => _currentQuery = trimmed);
      context.read<BlogProvider>().resetAndFetchSearchBlogs(trimmed);
    } else {
      setState(() => _currentQuery = "");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = context.watch<BlogProvider>();
    final showResults =
        _currentQuery.isNotEmpty || blogProvider.searchedblogs.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusnode,
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                style: TextStyle(
                  fontFamily: 'CrimsonText-Bold',
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search Here...',
                  hintStyle: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  suffixIcon: _isFocused
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _currentQuery = "";
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
                onChanged: _onSearch,
                onSubmitted: _onSearch,
              ),
            ),
          )
        ],
      ),
      body: showResults
          ? blogProvider.searchloading && blogProvider.searchedblogs.isEmpty
              ? Center(child: Shimmerloading(context))
              : RefreshIndicator(
                  onRefresh: () async {
                    if (_currentQuery.isNotEmpty) {
                      await context
                          .read<BlogProvider>()
                          .resetAndFetchSearchBlogs(_currentQuery);
                    }
                  },
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      BlogListSection(
                        blogs: blogProvider.searchedblogs,
                        isLoading: blogProvider.searchloading,
                      ),
                      if (blogProvider.searchloading)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                    ],
                  ),
                )
          : Center(
              child: Text(
                'Search For Blogs',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'CrimsonText-Bold',
                ),
              ),
            ),
    );
  }
}
