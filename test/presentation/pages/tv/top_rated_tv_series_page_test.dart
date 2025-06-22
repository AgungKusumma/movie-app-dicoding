import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/home/top_rated/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock & Fake
class MockTopRatedTvSeriesBloc extends Mock implements TopRatedTvSeriesBloc {}

class FakeTopRatedTvSeriesState extends Fake implements TopRatedTvSeriesState {}

class FakeTopRatedTvSeriesEvent extends Fake implements TopRatedTvSeriesEvent {}

void main() {
  late MockTopRatedTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTvSeriesState());
    registerFallbackValue(FakeTopRatedTvSeriesEvent());
  });

  setUp(() {
    mockBloc = MockTopRatedTvSeriesBloc();
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TopRatedTvSeriesBloc>.value(
        value: mockBloc,
        child: body,
      ),
    );
  }

  testWidgets('should show loading indicator when state is loading',
      (tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedTvSeriesLoading());

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show listview when state is loaded', (tester) async {
    final tv = TvSeries(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1],
      id: 1,
      originalName: 'Original Name',
      overview: 'Overview',
      popularity: 10.0,
      posterPath: '/posterPath.jpg',
      firstAirDate: '2022-01-01',
      name: 'TV Title',
      video: false,
      voteAverage: 8.5,
      voteCount: 123,
    );

    when(() => mockBloc.state).thenReturn(TopRatedTvSeriesLoaded([tv]));
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedTvSeriesLoaded([tv])));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvSeriesCard), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state)
        .thenReturn(TopRatedTvSeriesError('Error message'));
    when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.value(TopRatedTvSeriesError('Error message')));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.text('Error message'), findsOneWidget);
  });
}
