import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc(this.getWatchlistMovies) : super(WatchlistMoviesEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMoviesLoading());
      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(WatchlistMoviesError(failure.message)),
        (movies) {
          if (movies.isEmpty) {
            emit(WatchlistMoviesEmpty());
          } else {
            emit(WatchlistMoviesLoaded(movies));
          }
        },
      );
    });
  }
}
