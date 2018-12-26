class TVDetails {
  String backdropPath;
  List<CreatedBy> createdBy;
  List<int> episodeRunTime;
  String firstAirDate;
  List<Genres> genres;
  String homepage;
  int id;
  bool inProduction;
  List<String> languages;
  String lastAirDate;
  LastEpisodeToAir lastEpisodeToAir;
  String name;
  NextEpisodeToAir nextEpisodeToAir;
  List<Networks> networks;
  int numberOfEpisodes;
  int numberOfSeasons;
  List<String> originCountry;
  String originalLanguage;
  String originalName;
  String overview;
  double popularity;
  String posterPath;
  List<ProductionCompanies> productionCompanies;
  List<Seasons> seasons;
  String status;
  String type;
  double voteAverage;
  int voteCount;
  Videos videos;
  Credits credits;
  Similar similar;

  TVDetails(
      {this.backdropPath,
      this.createdBy,
      this.episodeRunTime,
      this.firstAirDate,
      this.genres,
      this.homepage,
      this.id,
      this.inProduction,
      this.languages,
      this.lastAirDate,
      this.lastEpisodeToAir,
      this.name,
      this.nextEpisodeToAir,
      this.networks,
      this.numberOfEpisodes,
      this.numberOfSeasons,
      this.originCountry,
      this.originalLanguage,
      this.originalName,
      this.overview,
      this.popularity,
      this.posterPath,
      this.productionCompanies,
      this.seasons,
      this.status,
      this.type,
      this.voteAverage,
      this.voteCount,
      this.videos,
      this.credits,
      this.similar});

  TVDetails.fromJson(Map<String, dynamic> json) {
    backdropPath = json['backdrop_path'];
    if (json['created_by'] != null) {
      createdBy = new List<CreatedBy>();
      json['created_by'].forEach((v) {
        createdBy.add(new CreatedBy.fromJson(v));
      });
    }
    episodeRunTime = json['episode_run_time'].cast<int>();
    firstAirDate = json['first_air_date'];
    if (json['genres'] != null) {
      genres = new List<Genres>();
      json['genres'].forEach((v) {
        genres.add(new Genres.fromJson(v));
      });
    }
    homepage = json['homepage'];
    id = json['id'];
    inProduction = json['in_production'];
    languages = json['languages'].cast<String>();
    lastAirDate = json['last_air_date'];
    lastEpisodeToAir = json['last_episode_to_air'] != null
        ? new LastEpisodeToAir.fromJson(json['last_episode_to_air'])
        : null;
    name = json['name'];
    nextEpisodeToAir = json['next_episode_to_air'] != null
        ? new NextEpisodeToAir.fromJson(json['next_episode_to_air'])
        : null;
    if (json['networks'] != null) {
      networks = new List<Networks>();
      json['networks'].forEach((v) {
        networks.add(new Networks.fromJson(v));
      });
    }
    numberOfEpisodes = json['number_of_episodes'];
    numberOfSeasons = json['number_of_seasons'];
    originCountry = json['origin_country'].cast<String>();
    originalLanguage = json['original_language'];
    originalName = json['original_name'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    if (json['production_companies'] != null) {
      productionCompanies = new List<ProductionCompanies>();
      json['production_companies'].forEach((v) {
        productionCompanies.add(new ProductionCompanies.fromJson(v));
      });
    }
    if (json['seasons'] != null) {
      seasons = new List<Seasons>();
      json['seasons'].forEach((v) {
        seasons.add(new Seasons.fromJson(v));
      });
    }
    status = json['status'];
    type = json['type'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    videos =
        json['videos'] != null ? new Videos.fromJson(json['videos']) : null;
    credits =
        json['credits'] != null ? new Credits.fromJson(json['credits']) : null;
    similar =
        json['similar'] != null ? new Similar.fromJson(json['similar']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['backdrop_path'] = this.backdropPath;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy.map((v) => v.toJson()).toList();
    }
    data['episode_run_time'] = this.episodeRunTime;
    data['first_air_date'] = this.firstAirDate;
    if (this.genres != null) {
      data['genres'] = this.genres.map((v) => v.toJson()).toList();
    }
    data['homepage'] = this.homepage;
    data['id'] = this.id;
    data['in_production'] = this.inProduction;
    data['languages'] = this.languages;
    data['last_air_date'] = this.lastAirDate;
    if (this.lastEpisodeToAir != null) {
      data['last_episode_to_air'] = this.lastEpisodeToAir.toJson();
    }
    data['name'] = this.name;
    if (this.nextEpisodeToAir != null) {
      data['next_episode_to_air'] = this.nextEpisodeToAir.toJson();
    }
    if (this.networks != null) {
      data['networks'] = this.networks.map((v) => v.toJson()).toList();
    }
    data['number_of_episodes'] = this.numberOfEpisodes;
    data['number_of_seasons'] = this.numberOfSeasons;
    data['origin_country'] = this.originCountry;
    data['original_language'] = this.originalLanguage;
    data['original_name'] = this.originalName;
    data['overview'] = this.overview;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    if (this.productionCompanies != null) {
      data['production_companies'] =
          this.productionCompanies.map((v) => v.toJson()).toList();
    }
    if (this.seasons != null) {
      data['seasons'] = this.seasons.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['type'] = this.type;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    if (this.videos != null) {
      data['videos'] = this.videos.toJson();
    }
    if (this.credits != null) {
      data['credits'] = this.credits.toJson();
    }
    if (this.similar != null) {
      data['similar'] = this.similar.toJson();
    }
    return data;
  }
}

class CreatedBy {
  int id;
  String creditId;
  String name;
  int gender;
  String profilePath;

  CreatedBy({this.id, this.creditId, this.name, this.gender, this.profilePath});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creditId = json['credit_id'];
    name = json['name'];
    gender = json['gender'];
    profilePath = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['credit_id'] = this.creditId;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['profile_path'] = this.profilePath;
    return data;
  }
}

class Genres {
  int id;
  String name;

  Genres({this.id, this.name});

  Genres.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class LastEpisodeToAir {
  String airDate;
  int episodeNumber;
  int id;
  String name;
  String overview;
  String productionCode;
  int seasonNumber;
  int showId;
  String stillPath;
  double voteAverage;
  double voteCount;

  LastEpisodeToAir(
      {this.airDate,
      this.episodeNumber,
      this.id,
      this.name,
      this.overview,
      this.productionCode,
      this.seasonNumber,
      this.showId,
      this.stillPath,
      this.voteAverage,
      this.voteCount});

  LastEpisodeToAir.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    episodeNumber = json['episode_number'];
    id = json['id'];
    name = json['name'];
    overview = json['overview'];
    productionCode = json['production_code'];
    seasonNumber = json['season_number'];
    showId = json['show_id'];
    stillPath = json['still_path'];
    voteAverage = json['vote_average'] * 1.0;
    voteCount = json['vote_count'] * 1.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['air_date'] = this.airDate;
    data['episode_number'] = this.episodeNumber;
    data['id'] = this.id;
    data['name'] = this.name;
    data['overview'] = this.overview;
    data['production_code'] = this.productionCode;
    data['season_number'] = this.seasonNumber;
    data['show_id'] = this.showId;
    data['still_path'] = this.stillPath;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    return data;
  }
}

class NextEpisodeToAir {
  String airDate;
  int episodeNumber;
  int id;
  String name;
  String overview;
  String productionCode;
  int seasonNumber;
  int showId;
  String stillPath;
  double voteAverage;
  double voteCount;

  NextEpisodeToAir(
      {this.airDate,
      this.episodeNumber,
      this.id,
      this.name,
      this.overview,
      this.productionCode,
      this.seasonNumber,
      this.showId,
      this.stillPath,
      this.voteAverage,
      this.voteCount});

  NextEpisodeToAir.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    episodeNumber = json['episode_number'];
    id = json['id'];
    name = json['name'];
    overview = json['overview'];
    productionCode = json['production_code'];
    seasonNumber = json['season_number'];
    showId = json['show_id'];
    stillPath = json['still_path'];
    voteAverage = json['vote_average'] * 1.0;
    voteCount = json['vote_count'] * 1.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['air_date'] = this.airDate;
    data['episode_number'] = this.episodeNumber;
    data['id'] = this.id;
    data['name'] = this.name;
    data['overview'] = this.overview;
    data['production_code'] = this.productionCode;
    data['season_number'] = this.seasonNumber;
    data['show_id'] = this.showId;
    data['still_path'] = this.stillPath;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    return data;
  }
}

class Networks {
  String name;
  int id;
  String logoPath;
  String originCountry;

  Networks({this.name, this.id, this.logoPath, this.originCountry});

  Networks.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    logoPath = json['logo_path'];
    originCountry = json['origin_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['logo_path'] = this.logoPath;
    data['origin_country'] = this.originCountry;
    return data;
  }
}

class ProductionCompanies {
  int id;
  String logoPath;
  String name;
  String originCountry;

  ProductionCompanies({this.id, this.logoPath, this.name, this.originCountry});

  ProductionCompanies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logoPath = json['logo_path'];
    name = json['name'];
    originCountry = json['origin_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo_path'] = this.logoPath;
    data['name'] = this.name;
    data['origin_country'] = this.originCountry;
    return data;
  }
}

