part of 'tv_series_detail_bloc.dart';

class TvSeriesDetailState extends Equatable {
  final TvSeriesDetail? tvSeriesDetail;
  final RequestState tvSeriesState;

  final List<TvSeries> recommendations;
  final RequestState recommendationState;

  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  const TvSeriesDetailState({
    this.tvSeriesDetail,
    this.tvSeriesState = RequestState.Empty,
    this.recommendations = const [],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.watchlistMessage = '',
    this.isAddedToWatchlist = false,
  });

  TvSeriesDetailState copyWith({
    TvSeriesDetail? tvSeriesDetail,
    RequestState? tvSeriesState,
    List<TvSeries>? recommendations,
    RequestState? recommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return TvSeriesDetailState(
      tvSeriesDetail: tvSeriesDetail ?? this.tvSeriesDetail,
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      recommendations: recommendations ?? this.recommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  @override
  List<Object?> get props => [
        tvSeriesDetail,
        tvSeriesState,
        recommendations,
        recommendationState,
        message,
        watchlistMessage,
        isAddedToWatchlist,
      ];
}
