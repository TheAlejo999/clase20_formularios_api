import 'dart:convert';

import 'package:http/http.dart' as http;

import 'movie_model.dart';

class MovieRemoteDataSource {
  // La API key se inyecta en tiempo de compilación con --dart-define=OMDB_API_KEY=<key>
  static const String _apiKey = String.fromEnvironment('OMDB_API_KEY');

  // Busca películas en OMDb en dos pasos:
  //   1. s= devuelve una lista de resultados con imdbID pero sin detalle.
  //   2. i= obtiene el detalle completo (Plot, imdbRating, Poster) por ID.
  Future<List<MovieModel>> searchMovies(String query) async {
    const apiKey = _apiKey;

    // Paso 1: búsqueda por título, tipo película, página 1.
    final searchUri = Uri.https('www.omdbapi.com', '/', {
      's': query,
      'type': 'movie',
      'apikey': apiKey,
    });

    final searchResponse =
        await http.get(searchUri).timeout(const Duration(seconds: 15));

    if (searchResponse.statusCode != 200) {
      return [];
    }

    final searchJson =
        jsonDecode(searchResponse.body) as Map<String, dynamic>;

    if (searchJson['Response'] == 'False') {
      return [];
    }

    final results = (searchJson['Search'] as List<dynamic>).take(5).toList();

    // Paso 2: detalle completo para cada ID (en paralelo).
    final details = await Future.wait(
      results.map((item) async {
        final id = (item as Map<String, dynamic>)['imdbID'] as String;
        final detailUri = Uri.https('www.omdbapi.com', '/', {
          'i': id,
          'plot': 'short',
          'apikey': apiKey,
        });
        final detailResponse =
            await http.get(detailUri).timeout(const Duration(seconds: 15));

        if (detailResponse.statusCode != 200) {
          return <String, dynamic>{};
        }

        return jsonDecode(detailResponse.body) as Map<String, dynamic>;
      }),
    );

    return details.map(MovieModel.fromJson).toList();
  }
}
