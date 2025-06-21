import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/home/popular/popular_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock & Fake
class MockPopularMoviesBloc extends Mock implements PopularMoviesBloc {}

class FakePopularMoviesState extends Fake implements PopularMoviesState {}

class FakePopularMoviesEvent extends Fake implements PopularMoviesEvent {}

void main() {
  late MockPopularMoviesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularMoviesState());
    registerFallbackValue(FakePopularMoviesEvent());
  });

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<PopularMoviesBloc>.value(
        value: mockBloc,
        child: body,
      ),
    );
  }

  testWidgets('should show loading indicator when state is loading',
      (tester) async {
    when(() => mockBloc.state).thenReturn(PopularMoviesLoading());

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show listview when state is has data', (tester) async {
    final movie = Movie(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1],
      id: 1,
      originalTitle: 'Original Title',
      overview: 'Overview',
      popularity: 10.0,
      posterPath: '/posterPath.jpg',
      releaseDate: '2022-01-01',
      title: 'Movie Title',
      video: false,
      voteAverage: 8.5,
      voteCount: 123,
    );

    when(() => mockBloc.state).thenReturn(PopularMoviesHasData([movie]));
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesHasData([movie])));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state).thenReturn(PopularMoviesError('Error message'));
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesError('Error message')));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.text('Error message'), findsOneWidget);
  });
}
