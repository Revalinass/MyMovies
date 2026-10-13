import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/favorite_service.dart';
import '../theme/app_colors.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;

  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final MovieService _movieService = MovieService();
  final FavoriteService _favoriteService = FavoriteService();

  late Future<Movie> _futureMovie;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _futureMovie = _movieService.getMovieDetail(widget.movieId);
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await _favoriteService.isFavorite(widget.movieId);
    setState(() {
      _isFavorite = isFav;
    });
  }

  Future<void> _toggleFavorite(Movie movie) async {
    final newStatus = await _favoriteService.toggleFavorite(movie);
    setState(() {
      _isFavorite = newStatus;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.secondaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            newStatus
                ? '${movie.title} ditambahkan ke Favorite'
                : '${movie.title} dihapus dari Favorite',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<Movie>(
        future: _futureMovie,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.secondaryDark),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}',
                  style: const TextStyle(color: AppColors.textGrey)),
            );
          }

          final movie = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === HERO SECTION ===
                // Backdrop besar + tombol back/favorite + poster mengambang
                SizedBox(
                  height: 320,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Backdrop full width
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 260,
                          child: movie.backdropUrl.isNotEmpty
                              ? Image.network(
                            movie.backdropUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: AppColors.gradientHero,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                          )
                              : Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColors.gradientHero,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ), // SizedBox
                      ), // ClipRRect

                      // Gradient overlay tipis di bagian bawah backdrop
                      // supaya transisi ke background halaman lebih halus
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        height: 260,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                AppColors.background.withOpacity(0.95),
                                AppColors.background.withOpacity(0.0),
                              ],
                            ), // LinearGradient
                          ), // BoxDecoration
                        ), // Container
                      ), // Positioned

                      // Tombol back, ukuran normal (circle icon biasa)
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                Colors.white.withOpacity(0.92),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back_rounded,
                                      color: AppColors.textDark),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ), // CircleAvatar
                              CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                Colors.white.withOpacity(0.92),
                                child: IconButton(
                                  icon: Icon(
                                    _isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: AppColors.favoriteRed,
                                  ),
                                  onPressed: () => _toggleFavorite(movie),
                                ),
                              ), // CircleAvatar
                            ],
                          ), // Row
                        ),
                      ), // SafeArea

                      // Poster mengambang menumpuk di atas backdrop,
                      // ini jadi signature visual halaman detail
                      Positioned(
                        left: 20,
                        bottom: 0,
                        child: Container(
                          width: 120,
                          height: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(color: Colors.white, width: 3),
                          ), // BoxDecoration
                          clipBehavior: Clip.antiAlias,
                          child: movie.posterUrl.isNotEmpty
                              ? Image.network(movie.posterUrl,
                              fit: BoxFit.cover)
                              : Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: AppColors.gradientHero,
                              ),
                            ),
                            child: const Icon(Icons.movie_rounded,
                                color: Colors.white, size: 36),
                          ),
                        ), // Container
                      ), // Positioned
                    ],
                  ), // Stack
                ), // SizedBox

                // === INFO SECTION ===
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          height: 1.2,
                        ),
                      ), // Text
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.star_rounded,
                            iconColor: AppColors.star,
                            label: movie.voteAverage.toStringAsFixed(1),
                            background: AppColors.secondaryLight,
                          ),
                          const SizedBox(width: 10),
                          _InfoChip(
                            icon: Icons.calendar_today_rounded,
                            iconColor: AppColors.primaryDark,
                            label: movie.releaseDate,
                            background: AppColors.primaryLight,
                          ),
                        ],
                      ), // Row
                      const SizedBox(height: 22),
                      Row(
                        children: const [
                          Icon(Icons.menu_book_rounded,
                              size: 18, color: AppColors.secondaryDark),
                          SizedBox(width: 6),
                          Text(
                            'Sinopsis',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ), // Row
                      const SizedBox(height: 10),
                      Text(
                        movie.overview.isNotEmpty
                            ? movie.overview
                            : 'Tidak ada sinopsis tersedia.',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.65,
                          color: AppColors.textGrey,
                        ),
                      ), // Text
                    ],
                  ), // Column
                ), // Padding
              ],
            ), // Column
          ); // SingleChildScrollView
        },
      ), // FutureBuilder
    ); // Scaffold
  }
}

// Chip kecil untuk info rating & tanggal rilis, dipakai berulang
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color background;

  const _InfoChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ), // BoxDecoration
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              fontSize: 13,
            ),
          ),
        ],
      ), // Row
    ); // Container
  }
}