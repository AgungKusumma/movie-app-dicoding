import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: '/dummy_backdrop.jpg',
    genreIds: [10, 20],
    id: 999,
    originalName: 'Dummy Original Name',
    overview: 'This is a dummy overview of the TV series.',
    popularity: 123.45,
    posterPath: '/dummy_poster.jpg',
    firstAirDate: '2022-01-01',
    name: 'Dummy TV Show',
    video: false,
    voteAverage: 8.5,
    voteCount: 100,
  );

  final tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv/tv_series_now_playing.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/dummy_backdrop.jpg",
            "genre_ids": [10, 20],
            "id": 999,
            "original_name": "Dummy Original Name",
            "overview": "This is a dummy overview of the TV series.",
            "popularity": 123.45,
            "poster_path": "/dummy_poster.jpg",
            "first_air_date": "2022-01-01",
            "name": "Dummy TV Show",
            "video": false,
            "vote_average": 8.5,
            "vote_count": 100
          }
        ]
      };
      expect(result, expectedJsonMap);
    });
  });
}
