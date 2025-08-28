import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class MovieService {
  Future<List> categoryMovies() async {
    try {
      final response =
          await http.get(Uri.parse("https://phimapi.com/the-loai"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Map> categoryDetailMovies(String type, int page, int limit) async {
    try {
      final response = await http.get(Uri.parse(
          "https://phimapi.com/v1/api/the-loai/$type?page=$page&limit=$limit"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map> newlyUpdatedMovies(int page) async {
    try {
      final response = await http.get(Uri.parse(
          "https://phimapi.com/danh-sach/phim-moi-cap-nhat?page=$page"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map> searchMovies(String keyword, int limit) async {
    try {
      final response = await http.get(Uri.parse(
          "https://phimapi.com/v1/api/tim-kiem?keyword=$keyword&limit=$limit"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map> dramaMovies(int page, int limit) async {
    try {
      final response = await http.get(Uri.parse(
          "https://phimapi.com/v1/api/danh-sach/phim-bo?page=$page&limit=$limit"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map> singleMovies(int page, int limit) async {
    try {
      final response = await http.get(Uri.parse(
          "https://phimapi.com/v1/api/danh-sach/phim-le?page=$page&limit=$limit"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map> cartoonMovies(int page, int limit) async {
    try {
      final response = await http.get(Uri.parse(
          "https://phimapi.com/v1/api/danh-sach/hoat-hinh?page=$page&limit=$limit"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map> tvShowsMovies(int page, int limit) async {
    try {
      final response = await http.get(Uri.parse(
          "https://phimapi.com/v1/api/danh-sach/tv-shows?page=$page&limit=$limit"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map?> singleDetailMovies(String nameMovie) async {
    try {
      final response =
          await http.get(Uri.parse("https://phimapi.com/phim/$nameMovie"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List> getFavoriteMovies() async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;
      final userDoc = await fireStore
          .collection("favoriteMovies")
          .doc(auth.currentUser!.uid)
          .collection("movies")
          .orderBy("timestamp", descending: true)
          .get();

      return userDoc.docs.map((e) => e.data()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> addFavoriteMovies(
      String name, String slug, String posterUrl) async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;
      final userDoc = fireStore
          .collection("favoriteMovies")
          .doc(auth.currentUser!.uid)
          .collection("movies")
          .doc(slug);

      await userDoc.set({
        "name": name,
        "slug": slug,
        "poster_url": posterUrl,
        "timestamp": DateTime.now(),
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFavoriteMovie(String slug) async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;
      await fireStore
          .collection("favoriteMovies")
          .doc(auth.currentUser!.uid)
          .collection("movies")
          .doc(slug)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List> historyWatchMovies() async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;

      final movieDoc = await fireStore
          .collection("historyWatchMovies")
          .doc(auth.currentUser!.uid)
          .collection("movies")
          .orderBy("timestamp", descending: true)
          .get();

      return movieDoc.docs.map((e) => e.data()).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map?> getHistoryWatchMovies(String slug) async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;

      final movieDoc = fireStore
          .collection("historyWatchMovies")
          .doc(auth.currentUser!.uid)
          .collection("movies")
          .doc(slug);

      final snapshot = await movieDoc.get();

      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> addHistoryWatchMovies(
      String name, String slug, String posterUrl, int episode) async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;

      final movieDoc = fireStore
          .collection("historyWatchMovies")
          .doc(auth.currentUser!.uid)
          .collection("movies")
          .doc(slug);

      await movieDoc.set({
        "name": name,
        "slug": slug,
        "poster_url": posterUrl,
        "episode": episode,
        "timestamp": DateTime.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      return;
    }
  }

  Future<bool> removeHistoryWatchMovies(String slug) async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;
      await fireStore
          .collection("historyWatchMovies")
          .doc(auth.currentUser!.uid)
          .collection("movies")
          .doc(slug)
          .delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
