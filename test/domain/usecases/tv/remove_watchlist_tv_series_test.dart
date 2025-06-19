import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv/dummy_objects_tv_series.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should remove watchlist TvSeries from repository', () async {
    // arrange
    when(mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.removeWatchlist(testTvSeriesDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
