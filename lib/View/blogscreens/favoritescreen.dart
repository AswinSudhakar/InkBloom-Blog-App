import 'package:flutter/material.dart';
import 'package:inkbloom/View/blogscreens/mainhome.dart';
import 'package:inkbloom/ViewModel/blogprovider.dart';
import 'package:inkbloom/View/widgets/bloglistview.dart';
import 'package:inkbloom/View/widgets/shimmer.dart';
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
      Provider.of<BlogProvider>(context, listen: false).refreshfavoriites();
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
        body: blogprovider.favoriteBlogs.isNotEmpty
            ? blogprovider.isLoading
                ? Center(child: Shimmerloading(context))
                : SizedBox(
                    child: RefreshIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      onRefresh: blogprovider.refreshfavoriites,
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height -
                                kToolbarHeight,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              BlogListSection(
                                blogs:
                                    context.watch<BlogProvider>().favoriteBlogs,
                                isLoading:
                                    context.watch<BlogProvider>().isLoading,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
            : RefreshIndicator(
                onRefresh: blogprovider.refreshfavoriites,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - kToolbarHeight,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/favorites.json',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No Favorites Found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'CrimsonText-Bold',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
