import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/movie/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      mockGetMovieDetail,
      mockGetMovieRecommendations,
      mockGetWatchListStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  final tId = 1;

  blocTest<MovieDetailBloc, MovieDetailState>(
    'emits [Loading, Loaded] when fetch detail success',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right([testMovie]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    expect: () => [
      MovieDetailState(movieState: RequestState.Loading),
      MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail,
      ),
      MovieDetailState(
        movieState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendationState: RequestState.Loaded,
        recommendations: [testMovie],
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [Loading, Error] when getMovieDetail fails',
    build: () {
      when(mockGetMovieDetail.execute(1))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      when(mockGetMovieRecommendations.execute(1))
          .thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(1)),
    expect: () => [
      MovieDetailState(movieState: RequestState.Loading),
      MovieDetailState(
        movieState: RequestState.Error,
        message: 'Failed',
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should update watchlist message and status when added',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
    expect: () => [
      MovieDetailState(watchlistMessage: 'Added to Watchlist'),
      MovieDetailState(
        watchlistMessage: 'Added to Watchlist',
        isAddedToWatchlist: true,
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should update watchlist message when add fails',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
    expect: () => [
      MovieDetailState(
        watchlistMessage: 'Failed',
        isAddedToWatchlist: false,
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should remove from watchlist',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return bloc;
    },
    act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
    expect: () => [
      MovieDetailState(
        watchlistMessage: 'Removed from Watchlist',
        isAddedToWatchlist: false,
      ),
    ],
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should load watchlist status true',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadMovieWatchlistStatus(tId)),
    expect: () => [
      MovieDetailState(isAddedToWatchlist: true),
    ],
  );
}
