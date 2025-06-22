import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/constants.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv-series';

  @override
  _WatchlistTvSeriesPageState createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist - TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
          builder: (context, state) {
            if (state is WatchlistTvSeriesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is WatchlistTvSeriesEmpty) {
              return Center(
                child: Text(
                  'Watchlist is empty.',
                  style: kSubtitle,
                ),
              );
            } else if (state is WatchlistTvSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.tvSeries[index];
                  return TvSeriesCard(movie);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is WatchlistTvSeriesError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(child: Text('No data.'));
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
