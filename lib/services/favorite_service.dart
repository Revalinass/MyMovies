import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';

class FavoriteService {
  static const String _key = 'favorite_movies';

  // mengambil seluruh daftar movie favorite yang tersimpan
  Future<List<Movie>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);

    if (data == null) {
      return [];
    }

    final List decoded = jsonDecode(data);
    return decoded.map((json) => Movie.fromJson(json)).toList();
  }

  // untuk mengecek apakah sebuah movie sudah ada di daftar favorite
  Future<bool> isFavorite(int movieId) async {
    final favorites = await getFavorites();
    return favorites.any((movie) => movie.id == movieId);
  }

  // menambahkan movie ke favorite
  Future<void> addFavorite(Movie movie) async {
    final favorites = await getFavorites();
    final alreadyExists = favorites.any((m) => m.id == movie.id);

    if (!alreadyExists) {
      favorites.add(movie);
      await _saveFavorites(favorites);
    }
  }

  // mengahpus movie dari favorite
  Future<void> removeFavorite(int movieId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((movie) => movie.id == movieId);
    await _saveFavorites(favorites);
  }

  Future<bool> toggleFavorite(Movie movie) async {
    final isFav = await isFavorite(movie.id);
    if (isFav) {
      await removeFavorite(movie.id);
      return false;
    } else {
      await addFavorite(movie);
      return true;
    }
  }

  Future<void> _saveFavorites(List<Movie> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(
      favorites.map((movie) => movie.toJson()).toList(),
    );
    await prefs.setString(_key, encoded);
  }
}