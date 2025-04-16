import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/blogdetail.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';

class HorizontalBlogList extends StatelessWidget {
  final List<BlogModel> blogs;
  final bool isLoading;

  const HorizontalBlogList({
    Key? key,
    required this.blogs,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: blogs.map((blog) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetail(blog: blog),
                    ));
              },
              child: Container(
                height: 180,
                width: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: NetworkImage(blog.imageUrl ??
                        'https://as1.ftcdn.net/v2/jpg/05/03/24/40/1000_F_503244059_fRjgerSXBfOYZqTpei4oqyEpQrhbpOML.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Text(
                    blog.title ?? 'No Title',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/*
HorizontalBlogList(
  blogs: context.watch<BlogProvider>().filteredblogs,
  isLoading: context.watch<BlogProvider>().isLoading,
)


*/
