import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

import 'package:flutter_movie_app/Network/movietvsearch_list.dart';

final MovieTVRepository movieRepository = MovieTVProdRepository();

abstract class MovieTVRepository {
  Future<MoviesTVList> fetchMoviesTV(int pageNumber, String baseurl);
  Future<TVSearchList> fetchTVShows(int pageNumber, String baseurl);
}

class MovieTVProdRepository implements MovieTVRepository {
  @override
  Future<MoviesTVList> fetchMoviesTV(int pageNumber, String baseurl) async {
    final response = await http.get(baseurl + pageNumber.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(response.body);
      MoviesTVList moviesList = MoviesTVList.fromJson(decRes);
      return moviesList;
    } else {
      // If that call was not successful, throw an error.
      return null;
    }
  }

  @override
  Future<TVSearchList> fetchTVShows(int pageNumber, String baseurl) async {
    final response = await http.get(baseurl + pageNumber.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(response.body);
      TVSearchList moviesList = TVSearchList.fromJson(decRes);
      return moviesList;
    } else {
      // If that call was not successful, throw an error.
      return null;
    }
  }
}

class SearchScreen extends StatefulWidget {
  final String searchQuery;
  final String baseurl;
  final String type;

  SearchScreen({Key key, this.searchQuery, this.baseurl, this.type})
      : super(key: key);

  @override
  SearchScreenState createState() {
    return new SearchScreenState();
  }
}

class SearchScreenState extends State<SearchScreen> {
  Widget errorWidget() {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Text("Something Went Wrong!!!",
              style: TextStyle(fontSize: 22.0, color: Colors.grey[500])),
          SizedBox(height: 10.0),
          RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text("Try Again",
                  style: TextStyle(fontSize: 18.0, color: Colors.white)),
              onPressed: () {
                setState(() {});
              })
        ]));
  }

  Widget noResults() {
    return Center(child: Text("No results found"));
  }

  Future<void> _fetchMoviesTV;
  Future<void> _fetchTVShows;
  @override
  void initState() {
    if (widget.type.toLowerCase() == "movie") {
      _fetchMoviesTV = movieRepository.fetchMoviesTV(1, widget.baseurl);
    } else {
      _fetchTVShows = movieRepository.fetchTVShows(1, widget.baseurl);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchQuery),
      ),
      body: Container(
        padding: EdgeInsets.all(4.0),
        child: FutureBuilder(
          future: widget.type.toLowerCase() == "movie" ? _fetchMoviesTV : _fetchTVShows,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) return errorWidget();
                if (widget.type.toLowerCase() == "movie") {
                  MoviesTVList moviestv = snapshot.data;
                  return moviestv.results.length == 0
                      ? noResults()
                      : MovieTVTile(
                          moviestv: snapshot.data,
                          tvshowslist: null,
                          baseurl: widget.baseurl,
                          type: widget.type,
                        );
                } else {
                  TVSearchList tvshows = snapshot.data;
                  return tvshows.results.length == 0
                      ? noResults()
                      : MovieTVTile(
                          moviestv: null,
                          tvshowslist: snapshot.data,
                          baseurl: widget.baseurl,
                          type: widget.type,
                        );
                }
            }
            return null;
          },
        ),
      ),
    );
  }
}

enum MovieTVLoadMoreStatus { LOADING, STABLE }

class MovieTVTile extends StatefulWidget {
  final MoviesTVList moviestv;
  final TVSearchList tvshowslist;
  final String baseurl;
  final String type;
  MovieTVTile(
      {Key key, this.moviestv, this.tvshowslist, this.baseurl, this.type})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => MovieTVTileState();
}

