import 'package:flutter/material.dart';
import 'package:flutter_movie_app/Constants.dart';
import 'package:flutter_movie_app/Network/moviedetail.dart';
import 'package:flutter_movie_app/Network/movies_list.dart';
import 'package:flutter_movie_app/Utils/Favorite.dart';
import 'package:flutter_movie_app/Utils/Storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
  double offset = 0.0;

  ScrollController _scrollController;
  MovieDetails movieDetails;

  Future<void> _getMovieDetails;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() => setState(() {
            offset = _scrollController.offset;
          }));
    _getMovieDetails = getMovieDetails();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        offset > kExpandedHeight - kToolbarHeight;
  }

  Future<void> getMovieDetails() async {
    int movieid = widget.movieid;
    String url =
        'https://api.themoviedb.org/3/movie/$movieid?api_key=$apikey&append_to_response=videos,credits,similar';
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
                      top: 40.0,
                      right: 20.0,
                      child: FavoriteWidget(
                        allowToggle: true,
                        movieid: widget.movieid,
                        isFavorited: false,
                        iconSize: 30.0,
                        iconColor: Colors.white,
                        onFavoritePressed: () {},
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.only(
                left: 22.0, top: 16.0, right: 16.0, bottom: 16.0),
            child: Text("Trailers",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500)),
          ),
          Container(
            padding:
                EdgeInsets.only(left: 4.0, top: 0.0, bottom: 0.0, right: 4.0),
            height: (MediaQuery.of(context).size.width * 0.5) + 40.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                primary: false,
                itemCount: movieDetails.videos.results.length,
                itemBuilder: (BuildContext context, int index) {
                  return getTrailerCard(movieDetails.videos.results[index]);
                }),
          ),
          Divider(
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 22.0, top: 16.0, right: 16.0, bottom: 16.0),
            child: Text("Cast",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500)),
          ),
          Container(
            //color: Colors.lightBlueAccent,
            padding: EdgeInsets.all(8.0),
            height: (MediaQuery.of(context).size.width * 0.5) + 30.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                primary: false,
                itemCount: movieDetails.credits.cast.length,
                itemBuilder: (BuildContext context, int index) {
                  return getCastCard(movieDetails.credits.cast[index]);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 22.0, top: 16.0, right: 16.0, bottom: 16.0),
            child: Text("Similar Movies",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500)),
          ),
          Container(
            height: (MediaQuery.of(context).size.width * 0.9 * 0.8) +
                8.0, // height = 90% of screenwidth + 8
            //color: Colors.amber,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                primary: false,
                itemCount: movieDetails.similar.results.length,
                itemBuilder: (BuildContext context, int index) {
                  return getSmallCard(movieDetails.similar.results[index]);
                }),
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }

  Widget getTrailerCard(VideoResults result) {
    double width = MediaQuery.of(context).size.height * 0.5;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: <Widget>[
              Material(
                elevation: 3.0,
                child: InkWell(
                  onTap: () {
                    _launchURL("https://www.youtube.com/watch?v=" + result.key);
                  },
                  child: Container(
                    width: width,
                    height: constraints.maxHeight * 0.82,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: CachedNetworkImage(
                        imageUrl: "https://i1.ytimg.com/vi/" +
                            result.key +
                            "/sddefault.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: width,
                height: constraints.maxHeight * 0.18,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                  child: Text(result.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal)),
                ),
              )
            ],
          );
        }));
  }

  Widget getCastCard(Cast cast) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          var width = constraints.maxHeight * 0.55;
          return Column(
            children: <Widget>[
              Container(
                width: width,
                height: width,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(width / 2),
                ),
                child: cast.profilePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(width / 2),
                        child: CachedNetworkImage(
                          imageUrl: "https://image.tmdb.org/t/p/w342" +
                              cast.profilePath,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                  //color: Colors.greenAccent,
                  width: constraints.maxHeight * 0.8,
                  height: constraints.maxHeight * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      Text(cast.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(cast.character,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal)),
                    ],
                  ))
            ],
          );
        }));
  }

  Widget getSmallCard(SimilarResults movie) {
    double width = MediaQuery.of(context).size.width * 0.3;
    // double height = 100.0;//MediaQuery.of(context).size.width * 0.9 * 0.8;

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie.id)));
      },
      child: Card(child: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: width,
          height: constraints.maxHeight,
          child: Column(children: <Widget>[
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
                        "https://image.tmdb.org/t/p/w342/" + movie.posterPath),
                    fit: BoxFit.cover,
                  )*/
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0)),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://image.tmdb.org/t/p/w342" + movie.posterPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                              movie.title,
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
                        Icon(Icons.favorite_border,
                            size: 20.0, color: Colors.grey)
                      ],
                    )
                  ],
                ))
          ]),
        );
      })),
    );
  }

  String dateTimeFormat(String mDate) {
    var parsedDate = DateTime.parse(mDate);
    var formatter = new DateFormat('MMM d, y');
    String formatted = formatter.format(parsedDate);
    return formatted;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showDialog();
    }
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Movies"),
          content: new Text("Could not play video !!!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
