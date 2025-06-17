import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/widgets/bloglistview.dart';
import 'package:provider/provider.dart';

class AuthorProfle extends StatefulWidget {
  final BlogModel blog;
  const AuthorProfle({super.key, required this.blog});

  @override
  State<AuthorProfle> createState() => _AuthorProfleState();
}

class _AuthorProfleState extends State<AuthorProfle> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).blogs;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          CircleAvatar(
            radius: 60,
            backgroundImage: widget.blog.avatar != null
                ? NetworkImage(widget.blog.avatar!)
                : NetworkImage(
                    '{https://static.vecteezy.com/system/resources/previews/014/194/232/original/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg}'),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${widget.blog.author}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'CrimsonText-Bold'),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: Card(
            elevation: 7,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'blogs of ${widget.blog.author}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'CrimsonText-Bold'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BlogListSection(
                    blogs: context
                        .watch<BlogProvider>()
                        .getMyBlogs(widget.blog.author ?? 'Unknown'),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
