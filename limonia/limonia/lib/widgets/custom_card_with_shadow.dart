import 'package:flutter/material.dart';

class CustomCardWithShadow extends StatelessWidget {
  final String assetPath;
  final String title;
  final VoidCallback onTap;

  const CustomCardWithShadow({
    Key? key,
    required this.assetPath,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.1), // Shadow color (10% opacity)
              offset: const Offset(2, 5), // X = 2, Y = 5
              blurRadius: 20, // Blur radius = 20
            ),
          ],
        ),
        child: Row(
          children: [
            // Start icon (loaded from assets)
            Image.asset(
              assetPath,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12), // Spacing between icon and text
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Navigation arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
