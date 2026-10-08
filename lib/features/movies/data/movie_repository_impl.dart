import '../domain/movie.dart';
import '../domain/movie_repository.dart';
import 'movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl(this._dataSource);

  final MovieRemoteDataSource _dataSource;

  @override
  Future<List<Movie>> search(String query) => _dataSource.searchMovies(query);
}
