import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv/dummy_objects_tv_series.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesBloc bloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    bloc = WatchlistTvSeriesBloc(mockGetWatchlistTvSeries);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistTvSeriesEmpty());
  });

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right([testWatchlistTvSeries]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesLoaded([testWatchlistTvSeries]),
    ],
    verify: (_) => verify(mockGetWatchlistTvSeries.execute()),
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [Loading, Error] when get watchlist fails',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesError('Failed'),
    ],
    verify: (_) => verify(mockGetWatchlistTvSeries.execute()),
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [Loading, Empty] when watchlist is empty',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
          .thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesEmpty(),
    ],
  );
}
