import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/widgets/bloglistview.dart';
import 'package:provider/provider.dart';

class AuthorProfle extends StatefulWidget {
  final blog;
  AuthorProfle({super.key, required this.blog});

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
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
                'https://static.vecteezy.com/system/resources/previews/014/194/232/original/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg'),
          ),
          Text('${widget.blog.author}'),
          SizedBox(
            height: 40,
          ),
          Expanded(
              child: Column(
            children: [
              BlogListSection(
                blogs:
                    context.watch<BlogProvider>().getMyBlogs(null ?? 'Unknown'),
              )
            ],
          ))
        ],
      ),
    );
  }
}
