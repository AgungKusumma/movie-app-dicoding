import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc(this.getWatchlistTvSeries)
      : super(WatchlistTvSeriesEmpty()) {
    on<FetchWatchlistTvSeries>((event, emit) async {
      emit(WatchlistTvSeriesLoading());
      final result = await getWatchlistTvSeries.execute();

      result.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (movies) {
          if (movies.isEmpty) {
            emit(WatchlistTvSeriesEmpty());
          } else {
            emit(WatchlistTvSeriesLoaded(movies));
          }
        },
      );
    });
  }
}