class MovieTVTileState extends State<MovieTVTile> {
  MovieTVLoadMoreStatus loadMoreStatus = MovieTVLoadMoreStatus.STABLE;
  final ScrollController scrollController = new ScrollController();
  List<Results> movies;
  List<TVResults> tvshows;
  int currentPageNumber;
  bool pagesOver = false;
  CancelableOperation movieOperation;
  @override
  void initState() {
    movies = widget.moviestv != null ? widget.moviestv.results : null;
    tvshows = widget.tvshowslist != null ? widget.tvshowslist.results : null;
    currentPageNumber = widget.moviestv != null
        ? widget.moviestv.page
        : widget.tvshowslist.page;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    if (movieOperation != null) movieOperation.cancel();
    super.dispose();
  }

  Widget getMovieCard(Results movietv) {
    double width = MediaQuery.of(context).size.width;
    double height = width * 0.45;

    return Card(
      child: Container(
          width: width,
          height: height,
          child: Row(children: <Widget>[
            Container(
              width: width * 0.33,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      bottomLeft: Radius.circular(4.0)),
                  image: movietv.posterPath == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w342/" +
                                  movietv.posterPath),
                          fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 16.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8.0),
                  Text(
                    movietv.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.type,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Text(
                        "${movietv.voteAverage}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Icon(Icons.star, color: Colors.orange, size: 20.0),
                      SizedBox(width: 16.0)
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          movietv.overview,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        movietv.releaseDate.split('-')[0],
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ])),
    );
  }

  Widget getTVShowCard(TVResults tvshow) {
    double width = MediaQuery.of(context).size.width;
    double height = width * 0.45;

    return Card(
      child: Container(
          width: width,
          height: height,
          child: Row(children: <Widget>[
            Container(
              width: width * 0.33,
              height: height,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      bottomLeft: Radius.circular(4.0)),
                  image: tvshow.posterPath == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w342/" +
                                  tvshow.posterPath),
                          fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 16.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8.0),
                  Text(
                    tvshow.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.type,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Text(
                        "${tvshow.voteAverage}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Icon(Icons.star, color: Colors.orange, size: 20.0),
                      SizedBox(width: 16.0)
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          tvshow.overview,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        tvshow.firstAirDate.split('-')[0],
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
        onNotification: onNotification,
        child: new ListView.builder(
          padding: EdgeInsets.only(
            top: 5.0,
          ),
          controller: scrollController,
          itemCount: widget.moviestv != null ? movies.length : tvshows.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            return widget.type.toLowerCase() == "movie"
                ? getMovieCard(movies[index])
                : getTVShowCard(tvshows[index]);
          },
        ));
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (scrollController.position.extentAfter == 0) {
        if (loadMoreStatus != null &&
            loadMoreStatus == MovieTVLoadMoreStatus.STABLE &&
            !pagesOver) {
          debugPrint('Loading page ($currentPageNumber + 1)');
          loadMoreStatus = MovieTVLoadMoreStatus.LOADING;

          if (widget.type.toLowerCase() == "movie") {
            movieOperation = CancelableOperation.fromFuture(movieRepository
                .fetchMoviesTV(currentPageNumber + 1, widget.baseurl)
                .then((moviestvObject) {
              if (moviestvObject == null) {
                debugPrint('Api error');
                return;
              }
              currentPageNumber = moviestvObject.page;

              if (currentPageNumber == moviestvObject.totalPages) {
                pagesOver = true;
                debugPrint('Page Over');
              }

              loadMoreStatus = MovieTVLoadMoreStatus.STABLE;
              setState(() => movies.addAll(moviestvObject.results));
            }));
          } else {
            movieOperation = CancelableOperation.fromFuture(movieRepository
                .fetchTVShows(currentPageNumber + 1, widget.baseurl)
                .then((moviestvObject) {
              if (moviestvObject == null) {
                debugPrint('Api error');
                return;
              }
              currentPageNumber = moviestvObject.page;

              if (currentPageNumber == moviestvObject.totalPages) {
                pagesOver = true;
                debugPrint('Page Over');
              }

              loadMoreStatus = MovieTVLoadMoreStatus.STABLE;
              setState(() => tvshows.addAll(moviestvObject.results));
            }));
          }
        }
      }
    }

    return false;
  }
}

//https://api.themoviedb.org/3/search/multi?api_key=<<api_key>>&query=""&page=1
