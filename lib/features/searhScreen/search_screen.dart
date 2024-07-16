import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieflix/core/repository.dart';

import '../Details Screen /DetailScreen.dart';
import '../home_screen/models/datamodel.dart';

class SearchScreen extends StatefulWidget {
  static const String path = "/search-screen";

  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Result> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _searchMovies(_searchController.text);
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _searchMovies(String query) async {
    // Call your API to search for movies
    // For demonstration purposes, I'll use a dummy data
    List<Result> results = await DataRepository.i.searchMovies(query);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: "Search for a movie or TV show",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            _searchResults.isEmpty
                ? Center(child: Text("No results found"))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => DetailScreen(
                              result: _searchResults[index],
                            ),
                          ),
                        ),
                        child: Card(
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w300${_searchResults[index].posterPath}',
                                fit: BoxFit.cover,
                              ),
                              Text(
                                _searchResults[index].title!,
                                style: GoogleFonts.openSans(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
