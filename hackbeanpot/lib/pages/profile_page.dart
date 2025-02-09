import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _bannerImageFile;
  File? _profileImageFile;

  final List<Map<String, dynamic>> trophies = [
    {'icon': Icons.flash_on, 'name': 'Quick Start'},
    {'icon': Icons.emoji_events, 'name': 'Champion'},
    {'icon': Icons.wine_bar, 'name': 'Elite'},
    {'icon': Icons.two_k, 'name': 'Level 24'},
    {'icon': Icons.ac_unit, 'name': 'Winter'},
  ];

  Future<void> _pickImage(bool isBanner) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final picker = ImagePicker();

      // Show image source dialog
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      // Pop the loading dialog
      if (mounted) Navigator.pop(context);

      if (source == null) return;

      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: isBanner ? 1200 : 800,
        maxHeight: isBanner ? 400 : 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);

        // Verify file exists
        if (await imageFile.exists()) {
          setState(() {
            if (isBanner) {
              _bannerImageFile = imageFile;
            } else {
              _profileImageFile = imageFile;
            }
          });
        } else {
          throw Exception('Selected image file does not exist');
        }
      }
    } catch (e) {
      // Pop the loading dialog if it's still showing
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Failed to pick image:'),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _showFullScreenImage(File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner and Profile Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner Image
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        image: _bannerImageFile != null
                            ? DecorationImage(
                                image: FileImage(_bannerImageFile!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _bannerImageFile == null
                          ? const Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                if (_bannerImageFile != null) {
                                  _showFullScreenImage(_bannerImageFile!);
                                }
                              },
                            ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          _bannerImageFile != null
                              ? Icons.edit
                              : Icons.add_a_photo,
                          color: Colors.white,
                        ),
                        onPressed: () => _pickImage(true),
                      ),
                    ),
                  ],
                ),
                // Profile Image
                Positioned(
                  top: 150,
                  left: 20,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_profileImageFile != null) {
                            _showFullScreenImage(_profileImageFile!);
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            image: _profileImageFile != null
                                ? DecorationImage(
                                    image: FileImage(_profileImageFile!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _profileImageFile == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _profileImageFile != null
                                  ? Icons.edit
                                  : Icons.add_a_photo,
                              size: 20,
                            ),
                            onPressed: () => _pickImage(false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Username and Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '@Road_Warrior69',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Trophy Case Label
                  const Text(
                    'TROPHY CASE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Horizontal Scrollable Trophy List
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trophies.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                trophies[index]['icon'],
                                size: 32,
                                color: Colors.amber,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                trophies[index]['name'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MILES TRAVELLED: 123.45',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'JOINED: 2024',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
