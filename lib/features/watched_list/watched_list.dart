import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movieflix/core/firestore_service.dart';
import '../../widgets/moviecard.dart';
import '../home_screen/models/moviedatamodel.dart';

class WatchedList extends StatefulWidget {
  static const String path = "/Watched_List";

  const WatchedList({super.key});

  @override
  State<WatchedList> createState() => _WatchedListState();
}

class _WatchedListState extends State<WatchedList> {
  static const _pageSize = 10;
  final PagingController<int, Result> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await FirestoreService.gatherMoviesForWatchedListPage(
          pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = 1 + pageKey;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Watched List'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: PagedListView<int, Result>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Result>(
          itemBuilder: (context, item, index) => MovieCard(
            movie: item,
            collection: 'watchedlist',
          ),
        ),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
