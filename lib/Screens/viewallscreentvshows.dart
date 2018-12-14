import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_movie_app/Network/tvshows_list.dart';

class ViewAll extends StatefulWidget {
  final String title;
  final String baseurl;

  ViewAll({Key key, this.title, this.baseurl}) : super(key: key);

  @override
  ViewAllState createState() {
    return new ViewAllState();
  }
}

class ViewAllState extends State<ViewAll> {
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

  Future<void> _fetchTVShows;
  @override
  void initState() {
    _fetchTVShows = movieRepository.fetchTVShows(1, widget.baseurl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(4.0),
        child: FutureBuilder(
          future: _fetchTVShows,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) return errorWidget();
                return TvShowTile(
                  movies: snapshot.data,
                  baseurl: widget.baseurl,
                );
            }
            return null;
          },
        ),
      ),
    );
  }
}

enum TvShowLoadMoreStatus { LOADING, STABLE }

class TvShowTile extends StatefulWidget {
  final TvShowsList movies;
  final String baseurl;
  TvShowTile({Key key, this.movies, this.baseurl}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TvShowTileState();
}

class TvShowTileState extends State<TvShowTile> {
  TvShowLoadMoreStatus loadMoreStatus = TvShowLoadMoreStatus.STABLE;
  final ScrollController scrollController = new ScrollController();
  List<Results> tvshows;
  int currentPageNumber;
  bool pagesOver = false;
  CancelableOperation movieOperation;
  @override
  void initState() {
    tvshows = widget.movies.results;
    currentPageNumber = widget.movies.page;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    if (movieOperation != null) movieOperation.cancel();
    super.dispose();
  }

  Widget getSmallCard(Results tvshow) {
    return Card(child: LayoutBuilder(builder: (context, constraints) {
      return Column(children: <Widget>[
        Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight * 0.7,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  topRight: Radius.circular(5.0)),
              /*image: DecorationImage(
                image: NetworkImage(
                    "https://image.tmdb.org/t/p/w342/" + tvshow.posterPath),
                fit: BoxFit.cover,
              )*/
            ),
            child: ClipRRect(
               borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                          child: CachedNetworkImage(
                imageUrl: "https://image.tmdb.org/t/p/w342" + tvshow.posterPath,
                fit: BoxFit.cover,
              ),
            )),
        Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight * 0.3,
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          tvshow.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(Icons.favorite_border, size: 20.0, color: Colors.grey)
                  ],
                )
              ],
            ))
      ]);
    }));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.31;
    final double height = MediaQuery.of(context).size.width * 0.9 * 0.8;

    return NotificationListener(
      onNotification: onNotification,
      child: new GridView.builder(
        padding: EdgeInsets.only(
          top: 5.0,
        ), // EdgeInsets.only
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: width / height,
          //childAspectRatio : MediaQuery.of(context).size.width * 0.9 * 0.8,
        ), // SliverGridDelegateWithFixedCrossAxisCount
        controller: scrollController,
        itemCount: tvshows.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return getSmallCard(tvshows[index]);
        },
      ), // GridView.builder
    ); // NotificationListener
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (scrollController.position.extentAfter == 0) {
        if (loadMoreStatus != null &&
            loadMoreStatus == TvShowLoadMoreStatus.STABLE &&
            !pagesOver) {
          debugPrint('Loading page $currentPageNumber');
          loadMoreStatus = TvShowLoadMoreStatus.LOADING;
          movieOperation = CancelableOperation.fromFuture(movieRepository
              .fetchTVShows(currentPageNumber + 1, widget.baseurl)
              .then((tvshowsObject) {
            if (tvshowsObject == null) {
              debugPrint('Api error');
              return;
            }
            currentPageNumber = tvshowsObject.page;

            if (currentPageNumber == tvshowsObject.totalPages) {
              pagesOver = true;
              debugPrint('Page Over');
            }

            loadMoreStatus = TvShowLoadMoreStatus.STABLE;
            setState(() => tvshows.addAll(tvshowsObject.results));
          }));
        }
      }
    }

    return false;
  }
}

final TvShowRepository movieRepository = TvShowRepositoryProdRepository();

abstract class TvShowRepository {
  Future<TvShowsList> fetchTVShows(int pageNumber, String baseurl);
}

class TvShowRepositoryProdRepository implements TvShowRepository {
  @override
  Future<TvShowsList> fetchTVShows(int pageNumber, String baseurl) async {
    final response = await http.get(baseurl + pageNumber.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(response.body);
      TvShowsList tvshowsList = TvShowsList.fromJson(decRes);
      return tvshowsList;
    } else {
      // If that call was not successful, throw an error.
      return null;
    }
  }
}
