import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

class UserImagePicker extends StatefulWidget {
  Function setPickedImage;
  UserImagePicker(this.setPickedImage);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  var _storedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (imageFile == null) return;

    setState(() {
      _storedImage = File(imageFile.path);
    });
    widget.setPickedImage(File(imageFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: 40,
              child: _storedImage != null
                  ? Image.file(_storedImage,
                      fit: BoxFit.cover, width: double.infinity)
                  : null),
          Center(
            child: TextButton(
                onPressed: _pickImage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_enhance),
                    Text(' Add Image')
                  ],
                )),
          )
        ],
      ),
    );
  }
}
