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

  Future<Map?> getFavoriteMovies() async {
    try {
      final auth = FirebaseAuth.instance;
      final fireStore = FirebaseFirestore.instance;
      final userDoc =
          fireStore.collection("favoriteMovies").doc(auth.currentUser!.uid);
      final data = await userDoc.get();
      if (data.exists &&
          data.data() != null &&
          data.data()!.containsKey("items")) {
        return data.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List> addFavoriteMovies(
      String name, String slug, String posterUrl) async {
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

        if (items.any((element) => element['slug'] == slug)) {
          return ["Đã yêu thích rồi!", false];
        }
      }
      items.add({
        "name": name,
        "slug": slug,
        "poster_url": posterUrl,
        "timestamp": Timestamp.now(),
      });
      await userDoc.set({
        "uid": auth.currentUser!.uid,
        "items": items,
        "create_at": Timestamp.now()
      });

      return ["Yêu thích thành công", true];
    } catch (e) {
      return ["Thất bại!", false];
    }
  }

  Future<List> removeFavoriteMovie(String slug) async {
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
        if (items.any((element) => element['slug'] == slug)) {
          items.removeWhere((element) => element['slug'] == slug);
          await userDoc.set({
            "items": items,
            "timestamp": Timestamp.now(),
          }, SetOptions(merge: true));

          return ["Xóa thành công!", true];
        } else {
          return ["Không tồn tại trong dữ liệu!", false];
        }
      } else {
        return ["Không tồn tại trong dữ liệu!", false];
      }
    } catch (e) {
      return ["Xóa thất bại!", false];
    }
  }
}
