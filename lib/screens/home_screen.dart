import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../theme/app_colors.dart';
import '../widgets/movie_section.dart';
import '../widgets/featured_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _movieService = MovieService();
  late Future<_HomeData> _futureHomeData;

  @override
  void initState() {
    super.initState();
    _futureHomeData = _loadHomeData();
  }

  Future<_HomeData> _loadHomeData() async {
    final results = await Future.wait([
      _movieService.getNowPlayingMovies(),
      _movieService.getPopularMovies(),
      _movieService.getUpcomingMovies(),
      _movieService.getTopRatedMovies(),
    ]);

    return _HomeData(
      nowPlaying: results[0],
      popular: results[1],
      upcoming: results[2],
      topRated: results[3],
    );
  }

  void _refreshMovies() {
    setState(() {
      _futureHomeData = _loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<_HomeData>(
        future: _futureHomeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.secondaryDark,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshMovies,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;

          if (data.nowPlaying.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada movie ditemukan',
                style: TextStyle(
                  color: AppColors.textGrey,
                ),
              ),
            );
          }

          final featuredMovie = data.nowPlaying.first;
          final nowPlayingMovies = data.nowPlaying.skip(1).toList();

          return RefreshIndicator(
            color: AppColors.secondaryDark,
            onRefresh: () async => _refreshMovies(),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 64,
                  floating: true,
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  title: Row(
                    children: const [
                      Icon(
                        Icons.local_movies_rounded,
                        color: AppColors.secondaryDark,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'MyMovies',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: AppColors.textDark,
                      ),
                      onPressed: _refreshMovies,
                    ),
                  ],
                ),

                // Banner Movie Utama
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: FeaturedBanner(
                      movie: featuredMovie,
                    ),
                  ),
                ),

                // Sedang Diputar
                SliverToBoxAdapter(
                  child: MovieSection(
                    title: 'Sedang Diputar',
                    icon: Icons.local_fire_department_rounded,
                    iconColor: AppColors.favoriteRed,
                    movies: nowPlayingMovies,
                  ),
                ),

                // Populer
                SliverToBoxAdapter(
                  child: MovieSection(
                    title: 'Populer',
                    icon: Icons.trending_up_rounded,
                    iconColor: AppColors.secondaryDark,
                    movies: data.popular,
                  ),
                ),

                // Mendatang
                SliverToBoxAdapter(
                  child: MovieSection(
                    title: 'Mendatang',
                    icon: Icons.event_available_rounded,
                    iconColor: AppColors.primaryDark,
                    movies: data.upcoming,
                  ),
                ),

                // Top Rating
                SliverToBoxAdapter(
                  child: MovieSection(
                    title: 'Top Rating',
                    icon: Icons.star_rounded,
                    iconColor: AppColors.star,
                    movies: data.topRated,
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Helper class khusus HomeScreen
class _HomeData {
  final List<Movie> nowPlaying;
  final List<Movie> popular;
  final List<Movie> upcoming;
  final List<Movie> topRated;

  _HomeData({
    required this.nowPlaying,
    required this.popular,
    required this.upcoming,
    required this.topRated,
  });
}