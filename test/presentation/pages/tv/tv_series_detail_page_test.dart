import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/tv/detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/tv/dummy_objects_tv_series.dart';

// Mocks & Fake
class MockTvSeriesDetailBloc extends Mock implements TvSeriesDetailBloc {}

class FakeTvSeriesDetailEvent extends Fake implements TvSeriesDetailEvent {}

class FakeTvSeriesDetailState extends Fake implements TvSeriesDetailState {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvSeriesDetailEvent());
    registerFallbackValue(FakeTvSeriesDetailState());
  });

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TvSeriesDetailBloc>.value(
        value: mockBloc,
        child: TvSeriesDetailPage(id: 1),
      ),
    );
  }

  testWidgets('should show add icon when not in watchlist', (tester) async {
    when(() => mockBloc.state).thenReturn(
      TvSeriesDetailState(
        tvSeriesState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        tvSeriesDetail: testTvSeriesDetail,
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
      TvSeriesDetailState(
        tvSeriesState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        tvSeriesDetail: testTvSeriesDetail,
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
      TvSeriesDetailState(
        tvSeriesState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        tvSeriesDetail: testTvSeriesDetail,
        recommendations: const [],
        watchlistMessage: 'Added to Watchlist',
        isAddedToWatchlist: false,
      ),
    );
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(
          TvSeriesDetailState(
            tvSeriesState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            tvSeriesDetail: testTvSeriesDetail,
            recommendations: const [],
            watchlistMessage: 'Added to Watchlist',
            isAddedToWatchlist: true,
          ),
        ));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump(); // allow SnackBar to build

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('should show AlertDialog when failed to add to watchlist',
      (tester) async {
    when(() => mockBloc.state).thenReturn(
      TvSeriesDetailState(
        tvSeriesState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        tvSeriesDetail: testTvSeriesDetail,
        recommendations: const [],
        watchlistMessage: 'Failed',
        isAddedToWatchlist: false,
      ),
    );
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(
          TvSeriesDetailState(
            tvSeriesState: RequestState.Loaded,
            recommendationState: RequestState.Loaded,
            tvSeriesDetail: testTvSeriesDetail,
            recommendations: const [],
            watchlistMessage: 'Failed',
            isAddedToWatchlist: false,
          ),
        ));

    await tester.pumpWidget(makeTestableWidget());
    await tester.pump(); // allow dialog to build

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
