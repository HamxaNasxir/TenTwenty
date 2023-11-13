import 'dart:async';
import 'package:tentwenty/network_service/models/upcomingMoviesModel.dart';
import 'upcomingMovieDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:floor/floor.dart';

part 'database.g.dart';

@Database(version: 1, entities: [UpcomingMoviesModel])
abstract class AppDatabase extends FloorDatabase {
  UpcomingMoviesDao get upcomingMoviesDao;
}
