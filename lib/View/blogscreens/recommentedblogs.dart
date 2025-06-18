import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/widgets/bloglistview.dart';
import 'package:inkbloom/widgets/shimmer.dart';
import 'package:provider/provider.dart';

class RecommentedBlogs extends StatefulWidget {
  const RecommentedBlogs({super.key});

  @override
  State<RecommentedBlogs> createState() => _RecommentedBlogsState();
}

class _RecommentedBlogsState extends State<RecommentedBlogs> {
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
      body: blogprovider.isLoading
          ? Center(child: Shimmerloading(context))
          : RefreshIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              onRefresh: blogprovider.refreshuserpref,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    BlogListSection(
                      blogs: context.watch<BlogProvider>().userprefblogs,
                      isLoading: context.watch<BlogProvider>().isLoading,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
