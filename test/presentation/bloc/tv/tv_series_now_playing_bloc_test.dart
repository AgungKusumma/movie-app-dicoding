import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/home/now_playing/tv_series_now_playing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../provider/tv/tv_series_list_notifier_test.mocks.dart';

void main() {
  late TvSeriesNowPlayingBloc tvSeriesNowPlayingBloc;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;

  setUp(() {
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    tvSeriesNowPlayingBloc = TvSeriesNowPlayingBloc(mockGetNowPlayingTvSeries);
  });

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];

  test('initial state should be empty', () {
    expect(tvSeriesNowPlayingBloc.state, TvSeriesNowPlayingEmpty());
  });

  blocTest<TvSeriesNowPlayingBloc, TvSeriesNowPlayingState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      return tvSeriesNowPlayingBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
    expect: () => [
      TvSeriesNowPlayingLoading(),
      TvSeriesNowPlayingLoaded(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTvSeries.execute());
    },
  );

  blocTest<TvSeriesNowPlayingBloc, TvSeriesNowPlayingState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetNowPlayingTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvSeriesNowPlayingBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
    expect: () => [
      TvSeriesNowPlayingLoading(),
      TvSeriesNowPlayingError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTvSeries.execute());
    },
  );
}
