import 'package:ditonton/common/home_tab_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabCubit extends Cubit<HomeTab> {
  HomeTabCubit() : super(HomeTab.movie);

  void setTab(HomeTab tab) {
    if (state != tab) emit(tab);
  }
}
