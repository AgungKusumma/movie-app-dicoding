part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;

  const FetchTvSeriesDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class AddTvSeriesToWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const AddTvSeriesToWatchlist(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class RemoveTvSeriesFromWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const RemoveTvSeriesFromWatchlist(this.tvSeries);

  @override
  List<Object?> get props => [tvSeries];
}

class LoadTvSeriesWatchlistStatus extends TvSeriesDetailEvent {
  final int id;

  const LoadTvSeriesWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class ResetTvWatchlistMessage extends TvSeriesDetailEvent {}
