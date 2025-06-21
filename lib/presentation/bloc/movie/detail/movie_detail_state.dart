part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final MovieDetail? movieDetail;
  final RequestState movieState;

  final List<Movie> recommendations;
  final RequestState recommendationState;

  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  const MovieDetailState({
    this.movieDetail,
    this.movieState = RequestState.Empty,
    this.recommendations = const [],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.watchlistMessage = '',
    this.isAddedToWatchlist = false,
  });

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    RequestState? movieState,
    List<Movie>? recommendations,
    RequestState? recommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieState: movieState ?? this.movieState,
      recommendations: recommendations ?? this.recommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object?> get props => [
        movieDetail,
        movieState,
        recommendations,
        recommendationState,
        message,
        watchlistMessage,
        isAddedToWatchlist,
      ];
}
