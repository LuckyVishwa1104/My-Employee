import 'package:flutter/material.dart';
import 'dart:io';

class ProfileImage extends StatelessWidget {
  final bool type;
  final String? imageUrl;
  final File? selectedImage;
  final double radius;

  const ProfileImage(
      {super.key,
      this.selectedImage,
      required this.type,
      required this.imageUrl,
      required this.radius
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade600,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.grey[300],
        radius: radius,
        child: type
            ? ClipOval(
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: 180,
                  height: 180,
                ),
              )
            : selectedImage != null
                ? ClipOval(
                    child: Image.file(
                      selectedImage!,
                      fit: BoxFit.cover,
                      width: 180,
                      height: 180,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 110,
                    color: Colors.grey[600],
                  ),
      ),
    );
  }
}
