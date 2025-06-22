import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_now_playing_event.dart';
part 'tv_series_now_playing_state.dart';

class TvSeriesNowPlayingBloc
    extends Bloc<TvSeriesNowPlayingEvent, TvSeriesNowPlayingState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;

  TvSeriesNowPlayingBloc(this.getNowPlayingTvSeries)
      : super(TvSeriesNowPlayingEmpty()) {
    on<FetchNowPlayingTvSeries>((event, emit) async {
      emit(TvSeriesNowPlayingLoading());
      final result = await getNowPlayingTvSeries.execute();
      result.fold(
        (failure) => emit(TvSeriesNowPlayingError(failure.message)),
        (data) => emit(TvSeriesNowPlayingLoaded(data)),
      );
    });
  }
}
