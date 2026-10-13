// Model Movie
// Mengikuti pola class Article pada Modul 5 (Client-Server)
// dan class TourismPlace pada Modul 3 (Flutter Layout)

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  // Base URL gambar TMDb
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  String get posterUrl =>
      posterPath != null ? '$_imageBaseUrl$posterPath' : '';

  String get backdropUrl =>
      backdropPath != null ? '$_imageBaseUrl$backdropPath' : '';

  // factory untuk parsing JSON dari API, sama seperti
  // Article.fromJson() pada Modul 5
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] ?? '-',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
    );
  }

  // Untuk disimpan ke shared_preferences (favorite list) dalam bentuk JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
    };
  }
}