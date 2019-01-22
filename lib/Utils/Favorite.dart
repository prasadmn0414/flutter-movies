import 'package:flutter/material.dart';


class FavoriteWidget extends StatefulWidget {
  final bool isFavorited;
  final VoidCallback onFavoritePressed;

  const FavoriteWidget({this.isFavorited, this.onFavoritePressed});

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();

}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorite = false;

  @override
  void initState() {
    _isFavorite = widget.isFavorited;
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
