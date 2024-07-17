import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieflix/exporter.dart';
import 'package:movieflix/features/home_screen/models/datamodel.dart';

class FirestoreService {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static final userId = FirebaseAuth.instance.currentUser?.uid;
  static final CollectionReference watchlist = db.collection("watchlist");

  static final CollectionReference watchedlist = db.collection('watchedlist');

  static Future<bool> addMovieToWatchlist(Result result) async {
    try {
      await watchedlist
          .doc(userId)
          .update({'watchedlist.${result.id}': FieldValue.delete()});
      final movies = await fetchWatchListMovies();
      movies.add(result);

      await watchlist.doc(userId).set({
        'movies': movies
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
      await watchlist
          .doc(userId)
          .update({'watchlist.${result.id}': FieldValue.delete()});
      final movies = await fetchWatchedListMovies();

      await watchlist.doc(userId).set({
        'movies': movies
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

  static Future<bool> checkInWatchList(int movieId) async {
    final moviesList = await fetchWatchListMovies();
    return moviesList.any((element) => element.id == movieId);
  }

  static Future<bool> checkInWatchedList(int movieId) async {
    final moviesLis = await fetchWatchedListMovies();
    return moviesLis.any((element) => element.id == movieId);
  }
}
