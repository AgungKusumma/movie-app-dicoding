import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/home/now_playing/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/home/popular/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/home/top_rated/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/home/now_playing/tv_series_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/home/popular/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/home/top_rated/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/provider/home_tab_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_series_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_series_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(() => HomeTabNotifier());

  // Bloc
  locator.registerFactory<NowPlayingMoviesBloc>(
    () => NowPlayingMoviesBloc(locator<GetNowPlayingMovies>()),
  );
  locator.registerFactory<PopularMoviesBloc>(
    () => PopularMoviesBloc(locator<GetPopularMovies>()),
  );
  locator.registerFactory<TopRatedMoviesBloc>(
    () => TopRatedMoviesBloc(locator<GetTopRatedMovies>()),
  );
  locator.registerFactory<WatchlistMoviesBloc>(
    () => WatchlistMoviesBloc(locator<GetWatchlistMovies>()),
  );
  locator.registerFactory<SearchBloc<Movie>>(
    () => SearchBloc<Movie>(locator<SearchMovies>().execute),
  );
  locator.registerFactory<SearchBloc<TvSeries>>(
    () => SearchBloc<TvSeries>(locator<SearchTvSeries>().execute),
  );
  locator.registerFactory<MovieDetailBloc>(
    () => MovieDetailBloc(
      locator<GetMovieDetail>(), // GetMovieDetail
      locator<GetMovieRecommendations>(), // GetMovieRecommendations
      locator<GetWatchListStatus>(), // GetWatchListStatus
      locator<SaveWatchlist>(), // SaveWatchlist
      locator<RemoveWatchlist>(), // RemoveWatchlist
    ),
  );

  // Bloc tv series
  locator.registerFactory<TvSeriesNowPlayingBloc>(
    () => TvSeriesNowPlayingBloc(locator<GetNowPlayingTvSeries>()),
  );
  locator.registerFactory<PopularTvSeriesBloc>(
    () => PopularTvSeriesBloc(locator<GetPopularTvSeries>()),
  );
  locator.registerFactory<TopRatedTvSeriesBloc>(
    () => TopRatedTvSeriesBloc(locator<GetTopRatedTvSeries>()),
  );

  // provider tv series
  locator.registerFactory(
    () => TvSeriesDetailNotifier(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvSeriesNotifier(
      getWatchlistTvSeries: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // use case tv series
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // repository tv series
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // data sources tv series
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
