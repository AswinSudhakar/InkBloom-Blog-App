import 'package:flutter/material.dart';
import 'package:inkbloom/View/additionalscreen/authordetails.dart';
import 'package:inkbloom/View/blogscreens/editblog.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';
import 'package:inkbloom/service/userprofile.dart';
import 'package:inkbloom/View/widgets/expandabletext.dart';
import 'package:inkbloom/View/widgets/toastmessage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogDetail extends StatefulWidget {
  final BlogModel blog;

  const BlogDetail({super.key, required this.blog});

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  bool isClicked = false;
  String? name;
  String? email;
  String? avatar;

  Future<void> fetchAndLoadUserData() async {
    await ProfileService().getUserProfile();
    await _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        name = prefs.getString('name') ?? "Guest";
        email = prefs.getString('email') ?? "No Email";
        avatar = prefs.getString('avatar') ?? "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndLoadUserData();
    final blogProvider = context.read<BlogProvider>();
    isClicked =
        blogProvider.favoriteBlogs.any((blog) => blog.id == widget.blog.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottomNavigationBar: (widget.blog.author == name ||
                widget.blog.author == email)
            ? SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBlog(blog: widget.blog),
                            ));
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        final success = await Provider.of<BlogProvider>(context,
                                listen: false)
                            .Deleteblog(widget.blog);

                        if (success == true) {
                          if (mounted) {
                            Navigator.pop(context);

                            CustomToastMessagee.show(
                                message: 'Blog Deleted Successfully',
                                color: Colors.red);
                          }
                        } else {
                          CustomToastMessagee.show(
                              message: 'Failed to delete blog',
                              color: Colors.red);
                        }
                      },
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Created at: ${widget.blog.createdAt!.split('T').first}',
                            ),
                            width: 300,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.info),
                    )
                  ],
                ),
              )
            : null,
        body: Stack(
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Image.network(
                widget.blog.imageUrl?.isNotEmpty == true
                    ? widget.blog.imageUrl!
                    : 'https://th.bing.com/th/id/OIP.etbTey4SJkpyu9XPJZSxTAHaHa?w=164&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: Center(
                      child: Icon(Icons.broken_image,
                          size: 60, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.60,
              minChildSize: 0.60,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
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
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Wrap(
                          children: [
                            Text(
                              '${widget.blog.title}',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontFamily: 'Tagesschrift-Regular'),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.4),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: double.infinity,
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  // onTap: () {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => AuthorProfle(
                                  //           blog: widget.blog,
                                  //         ),
                                  //       ));
                                  // },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: widget.blog.avatar !=
                                                null
                                            ? NetworkImage(widget.blog.avatar!)
                                            : NetworkImage(
                                                "https://th.bing.com/th/id/OIP.rcmXeqCUOiCg54dfU4v9tgHaHa?rs=1&pid=ImgDetMain"),
                                        radius: 15,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Author: ${widget.blog.author}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontFamily:
                                                'CrimsonText-SemiBoldItalic',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                "Read Time: ${widget.blog.readTime} Min",
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontFamily: 'CrimsonText-SemiBoldItalic',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),

                        StepwiseExpandableText(
                          text: widget.blog.content!,
                          linesPerStep: 15,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              left: 20,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: Icon(
                    isClicked ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    final blogProvider = context.read<BlogProvider>();

                    if (isClicked) {
                      final removed =
                          await blogProvider.deleteFromFav(widget.blog.id!);
                      if (removed == true) {
                        if (mounted) {
                          setState(() {
                            isClicked = false;
                          });
                        }
                        if (mounted) {
                          CustomToastMessagee.show(
                            message: 'Removed from favorites',
                          );
                        }
                      }
                    } else {
                      await blogProvider.addToFavorite(widget.blog.id!);
                      if (mounted) {
                        setState(() {
                          isClicked = true;
                        });
                      }
                      if (mounted) {
                        CustomToastMessagee.show(
                          message: 'Added to favorites',
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
