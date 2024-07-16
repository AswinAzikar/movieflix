import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:movieflix/exporter.dart';
import 'package:movieflix/features/authentication/phone_auth/phone_auth_mixin.dart';
import 'package:movieflix/features/splash_screen/models/Genre_model.dart';
import '../features/home_screen/models/datamodel.dart';
import '../features/profile_screen/profile_details_model.dart';
import 'api_constants.dart';
import 'app_config.dart';
import 'error_exception_handler.dart';
import 'interceptors.dart';

bool validateStatus(int? status) {
  List validStatusCodes = [304, 200, 201, 204];
  return validStatusCodes.contains(status);
}

class DataRepository with ErrorExceptionHandler {
  final Dio _client = Dio(BaseOptions(
      validateStatus: validateStatus,
      baseUrl: appConfig.baseUrl,
      receiveDataWhenStatusError: true,
      contentType: "application/json"));

  static DataRepository get i => _instance;
  static final DataRepository _instance = DataRepository._private();

  DataRepository._private() {
    _client.interceptors.add(PhoneAuthInterceptor());
    _client.interceptors.add(LoggingInterceptor());
  }

  Future<ModelClass?> fetchTrending(int page) async {
    try {
      var response =
          await _client.get(APIConstants.popularMovies, queryParameters: {
        "language": "en-US",
        "page": page,
      });

      ModelClass modelClass = ModelClass.fromJson(response.data);

      return modelClass;
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<List<Result>> fetchMovies(int page, String sectionName) async {
    logError(sectionName);
    String concat = "";
    if (sectionName == "Top Rated Movies") {
      concat = APIConstants.topRatedMovies;
    } else if (sectionName == "Now Playing") {
      concat = APIConstants.nowPlayingMovies;
    } else {
      concat = APIConstants.upComingMovies;
    }

    try {
      var response = await _client.get(concat, queryParameters: {
        "language": "en-US",
        "page": page,
      });

      if (response.statusCode == 200) {
        ModelClass modelClass = ModelClass.fromJson(response.data);
        return modelClass.results!;
      } else {
        throw Exception('Failed to load $sectionName');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load $sectionName (catch)');
    }
  }

  Future<List<Genre>> fetchGenres() async {
    try {
      var response = await _client.get(APIConstants.genre);
      if (response.statusCode == 200) {
        final List<dynamic> genresJson = response.data['genres'];
        return genresJson.map((json) => Genre.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      throw Exception('Failed to load genres: $e');
    }
  }

  Future<Map<int, String>> getGenreMap() async {
    final DataRepository genreService = DataRepository.i;
    final List<Genre> genres = await genreService.fetchGenres();
    return {for (var genre in genres) genre.id: genre.name};
  }

  Future<Response> updateDevice(BaseDeviceInfo deviceInfo) async {
    try {
      final response =
          await _client.put(APIConstants.updateDevice, data: deviceInfo.data);
      return response;
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<ProfileDetailsModel> fetchProfileDetails() async {
    try {
      final response = await _client.get(APIConstants.profileDetails);
      return ProfileDetailsModel.fromMap(response.data);
    } catch (e) {
      throw handleError(e);
    }
  }

  Future<List<Result>> searchMovies(String query, int pagekey) async {
    logError(query);

    try {
      var response = await _client.get(APIConstants.search, queryParameters: {
        // "language": "en-US",
         "query": query,
        // "page": pagekey
      });

      if (response.statusCode == 200) {
        ModelClass modelClass = ModelClass.fromJson(response.data);
        return modelClass.results!;
      } else {
        throw Exception('Failed to load $query');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load $query (catch)');
    }
  }
}
