import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/detail_screen.dart';
import '../theme/app_colors.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.22),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ), // BoxDecoration
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Poster sebagai latar penuh, mengisi seluruh card
            movie.posterUrl.isNotEmpty
                ? Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const _PosterPlaceholder(),
            )
                : const _PosterPlaceholder(),

            // Gradient gelap->transparan di bagian bawah agar judul
            // tetap terbaca di atas poster apapun warnanya
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.overlayDark.withOpacity(0.92),
                      AppColors.overlayDark.withOpacity(0.0),
                    ],
                  ), // LinearGradient
                ), // BoxDecoration
              ), // Container
            ), // Positioned

            // Judul movie di atas gradient
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                  height: 1.2,
                  shadows: [
                    Shadow(color: Colors.black38, blurRadius: 4),
                  ],
                ), // TextStyle
              ), // Text
            ), // Positioned

            // Badge rating melayang di pojok kanan atas
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 4,
                    ),
                  ],
                ), // BoxDecoration
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.star, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ), // Row
              ), // Container
            ), // Positioned
          ],
        ), // Stack
      ), // Container
    ); // InkWell
  }
}

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.gradientHero,
        ),
      ), // BoxDecoration
      child: const Center(
        child: Icon(Icons.movie_rounded, size: 40, color: Colors.white),
      ),
    );
  }
}