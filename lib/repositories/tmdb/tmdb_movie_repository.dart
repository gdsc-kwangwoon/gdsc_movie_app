import 'dart:convert';
import 'package:gdsc_movie_app/constants/api_endpoints.dart';
import 'package:gdsc_movie_app/constants/api_keys.dart';
import 'package:gdsc_movie_app/models/tmdb/tmdb_movie_list_model.dart';
import 'package:http/http.dart' as http;

class TMDBMovieRepository {
  Future<TMDBMovieListModel?> getNowPlaying({
    int page = 1,
  }) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer ${ApiKey.tmbdReadAccessToken}',
    };

    final res = await http.get(
      Uri.parse("${ApiEndpoints.tmdbNowPlaying}?language=en-US&page=$page"),
      headers: headers,
    );

    // await Future.delayed(const Duration(seconds: 2));

    if (res.statusCode == 200) {
      return TMDBMovieListModel.fromJson(await json.decode(res.body));
    }

    return null;
  }
}
