// import 'package:flutter/material.dart';
//
// import '../network_service/models/upcomingMoviesModel.dart';
// import '../network_service/repository/moviesRepository.dart';
// import '../utils/constants.dart';
//
// class MoviesProvider extends ChangeNotifier {
//   final MoviesRepository userRepository;
//
//   MoviesProvider({required this.userRepository});
//
//   List<UpcomingMoviesModel> _upcomingMoviesList = [];
//   bool _isLoading = false;
//   String _errorMessage = '';
//
//   List<UpcomingMoviesModel> get upcomingMoviesList => _upcomingMoviesList;
//
//   bool get isLoading => _isLoading;
//
//   String get errorMessage => _errorMessage;
//
//   Future<void> fetchUpcomingMovies() async {
//     _isLoading = true;
//     _errorMessage = '';
//
//     try {
//       _upcomingMoviesList = await userRepository.getUpcomingMovies(AppConstants.upcomingMovies);
//     } catch (e) {
//       _errorMessage = 'Failed to fetch movies';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
