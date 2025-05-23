import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/blogdetail.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';

class BlogListSection extends StatelessWidget {
  final List<BlogModel> blogs;
  final bool isLoading;
  final bool isScrollable;
  final void Function(BlogModel blog)? onTap;

  const BlogListSection({
    super.key,
    required this.blogs,
    this.isLoading = false,
    this.isScrollable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (blogs.isEmpty) {
      return const Center(
        child: Text(
          'No blogs found',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
      );
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
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 190,
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Image.network(
                          blog.imageUrl ??
                              'https://as1.ftcdn.net/v2/jpg/05/03/24/40/1000_F_503244059_fRjgerSXBfOYZqTpei4oqyEpQrhbpOML.jpg',
                          height: double.infinity,
                          width: 120,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 120,
                              color: Colors.grey[300],
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2)),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image,
                                  size: 40, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${blog.readTime ?? 'N/A'} Min Read',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            blog.title ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CrimsonText-Bold',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            blog.content ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'CrimsonText-SemiBoldItalic',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.article_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Tap to read more',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
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

// import 'package:flutter/material.dart';
// import 'package:inkbloom/View/blogscreens/blogdetail.dart';
// import 'package:inkbloom/models/blog/blogmodel.dart';

// class BlogListSection extends StatelessWidget {
//   final List<BlogModel> blogs;
//   final bool isLoading;
//   final bool isScrollable;
//   final void Function(BlogModel blog)? onTap;

//   const BlogListSection({
//     super.key,
//     required this.blogs,
//     this.isLoading = false,
//     this.isScrollable = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (blogs.isEmpty) {
//       return const Center(
//           child: Text(
//         'No blogs found',
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
//       ));
//     }

//     return ListView.builder(
//       shrinkWrap: !isScrollable,
//       physics: isScrollable
//           ? const BouncingScrollPhysics()
//           : const NeverScrollableScrollPhysics(),
//       itemCount: blogs.length,
//       itemBuilder: (context, index) {
//         final blog = blogs[index];

//         return InkWell(
//           onTap: () => onTap != null
//               ? onTap!(blog)
//               : Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BlogDetail(blog: blog),
//                   ),
//                 ),
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Container(
//               height: 180,
//               padding: const EdgeInsets.all(15),
//               child: Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       blog.imageUrl ??
//                           'https://as1.ftcdn.net/v2/jpg/05/03/24/40/1000_F_503244059_fRjgerSXBfOYZqTpei4oqyEpQrhbpOML.jpg',
//                       height: double.infinity,
//                       width: 110,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           blog.title ?? 'No Title',
//                           style: const TextStyle(
//                               fontSize: 26,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'CrimsonText-Bold'),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           blog.content ?? '',
//                           maxLines: 3,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontFamily: 'CrimsonText-SemiBoldItalic',
//                             fontSize: 18,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           'Readtime: ${blog.readTime} Min',
//                           style: TextStyle(
//                             fontFamily: 'CrimsonText-SemiBoldItalic',
//                             fontSize: 17,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

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
