import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../utils/images.dart';

class CustomImage extends StatelessWidget {
  final String? path;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit? fit;
  final String? placeholder;

  const CustomImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder = Images.placeholder,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: path!,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) =>
            Image.asset(placeholder!, height: height, width: width, fit: fit),
        errorWidget: (context, url, error) =>
            Image.asset(placeholder!, height: height, width: width, fit: fit),
      ),
    );
  }
}
