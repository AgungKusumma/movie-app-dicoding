import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_tv_series_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchBloc<TvSeries> searchBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    searchBloc = SearchBloc<TvSeries>(mockSearchTvSeries.execute);
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
  final tQuery = 'breaking';

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty<TvSeries>());
  });

  blocTest<SearchBloc<TvSeries>, SearchState<TvSeries>>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTvSeriesList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 1000),
    expect: () => [
      SearchLoading<TvSeries>(),
      SearchHasData<TvSeries>(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest<SearchBloc<TvSeries>, SearchState<TvSeries>>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 1000),
    expect: () => [
      SearchLoading<TvSeries>(),
      SearchError<TvSeries>('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}
