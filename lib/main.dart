import 'package:flutter/material.dart';
import 'package:formularios_api/features/movies/data/movie_remote_data_source.dart';
import 'package:formularios_api/features/movies/data/movie_repository_impl.dart';
import 'package:formularios_api/features/movies/domain/get_movies.dart';
import 'package:formularios_api/features/movies/presentation/movie_search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscar películas',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1F3864),
        useMaterial3: true,
      ),
      home: MovieSearchScreen(
        getMovies: GetMovies(
          MovieRepositoryImpl(MovieRemoteDataSource()),
        ),
      ),
    );
  }
}
