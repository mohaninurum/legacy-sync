import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';

class ImagePreview extends StatelessWidget {
  final String url;

  const ImagePreview({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
      body: Hero(
        tag: url,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.black),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Colors.white))),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return LegacyAppBar(title: "Image Preview");
  }
}
