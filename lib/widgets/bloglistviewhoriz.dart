import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/blogdetail.dart';
import 'package:inkbloom/models/blog/blogmodel.dart';

class HorizontalBlogList extends StatelessWidget {
  final List<BlogModel> blogs;
  final bool isLoading;

  const HorizontalBlogList({
    super.key,
    required this.blogs,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (blogs.isEmpty) {
      return const Center(
        child: Text(
          'No blogs available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: blogs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final blog = blogs[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogDetail(blog: blog),
                ),
              );
            },
            child: Container(
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        blog.imageUrl ??
                            'https://as1.ftcdn.net/v2/jpg/05/03/24/40/1000_F_503244059_fRjgerSXBfOYZqTpei4oqyEpQrhbpOML.jpg',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image,
                                size: 40, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.65),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Text(
                        blog.title ?? 'No Title',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'CrimsonText-Bold',
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black54,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:inkbloom/View/blogscreens/blogdetail.dart';
// import 'package:inkbloom/models/blog/blogmodel.dart';

// class HorizontalBlogList extends StatelessWidget {
//   final List<BlogModel> blogs;
//   final bool isLoading;

//   const HorizontalBlogList({
//     super.key,
//     required this.blogs,
//     required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: blogs.map((blog) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BlogDetail(blog: blog),
//                     ));
//               },
//               child: Container(
//                 height: 180,
//                 width: 230,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   color: Colors.grey[300],
//                   image: DecorationImage(
//                     image: NetworkImage(blog.imageUrl ??
//                         'https://as1.ftcdn.net/v2/jpg/05/03/24/40/1000_F_503244059_fRjgerSXBfOYZqTpei4oqyEpQrhbpOML.jpg'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   alignment: Alignment.bottomLeft,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     gradient: LinearGradient(
//                       colors: [Colors.black54, Colors.transparent],
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                     ),
//                   ),
//                   child: Text(
//                     blog.title ?? 'No Title',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       fontFamily: 'CrimsonText-Bold',
//                       shadows: [Shadow(blurRadius: 4, color: Colors.black)],
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// /*
// HorizontalBlogList(
//   blogs: context.watch<BlogProvider>().filteredblogs,
//   isLoading: context.watch<BlogProvider>().isLoading,
// )


// */
