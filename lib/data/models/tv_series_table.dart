import 'package:equatable/equatable.dart';

class TvSeriesTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;

  TvSeriesTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  // factory TvSeriesTable.fromEntity(TvSeriesDetail movie) => TvSeriesTable(
  //       id: movie.id,
  //       title: movie.title,
  //       posterPath: movie.posterPath,
  //       overview: movie.overview,
  //     );

  factory TvSeriesTable.fromMap(Map<String, dynamic> map) => TvSeriesTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
      };

  // TvSeries toEntity() => TvSeries.watchlist(
  //       id: id,
  //       overview: overview,
  //       posterPath: posterPath,
  //       title: title,
  //     );

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, posterPath, overview];
}
