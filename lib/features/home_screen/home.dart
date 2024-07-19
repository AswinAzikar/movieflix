import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:movieflix/core/repository.dart';
import '../../widgets/horizontal_movie_slider_with_title_.dart';
import '../Details Screen /DetailScreen.dart';
import '../searhScreen/search_screen.dart';
import '../watch_ list_screen/watch_list.dart';
import '../watched_list/watched_list.dart';
import 'models/moviedatamodel.dart';

class HomeScreen extends StatefulWidget {
  static const String path = "/home-screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  CarouselController carouselController = CarouselController();
  List<Result> trending = [];

  int offset = 1;
  int toprated_offset = 1;
  int currentPage = 1;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchForUI(offset);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          "assets/appicon/logo.png",
          height: 140,
          width: 140,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        elevation: 2,
        backgroundColor: Colors.transparent,
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                    Image.asset(
                      "assets/appicon/logo.png",
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "MovieFlix",
                      style: TextStyle(
                        color: Colors.transparent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.red,
                ),
                title:
                    const Text("Home", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.search, color: Colors.red),
                title:
                    const Text("Search", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushNamed(context, SearchScreen.path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove_red_eye, color: Colors.red),
                title: const Text("Watched list",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushNamed(context, WatchedList.path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: const Text("Watch list",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushNamed(context, WatchList.path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.movie, color: Colors.red),
                title:
                    const Text("Movies", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pushNamed(context, HomeScreen.path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.tv, color: Colors.red),
                title: const Text("TV Shows",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate to TV shows screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.red),
                title: const Text("Settings",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate to settings screen
                },
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          fetchForUI(1);
        },
        child: Builder(builder: (context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth * 0.1,
                ),
                trending.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        child: CarouselSlider.builder(
                          carouselController: carouselController,
                          itemCount: trending.length,
                          options: CarouselOptions(
                            aspectRatio: 1,
                            autoPlay: true,
                            viewportFraction: 0.6,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            autoPlayAnimationDuration:
                                const Duration(seconds: 1),
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentPage = index;
                              });
                              if (index == trending.length - 1) {
                                fetchForUI(offset);
                              }
                            },
                          ),
                          itemBuilder: (context, index, realIndex) {
                            final imageUrl =
                                'https://image.tmdb.org/t/p/w300${trending[index].posterPath}';
                            return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => DetailScreen(
                                    result: trending[index],
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Center(
                                      child: Text(
                                        trending[index].title!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                SizedBox(height: 0.05 * screenHeight),
                const HorizontalSliderWithTitleforMovies(
                  title: "Now Playing",
                ),
                SizedBox(height: 0.05 * screenHeight),
                const HorizontalSliderWithTitleforMovies(
                  title: "Top Rated Movies",
                ),
                const HorizontalSliderWithTitleforMovies(
                  title: "Upcoming Movies",
                ),
                SizedBox(height: 0.05 * screenHeight),
              ],
            ),
          );
        }),
      ),
    );
  }

  void fetchForUI(int offset) {
    DataRepository.i.fetchTrending(offset).then(
      (value) {
        setState(() {
          trending.addAll(value!.results!);
          isLoading = false;
        });
      },
    ).onError(
      (error, stackTrace) {
        // Handle error
      },
    );
  }
}
