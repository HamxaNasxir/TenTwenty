// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UpcomingMoviesDao? _upcomingMoviesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UpcomingMoviesModel` (`id` INTEGER NOT NULL, `originalTitle` TEXT NOT NULL, `overview` TEXT NOT NULL, `posterPath` TEXT NOT NULL, `releaseDate` TEXT NOT NULL, `title` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UpcomingMoviesDao get upcomingMoviesDao {
    return _upcomingMoviesDaoInstance ??=
        _$UpcomingMoviesDao(database, changeListener);
  }
}

class _$UpcomingMoviesDao extends UpcomingMoviesDao {
  _$UpcomingMoviesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _upcomingMoviesModelInsertionAdapter = InsertionAdapter(
            database,
            'UpcomingMoviesModel',
            (UpcomingMoviesModel item) => <String, Object?>{
                  'id': item.id,
                  'originalTitle': item.originalTitle,
                  'overview': item.overview,
                  'posterPath': item.posterPath,
                  'releaseDate': item.releaseDate,
                  'title': item.title
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UpcomingMoviesModel>
      _upcomingMoviesModelInsertionAdapter;

  @override
  Future<List<UpcomingMoviesModel>> getAllMovies() async {
    return _queryAdapter.queryList('SELECT * FROM UpcomingMoviesModel',
        mapper: (Map<String, Object?> row) => UpcomingMoviesModel(
            id: row['id'] as int,
            originalTitle: row['originalTitle'] as String,
            overview: row['overview'] as String,
            posterPath: row['posterPath'] as String,
            releaseDate: row['releaseDate'] as String,
            title: row['title'] as String));
  }

  @override
  Future<UpcomingMoviesModel?> getMovieById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM UpcomingMoviesModel WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UpcomingMoviesModel(
            id: row['id'] as int,
            originalTitle: row['originalTitle'] as String,
            overview: row['overview'] as String,
            posterPath: row['posterPath'] as String,
            releaseDate: row['releaseDate'] as String,
            title: row['title'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertMovie(UpcomingMoviesModel movie) async {
    await _upcomingMoviesModelInsertionAdapter.insert(
        movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertAllMovies(List<UpcomingMoviesModel> movies) async {
    await _upcomingMoviesModelInsertionAdapter.insertList(
        movies, OnConflictStrategy.abort);
  }
}
