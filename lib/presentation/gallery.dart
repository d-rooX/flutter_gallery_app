import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_gallery/models/photo.dart';
import 'package:photo_gallery/presentation/photo.dart';

class Gallery extends StatelessWidget {
  final List<Photo> photos;
  const Gallery({super.key, required this.photos});

  // @override
  // Widget build(BuildContext context) {
  //   // show staggered gridview
  //   return MasonryGridView(
  //     gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //     ),
  //     children: photos
  //         .map((photo) => PhotoWidget(photo: photo))
  //         .toList(growable: false),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: photos
              .map((photo) => PhotoWidget(photo: photo))
              .toList(growable: false),
    );
  }

}
