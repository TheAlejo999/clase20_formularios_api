import 'movie.dart';

abstract interface class MovieRepository {
  Future<List<Movie>> search(String query);
}
