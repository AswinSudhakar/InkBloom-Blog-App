import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/editblog.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';

import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:provider/provider.dart';

class BlogDetail extends StatelessWidget {
  final BlogModel blog;
  const BlogDetail({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background Image Section
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Image.network(
                blog.imageUrl?.isNotEmpty == true
                    ? blog.imageUrl!
                    : 'https://th.bing.com/th/id/OIP.etbTey4SJkpyu9XPJZSxTAHaHa?w=164&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
                fit: BoxFit.cover,
              ),
            ),

            // Scrollable Foreground
            DraggableScrollableSheet(
              initialChildSize:
                  0.60, // how much of the screen it covers initially
              minChildSize: 0.60,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController, // important!
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${blog.title}',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Author & Read Time
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.4),
                              borderRadius: BorderRadius.circular(20)),
                          width: double.infinity,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Author: ${blog.author}"),
                              Text("Read Time: ${blog.readTime}"),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),

                        // Content
                        Text(
                          '${blog.content}',
                          style: TextStyle(fontSize: 16, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Optional Back Button on top
            Positioned(
              top: 40,
              left: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Color.fromARGB(128, 0, 0, 0),
                child: IconButton(
                  icon: Icon(Icons.favorite, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),

            Positioned(
                bottom: 40,
                left: 40,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(.4)),
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBlog(blog: blog),
                              ));
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          final success = await Provider.of<BlogProvider>(
                                  context,
                                  listen: false)
                              .Deleteblog(blog);

                          if (success!) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Blog deleted successfully')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete blog')),
                            );
                          }
                        },
                        icon: Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Created at: ${blog.createdAt!.split('T').first}'),
                          ));

                          SnackBarBehavior.floating;
                        },
                        icon: Icon(Icons.info),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
