import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:movieflix/core/repository.dart';
import 'package:movieflix/features/searhScreen/search_screen.dart';

import '../../widgets/horizontal_slider_with_title.dart';
import '../Details Screen /DetailScreen.dart';
import 'models/datamodel.dart';

class HomeScreen extends StatefulWidget {
  static const String path = "/home-screen";

  const HomeScreen({super.key});

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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ));
          },
          backgroundColor: const Color.fromARGB(255, 46, 45, 45),
          child: const Icon(
            Icons.search,
            color: Colors.red,
          )),
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
                SizedBox(height: .05 * screenHeight),
                const HorizontalSliderWithTitle(
                  title: "Now Playing",
                ),
                SizedBox(height: .05 * screenHeight),
                const HorizontalSliderWithTitle(
                  title: "Top Rated Movies",
                ),
                const HorizontalSliderWithTitle(
                  title: "Upcoming Movies",
                ),
                SizedBox(height: .05 * screenHeight),
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
        /// set error
      },
    );
  }
}
