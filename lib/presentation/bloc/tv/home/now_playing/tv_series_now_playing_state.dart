part of 'tv_series_now_playing_bloc.dart';

abstract class TvSeriesNowPlayingState extends Equatable {
  const TvSeriesNowPlayingState();

  @override
  List<Object> get props => [];
}

class TvSeriesNowPlayingEmpty extends TvSeriesNowPlayingState {}

class TvSeriesNowPlayingLoading extends TvSeriesNowPlayingState {}

class TvSeriesNowPlayingLoaded extends TvSeriesNowPlayingState {
  final List<TvSeries> result;

  const TvSeriesNowPlayingLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TvSeriesNowPlayingError extends TvSeriesNowPlayingState {
  final String message;

  const TvSeriesNowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}
