import 'package:ditonton/common/home_tab_enum.dart';
import 'package:ditonton/injection.dart';
import 'package:ditonton/presentation/pages/movie/about_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/home_tv_page.dart';
import 'package:ditonton/presentation/pages/tv/search_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_series_page.dart';
import 'package:ditonton/presentation/provider/home_tab_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeRootPage extends StatelessWidget {
  static const ROUTE_NAME = '/home';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<HomeTabNotifier>(),
      child: Consumer<HomeTabNotifier>(
        builder: (context, notifier, _) {
          final currentTab = notifier.currentTab;

          return Scaffold(
            drawer: _buildDrawer(context, notifier),
            appBar: AppBar(
              title: Text(currentTab == HomeTab.movie
                  ? 'Ditonton - Movies'
                  : 'Ditonton - TV Series'),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final route = currentTab == HomeTab.movie
                        ? SearchPage.ROUTE_NAME
                        : SearchTvSeriesPage.ROUTE_NAME;
                    Navigator.pushNamed(context, route);
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: currentTab == HomeTab.movie
                  ? HomeMoviePage()
                  : HomeTvSeriesPage(),
            ),
          );
        },
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, HomeTabNotifier notifier) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/circle-g.png'),
            ),
            accountName: const Text('Ditonton'),
            accountEmail: const Text('ditonton@dicoding.com'),
            decoration: BoxDecoration(color: Colors.grey.shade900),
          ),
          ListTile(
            leading: Icon(Icons.movie),
            title: Text('Movies'),
            onTap: () {
              notifier.setTab(HomeTab.movie);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.tv),
            title: Text('TV Series'),
            onTap: () {
              notifier.setTab(HomeTab.tv);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.save_alt),
            title: Text('Watchlist - Movies'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
            },
          ),
          ListTile(
            leading: Icon(Icons.save_alt),
            title: Text('Watchlist - TV Series'),
            onTap: () {
              Navigator.pushNamed(context, WatchlistTvSeriesPage.ROUTE_NAME);
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () {
              Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
            },
          ),
        ],
      ),
    );
  }
}
