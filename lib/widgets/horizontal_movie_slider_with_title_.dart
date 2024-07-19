import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movieflix/core/repository.dart';

import '../features/Details Screen /DetailScreen.dart';
import '../features/home_screen/models/moviedatamodel.dart';

class HorizontalSliderWithTitleforMovies extends StatefulWidget {
  const HorizontalSliderWithTitleforMovies(
      {super.key, required this.title});

  final String title;

  @override
  State<HorizontalSliderWithTitleforMovies> createState() =>
      _HorizontalSliderWithTitleforMoviesState();
}

class _HorizontalSliderWithTitleforMoviesState extends State<HorizontalSliderWithTitleforMovies> {
  late int page;
  late String sectionName;

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  final PagingController<int, Result> pagingController =
      PagingController(firstPageKey: 1);

  Future<void> fetchPage(int pageKey) async {
    final dynamic items;
    
      items = await DataRepository.i.fetchMovies(pageKey, widget.title);
  
    if (items.length < 20) {
      pagingController.appendLastPage(items);
    } else {
      pagingController.appendPage(items, pageKey + 1);
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontFamily: GoogleFonts.montserrat().fontFamily,
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: PagedListView<int, Result>(
            scrollDirection: Axis.horizontal,
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<Result>(
              itemBuilder: (context, item, index) {
                final imageUrl =
                    'https://image.tmdb.org/t/p/w500${item.posterPath}';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(result: item)));
                  },
                  child: AspectRatio(
                    aspectRatio: .7,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Text(item.title ?? "")
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
