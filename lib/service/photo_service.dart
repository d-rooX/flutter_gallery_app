import 'package:photo_gallery/models/photo.dart';

abstract interface class PhotoService {
  Future<List<Photo>> getPhotos([String? searchQuery]);
}
