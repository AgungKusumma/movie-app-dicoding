import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/home/popular/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_series_page.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock & Fake
class MockPopularTvSeriesBloc extends Mock implements PopularTvSeriesBloc {}

class FakePopularTvSeriesState extends Fake implements PopularTvSeriesState {}

class FakePopularTvSeriesEvent extends Fake implements PopularTvSeriesEvent {}

void main() {
  late MockPopularTvSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularTvSeriesState());
    registerFallbackValue(FakePopularTvSeriesEvent());
  });

  setUp(() {
    mockBloc = MockPopularTvSeriesBloc();
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<PopularTvSeriesBloc>.value(
        value: mockBloc,
        child: body,
      ),
    );
  }

  testWidgets('should show loading indicator when state is loading',
      (tester) async {
    when(() => mockBloc.state).thenReturn(PopularTvSeriesLoading());

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show listview when state is loaded', (tester) async {
    final tv = TvSeries(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2],
      id: 1,
      originalName: 'Original Name',
      overview: 'Overview',
      popularity: 9.0,
      posterPath: '/poster.jpg',
      firstAirDate: '2022-01-01',
      name: 'TV Title',
      video: false,
      voteAverage: 8.7,
      voteCount: 200,
    );

    when(() => mockBloc.state).thenReturn(PopularTvSeriesLoaded([tv]));
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvSeriesLoaded([tv])));

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvSeriesCard), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state)
        .thenReturn(PopularTvSeriesError('Error message'));
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvSeriesError('Error message')));

    await tester.pumpWidget(_makeTestableWidget(PopularTvSeriesPage()));

    expect(find.text('Error message'), findsOneWidget);
  });
}
