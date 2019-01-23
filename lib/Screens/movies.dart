import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_movie_app/Screens/moviedetailscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_movie_app/Network/movies_list.dart';
import 'package:flutter_movie_app/Network/genres.dart';
import 'package:flutter_movie_app/Screens/viewallscreenmovies.dart';
import 'package:flutter_movie_app/Constants.dart';
import 'package:flutter_movie_app/Utils/Favorite.dart';
import 'package:flutter_movie_app/Utils/Storage.dart';

enum MovieTypes { NOWSHOWING, POPULAR, UPCOMING, TOPRATED }

class Movies extends StatefulWidget {
  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  List<Results> nowShowingResults;
  List<Results> popularResults;
  List<Results> upcomingResults;
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

  Widget getBigCard(Results movie) {
    double width = MediaQuery.of(context).size.width * 0.9;
    double height = width * 0.8;

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie.id)));
      },
      child: Card(
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
                              movie.backdropPath),
                          fit: BoxFit.cover,
                        )*/
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                      child: CachedNetworkImage(
                        imageUrl: "https://image.tmdb.org/t/p/w780/" +
                            movie.backdropPath,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(movie.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "${movie.voteAverage}",
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
                          getGenres(movie.genreIds),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 14.0),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FavoriteWidget(
                            movieid: movie.id,
                            isFavorited: false,
                            onFavoritePressed: () {

                              // Write the string to file for saving favourites
                              readFile(favFile).then((String filedata) {
                                List<Results> favMovies = [];
                                if (filedata.length > 0) {
                                  jsonDecode(filedata).forEach((map) {
                                    Results obj = Results.fromJson(map);
                                    if (obj.id != movie.id) {
                                      favMovies.add(obj);
                                    }
                                  });
                                }
                                favMovies.add(movie);
                                String res = jsonEncode(favMovies);
                                cleanFile(favFile).then((File file) {
                                  writeFile(res, favFile);
                                });
                              });
                            },
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget getSmallCard(Results movie) {
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
                        "https://image.tmdb.org/t/p/w342/" + movie.posterPath),
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
          ],
        ),
      ),
    );*/
  }

  Widget titleCardWidget(
      MovieTypes movietype, bool showBigCard, List<Results> movieList) {
    String title = "";
    String baseurl = "";
    switch (movietype) {
      case MovieTypes.NOWSHOWING:
        title = "Now Showing";
        baseurl =
            'https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey&page=';

        break;
      case MovieTypes.POPULAR:
        title = "Popular";
        baseurl =
            'https://api.themoviedb.org/3/movie/popular?api_key=$apikey&page=';
        break;
      case MovieTypes.UPCOMING:
        title = "Upcoming";
        baseurl =
            'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey&page=';
        break;
      case MovieTypes.TOPRATED:
        title = "Top Rated";
        baseurl =
            'https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey&page=';
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
                                title: title + ' Movies', baseurl: baseurl)));
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

  Future<void> getMovies() async {
    final nowShowingResponse = await http.get(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=$apikey&page=1');
    if (nowShowingResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(nowShowingResponse.body);
      nowShowingResults = MoviesList.fromJson(decRes).results;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }

    final popularResponse = await http.get(
        'https://api.themoviedb.org/3/movie/popular?api_key=$apikey&page=1');
    if (popularResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(popularResponse.body);
      popularResults = MoviesList.fromJson(decRes).results;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }

    final upcomingResponse = await http.get(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=$apikey&page=1');
    if (upcomingResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(upcomingResponse.body);
      upcomingResults = MoviesList.fromJson(decRes).results;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }

    final topRatedResponse = await http.get(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$apikey&page=1');
    if (topRatedResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(topRatedResponse.body);
      topRatedResults = MoviesList.fromJson(decRes).results;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }

    final genreResponse = await http
        .get('https://api.themoviedb.org/3/genre/movie/list?api_key=$apikey');
    if (genreResponse.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var decRes = jsonDecode(genreResponse.body);
      genresList = GenresList.fromJson(decRes).genres;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load api');
    }
  }

  Widget moviesWidget() {
    return ListView(
      children: <Widget>[
        titleCardWidget(MovieTypes.NOWSHOWING, true, nowShowingResults),
        titleCardWidget(MovieTypes.POPULAR, false, popularResults),
        titleCardWidget(MovieTypes.UPCOMING, true, upcomingResults),
        titleCardWidget(MovieTypes.TOPRATED, false, topRatedResults)
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
                  _getMovies = getMovies();
                });
              })
        ]));
  }

  Future<void> _getMovies;
  @override
  void initState() {
    _getMovies = getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.0),
        child: FutureBuilder(
          future: _getMovies,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) return errorWidget();
                return moviesWidget();
            }
            return null;
          },
        ));
  }
}
