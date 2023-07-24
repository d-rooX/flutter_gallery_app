import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/service/photo_service.dart';

import '../constants.dart';

class PexelsService implements PhotoService {
  final String token;

  static const String apiHost = 'api.pexels.com';
  static const String apiVersion = 'v1';
  static const String searchEndpoint = 'search';
  static const String curatedEndpoint = 'curated';

  const PexelsService({required this.token});

  @override
  Future<List<Photo>> getPhotos([String? searchQuery]) async {
    if (searchQuery == null || searchQuery.isEmpty) {
      return await _getCuratedPhotos();
    } else {
      return await _searchPhotos(searchQuery);
    }
  }

  Future<List<Photo>> _getCuratedPhotos() async {
    final response = await http.get(
      Uri.https(
        apiHost,
        '/$apiVersion/$curatedEndpoint',
        {
          'per_page': perPageResults.toString(),
        },
      ),
      headers: {'Authorization': token},
    );
    final responseMap = json.decode(response.body);

    return _fromJson(responseMap['photos']);
  }

  Future<List<Photo>> _searchPhotos(String searchQuery) async {
    final response = await http.get(
      Uri.https(
        apiHost,
        '/$apiVersion/$searchEndpoint',
        {
          'query': searchQuery,
          'per_page': perPageResults.toString(),
        },
      ),
      headers: {'Authorization': token},
    );
    final responseMap = json.decode(response.body);

    return _fromJson(responseMap['photos']);
  }

  List<Photo> _fromJson(List json) {
    return json
        .map(
          (photo) => Photo(
            name: photo['alt'],
            author: photo['photographer'],
            originalURL: photo['src']['original'],
            thumbURL: photo['src']['medium'],
            heroTag: photo['id'].toString(),
          ),
        )
        .toList(growable: false);
  }
}
