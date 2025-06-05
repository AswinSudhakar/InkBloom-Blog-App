import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/mainhome.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/widgets/bloglistview.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlogProvider>(context, listen: false).getfavBlogs();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blogprovider = Provider.of<BlogProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Mainhome(),
                ));
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text(
          'Favourites',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              fontFamily: 'CrimsonText-Bold'),
        ),
      ),
      body: blogprovider.isLoading
          ? Center(
              child: Lottie.asset(
              'assets/animations/lottieeee.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ))
          : Container(
              child: RefreshIndicator(
                onRefresh: blogprovider.refreshfavoriites,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      BlogListSection(
                        blogs: context.watch<BlogProvider>().favoriteBlogs,
                        isLoading: context.watch<BlogProvider>().isLoading,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
