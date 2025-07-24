import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicturePicker extends StatefulWidget {
  final Function(String?) onImagePicked;
  final String? initialImage;

  const ProfilePicturePicker({
    super.key,
    required this.onImagePicked,
    this.initialImage,
  });

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
      widget.onImagePicked(_imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blueAccent,
        backgroundImage:
            _imagePath != null ? FileImage(File(_imagePath!)) : null,
        child:
            _imagePath == null
                ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                : null,
      ),
    );
  }
}
