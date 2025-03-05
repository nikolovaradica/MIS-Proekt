import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoOfTheDay extends StatelessWidget {
  final XFile? photoOfTheDay;
  final Function(XFile?) onPhotoSelected;

  const PhotoOfTheDay({
    super.key, 
    required this.photoOfTheDay, 
    required this.onPhotoSelected
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photoOfTheDay == null)
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final photo = await picker.pickImage(source: ImageSource.camera);
              onPhotoSelected(photo);
            },
            child: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 50,
                color: Colors.grey,
              ),
            ),
          )
        else
          Stack(
            children: [
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(photoOfTheDay!.path),
                    fit: BoxFit.cover
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final photo = await picker.pickImage(source: ImageSource.camera);
                    onPhotoSelected(photo);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
          ],
        )
      ],
    );
  }
}