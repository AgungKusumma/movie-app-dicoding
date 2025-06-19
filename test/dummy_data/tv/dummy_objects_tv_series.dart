import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

final testTvSeries = TvSeries(
  adult: false,
  backdropPath: '/testBackdrop.jpg',
  genreIds: [18, 80],
  id: 1,
  originalName: 'Original TV Name',
  overview: 'Test TV overview',
  popularity: 123.45,
  posterPath: '/testPoster.jpg',
  firstAirDate: '2023-01-01',
  name: 'Test TV Series',
  video: false,
  voteAverage: 8.7,
  voteCount: 999,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: '/testBackdrop.jpg',
  genres: [Genre(id: 1, name: 'Drama')],
  id: 1,
  originalName: 'Original TV Name',
  overview: 'Test TV overview',
  posterPath: '/testPoster.jpg',
  firstAirDate: '2023-01-01',
  episodeRunTime: [45],
  name: 'Test TV Series',
  voteAverage: 8.7,
  voteCount: 999,
  seasons: [
    Season(
      airDate: '2023-01-01',
      episodeCount: 10,
      id: 100,
      name: 'Season 1',
      overview: 'Season 1 Overview',
      posterPath: '/seasonPoster.jpg',
      seasonNumber: 1,
    ),
  ],
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  overview: 'Test TV overview',
  posterPath: '/testPoster.jpg',
  name: 'Test TV Series',
);

final testTvSeriesTable = TvSeriesTable(
  id: 1,
  title: 'Test TV Series',
  posterPath: '/testPoster.jpg',
  overview: 'Test TV overview',
);

final testTvSeriesMap = {
  'id': 1,
  'title': 'Test TV Series',
  'posterPath': '/testPoster.jpg',
  'overview': 'Test TV overview',
};
