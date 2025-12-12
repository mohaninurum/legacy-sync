

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class AppNetworkImage extends StatelessWidget {
  final String url;


  const AppNetworkImage({
    Key? key,
    required this.url,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height:  200,
      decoration: BoxDecoration(
        borderRadius:  BorderRadius.circular(16),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius:  BorderRadius.circular(16),
        child: CachedNetworkImage(
          width: double.infinity,
          height:200 ,
          imageUrl: url,
          fit: BoxFit.contain,
          placeholder: (context, url) => const Center(child: SizedBox(height: 30,width: 30, child: CircularProgressIndicator(color: Colors.white))),
          errorWidget: (context, url, error) => const Icon(Icons.error,color: Colors.white),
        ),
      ),
    );
  }
}