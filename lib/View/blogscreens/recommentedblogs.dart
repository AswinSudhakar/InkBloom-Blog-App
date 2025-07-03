import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/View/widgets/bloglistview.dart';
import 'package:inkbloom/View/widgets/shimmer.dart';
import 'package:provider/provider.dart';

class RecommentedBlogs extends StatefulWidget {
  const RecommentedBlogs({super.key});

  @override
  State<RecommentedBlogs> createState() => _RecommentedBlogsState();
}

class _RecommentedBlogsState extends State<RecommentedBlogs> {
  ScrollController _scrollController = ScrollController();
  final blogprovider = BlogProvider();
  @override
  void initState() {
    final provider = Provider.of<BlogProvider>(context, listen: false);
    provider.loadRecommentedblogs();

    _scrollController.addListener(() {
      final provider = Provider.of<BlogProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          provider.myhasMore &&
          !provider.isloadingMy) {
        provider.loadRecommentedblogs();
      }
    });
    super.initState();
  }

  Future<void> _handleRefresh(BuildContext context) {
    return Provider.of<BlogProvider>(context, listen: false)
        .loadRecommentedblogs(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final blogprovider = Provider.of<BlogProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Recommented Blogs',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              fontFamily: 'CrimsonText-Bold'),
        ),
      ),
      body: blogprovider.loadingRec
          ? Center(child: Shimmerloading(context))
          : RefreshIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              onRefresh: () => _handleRefresh(context),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    BlogListSection(
                      blogs: context.watch<BlogProvider>().recBlogs,
                      isLoading: context.watch<BlogProvider>().loadingRec,
                      showloaderatbottom: blogprovider.rechasmore,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
