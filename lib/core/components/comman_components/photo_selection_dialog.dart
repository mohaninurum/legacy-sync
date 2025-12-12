import 'package:flutter/material.dart';
import 'package:legacy_sync/core/images/images.dart';

class PhotoSelectionDialog extends StatelessWidget {
  final VoidCallback? onGalleryPressed;
  final VoidCallback? onCameraPressed;

  const PhotoSelectionDialog({
    Key? key,
    this.onGalleryPressed,
    this.onCameraPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xfff0f0f0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildOption(
                    imagePath: Images.gallery_image,
                    title: 'Choose\nfrom library',
                    context: context,
                    onTap: () {
                      Navigator.of(context).pop();
                      onGalleryPressed?.call();
                    },
                  ),
                ),
                Container(
                  width: 1,
                  height: 80,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                Expanded(
                  child: _buildOption(
                    imagePath: Images.camera_image,
                    context: context,
                    title: 'Take a photo\n ',
                    onTap: () {
                      Navigator.of(context).pop();
                      onCameraPressed?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required String imagePath,
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath,height:50,width: 50),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




