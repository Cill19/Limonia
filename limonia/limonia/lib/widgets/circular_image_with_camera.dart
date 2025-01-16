import 'package:flutter/material.dart';

class CircularImageWithCamera extends StatelessWidget {
  final String imagePath;
  final String cameraIconPath;
  final bool showCameraIcon;

  const CircularImageWithCamera({
    Key? key,
    required this.imagePath,
    required this.cameraIconPath,
    this.showCameraIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Circular image
        ClipOval(
          child: Image.asset(
            imagePath,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        // Camera icon
        if (showCameraIcon)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset(
                  cameraIconPath,
                  width: 16,
                  height: 16,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
