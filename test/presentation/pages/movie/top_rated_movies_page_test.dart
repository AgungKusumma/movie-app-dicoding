import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/home/top_rated/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock & Fake
class MockTopRatedMoviesBloc extends Mock implements TopRatedMoviesBloc {}

class FakeTopRatedMoviesState extends Fake implements TopRatedMoviesState {}

class FakeTopRatedMoviesEvent extends Fake implements TopRatedMoviesEvent {}

void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedMoviesState());
    registerFallbackValue(FakeTopRatedMoviesEvent());
  });

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: BlocProvider<TopRatedMoviesBloc>.value(
        value: mockBloc,
        child: body,
      ),
    );
  }

  testWidgets('should show loading indicator when state is loading',
      (tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedMoviesLoading());

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

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

    when(() => mockBloc.state).thenReturn(TopRatedMoviesHasData([movie]));
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesHasData([movie])));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('should show error message when state is error', (tester) async {
    when(() => mockBloc.state).thenReturn(TopRatedMoviesError('Error message'));
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesError('Error message')));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.text('Error message'), findsOneWidget);
  });
}
