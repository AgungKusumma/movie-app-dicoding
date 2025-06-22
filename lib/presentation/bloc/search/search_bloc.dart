import 'package:dartz/dartz.dart';
import 'package:ditonton/common/debounce.dart';
import 'package:ditonton/common/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc<T> extends Bloc<SearchEvent, SearchState<T>> {
  final Future<Either<Failure, List<T>>> Function(String query) search;

  SearchBloc(this.search) : super(SearchEmpty<T>()) {
    on<OnQueryChanged>(
      (event, emit) async {
        emit(SearchLoading<T>());
        final result = await search(event.query);
        result.fold(
          (failure) => emit(SearchError<T>(failure.message)),
          (data) => emit(SearchHasData<T>(data)),
        );
      },
      transformer: debounce(const Duration(milliseconds: 1000)),
    );
  }
}
