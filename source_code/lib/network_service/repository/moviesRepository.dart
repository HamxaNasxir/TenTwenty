import 'package:dio/dio.dart';
import 'package:tentwenty/network_service/repository/baseRepository.dart';
import 'package:floor/floor.dart';

import '../../utils/constants.dart';
import '../dio_client.dart';
import '../floor/database.dart';
import '../models/movieDetailModel.dart';
import '../models/upcomingMoviesModel.dart';
import '../models/videosModel.dart';
import 'package:connectivity/connectivity.dart';

class MoviesRepository extends BaseRepository {
  final ApiService apiService;
  final Connectivity connectivity = Connectivity();

  MoviesRepository({required this.apiService});

  List<UpcomingMoviesModel> upcomingMoviesList = [];
  List<VideoResults> videosList = [];
  var movieDetailModel;

  List<UpcomingMoviesModel> get getUpcomingMoviesList => upcomingMoviesList;
  var database;

  @override
  Future<void> initModel() async {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    try {
      // Check for internet connectivity
      var connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        upcomingMoviesList = await database.upcomingMoviesDao.getAllMovies();
      } else {
        setLoading(true);
        await getUpcomingMovies(AppConstants.upcomingMovies);
        await _saveMoviesToDatabase(upcomingMoviesList);

        setLoading(false);
      }
      notifyListeners();
    } catch (e) {
      // Handle the error
      print('Error fetching movies: $e');
    }
  }

  Future<void> _saveMoviesToDatabase(List<UpcomingMoviesModel> movies) async {
    for (var movie in movies) {
      final existingMovie = await database.upcomingMoviesDao.getMovieById(movie.id);
      if (existingMovie == null) {
        await database.upcomingMoviesDao.insertMovie(movie);
      }
    }
  }

  Future<dynamic> getTrailerUrl(String videoId) async {
    Map<String, dynamic> queryParameters = {"api_key": AppConstants.apiKey};

    try {
      final data = await apiService.get("movie/${videoId}/videos", queryParameters: queryParameters);

      return parseUpcomingMoviesResponse(data, true);
    } catch (e) {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<dynamic> getMovieDetail(String movieId) async {
    Map<String, dynamic> queryParameters = {"api_key": AppConstants.apiKey};

    try {
      final data = await apiService.get("movie/${movieId}", queryParameters: queryParameters);

      return parseMovieDetailResponse(data);
    } catch (e) {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<dynamic> searchMovieByQuery(String query) async {
    Map<String, dynamic> queryParameters = {"api_key": AppConstants.apiKey, "query": query};
    try {
      final data = await apiService.get(AppConstants.searchMovies, queryParameters: queryParameters);

      return parseUpcomingMoviesResponse(data, false);
    } catch (e) {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<dynamic> getUpcomingMovies(String uri) async {
    Map<String, dynamic> queryParameters = {"api_key": AppConstants.apiKey};

    try {
      final data = await apiService.get(uri, queryParameters: queryParameters);

      return parseUpcomingMoviesResponse(data, false);
    } catch (e) {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<List<dynamic>> parseUpcomingMoviesResponse(Response<dynamic> response, bool isVideo) async {
    List jsonResponse = response.data["results"];
    if (isVideo) {
      videosList = jsonResponse.map((data) => VideoResults.fromJson(data)).toList();
    } else {
      upcomingMoviesList = jsonResponse.map((data) => UpcomingMoviesModel.fromJson(data)).toList();
    }
    return isVideo ? videosList : upcomingMoviesList;
  }

  MovieDetailModel parseMovieDetailResponse(Response<dynamic> response) {
    movieDetailModel = MovieDetailModel.fromJson(response.data);
    return movieDetailModel;
  }
}
