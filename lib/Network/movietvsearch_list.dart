class MoviesTVList {
  int page;
  int totalResults;
  int totalPages;
  List<Results> results;

  MoviesTVList({this.page, this.totalResults, this.totalPages, this.results});

  MoviesTVList.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  double voteAverage;
  int voteCount;
  int id;
  bool video;
  String mediaType;
  String title;
  double popularity;
  String posterPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String releaseDate;

  Results(
      {this.voteAverage,
      this.voteCount,
      this.id,
      this.video,
      this.mediaType,
      this.title,
      this.popularity,
      this.posterPath,
      this.originalLanguage,
      this.originalTitle,
      this.genreIds,
      this.backdropPath,
      this.adult,
      this.overview,
      this.releaseDate});

  Results.fromJson(Map<String, dynamic> json) {
    voteAverage = json['vote_average'] * 1.0;
    voteCount = json['vote_count'];
    id = json['id'];
    video = json['video'];
    mediaType = json['media_type'];
    title = json['title'];
    popularity = json['popularity'] * 1.0;
    posterPath = json['poster_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    backdropPath = json['backdrop_path'];
    adult = json['adult'];
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    data['id'] = this.id;
    data['video'] = this.video;
    data['media_type'] = this.mediaType;
    data['title'] = this.title;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['genre_ids'] = this.genreIds;
    data['backdrop_path'] = this.backdropPath;
    data['adult'] = this.adult;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    return data;
  }
}

/*
*************************************************************************************************************************************
*/

class TVSearchList {
  int page;
  int totalResults;
  int totalPages;
  List<TVResults> results;

  TVSearchList({this.page, this.totalResults, this.totalPages, this.results});

  TVSearchList.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = new List<TVResults>();
      json['results'].forEach((v) {
        results.add(new TVResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TVResults {
  String originalName;
  int id;
  String name;
  int voteCount;
  double voteAverage;
  String posterPath;
  String firstAirDate;
  double popularity;
  List<int> genreIds;
  String originalLanguage;
  String backdropPath;
  String overview;
  List<String> originCountry;

  TVResults(
      {this.originalName,
      this.id,
      this.name,
      this.voteCount,
      this.voteAverage,
      this.posterPath,
      this.firstAirDate,
      this.popularity,
      this.genreIds,
      this.originalLanguage,
      this.backdropPath,
      this.overview,
      this.originCountry});

  TVResults.fromJson(Map<String, dynamic> json) {
    originalName = json['original_name'];
    id = json['id'];
    name = json['name'];
    voteCount = json['vote_count'];
    voteAverage = json['vote_average'] * 1.0;
    posterPath = json['poster_path'];
    firstAirDate = json['first_air_date'];
    popularity = json['popularity'] * 1.0;
    genreIds = json['genre_ids'].cast<int>();
    originalLanguage = json['original_language'];
    backdropPath = json['backdrop_path'];
    overview = json['overview'];
    originCountry = json['origin_country'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original_name'] = this.originalName;
    data['id'] = this.id;
    data['name'] = this.name;
    data['vote_count'] = this.voteCount;
    data['vote_average'] = this.voteAverage;
    data['poster_path'] = this.posterPath;
    data['first_air_date'] = this.firstAirDate;
    data['popularity'] = this.popularity;
    data['genre_ids'] = this.genreIds;
    data['original_language'] = this.originalLanguage;
    data['backdrop_path'] = this.backdropPath;
    data['overview'] = this.overview;
    data['origin_country'] = this.originCountry;
    return data;
  }
}