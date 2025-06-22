import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv/detail/tv_series_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvSeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-series';

  final int id;

  TvSeriesDetailPage({required this.id});

  @override
  _TvSeriesDetailPageState createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesDetailBloc>()
        ..add(FetchTvSeriesDetail(widget.id))
        ..add(LoadTvSeriesWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TvSeriesDetailBloc, TvSeriesDetailState>(
        listener: (context, state) {
          final message = state.watchlistMessage;
          if (message.isNotEmpty) {
            if (message == 'Added to Watchlist' ||
                message == 'Removed from Watchlist') {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            } else {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(content: Text(message)),
              );
            }

            context.read<TvSeriesDetailBloc>().add(ResetTvWatchlistMessage());
          }
        },
        builder: (context, state) {
          if (state.tvSeriesState == RequestState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.tvSeriesState == RequestState.Loaded) {
            final tvSeries = state.tvSeriesDetail!;
            return SafeArea(
              child: DetailContent(
                tvSeries: tvSeries,
                recommendations: state.recommendations,
                isAddedWatchlist: state.isAddedToWatchlist,
              ),
            );
          } else if (state.tvSeriesState == RequestState.Error) {
            return Center(child: Text(state.message));
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedWatchlist;

  const DetailContent({
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvSeries.name,
                              style: kHeading5,
                            ),
                            FilledButton(
                              onPressed: () {
                                if (isAddedWatchlist) {
                                  context.read<TvSeriesDetailBloc>().add(
                                        RemoveTvSeriesFromWatchlist(tvSeries),
                                      );
                                } else {
                                  context.read<TvSeriesDetailBloc>().add(
                                        AddTvSeriesToWatchlist(tvSeries),
                                      );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(isAddedWatchlist
                                      ? Icons.check
                                      : Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tvSeries.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvSeries.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: tvSeries.seasons.length,
                              separatorBuilder: (_, __) =>
                                  Divider(color: Colors.grey),
                              itemBuilder: (context, index) {
                                final season = tvSeries.seasons[index];
                                final airDate =
                                    season.airDate?.isNotEmpty == true
                                        ? season.airDate!
                                        : 'Unknown';
                                final episodeCount = season.episodeCount;
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    '${season.name} • $airDate • $episodeCount episode${episodeCount != 1 ? 's' : ''}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            _buildRecommendations(context),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    return BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
      builder: (context, state) {
        if (state.recommendationState == RequestState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.recommendationState == RequestState.Error) {
          return Text(state.message);
        } else if (state.recommendationState == RequestState.Loaded) {
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              itemBuilder: (_, index) {
                final movie = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        TvSeriesDetailPage.ROUTE_NAME,
                        arguments: movie.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        placeholder: (_, __) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (_, __, ___) => Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
