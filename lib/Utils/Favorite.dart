import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_movie_app/Constants.dart';
import 'package:flutter_movie_app/Utils/Storage.dart';
import 'package:flutter_movie_app/Network/movies_list.dart';

typedef onFavoritePressed = void Function(bool isFavourite);

class FavoriteWidget extends StatefulWidget {
  final bool isFavorited;
  final onFavoritePressed;
  final int movieid;
  final double iconSize;
  final Color iconColor;
  final bool allowToggle;

  const FavoriteWidget(
      {this.isFavorited,
      this.onFavoritePressed,
      this.movieid,
      this.iconSize = 20.0,
      this.iconColor = Colors.grey,
      this.allowToggle = false});

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
    // isFavoriteMovie();
    super.initState();
  }

  void _toggleFavorite() {
    widget.onFavoritePressed(!_isFavorite);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    isFavoriteMovie();

    return Container(
      width: 20.0,
      height: 20.0,
      child: IgnorePointer(
        ignoring: widget.allowToggle ? false : (_isFavorite ? true : false),
        child: IconButton(
          iconSize: widget.iconSize,
          padding: EdgeInsets.zero,
          onPressed: _toggleFavorite,
          icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.iconColor),
        ),
      ),
    );
  }
}
