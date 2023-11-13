import 'package:floor/floor.dart';

@entity
class UpcomingMoviesModel {
  @primaryKey
  late int id;

  late String originalTitle;
  late String overview;
  late String posterPath;
  late String releaseDate;
  late String title;

  UpcomingMoviesModel({
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
  });

  UpcomingMoviesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    posterPath = json['poster_path'] ?? '';
    releaseDate = json['release_date'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['original_title'] = originalTitle;
    _data['overview'] = overview;
    _data['poster_path'] = posterPath;
    _data['release_date'] = releaseDate;
    _data['title'] = title;
    return _data;
  }
}
