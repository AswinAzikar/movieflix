import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movieflix/core/repository.dart';
import 'package:movieflix/exporter.dart';
import 'package:movieflix/mixins/search_mixin.dart';
import 'package:movieflix/widgets/vertical_slider.dart';
import '../home_screen/models/datamodel.dart';

class SearchScreen extends StatefulWidget {
  static const String path = "/search-screen";

  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SearchMixin {
  final PagingController<int, Result> pagingController =
      PagingController(firstPageKey: 1);
  @override
  void initState() {
    super.initState();
    addSearchListener(() {
      pagingController.value = PagingState();
      pagingController.refresh();
    });
    pagingController.addPageRequestListener(
      (pageKey) {
        _searchMovies(searchController.text, pageKey);
      },
    );
  }

  @override
  void dispose() {
    removeSearchListener();
    super.dispose();
  }

  Future<void> _searchMovies(String query, int pageKey) async {
    final items = await DataRepository.i.searchMovies(query, pageKey);

    if (items.length != 20) {
      pagingController.appendLastPage(items);
      logError("succcess last page");
    } else {
      pagingController.appendPage(items, pageKey + 1);
    }
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
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: "Search for a movie or TV show",
                border: OutlineInputBorder(),
              ),
            ),
            // SizedBox(height: 16),
            Expanded(child: VerticalSlider(pagingController: pagingController))
          ],
        ),
      ),
    );
  }
}
