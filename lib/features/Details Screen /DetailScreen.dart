import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieflix/core/firestore_service.dart';
import 'package:movieflix/exporter.dart';
import 'package:movieflix/widgets/watchlistbutton.dart';

import '../../widgets/chip_labels.dart';
import '../home_screen/models/datamodel.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.result});

  final Result result;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isInwatchList = false;
  bool _isInwatchedList = false;

  @override
  void initState() {
    super.initState();

    FirestoreService.checkInWatchList(widget.result.id!).then(
      (value) {
        _isInwatchList = value;
        _isInwatchedList = false;
        setState(() {});
      },
    );
    FirestoreService.checkInWatchedList(widget.result.id!).then(
      (value) {
        _isInwatchedList = value;
        _isInwatchList = false;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;
    print(_isInwatchList);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            child: Column(
              children: [
                Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1.0,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: CachedNetworkImage(
                          filterQuality: FilterQuality.high,
                          alignment: Alignment.topCenter,
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${widget.result.backdropPath}',
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.95),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color.fromARGB(255, 204, 204, 204),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.result.title!,
                              style: TextStyle(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.result.originalTitle != widget.result.title
                                  ? 'Also known as : ${widget.result.originalTitle}'
                                  : " ",
                              style: TextStyle(
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 0.04 * screenHeight),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenreChipsWidget(genreIds: widget.result.genreIds ?? []),
                      SizedBox(height: 0.04 * screenHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Builder(builder: (context) {
                            if (_isInwatchList) {
                              return TextButton.icon(
                                onPressed: () {},
                                label: Text(
                                  "Added to watch list",
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: Icon(Icons.done, color: Colors.green),
                              );
                            }
                            return WatchlistButton(
                                icon: Icons.favorite,
                                text: 'Add to watch list',
                                onPressed: () {
                                  FirestoreService.addMovieToWatchlist(
                                          widget.result)
                                      .then(
                                    (value) {
                                      logSuccess(value);
                                      setState(() {
                                        _isInwatchList = true;
                                        _isInwatchedList = false;
                                      });
                                    },
                                  );
                                });
                          }),
                          SizedBox(width: 0.01 * screenWidth),
                          Builder(builder: (context) {
                            if (_isInwatchedList) {
                              return TextButton.icon(
                                onPressed: () {},
                                label: Text(
                                  "Added to watched list",
                                  style: TextStyle(color: Colors.white),
                                ),
                                icon: Icon(Icons.done, color: Colors.green),
                              );
                            }
                            return WatchlistButton(
                                icon: Icons.visibility,
                                text: 'Add to watched list',
                                onPressed: () {
                                  FirestoreService.addMovieToWatchedlist(
                                          widget.result)
                                      .then(
                                    (value) {
                                      logSuccess(value);
                                      setState(() {
                                        _isInwatchedList = true;
                                        _isInwatchList = false;
                                      });
                                    },
                                  );
                                });
                          })
                        ],
                      ),
                      SizedBox(height: 0.04 * screenHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Votings : ",
                            style: TextStyle(
                                fontFamily:
                                    GoogleFonts.montserrat().fontFamily),
                          ),
                          RatingBar.builder(
                            ignoreGestures: true,
                            itemSize: 30,
                            glow: true,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (double value) {},
                            initialRating: widget.result.voteAverage! / 2,
                            minRating: 0.5,
                            allowHalfRating: true,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.03 * screenHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Popularity : ",
                            style: TextStyle(
                                fontFamily:
                                    GoogleFonts.montserrat().fontFamily),
                          ),
                          RatingBar.builder(
                            itemSize: 30,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (double value) {},
                            initialRating: widget.result.popularity! / 200,
                            ignoreGestures: true,
                            minRating: 0.5,
                            allowHalfRating: true,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.03 * screenHeight),
                      Text(
                        "Description : ",
                        style: TextStyle(
                            fontFamily: GoogleFonts.montserrat().fontFamily),
                      ),
                      SizedBox(height: 0.03 * screenHeight),
                      Row(
                        children: [
                          Expanded(child: Text(widget.result.overview!))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
