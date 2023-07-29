import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:photo_gallery/constants.dart';
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/service/photo_service.dart';

class UnsplashService implements PhotoService {
  final String token;
  const UnsplashService({required this.token});

  static const apiHost = 'api.unsplash.com';
  static const apiVersion = 'v1';
  static const photosEndpoint = 'photos';
  static const searchEndpoint = 'search/photos';

  @override
  Future<List<Photo>> getPhotos([String? searchQuery]) async {
    if (searchQuery == null || searchQuery.isEmpty) {
      return await _getPopularPhotos();
    } else {
      return await _searchPhotos(searchQuery);
    }
  }

  Future<List<Photo>> _searchPhotos(String searchQuery) async {
    final response = await http.get(
      Uri.https(apiHost, '/$searchEndpoint', {
        'query': searchQuery,
        'per_page': perPageResults.toString(),
        'order_by': 'popular',
      }),
      headers: {
        'Accept-Version': apiVersion,
        'Authorization': 'Client-ID $token'
      },
    );
    final responseMap = json.decode(response.body);
    return _fromJson(responseMap['results']);
  }

  Future<List<Photo>> _getPopularPhotos() async {
    final response = await http.get(
      Uri.https(apiHost, '/$photosEndpoint', {
        'per_page': perPageResults.toString(),
        'order_by': 'popular',
      }),
      headers: {
        'Accept-Version': apiVersion,
        'Authorization': 'Client-ID $token'
      },
    );
    final responseMap = json.decode(response.body);
    return _fromJson(responseMap);
  }

  List<Photo> _fromJson(List photos) {
    return photos
        .map((photo) => Photo(
              heroTag: photo['id'],
              originalURL: photo['urls']['raw'],
              thumbURL: photo['urls']['small'],
              author: photo['user']['name'],
              likes: photo['likes'],
              name: photo['description'] ?? '',
            ))
        .toList(growable: false);
  }
}
