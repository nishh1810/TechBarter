import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/services/api_service.dart';

class ProfileImageUploader extends StatefulWidget {
  const ProfileImageUploader({super.key});

  @override
  State<ProfileImageUploader> createState() => _ProfileImageUploaderState();
}

class _ProfileImageUploaderState extends State<ProfileImageUploader> {
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Pick only images
      );
      if (result != null) {
        setState(() {
          _imageBytes = result.files.first.bytes;
          Provider.of<UserProvider>(context, listen: false).updateProfileImage(_imageBytes);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageId = Provider.of<UserProvider>(context).user?.profileImage?.id;
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(60), // Circular shape
              border: Border.all(color: Colors.grey.shade300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(4, 4),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  spreadRadius: -3,
                  blurRadius: 10,
                  offset: const Offset(-4, -4),
                ),
              ],
            ),
            child: _imageBytes == null
                ? FutureBuilder<String>(
                  future: ApiService.loadImage(imageId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                          width: 120,
                          height: 120,
                          child: Center(child: CircularProgressIndicator())
                      );
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.camera_alt, size: 40, color: Colors.grey);
                    }
                    else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          snapshot.data.toString(),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.memory(
                    _imageBytes!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
