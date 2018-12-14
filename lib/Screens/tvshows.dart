import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/Screens/viewallscreentvshows.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_movie_app/Network/tvshows_list.dart';
import 'package:flutter_movie_app/Network/genres.dart';
import 'package:flutter_movie_app/Constants.dart';

enum TvShowsTypes { AIRINGTODAY, ONTHEAIR, POPULAR, TOPRATED }

class TvShows extends StatefulWidget {
  @override
  _TvShowsState createState() => _TvShowsState();
}

class _TvShowsState extends State<TvShows> {
  List<Results> airingTodayResults;
  List<Results> onTheAirResults;
  List<Results> popularResults;
  List<Results> topRatedResults;
  List<Genres> genresList;

  String getGenres(List<int> list) {
    String genre = "";
    List<Genres> filteredList = genresList.where((item) {
      return list.contains(item.id);
    }).toList();

    for (var i = 0; i < filteredList.length; i++) {
      if (i != filteredList.length - 1) {
        genre = genre + filteredList[i].name + ", ";
      } else {
        genre = genre + filteredList[i].name;
      }
    }

    return genre;
  }

  Widget getBigCard(Results tvshow) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double height = width * 0.8;

    return Card(
      child: Container(
        width: width,
        height: height,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  width: width,
                  height: height * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                      /*image: DecorationImage(
                        image: NetworkImage("https://image.tmdb.org/t/p/w780/" +
                            tvshow.backdropPath),
                        fit: BoxFit.cover,
                      )*/),
                      child: CachedNetworkImage(
                    imageUrl:
                        "https://image.tmdb.org/t/p/w780" + tvshow.backdropPath,
                    fit: BoxFit.cover,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(tvshow.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        "${tvshow.voteAverage}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 15.0,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
                width: width,
                height: height * 0.2,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        getGenres(tvshow.genreIds),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 14.0),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.favorite_border,
                            size: 20.0, color: Colors.grey)
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget getSmallCard(Results tvshow) {
    double width = MediaQuery.of(context).size.width * 0.3;
    //double height = MediaQuery.of(context).size.width * 0.9 * 0.8;

    return Card(child: LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: width,
        height: constraints.maxHeight,
        child: Column(
          children: <Widget>[
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
                  )*/),
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://image.tmdb.org/t/p/w342" + tvshow.posterPath,
                    fit: BoxFit.cover,
                  )
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
                        Icon(Icons.favorite_border,
                            size: 20.0, color: Colors.grey)
                      ],
                    )
                  ],
                ))
          ],
        ),
      );
    }));

    /*return Card(
      child: Container(
        width: width,
        height: height,
        child: Column(
          children: <Widget>[
            Container(
              width: width,
              height: height * 0.7,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0)),
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://image.tmdb.org/t/p/w342/" + tvshow.posterPath),
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
                width: width,
                height: height * 0.3,
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
                        Icon(Icons.favorite_border,
                            size: 20.0, color: Colors.grey)
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );*/
  }

  Widget titleCardWidget(
      TvShowsTypes tvtype, bool showBigCard, List<Results> movieList) {
    String title = "";
    String baseurl = "";
    switch (tvtype) {
      case TvShowsTypes.AIRINGTODAY:
        title = "Airing Today";
        baseurl =
            'https://api.themoviedb.org/3/tv/airing_today?api_key=$apikey&language=en-US&page=';
        break;
      case TvShowsTypes.ONTHEAIR:
        title = "On the Air";
        baseurl =
            'https://api.themoviedb.org/3/tv/on_the_air?api_key=$apikey&language=en-US&page=';
        break;
      case TvShowsTypes.POPULAR:
        title = "Popular";
        baseurl =
            'https://api.themoviedb.org/3/tv/popular?api_key=$apikey&language=en-US&page=';
        break;
      case TvShowsTypes.TOPRATED:
        title = "Top Rated";
        baseurl =
            'https://api.themoviedb.org/3/tv/top_rated?api_key=$apikey&language=en-US&page=';
        break;
    }

    return Container(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAll(
                                title: title + ' TV Shows', baseurl: baseurl)));
                  },
                  child: Text("View All",
                      style: TextStyle(color: Theme.of(context).accentColor)),
                ),
              ],
            ),
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
                itemCount: movieList.length,
                itemBuilder: (BuildContext context, int index) {
                  return showBigCard == true
                      ? getBigCard(movieList[index])
                      : getSmallCard(movieList[index]);
                }),
          )
        ],
      ),
    );
  }

  Future<void> getTVShows() async {
    final airingTodayResponse = await http.get(
        'https://api.themoviedb.org/3/tv/airing_today?api_key=$apikey&language=en-US&page=1');
    if (airingTodayResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(airingTodayResponse.body);
      airingTodayResults = TvShowsList.fromJson(decRes).results;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }

    final onTheAirResponse = await http.get(
        'https://api.themoviedb.org/3/tv/on_the_air?api_key=$apikey&language=en-US&page=1');
    if (onTheAirResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(onTheAirResponse.body);
      onTheAirResults = TvShowsList.fromJson(decRes).results;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }

    final popularResponse = await http.get(
        'https://api.themoviedb.org/3/tv/popular?api_key=$apikey&language=en-US&page=1');
    if (popularResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(popularResponse.body);
      popularResults = TvShowsList.fromJson(decRes).results;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }

    final topRatedResponse = await http.get(
        'https://api.themoviedb.org/3/tv/top_rated?api_key=$apikey&language=en-US&page=1');
    if (topRatedResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(topRatedResponse.body);
      topRatedResults = TvShowsList.fromJson(decRes).results;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }

    final genreResponse = await http.get(
        'https://api.themoviedb.org/3/genre/tv/list?api_key=$apikey&language=en-US');
    if (genreResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(genreResponse.body);
      genresList = GenresList.fromJson(decRes).genres;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }
  }

  Widget tvShowsWidget() {
    return ListView(
      children: <Widget>[
        titleCardWidget(TvShowsTypes.AIRINGTODAY, true, airingTodayResults),
        titleCardWidget(TvShowsTypes.ONTHEAIR, false, onTheAirResults),
        titleCardWidget(TvShowsTypes.POPULAR, true, popularResults),
        titleCardWidget(TvShowsTypes.TOPRATED, false, topRatedResults)
      ],
    );
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
                  _getTVShows = getTVShows();
                });
              })
        ]));
  }

  Future<void> _getTVShows;
  @override
  void initState() {
    _getTVShows = getTVShows();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: FutureBuilder(
          future: _getTVShows,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) return errorWidget();
                return tvShowsWidget();
            }
            return null;
          },
        ));
  }
}
