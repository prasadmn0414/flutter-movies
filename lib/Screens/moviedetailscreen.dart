import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieDetail extends StatefulWidget {
  @override
  _MainCollapsingToolbarState createState() => _MainCollapsingToolbarState();
}

class _MainCollapsingToolbarState extends State<MovieDetail> {
  ScrollController _scrollController;
  var kExpandedHeight = 0.0;

  @override
  void initState() {
    super.initState();
     kExpandedHeight = MediaQuery.of(context).size.height * 0.5;
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

bool get _showTitle {
    return _scrollController.hasClients
        && _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: kExpandedHeight,
              floating: false,
              pinned: true,
              title: _showTitle ? Text('_SliverAppBar') : null,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.greenAccent,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5 * 0.66,
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://png.pngtree.com/thumb_back/fw800/back_pic/03/87/17/0857d1192214be1.jpg",
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: Center(
          child: Text("Sample text"),
        ),
      ),
    );
  }
}
