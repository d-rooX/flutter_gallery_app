import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_gallery/models/photo.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class PhotoPage extends StatefulWidget {
  final Photo photo;
  const PhotoPage({super.key, required this.photo});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  bool isLoading = true;
  late Image image;
  Uint8List? imageBytes;

  @override
  void initState() {
    image = Image.network(widget.photo.thumbURL);
    _getFullSizeImage();
    super.initState();
  }

  Future<void> _getFullSizeImage() async {
    final _image = await http.get(Uri.parse(widget.photo.originalURL));
    imageBytes = _image.bodyBytes;
    setState(() {
      image = Image.memory(imageBytes!, gaplessPlayback: true);
      isLoading = false;
    });
  }

  void _savePhoto() {
    if (imageBytes == null) return;
    ImageGallerySaver.saveImage(imageBytes!, quality: 100);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.photo.name.isNotEmpty) Text(widget.photo.name),
            const SizedBox(height: 5),
            Text(
              widget.photo.author,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _savePhoto,
        child: const Icon(Icons.download),
      ),
      body: Center(
        child: Stack(
          children: [
            Hero(
              tag: widget.photo.heroTag,
              child: ZoomOverlay(
                maxScale: 5.0,
                minScale: 0.5,
                twoTouchOnly: true,
                child: image,
              ),
            ),
            if (isLoading)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
