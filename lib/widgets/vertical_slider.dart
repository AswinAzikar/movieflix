import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movieflix/core/repository.dart';

import '../features/Details Screen /DetailScreen.dart';
import '../features/home_screen/models/datamodel.dart';

class VerticalSlider extends StatefulWidget {
  const VerticalSlider({
    super.key,
    required this.pagingController,
  });
  final PagingController<int, Result> pagingController;

  @override
  State<VerticalSlider> createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, Result>(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
      ),
      scrollDirection: Axis.vertical,
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<Result>(
        itemBuilder: (context, item, index) {
          final imageUrl = 'https://image.tmdb.org/t/p/w500${item.posterPath}';
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
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
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
    );
  }
}
