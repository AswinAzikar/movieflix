import 'dart:convert';

ModelClass modelClassFromJson(String str) =>
    ModelClass.fromJson(json.decode(str));

class ModelClass {
  final int? page;
  final List<Result>? results;
  final int? totalPages;
  final int? totalResults;

  ModelClass({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory ModelClass.fromJson(Map<String, dynamic> json) => ModelClass(
        page: json["page"],
        results: json["results"] == null
            ? []
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class Result {
  final String? backdropPath; 
  final int? id;
  final String? title;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final MediaType? mediaType;
  final bool? adult;
  final OriginalLanguage? originalLanguage;
  final List<int>? genreIds;
  final double? popularity;
  final DateTime? releaseDate;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  Result({
    this.backdropPath,
    this.id,
    this.title,
    this.originalTitle,
    this.overview,
    this.posterPath,
    this.mediaType,
    this.adult,
    this.originalLanguage,
    this.genreIds,
    this.popularity,
    this.releaseDate,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        backdropPath: json["backdrop_path"], // Accepting null value directly
        id: json["id"],
        title: json["title"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        mediaType: json["media_type"] == null
            ? null
            : mediaTypeValues.map[json["media_type"]],
        adult: json["adult"],
        originalLanguage: json["original_language"] == null
            ? null
            : originalLanguageValues.map[json["original_language"]],
        genreIds: json["genre_ids"] == null
            ? []
            : List<int>.from(json["genre_ids"].map((x) => x)),
        popularity: json["popularity"]?.toDouble(),
        releaseDate: json["release_date"] == null
            ? null
            : DateTime.parse(json["release_date"]),
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );
}

enum MediaType { MOVIE }

final mediaTypeValues = EnumValues({"movie": MediaType.MOVIE});

enum OriginalLanguage { EN, ES, JA }

final originalLanguageValues = EnumValues({
  "en": OriginalLanguage.EN,
  "es": OriginalLanguage.ES,
  "ja": OriginalLanguage.JA
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    return reverseMap ??= map.map((k, v) => MapEntry(v, k));
  }
}
