import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/ViewModel/themeprovider.dart';
import 'package:inkbloom/test.dart';

import 'package:inkbloom/widgets/bloglistview.dart';
import 'package:lottie/lottie.dart';
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
    _searchController = TextEditingController(); // ✅ Initialize first

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusnode.requestFocus();
    });

    _focusnode.addListener(() {
      setState(() {
        _isFocused = _focusnode.hasFocus;
      });
    });

    super.initState(); // ✅ Call this last
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<ThemeProvider>(context);
    final blogProvider = context.watch<BlogProvider>();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          // title: AnimSearchBar(
          //   searchIconColor:
          //       themeprovider.isDarkMode ? Colors.white : Colors.black,
          //   textFieldColor: themeprovider.isDarkMode
          //       ? Colors.grey.shade800
          //       : Colors.grey.shade200,
          //   boxShadow: false,
          //   color: themeprovider.isDarkMode ? Colors.black : Colors.white,
          //   width: MediaQuery.of(context).size.width * 0.8,
          //   textController: _searchController,
          //   onSuffixTap: () {
          //     setState(() {
          //       _searchController.clear();
          //     });
          //   },

          //   closeSearchOnSuffixTap: true,
          //   helpText: 'Search blogs...',
          //   animationDurationInMilli: 300,
          //   autoFocus: true,
          // ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                width: 300,
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'CrimsonText-Bold',
                  ),
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  focusNode: _focusnode,
                  controller: _searchController,
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
                ? Center(child: buildShimmerList())
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
