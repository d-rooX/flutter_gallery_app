import 'package:flutter/material.dart';
import 'package:photo_gallery/constants.dart';
import 'package:photo_gallery/implementation/pexels_service.dart';
import 'package:photo_gallery/implementation/pixabay_service.dart';
import 'package:photo_gallery/implementation/unsplash_service.dart';

import '../models/photo.dart';
import '../presentation/gallery.dart';
import '../service/photo_service.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PhotoService> services = [
    const PexelsService(token: pexelsApiToken),
    const PixabayService(token: pixabayApiToken),
    const UnsplashService(token: unsplashApiToken),
  ];
  int currentServiceIndex = 0;
  List<Photo> photos = [];

  Future<void> _loadPhotos() async {
    // resetting current photos
    setState(() => photos = []);
    // retrieving photos from current service
    final currentService = services[currentServiceIndex];
    final searchQuery = _searchController.text;
    final _loadedPhotos = await currentService.getPhotos(searchQuery);
    setState(() => photos = _loadedPhotos);
  }

  @override
  void initState() {
    _loadPhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery App')),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/pexels.png'),
              color: Colors.white,
            ),
            label: 'Pexels',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/pixabay.png'),
              color: Colors.white,
            ),
            label: 'Pixabay',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/icons/unsplash.png'),
              color: Colors.white,
            ),
            label: 'Unsplash',
          ),
        ],
        onTap: (value) => setState(() {
          currentServiceIndex = value;
          _loadPhotos();
        }),
        currentIndex: currentServiceIndex,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: TextField(
              decoration: const InputDecoration(hintText: "Search photos..."),
              controller: _searchController,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                _loadPhotos();
              },
            ),
          ),
          Expanded(
            child: Gallery(photos: photos),
          ),
        ],
      ),
    );
  }
}
