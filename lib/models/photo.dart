class Photo {
  final String name;
  final String author;
  final String thumbURL;
  final String originalURL;

  // need to be unique value, used for Hero widget to animate between screens
  final String heroTag;

  const Photo({
    required this.name,
    required this.author,
    required this.thumbURL,
    required this.originalURL,
    required this.heroTag,
  });
}
