import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movie/dummy_objects.dart';

// Mocks & Fake
class MockMovieDetailBloc extends Mock implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
  });

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<MovieDetailBloc>.value(
        value: mockBloc,
        child: MovieDetailPage(id: 1),
      ),
    );
  }

  testWidgets('should show add icon when not in watchlist', (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendations: const [],
        isAddedToWatchlist: false,
      ),
    );
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('should show check icon when already in watchlist',
      (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendations: const [],
        isAddedToWatchlist: true,
      ),
    );
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('should show SnackBar when added to watchlist', (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendations: const [],
        watchlistMessage: 'Added to Watchlist',
        isAddedToWatchlist: false,
      ),
    );
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(
          MovieDetailState(
            movieState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            recommendations: const [],
            watchlistMessage: 'Added to Watchlist',
            isAddedToWatchlist: true,
          ),
        ));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump(); // for SnackBar to appear

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('should show AlertDialog when adding to watchlist fails',
      (tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        recommendations: const [],
        watchlistMessage: 'Failed',
        isAddedToWatchlist: false,
      ),
    );
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(
          MovieDetailState(
            movieState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            recommendations: const [],
            watchlistMessage: 'Failed',
            isAddedToWatchlist: false,
          ),
        ));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump(); // for dialog to appear

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
