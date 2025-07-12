import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';

import 'package:inkbloom/View/widgets/bloglistview.dart';
import 'package:inkbloom/View/widgets/shimmer.dart';

import 'package:provider/provider.dart';

class Myblogs extends StatefulWidget {
  const Myblogs({super.key});

  @override
  State<Myblogs> createState() => _MyBlogState();
}

class _MyBlogState extends State<Myblogs> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).loadMyBlogs();
    });

    _scrollController.addListener(() {
      final provider = Provider.of<BlogProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          provider.myhasMore &&
          !provider.isloadingMy) {
        provider.loadMyBlogs();
      }
    });

    super.initState();
  }

  Future<void> _handleRefresh(BuildContext context) {
    return Provider.of<BlogProvider>(context, listen: false)
        .loadMyBlogs(reset: true);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final blogprovider = Provider.of<BlogProvider>(context);

    final myblogs = blogprovider.myBlogs;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Blogs',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              fontFamily: 'CrimsonText-Bold'),
        ),
      ),
      body: blogprovider.isLoading
          ? Center(child: Shimmerloading(context))
          : RefreshIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              onRefresh: () => _handleRefresh(context),
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 30),
                children: [
                  BlogListSection(
                      blogs: myblogs,
                      isLoading: blogprovider.isloadingMy,
                      showloaderatbottom: blogprovider.myBlogs.isNotEmpty &&
                          blogprovider.myhasMore &&
                          blogprovider.isloadingMy),
                ],
              ),
            ),
    );
  }
}
