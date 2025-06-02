import 'package:flutter/material.dart';

import 'full_screen_view.dart';

class ImageThumbnail extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const ImageThumbnail({required this.imageUrl, required this.tag, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FullScreenImage(imageUrl: imageUrl, tag: tag),
        ),
      ),
      child: Hero(
        tag: tag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