class Seasons {
  String airDate;
  int episodeCount;
  int id;
  String name;
  String overview;
  String posterPath;
  int seasonNumber;

  Seasons(
      {this.airDate,
      this.episodeCount,
      this.id,
      this.name,
      this.overview,
      this.posterPath,
      this.seasonNumber});

  Seasons.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    episodeCount = json['episode_count'];
    id = json['id'];
    name = json['name'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    seasonNumber = json['season_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['air_date'] = this.airDate;
    data['episode_count'] = this.episodeCount;
    data['id'] = this.id;
    data['name'] = this.name;
    data['overview'] = this.overview;
    data['poster_path'] = this.posterPath;
    data['season_number'] = this.seasonNumber;
    return data;
  }
}

class Videos {
  List<VideoResults> results;

  Videos({this.results});

  Videos.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = new List<VideoResults>();
      json['results'].forEach((v) {
        results.add(new VideoResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoResults {
  String id;
  String iso6391;
  String iso31661;
  String key;
  String name;
  String site;
  int size;
  String type;

  VideoResults(
      {this.id,
      this.iso6391,
      this.iso31661,
      this.key,
      this.name,
      this.site,
      this.size,
      this.type});

  VideoResults.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iso6391 = json['iso_639_1'];
    iso31661 = json['iso_3166_1'];
    key = json['key'];
    name = json['name'];
    site = json['site'];
    size = json['size'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iso_639_1'] = this.iso6391;
    data['iso_3166_1'] = this.iso31661;
    data['key'] = this.key;
    data['name'] = this.name;
    data['site'] = this.site;
    data['size'] = this.size;
    data['type'] = this.type;
    return data;
  }
}

class Credits {
  List<Cast> cast;
  List<Crew> crew;

  Credits({this.cast, this.crew});

  Credits.fromJson(Map<String, dynamic> json) {
    if (json['cast'] != null) {
      cast = new List<Cast>();
      json['cast'].forEach((v) {
        cast.add(new Cast.fromJson(v));
      });
    }
    if (json['crew'] != null) {
      crew = new List<Crew>();
      json['crew'].forEach((v) {
        crew.add(new Crew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cast != null) {
      data['cast'] = this.cast.map((v) => v.toJson()).toList();
    }
    if (this.crew != null) {
      data['crew'] = this.crew.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cast {
  String character;
  String creditId;
  int id;
  String name;
  int gender;
  String profilePath;
  int order;

  Cast(
      {this.character,
      this.creditId,
      this.id,
      this.name,
      this.gender,
      this.profilePath,
      this.order});

  Cast.fromJson(Map<String, dynamic> json) {
    character = json['character'];
    creditId = json['credit_id'];
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    profilePath = json['profile_path'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['character'] = this.character;
    data['credit_id'] = this.creditId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['profile_path'] = this.profilePath;
    data['order'] = this.order;
    return data;
  }
}

class Crew {
  String creditId;
  String department;
  int id;
  String name;
  int gender;
  String job;
  String profilePath;

  Crew(
      {this.creditId,
      this.department,
      this.id,
      this.name,
      this.gender,
      this.job,
      this.profilePath});

  Crew.fromJson(Map<String, dynamic> json) {
    creditId = json['credit_id'];
    department = json['department'];
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    job = json['job'];
    profilePath = json['profile_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_id'] = this.creditId;
    data['department'] = this.department;
    data['id'] = this.id;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['job'] = this.job;
    data['profile_path'] = this.profilePath;
    return data;
  }
}

class Similar {
  int page;
  List<SimilarResults> results;
  int totalPages;
  int totalResults;

  Similar({this.page, this.results, this.totalPages, this.totalResults});

  Similar.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      results = new List<SimilarResults>();
      json['results'].forEach((v) {
        results.add(new SimilarResults.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = this.totalPages;
    data['total_results'] = this.totalResults;
    return data;
  }
}

class SimilarResults {
  String originalName;
  int id;
  String name;
  int voteCount;
  double voteAverage;
  String firstAirDate;
  String posterPath;
  List<int> genreIds;
  String originalLanguage;
  String backdropPath;
  String overview;
  List<String> originCountry;
  double popularity;

  SimilarResults(
      {this.originalName,
      this.id,
      this.name,
      this.voteCount,
      this.voteAverage,
      this.firstAirDate,
      this.posterPath,
      this.genreIds,
      this.originalLanguage,
      this.backdropPath,
      this.overview,
      this.originCountry,
      this.popularity});

  SimilarResults.fromJson(Map<String, dynamic> json) {
    originalName = json['original_name'];
    id = json['id'];
    name = json['name'];
    voteCount = json['vote_count'];
    voteAverage = json['vote_average'];
    firstAirDate = json['first_air_date'];
    posterPath = json['poster_path'];
    genreIds = json['genre_ids'].cast<int>();
    originalLanguage = json['original_language'];
    backdropPath = json['backdrop_path'];
    overview = json['overview'];
    originCountry = json['origin_country'].cast<String>();
    popularity = json['popularity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original_name'] = this.originalName;
    data['id'] = this.id;
    data['name'] = this.name;
    data['vote_count'] = this.voteCount;
    data['vote_average'] = this.voteAverage;
    data['first_air_date'] = this.firstAirDate;
    data['poster_path'] = this.posterPath;
    data['genre_ids'] = this.genreIds;
    data['original_language'] = this.originalLanguage;
    data['backdrop_path'] = this.backdropPath;
    data['overview'] = this.overview;
    data['origin_country'] = this.originCountry;
    data['popularity'] = this.popularity;
    return data;
  }
}
