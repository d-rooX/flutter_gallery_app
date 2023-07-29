import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/service/photo_service.dart';

import '../constants.dart';

class PixabayService implements PhotoService {
  final String token;
  const PixabayService({required this.token});

  static const apiHost = 'pixabay.com';

  @override
  Future<List<Photo>> getPhotos([String? searchQuery]) async {
    final parameters = {
      'key': token,
      'per_page': perPageResults.toString(),
      'image_type': 'photo',
    };
    if (searchQuery != null && searchQuery.isNotEmpty) {
      parameters['q'] = searchQuery;
    }

    final response = await http.get(Uri.https(apiHost, '/api/', parameters));
    final responseMap = json.decode(response.body);

    return _fromJson(responseMap['hits']);
  }

  List<Photo> _fromJson(List photos) {
    return photos
        .map((photo) => Photo(
              name: '',
              author: photo['user'],
              thumbURL: photo['webformatURL'],
              originalURL: photo['largeImageURL'],
              likes: photo['likes'],
              heroTag: photo['id'].toString(),
            ))
        .toList(growable: false);
  }
}
