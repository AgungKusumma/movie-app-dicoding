import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/detail/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv/dummy_objects_tv_series.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListStatusTvSeries,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late TvSeriesDetailBloc bloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTvSeries mockGetWatchListStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlist;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlist;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatusTvSeries();
    mockSaveWatchlist = MockSaveWatchlistTvSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTvSeries();
    bloc = TvSeriesDetailBloc(
      mockGetTvSeriesDetail,
      mockGetTvSeriesRecommendations,
      mockGetWatchListStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  const tId = 1;

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'emits [Loading, Loaded] when fetch detail success',
    build: () {
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testTvSeries]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
    expect: () => [
      const TvSeriesDetailState(tvSeriesState: RequestState.Loading),
      TvSeriesDetailState(
        tvSeriesState: RequestState.Loaded,
        tvSeriesDetail: testTvSeriesDetail,
      ),
      TvSeriesDetailState(
        tvSeriesState: RequestState.Loaded,
        tvSeriesDetail: testTvSeriesDetail,
        recommendationState: RequestState.Loaded,
        recommendations: [testTvSeries],
      ),
    ],
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, Error] when getTvDetail fails',
    build: () {
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
    expect: () => [
      const TvSeriesDetailState(tvSeriesState: RequestState.Loading),
      const TvSeriesDetailState(
        tvSeriesState: RequestState.Error,
        message: 'Failed',
      ),
    ],
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should update watchlist message and status when added',
    build: () {
      when(mockSaveWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListStatus.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(AddTvSeriesToWatchlist(testTvSeriesDetail)),
    expect: () => [
      const TvSeriesDetailState(watchlistMessage: 'Added to Watchlist'),
      const TvSeriesDetailState(
        watchlistMessage: 'Added to Watchlist',
        isAddedToWatchlist: true,
      ),
    ],
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should update watchlist message when add fails',
    build: () {
      when(mockSaveWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(AddTvSeriesToWatchlist(testTvSeriesDetail)),
    expect: () => [
      const TvSeriesDetailState(
        watchlistMessage: 'Failed',
        isAddedToWatchlist: false,
      ),
    ],
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should remove from watchlist',
    build: () {
      when(mockRemoveWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(testTvSeriesDetail.id))
          .thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(RemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
    expect: () => [
      const TvSeriesDetailState(
        watchlistMessage: 'Removed from Watchlist',
        isAddedToWatchlist: false,
      ),
    ],
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should load watchlist status true',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvSeriesWatchlistStatus(tId)),
    expect: () => [
      const TvSeriesDetailState(isAddedToWatchlist: true),
    ],
  );
}
