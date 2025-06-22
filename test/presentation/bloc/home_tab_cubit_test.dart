import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/home_tab_enum.dart';
import 'package:ditonton/presentation/bloc/home_tab_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeTabCubit', () {
    late HomeTabCubit tabCubit;

    setUp(() {
      tabCubit = HomeTabCubit();
    });

    tearDown(() {
      tabCubit.close();
    });

    test('initial state is HomeTab.movie', () {
      expect(tabCubit.state, HomeTab.movie);
    });

    blocTest<HomeTabCubit, HomeTab>(
      'emits [HomeTab.tv] when setTab(HomeTab.tv) is called',
      build: () => tabCubit,
      act: (cubit) => cubit.setTab(HomeTab.tv),
      expect: () => [HomeTab.tv],
    );

    blocTest<HomeTabCubit, HomeTab>(
      'does not emit when setTab is called with same value',
      build: () => tabCubit,
      act: (cubit) => cubit.setTab(HomeTab.movie),
      expect: () => [],
    );
  });
}
