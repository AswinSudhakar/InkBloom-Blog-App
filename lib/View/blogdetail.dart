import 'package:flutter/material.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/View/blogscreens/home2.dart';

class BlogDetail extends StatelessWidget {
  BlogModel blog;
  BlogDetail({super.key, required this.blog});

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
          ],
        ),
      ),
    );
  }
}
