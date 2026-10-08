import 'movie.dart';
import 'movie_repository.dart';

class GetMovies {
  const GetMovies(this._repository);

  final MovieRepository _repository;

  Future<List<Movie>> call(String query) => _repository.search(query);
}
