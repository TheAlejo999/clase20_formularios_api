import '../domain/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.title,
    required super.description,
    required super.posterUrl,
    required super.rating,
  });

  // OMDb devuelve los campos con mayúscula inicial.
  // imdbRating viene como String ("7.4") o "N/A" cuando no tiene valor.
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final ratingStr = json['imdbRating'] as String? ?? 'N/A';
    final rating = double.tryParse(ratingStr) ?? 0.0;

    return MovieModel(
      title: json['Title'] as String? ?? 'Sin título',
      description: json['Plot'] as String? ?? 'Sin descripción',
      posterUrl: json['Poster'] as String? ?? '',
      rating: rating,
    );
  }
}
