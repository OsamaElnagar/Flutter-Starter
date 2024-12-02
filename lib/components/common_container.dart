import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:starter/utils/defaults.dart';

class CommonContainer extends StatelessWidget {
  const CommonContainer(
      {super.key,
      this.child,
      this.hasDecoImage = false,
      this.decoImagePath = ''});

  final Widget? child;
  final bool hasDecoImage;
  final String? decoImagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).drawerTheme.backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDefaults.borderRadius),
        ),
        image: hasDecoImage
            ? DecorationImage(
                image: CachedNetworkImageProvider(decoImagePath!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(2 / 3),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      padding: const EdgeInsets.all(AppDefaults.padding * 0.75),
      child: child,
    );
  }
}
