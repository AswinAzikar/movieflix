import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movieflix/features/home_screen/models/datamodel.dart';

import '../features/Details Screen /DetailScreen.dart';

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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
      ),
      scrollDirection: Axis.vertical,
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<Result>(
        itemBuilder: (context, item, index) {
          final imageUrl = item.backdropPath != null
              ? 'https://image.tmdb.org/t/p/w500${item.backdropPath}'
              : null;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(result: item),
                ),
              );
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
                        child: imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Container(
                                color: Colors.grey,
                                child: const Center(
                                  child: Icon(Icons.image_not_supported),
                                ),
                              ), // Placeholder widget
                      ),
                    ),
                  ),
                  Text(item.title ?? 'No Title')
                ],
              ),
            ),
          );
        },
        noItemsFoundIndicatorBuilder: (context) =>
            const Center(child: Text('No movies found')),
        firstPageErrorIndicatorBuilder: (context) =>
            const Center(child: Text('Error loading movies. Please try again')),
      ),
    );
  }
}
