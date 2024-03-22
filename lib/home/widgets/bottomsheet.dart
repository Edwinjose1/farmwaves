import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BottomsheetTakingimage extends StatelessWidget {
  final Function(File) onImageSelected;

  const BottomsheetTakingimage({Key? key, required this.onImageSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> takePhoto() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        onImageSelected(File(pickedFile.path));
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Close the modal bottom sheet
      }
    }

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _chooseFromGallery() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        onImageSelected(File(pickedFile.path));
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Close the modal bottom sheet
      }
    }

    return SizedBox(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a photo'),
            onTap: takePhoto,
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Choose from gallery'),
            onTap: _chooseFromGallery,
          ),
        ],
      ),
    );
  }
}
