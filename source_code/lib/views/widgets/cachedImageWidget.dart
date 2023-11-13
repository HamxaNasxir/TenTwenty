import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tentwenty/utils/colors.dart';

cachedImage(String imageUrl, {bool search = false, double width = 0.0, double height = 0.0}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    width: search ? width : null,
    height: search ? height : null,
    progressIndicatorBuilder: (context, url, downloadProgress) => Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
            color: bottomNavColor,
          ),
        ),
      ],
    ),
    errorWidget: (context, url, error) => const Icon(
      Icons.error,
      color: bottomNavColor,
    ),
  );
}
