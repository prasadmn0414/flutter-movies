import 'package:flutter/material.dart';
import 'package:flutter_movie_app/Constants.dart';
import 'package:flutter_movie_app/Network/moviedetail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieid;
  MovieDetailScreen(this.movieid);

  @override
  _MainCollapsingToolbarState createState() => _MainCollapsingToolbarState();
}

var kExpandedHeight = 0.0;
var screenWidth = 0.0;
var screenHeight = 0.0;

class _MainCollapsingToolbarState extends State<MovieDetailScreen> {
  ScrollController _scrollController;
  MovieDetails movieDetails;

  Future<void> _getMovieDetails;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _getMovieDetails = getMovieDetails();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    kExpandedHeight = screenHeight * 0.5;
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  Future<void> getMovieDetails() async {
    int movieid = widget.movieid;
    String url = 'https://api.themoviedb.org/3/movie/$movieid?api_key=$apikey';
    final movieDetailResponse = await http.get(url);
    if (movieDetailResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(movieDetailResponse.body);
      movieDetails = MovieDetails.fromJson(decRes);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }
  }

  String getGenres(List<Genres> genres) {
    String genre = "";
    for (var i = 0; i < genres.length; i++) {
      if (i != genres.length - 1) {
        genre = genre + genres[i].name + ", ";
      } else {
        genre = genre + genres[i].name;
      }
    }

    return genre;
  }

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
                setState(() {
                  _getMovieDetails = getMovieDetails();
                });
              })
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _getMovieDetails,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("");
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) return errorWidget();
            return movieDetailsSliverAppbar();
        }
        return null;
      },
    ));
  }

  Widget movieDetailsSliverAppbar() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: kExpandedHeight,
            floating: false,
            pinned: true,
            title: _showTitle ? Text(movieDetails.title) : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Theme.of(context).accentColor,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: screenWidth,
                          height: kExpandedHeight * 0.66,
                          color: Colors.grey,
                          child: CachedNetworkImage(
                            imageUrl: "https://image.tmdb.org/t/p/w780" +
                                movieDetails.backdropPath,
                            fit: BoxFit.fill,
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      left: 0.0,
                      top: 0.0,
                      child: Container(
                        width: screenWidth,
                        height: kExpandedHeight * 0.66,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Positioned(
                      left: 20.0,
                      bottom: 32.0,
                      right: 16.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: screenWidth / 4,
                            height: (screenWidth / 4) *
                                    (screenHeight / screenWidth) -
                                30.0,
                            color: Colors.grey,
                            child: CachedNetworkImage(
                              imageUrl: "https://image.tmdb.org/t/p/w342" +
                                  movieDetails.posterPath,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                SizedBox(
                                  height: 24.0,
                                ),
                                Text(movieDetails.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                    )),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Text(getGenres(movieDetails.genres),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13.0,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: movieDetailsBody(),
    );
  }

  Widget movieDetailsBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 28.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "${movieDetails.voteAverage}",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '/10',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: <Widget>[
                Text(
                  movieDetails.overview,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Release Date",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold)),
                        Text("Runtime",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dateTimeFormat(movieDetails.releaseDate),
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "${(movieDetails.runtime ~/ 60.0)} hr ${(movieDetails.runtime % 60.0).toInt()} mins",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String dateTimeFormat(String mDate) {
    var parsedDate = DateTime.parse(mDate);
    var formatter = new DateFormat('MMM d, y');
    String formatted = formatter.format(parsedDate);
    return formatted;
  }
}
