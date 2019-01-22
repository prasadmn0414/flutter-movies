import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_movie_app/Constants.dart';
import 'package:flutter_movie_app/Utils/Storage.dart';
import 'package:flutter_movie_app/Network/movies_list.dart';

class FavoriteWidget extends StatefulWidget {
  final bool isFavorited;
  final VoidCallback onFavoritePressed;
  final int movieid;

  const FavoriteWidget(
      {this.isFavorited, this.onFavoritePressed, this.movieid});

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorite = false;

  void isFavoriteMovie() {
    bool isFav = false;

    readFile(favFile).then((String filedata) {
      List<Results> favMovies = [];
      if (filedata.length > 0) {
        jsonDecode(filedata)
            .forEach((map) => favMovies.add(Results.fromJson(map)));
      }

      if (favMovies.indexWhere((obj) => obj.id == widget.movieid) == -1) {
        // -1 means not found
        isFav = false;
      } else {
        isFav = true;
      }

      setState(() {
        _isFavorite = isFav;
      });
    });
  }

  @override
  void initState() {
    _isFavorite = widget.isFavorited;
    isFavoriteMovie();
    super.initState();
  }

  void _toggleFavorite() {
    widget.onFavoritePressed();
    setState(() {
      // If the lake is currently favorited, unfavorite it.
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      child: IgnorePointer(
        ignoring: _isFavorite ? true : false,
        child: IconButton(
          iconSize: 20.0,
          padding: EdgeInsets.zero,
          onPressed: _toggleFavorite,
          icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.grey),
        ),
      ),
    );
  }
}
