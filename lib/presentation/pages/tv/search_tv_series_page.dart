import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTvSeriesPage extends StatelessWidget {
  static const ROUTE_NAME = '/search-tv-series';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search - TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchBloc<TvSeries>>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Expanded(
              child: BlocBuilder<SearchBloc<TvSeries>, SearchState<TvSeries>>(
                builder: (context, state) {
                  if (state is SearchLoading<TvSeries>) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchHasData<TvSeries>) {
                    final result = state.result;

                    if (result.isEmpty) {
                      return Center(
                        child: Text(
                          'TV Series not found.',
                          style: kSubtitle,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final tvSeries = result[index];
                          return TvSeriesCard(tvSeries);
                        },
                        itemCount: result.length,
                      );
                    }
                  } else if (state is SearchError<TvSeries>) {
                    return Center(
                      child: Text(
                        'Error, please check your internet connection!',
                        style: kSubtitle,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
