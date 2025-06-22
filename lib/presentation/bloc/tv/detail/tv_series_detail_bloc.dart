import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTvSeries getWatchListTvStatus;
  final SaveWatchlistTvSeries saveTvWatchlist;
  final RemoveWatchlistTvSeries removeTvWatchlist;

  TvSeriesDetailBloc(
    this.getTvSeriesDetail,
    this.getTvSeriesRecommendations,
    this.getWatchListTvStatus,
    this.saveTvWatchlist,
    this.removeTvWatchlist,
  ) : super(const TvSeriesDetailState()) {
    on<FetchTvSeriesDetail>(_onFetchTvSeriesDetail);
    on<AddTvSeriesToWatchlist>(_onAddToWatchlist);
    on<RemoveTvSeriesFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadTvSeriesWatchlistStatus>(_onLoadWatchlistStatus);
    on<ResetTvWatchlistMessage>((event, emit) {
      emit(state.copyWith(watchlistMessage: ''));
    });
  }

  Future<void> _onFetchTvSeriesDetail(
    FetchTvSeriesDetail event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(tvSeriesState: RequestState.Loading));

    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationResult =
        await getTvSeriesRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          tvSeriesState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvDetail) {
        emit(state.copyWith(
          tvSeriesDetail: tvDetail,
          tvSeriesState: RequestState.Loaded,
        ));

        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
            ));
          },
          (recommendations) {
            emit(state.copyWith(
              recommendationState: RequestState.Loaded,
              recommendations: recommendations,
            ));
          },
        );
      },
    );
  }

  Future<void> _onAddToWatchlist(
    AddTvSeriesToWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await saveTvWatchlist.execute(event.tvSeries);
    final message = result.fold((f) => f.message, (msg) => msg);

    emit(state.copyWith(watchlistMessage: message));
    add(LoadTvSeriesWatchlistStatus(event.tvSeries.id));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveTvSeriesFromWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await removeTvWatchlist.execute(event.tvSeries);
    final message = result.fold((f) => f.message, (msg) => msg);

    emit(state.copyWith(watchlistMessage: message));
    add(LoadTvSeriesWatchlistStatus(event.tvSeries.id));
  }

  Future<void> _onLoadWatchlistStatus(
    LoadTvSeriesWatchlistStatus event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await getWatchListTvStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
