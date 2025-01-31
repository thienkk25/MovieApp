import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/src/models/movie_model.dart';

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

  Future<Map> newlyUpdatedMovies() async {
    try {
      final response = await http.get(
          Uri.parse("https://phimapi.com/danh-sach/phim-moi-cap-nhat?page=1"));
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

  Future<MovieModel?> singleDetailMovies(String nameMovie) async {
    try {
      final response =
          await http.get(Uri.parse("https://phimapi.com/phim/$nameMovie"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MovieModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> favoriteMovies(String slug) async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;
      final userDoc =
          fireStore.collection("favoriteMovies").doc(auth.currentUser!.uid);
      final data = await userDoc.get();
      List<dynamic> items = [];
      if (data.exists &&
          data.data() != null &&
          data.data()!.containsKey("items")) {
        items = List.from(data["items"]);

        if (items.any((element) => element == slug)) {
          return "Đã yêu thích rồi 😁";
        }
      }
      items.add(slug);
      await userDoc.set({
        "uid": auth.currentUser!.uid,
        "items": items,
        "timestamp": Timestamp.now(),
      });

      return "Yêu thích thành công 😊";
    } catch (e) {
      return "Thất bại!";
    }
  }

  Future<String> removeFavoriteMovie(String slug) async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;
      final userDoc =
          fireStore.collection("favoriteMovies").doc(auth.currentUser!.uid);
      final data = await userDoc.get();
      if (data.exists &&
          data.data() != null &&
          data.data()!.containsKey("items")) {
        List<dynamic> items = List.from(data["items"]);
        if (items.any((element) => element == slug)) {
          items.removeWhere((element) => element == slug);
          await userDoc.set({
            "items": items,
            "timestamp": Timestamp.now(),
          }, SetOptions(merge: true));

          return "Xóa thành công!";
        } else {
          return "Không tồn tại trong dữ liệu!";
        }
      } else {
        return "Không tồn tại trong dữ liệu!";
      }
    } catch (e) {
      return "Xóa thất bại!";
    }
  }
}
