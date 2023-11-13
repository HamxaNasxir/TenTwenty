import 'package:floor/floor.dart';
import '../models/upcomingMoviesModel.dart';

@dao
abstract class UpcomingMoviesDao {
  @Query('SELECT * FROM UpcomingMoviesModel')
  Future<List<UpcomingMoviesModel>> getAllMovies();

  @insert
  Future<void> insertMovie(UpcomingMoviesModel movie);

  @insert
  Future<void> insertAllMovies(List<UpcomingMoviesModel> movies);

  @Query('SELECT * FROM UpcomingMoviesModel WHERE id = :id')
  Future<UpcomingMoviesModel?> getMovieById(int id);
}
