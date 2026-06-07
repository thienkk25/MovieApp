import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class MovieFirestoreDataSource {
  Future<Map> getFavoriteMovies();
  Future<bool> addFavoriteMovies(
    String name,
    String slug,
    String posterUrl,
    String lang,
    String episodeCurrent,
  );
  Future<bool> removeFavoriteMovie(String slug);
  Future<Map> historyWatchMovies();
  Future<Map?> getHistoryWatchMovies(String slug);
  Future<void> addHistoryWatchMovies(
    String name,
    String slug,
    String posterUrl,
    int episode,
  );
  Future<bool> removeHistoryWatchMovies(String slug);
}

class MovieFirestoreDataSourceImpl implements MovieFirestoreDataSource {
  final FirebaseFirestore _fireStore;
  final FirebaseAuth _auth;

  MovieFirestoreDataSourceImpl({
    FirebaseFirestore? fireStore,
    FirebaseAuth? auth,
  })  : _fireStore = fireStore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  @override
  Future<Map> getFavoriteMovies() async {
    if (_uid.isEmpty) return {};
    final userDoc = await _fireStore
        .collection("favoriteMovies")
        .doc(_uid)
        .collection("movies")
        .orderBy("timestamp", descending: true)
        .get();

    if (userDoc.docs.isNotEmpty) {
      return {for (var e in userDoc.docs) e.id: e.data()};
    }
    return {};
  }

  @override
  Future<bool> addFavoriteMovies(
    String name,
    String slug,
    String posterUrl,
    String lang,
    String episodeCurrent,
  ) async {
    if (_uid.isEmpty) return false;
    final userDoc = _fireStore
        .collection("favoriteMovies")
        .doc(_uid)
        .collection("movies")
        .doc(slug);

    await userDoc.set({
      "name": name,
      "slug": slug,
      "poster_url": posterUrl,
      "lang": lang,
      "episode_current": episodeCurrent,
      "timestamp": DateTime.now(),
    }, SetOptions(merge: true));

    return true;
  }

  @override
  Future<bool> removeFavoriteMovie(String slug) async {
    if (_uid.isEmpty) return false;
    await _fireStore
        .collection("favoriteMovies")
        .doc(_uid)
        .collection("movies")
        .doc(slug)
        .delete();
    return true;
  }

  @override
  Future<Map> historyWatchMovies() async {
    if (_uid.isEmpty) return {};
    final movieDoc = await _fireStore
        .collection("historyWatchMovies")
        .doc(_uid)
        .collection("movies")
        .orderBy("timestamp", descending: true)
        .get();
    if (movieDoc.docs.isNotEmpty) {
      return {for (var e in movieDoc.docs) e.id: e.data()};
    }
    return {};
  }

  @override
  Future<Map?> getHistoryWatchMovies(String slug) async {
    if (_uid.isEmpty) return null;
    final movieDoc = _fireStore
        .collection("historyWatchMovies")
        .doc(_uid)
        .collection("movies")
        .doc(slug);

    final snapshot = await movieDoc.get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      return null;
    }
  }

  @override
  Future<void> addHistoryWatchMovies(
    String name,
    String slug,
    String posterUrl,
    int episode,
  ) async {
    if (_uid.isEmpty) return;
    final movieDoc = _fireStore
        .collection("historyWatchMovies")
        .doc(_uid)
        .collection("movies")
        .doc(slug);

    await movieDoc.set({
      "name": name,
      "slug": slug,
      "poster_url": posterUrl,
      "episode": episode,
      "timestamp": DateTime.now(),
    }, SetOptions(merge: true));
  }

  @override
  Future<bool> removeHistoryWatchMovies(String slug) async {
    if (_uid.isEmpty) return false;
    await _fireStore
        .collection("historyWatchMovies")
        .doc(_uid)
        .collection("movies")
        .doc(slug)
        .delete();

    return true;
  }
}
