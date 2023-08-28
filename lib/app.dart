import 'package:flutter/material.dart';
import 'package:photo_gallery/pages/gallery_page.dart';

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const GalleryPage(),
    );
  }
}
