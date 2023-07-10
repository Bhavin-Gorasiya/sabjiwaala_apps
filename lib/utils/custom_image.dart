import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Network image widget with error image and loader.
class CustomNetworkImage extends StatefulWidget {
  const CustomNetworkImage({
    Key? key,
    required this.src,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);
  final String src;
  final BoxFit fit;
  final double? width, height;

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  Image image() => Image(
        image: CachedNetworkImageProvider(
          widget.src,
        ),
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        errorBuilder: (context, object, st) {
          return Image.asset("assets/placeholder2.jpeg");
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
                // value: loadingProgress.expectedTotalBytes != null
                //     ? loadingProgress.cumulativeBytesLoaded /
                //         loadingProgress.expectedTotalBytes!
                //     : null,
                ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return image();
  }
}
