import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/widgets/bloglistview.dart';
import 'package:inkbloom/widgets/shimmer.dart';
import 'package:provider/provider.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  late TextEditingController _searchController;
  FocusNode _focusnode = FocusNode();
  bool _isFocused = false;
  bool hassearched = false;

  @override
  void initState() {
    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusnode.requestFocus();
    });

    _focusnode.addListener(() {
      setState(() {
        _isFocused = _focusnode.hasFocus;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = context.watch<BlogProvider>();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 40,
                width: 300,
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  focusNode: _focusnode,
                  controller: _searchController,
                  onChanged: (query) {
                    if (query.length > 3) {
                      setState(() {
                        hassearched = true;
                      });
                      Provider.of<BlogProvider>(context, listen: false)
                          .SearchBlogs(query);
                    } else {
                      setState(() {
                        hassearched = false;
                      });
                    }
                  },
                  onSubmitted: (query) {
                    setState(() {
                      hassearched = true;
                    });
                    if (query.trim().isNotEmpty) {
                      Provider.of<BlogProvider>(context, listen: false)
                          .SearchBlogs(query);
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Search Here...',
                      hintStyle: TextStyle(
                        fontFamily: 'CrimsonText-Bold',
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      suffixIcon: _isFocused
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder()),
                ),
              ),
            )
          ],
        ),
        body: hassearched
            ? blogProvider.isLoading
                ? Center(child: Shimmerloading(context))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        BlogListSection(
                          blogs: blogProvider.searchedblogs,
                          isLoading: blogProvider.isLoading,
                        ),
                      ],
                    ),
                  )
            : Center(
                child: Text(
                'Search For Blogs',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'CrimsonText-Bold',
                ),
              )));
  }
}
