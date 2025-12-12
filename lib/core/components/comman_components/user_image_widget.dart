import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:legacy_sync/core/images/images.dart';

class UserImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String? filePath;
  final double size;
  final double radius;
  final String? assetPlaceholder;
  final BoxFit fit;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;

  UserImageWidget({Key? key, this.imageUrl, this.size = 60.0, this.radius = 50.0, this.assetPlaceholder, this.filePath, this.fit = BoxFit.cover, this.borderRadius = 100.0, this.borderColor, this.borderWidth = 0.0})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      height: size,
        width: size,
        child: ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: _buildImageWidget()));
  }

  Widget _buildImageWidget() {
    // If imageUrl is provided and not empty, try to load network image
    if (filePath != null && filePath!.isNotEmpty) {
      return Image.file(width: size, height: size, File(filePath!), fit: fit, errorBuilder: (context, error, stackTrace) => _buildFallbackImage());
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        width: size,
        height: size,
        imageUrl: imageUrl!,
        fit: fit,
        placeholder: (context, url) => _buildLoadingPlaceholder(),
        errorWidget: (context, url, error) => _buildFallbackImage(),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
      );
    }

    // If no URL provided, show fallback image
    return _buildFallbackImage();
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[200],
      child:  Center(child: SizedBox(width: size, height: size, child: const SizedBox(height: 30,width: 30,child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.grey)))),
    );
  }

  Widget _buildFallbackImage() {
    // If asset placeholder is provided, use it
    if (assetPlaceholder != null && assetPlaceholder!.isNotEmpty) {
      return CircleAvatar(radius: radius, child: Image.asset(assetPlaceholder!, fit: BoxFit.contain));
    }

    // Otherwise use default avatar
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(radius: radius, child: Image.asset(Images.image_user, fit: BoxFit.contain));
  }
}
