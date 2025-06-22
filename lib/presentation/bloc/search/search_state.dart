part of 'search_bloc.dart';

abstract class SearchState<T> extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchEmpty<T> extends SearchState<T> {}

class SearchLoading<T> extends SearchState<T> {}

class SearchError<T> extends SearchState<T> {
  final String message;
  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchHasData<T> extends SearchState<T> {
  final List<T> result;
  const SearchHasData(this.result);

  @override
  List<Object?> get props => [result];
}
