// Movie Service
// Mengikuti konsep client-server pada Modul 5 (FutureBuilder)
// Bedanya: Modul 5 pakai DefaultAssetBundle.loadString (data lokal),
// disini kita pakai package http untuk request ke server TMDb asli.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../models/movie.dart';

class MovieService {
  // Helper internal supaya 4 endpoint list (now_playing, popular,
  // upcoming, top_rated) tidak menduplikasi kode parsing yang sama.
  Future<List<Movie>> _fetchMovieList(
      String endpoint,
      String errorMessage,
      ) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/$endpoint?api_key=${ApiConfig.apiKey}&language=en-US&page=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List results = data['results'] ?? [];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('$errorMessage (kode: ${response.statusCode})');
    }
  }

  // Movie yang sedang tayang di bioskop
  Future<List<Movie>> getNowPlayingMovies() =>
      _fetchMovieList('movie/now_playing', 'Gagal mengambil data movies');

  // Movie yang sedang populer
  Future<List<Movie>> getPopularMovies() =>
      _fetchMovieList('movie/popular', 'Gagal mengambil data movie populer');

  // Movie yang akan datang (belum tayang)
  Future<List<Movie>> getUpcomingMovies() => _fetchMovieList(
    'movie/upcoming',
    'Gagal mengambil data movie mendatang',
  );

  // Movie dengan rating tertinggi
  Future<List<Movie>> getTopRatedMovies() =>
      _fetchMovieList('movie/top_rated', 'Gagal mengambil data top rating');

  // Mengambil detail satu movie berdasarkan id
  Future<Movie> getMovieDetail(int movieId) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/movie/$movieId?api_key=${ApiConfig.apiKey}&language=en-US',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Gagal mengambil detail movie (kode: ${response.statusCode})');
    }
  }

  // Search movie berdasarkan keyword
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final url = Uri.parse(
      '${ApiConfig.baseUrl}/search/movie?api_key=${ApiConfig.apiKey}&language=en-US&query=$query&page=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List results = data['results'] ?? [];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Gagal melakukan pencarian (kode: ${response.statusCode})');
    }
  }
}