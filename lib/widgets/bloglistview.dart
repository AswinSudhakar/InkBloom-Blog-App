import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/blogdetail.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';

class BlogListSection extends StatelessWidget {
  final List<BlogModel> blogs;
  final bool isLoading;
  final bool isScrollable;
  final void Function(BlogModel blog)? onTap;

  const BlogListSection({
    Key? key,
    required this.blogs,
    this.isLoading = false,
    this.isScrollable = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (blogs.isEmpty) {
      return const Center(child: Text('No blogs found'));
    }

    return ListView.builder(
      shrinkWrap: !isScrollable,
      physics: isScrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];

        return InkWell(
          onTap: () => onTap != null
              ? onTap!(blog)
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogDetail(blog: blog),
                  ),
                ),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 180,
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      blog.imageUrl ??
                          'https://as1.ftcdn.net/v2/jpg/05/03/24/40/1000_F_503244059_fRjgerSXBfOYZqTpei4oqyEpQrhbpOML.jpg',
                      height: double.infinity,
                      width: 110,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          blog.title ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          blog.content ?? '',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Readtime: ${blog.readTime}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/*
BlogListSection(
  blogs: context.read<BlogProvider>().blogs,
  isLoading: context.watch<BlogProvider>().isLoading,
)



BlogListSection(
  blogs: context.watch<BlogProvider>().filteredBlogs,
  isLoading: false,
)



BlogListSection(
  blogs: provider.filteredBlogs,
  onTap: (blog) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(blog.title ?? ''),
        content: Text("Custom action here"),
      ),
    );
  },
)


*/
