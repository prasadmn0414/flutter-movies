import 'package:flutter/material.dart';
import 'package:flutter_movie_app/Screens/movies.dart';
import 'package:flutter_movie_app/Screens/searchscreen.dart';
import 'package:flutter_movie_app/Screens/tvshows.dart';
import 'package:flutter_movie_app/Constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle;
  final TextEditingController _filter = new TextEditingController();

  Widget getCurrentScreen() {
    switch (currentPage) {
      case 0:
        return Movies();
      case 1:
        return TvShows();
    }

    return Container();
  }

  Widget getAppBarTitle() {
    switch (currentPage) {
      case 0:
        return Text('Movies');
      case 1:
        return Text('TV Shows');
    }

    return Text("");
  }

  void _searchPressed() {
    setState(() {
      String searchkey = "";
      String type = "";

      if (this.currentPage == 0) {
        searchkey = "movie";
        type = "Movie";
      } else {
        searchkey = "tv";
        type = "TV Show";
      }

      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          autofocus: true,
          autocorrect: false,
          cursorColor: Colors.white,
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w400),
          controller: _filter,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Search Movies, TV Shows...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4))),
          textInputAction: TextInputAction.search,
          onSubmitted: (searchtext) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchScreen(
                        searchQuery: searchtext,
                        baseurl:
                            "https://api.themoviedb.org/3/search/$searchkey?api_key=$apikey&query=$searchtext&page=",
                        type: type)));
            _searchPressed();
          },
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = getAppBarTitle();

        _filter.clear();
      }
    });
  }

  @override
  void initState() {
    _appBarTitle = getAppBarTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(icon: _searchIcon, onPressed: _searchPressed)
        ],
      ),
      backgroundColor: Colors.white,
      body: getCurrentScreen(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('Assets/accountBg.jpg')),
              ),
              accountName: Text("Prasad M N"),
              accountEmail: Text("pressi.mn@gmail.com"),
              currentAccountPicture: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 250.0,
                  backgroundImage: AssetImage('Assets/avatar.jpg'),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: currentPage == 0
                    ? Theme.of(context).accentColor
                    : Colors.transparent,
              ),
              child: ListTile(
                title: Text('Movies',
                    style: currentPage == 0
                        ? TextStyle(color: Colors.white)
                        : TextStyle(
                            color: Theme.of(context).textTheme.title.color)),
                leading: Icon(Icons.movie,
                    color: currentPage == 0
                        ? Colors.white
                        : Theme.of(context).accentColor),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    currentPage = 0;
                    _appBarTitle = getAppBarTitle();
                  });
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: currentPage == 1
                    ? Theme.of(context).accentColor
                    : Colors.transparent,
              ),
              child: ListTile(
                title: Text('TV Shows',
                    style: currentPage == 1
                        ? TextStyle(color: Colors.white)
                        : TextStyle(
                            color: Theme.of(context).textTheme.title.color)),
                leading: Icon(Icons.tv,
                    color: currentPage == 1
                        ? Colors.white
                        : Theme.of(context).accentColor),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    currentPage = 1;
                    _appBarTitle = getAppBarTitle();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
