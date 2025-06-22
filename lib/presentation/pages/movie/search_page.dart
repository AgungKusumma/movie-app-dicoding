import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/search/search_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search - Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchBloc<Movie>>().add(OnQueryChanged(query));
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
              child: BlocBuilder<SearchBloc<Movie>, SearchState<Movie>>(
                builder: (context, state) {
                  if (state is SearchLoading<Movie>) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchHasData<Movie>) {
                    final result = state.result;

                    if (result.isEmpty) {
                      return Center(
                        child: Text(
                          'Movies not found.',
                          style: kSubtitle,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = result[index];
                          return MovieCard(movie);
                        },
                        itemCount: result.length,
                      );
                    }
                  } else if (state is SearchError<Movie>) {
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
