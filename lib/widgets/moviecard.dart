import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieflix/core/firestore_service.dart';

import '../features/home_screen/models/datamodel.dart';

class MovieCard extends StatelessWidget {
  final Result movie;

  final String collection;

  static const String placeHolderImage = 'https://via.placeholder.com/150';
  static const String baseUrl = 'https://image.tmdb.org/t/p/w500';

  const MovieCard({super.key, required this.movie, required this.collection});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 0.1 * screenWidth),
            Icon(Icons.delete),
            Text("Delete"),
          ],
        ),
      ),
      onDismissed: (DismissDirection direction) {
        print('direction: $direction');
        FirestoreService.removeMovieFromlist(movie.id!, collection);
      },
      secondaryBackground: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete),
            Text("Delete"),
            SizedBox(width: 0.1 * screenWidth),
          ],
        ),
      ),
      key: Key(
        movie.id.toString(),
      ),
      // child: ClipRRect(
      //     borderRadius: BorderRadius.circular(), child: Placeholder()),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: InkWell(
            splashColor: Colors.grey.withOpacity(0.5),
            onTap: () {
              debugPrint('Card tapped1.');
            },
            child: SizedBox(
              width: double.infinity,
              height: screenHeight * 0.19,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CachedNetworkImage(
                      height: screenHeight * 0.19,
                      imageUrl: '$baseUrl/${movie.posterPath}',
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  movie.title ?? movie.originalTitle ?? "",
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Text(
                                "Votings: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: movie.voteAverage! / 2,
                                minRating: 0.5,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (double value) {},
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Popularity: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: movie.popularity! / 2,
                                minRating: 0.5,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (double value) {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
