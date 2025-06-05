import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/ViewModel/userprovider.dart';

import 'package:inkbloom/widgets/bloglistview.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Myblogs extends StatefulWidget {
  const Myblogs({super.key});

  @override
  State<Myblogs> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<Myblogs> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final blogprovider = Provider.of<BlogProvider>(context);
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
          ? Center(
              child: Lottie.asset(
              'assets/animations/lottieeee.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ))
          : SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    BlogListSection(
                      blogs: context
                          .watch<BlogProvider>()
                          .getMyBlogs(userProvider.name ?? 'Unknown'),
                      isLoading: context.watch<BlogProvider>().isLoading,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
