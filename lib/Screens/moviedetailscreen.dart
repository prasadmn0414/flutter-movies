import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieDetail extends StatefulWidget {
  @override
  _MainCollapsingToolbarState createState() => _MainCollapsingToolbarState();
}

var kExpandedHeight = 0.0;
var screenWidth = 0.0;
var screenHeight = 0.0;

class _MainCollapsingToolbarState extends State<MovieDetail> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() => setState(() {}));
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
                  color: Theme.of(context).accentColor,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: kExpandedHeight * 0.66,
                            color: Colors.grey,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://png.pngtree.com/thumb_back/fw800/back_pic/03/87/17/0857d1192214be1.jpg",
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
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
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                 SizedBox(height: 24.0,),
                                  Text(
                                      'Fantastic Beasts: The Crimes of Grindelwald',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                      )),
                                      SizedBox(height: 8.0,),
                                      Text(
                                      'Family, Fantasy, Adventure',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.0,
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
        body: Center(
          child: Text("Sample text"),
        ),
      ),
    );
  }
}
