import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieflix/exporter.dart';
import 'package:movieflix/features/home_screen/models/moviedatamodel.dart';

class FirestoreService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static final userId = FirebaseAuth.instance.currentUser?.uid;
  static final CollectionReference watchlist = db.collection("watchlist");

  static final CollectionReference watchedlist = db.collection('watchedlist');
  static Future<List<Result>> fetchWatchListMovies() {
    return watchlist.doc(userId).get().then(
      (value) {
        final data = value.data() == null
            ? null
            : (value.data() as Map<String, dynamic>);
        if (data == null) return [];
        final moviesList = data['movies'] as List;
        return moviesList
            .map(
              (e) => Result.fromJson(e),
            )
            .toList();
      },
    );
  }

  static Future<List<Result>> fetchWatchedListMovies() {
    return watchedlist.doc(userId).get().then(
      (value) {
        final data = value.data() == null
            ? null
            : (value.data() as Map<String, dynamic>);
        if (data == null) return [];
        final moviesList = data['movies'] as List;
        return moviesList
            .map(
              (e) => Result.fromJson(e),
            )
            .toList();
      },
    );
  }

  static Future<bool> addMovieToWatchlist(Result result) async {
    try {
      // await watchedlist
      //     .doc(userId)
      //     .update({'watchedlist.${result.id}': FieldValue.delete()});
      final movies = await fetchWatchListMovies();
      movies.add(result);

      await watchlist.doc(userId).set({
        'movies': movies
            .map(
              (e) => e.toMap(),
            )
            .toList(),
      }, SetOptions(merge: true));

      final watchedListMovies = await fetchWatchedListMovies();
      watchedListMovies.removeWhere((element) => element.id == result.id);
      await watchedlist.doc(userId).set({
        'movies': watchedListMovies
            .map(
              (e) => e.toMap(),
            )
            .toList(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      logError(e);
    }
    return false;
  }

  static Future<bool> addMovieToWatchedlist(Result result) async {
    try {
      final movies = await fetchWatchedListMovies();

      movies.add(result);

      logError(movies);
      await watchedlist.doc(userId).set({
        'movies': movies
            .map(
              (e) => e.toMap(),
            )
            .toList(),
      }, SetOptions(merge: true));

      final watchListMovies = await fetchWatchListMovies();
      watchListMovies.removeWhere((element) => element.id == result.id);
      await watchlist.doc(userId).set({
        'movies': watchListMovies
            .map(
              (e) => e.toMap(),
            )
            .toList(),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      logError(e);
    }
    return false;
  }

  static Future<void> removeMovieFromlist(
      int movieId, String collectionName) async {
    try {
      if (collectionName == 'watchlist') {
        final watchListMovies = await fetchWatchListMovies();
        watchListMovies.removeWhere((element) => element.id == movieId);

        await watchlist.doc(userId).set({
          'movies': watchListMovies
              .map(
                (e) => e.toMap(),
              )
              .toList(),
        }, SetOptions(merge: true));
      } else if (collectionName == 'watchedlist') {
        final watchedListMovies = await fetchWatchedListMovies();
        watchedListMovies.removeWhere((element) => element.id == movieId);

        await watchedlist.doc(userId).set({
          'movies': watchedListMovies
              .map(
                (e) => e.toMap(),
              )
              .toList(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      logError(e);
    }
  }

  static Future<bool> checkInWatchList(int movieId) async {
    final moviesList = await fetchWatchListMovies();
    return moviesList.any((element) => element.id == movieId);
  }

  static Future<bool> checkInWatchedList(int movieId) async {
    final moviesLis = await fetchWatchedListMovies();
    return moviesLis.any((element) => element.id == movieId);
  }

  static Future<List<Result>> gatherMoviesForWatchListPage(
      int page, int pageSize) async {
    return watchlist.doc(userId).get().then(
      (value) {
        final data = value.data() == null
            ? null
            : (value.data() as Map<String, dynamic>);
        if (data == null) {
          logError("list Empty");

          return [];
        }
        final moviesList = data['movies'] as List;
        print(data);
        final paginatedMovies =
            moviesList.skip((page - 1) * pageSize).take(pageSize).toList();
        return paginatedMovies
            .map(
              (e) => Result.fromJson(e),
            )
            .toList();
      },
    );
  }

  static Future<List<Result>> gatherMoviesForWatchedListPage(
      int page, int pageSize) async {
    return watchedlist.doc(userId).get().then(
      (value) {
        final data = value.data() == null
            ? null
            : (value.data() as Map<String, dynamic>);
        if (data == null) {
          logError("list Empty");
          logError(data);
          return [];
        }

        final moviesList = data['movies'] as List;
        logError(moviesList);
        final paginatedMovies =
            moviesList.skip((page - 1) * pageSize).take(pageSize).toList();
        return paginatedMovies
            .map(
              (e) => Result.fromJson(e),
            )
            .toList();
      },
    );
  }
}
