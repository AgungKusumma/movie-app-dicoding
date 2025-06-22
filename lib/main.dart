import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/home/now_playing/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/home/popular/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/home/top_rated/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/home/now_playing/tv_series_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/home/popular/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_root_page.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/now_playing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_series_page.dart';
import 'package:ditonton/presentation/provider/home_tab_notifier.dart';
import 'package:ditonton/presentation/provider/tv/top_rated_tv_series_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_series_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_series_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<HomeTabNotifier>(),
        ),
        // tv series
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvSeriesNotifier>(),
        ),

        // Bloc
        BlocProvider<NowPlayingMoviesBloc>(
          create: (_) => di.locator<NowPlayingMoviesBloc>(),
        ),
        BlocProvider<PopularMoviesBloc>(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider<TopRatedMoviesBloc>(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider<WatchlistMoviesBloc>(
          create: (_) => di.locator<WatchlistMoviesBloc>(),
        ),
        BlocProvider<SearchBloc<Movie>>(
          create: (_) => di.locator<SearchBloc<Movie>>(),
        ),
        BlocProvider<SearchBloc<TvSeries>>(
          create: (_) => di.locator<SearchBloc<TvSeries>>(),
        ),
        // Bloc tv series
        BlocProvider<TvSeriesNowPlayingBloc>(
          create: (_) => di.locator<TvSeriesNowPlayingBloc>(),
        ),
        BlocProvider<PopularTvSeriesBloc>(
          create: (_) => di.locator<PopularTvSeriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeRootPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeRootPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeRootPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => BlocProvider<MovieDetailBloc>.value(
                  value: di.locator<MovieDetailBloc>()
                    ..add(FetchMovieDetail(id))
                    ..add(LoadMovieWatchlistStatus(id)),
                  child: MovieDetailPage(id: id),
                ),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case NowPlayingTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => NowPlayingTvSeriesPage());
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case SearchTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvSeriesPage());
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvSeriesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
