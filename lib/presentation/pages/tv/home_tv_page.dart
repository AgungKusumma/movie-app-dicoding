import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/home/now_playing/tv_series_now_playing_bloc.dart';
import 'package:ditonton/presentation/pages/tv/now_playing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_series_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeTvSeriesPage extends StatefulWidget {
  @override
  _HomeTvSeriesPageState createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesNowPlayingBloc>().add(FetchNowPlayingTvSeries());
    });
    Future.microtask(
        () => Provider.of<TvSeriesListNotifier>(context, listen: false)
          ..fetchPopularTvSeries()
          ..fetchTopRatedTvSeries());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubHeading(
            title: 'Now Playing',
            onTap: () =>
                Navigator.pushNamed(context, NowPlayingTvSeriesPage.ROUTE_NAME),
          ),
          BlocBuilder<TvSeriesNowPlayingBloc, TvSeriesNowPlayingState>(
            builder: (context, state) {
              if (state is TvSeriesNowPlayingLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TvSeriesNowPlayingLoaded) {
                return TvSeriesList(state.result);
              } else if (state is TvSeriesNowPlayingError) {
                return Center(child: Text(state.message));
              } else {
                return Container();
              }
            },
          ),
          _buildSubHeading(
            title: 'Popular',
            onTap: () =>
                Navigator.pushNamed(context, PopularTvSeriesPage.ROUTE_NAME),
          ),
          Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
            final state = data.popularTvSeriesState;
            if (state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state == RequestState.Loaded) {
              return TvSeriesList(data.popularTvSeries);
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () =>
                Navigator.pushNamed(context, TopRatedTvSeriesPage.ROUTE_NAME),
          ),
          Consumer<TvSeriesListNotifier>(
            builder: (context, data, child) {
              final state = data.topRatedTvSeriesState;
              if (state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.Loaded) {
                return TvSeriesList(data.topRatedTvSeries);
              } else {
                return Text('Failed');
              }
            },
          ),
        ],
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  TvSeriesList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvSeriesDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
