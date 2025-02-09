import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _bannerImageFile;
  File? _profileImageFile;
  String _bannerImage = 'https://picsum.photos/800/400'; // Default banner image
  String _profileImage = 'https://picsum.photos/200'; // Default profile image

  final List<Map<String, dynamic>> trophies = [
    {'icon': Icons.flash_on, 'name': 'Quick Start'},
    {'icon': Icons.emoji_events, 'name': 'Champion'},
    {'icon': Icons.wine_bar, 'name': 'Elite'},
    {'icon': Icons.two_k, 'name': 'Level 24'},
    {'icon': Icons.ac_unit, 'name': 'Winter'},
  ];

  Future<void> _pickImage(bool isBanner) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: isBanner
            ? const CropAspectRatio(ratioX: 2, ratioY: 1)
            : const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: isBanner ? 800 : 400,
        maxHeight: isBanner ? 400 : 400,
        cropStyle: isBanner ? CropStyle.rectangle : CropStyle.circle,
      );

      if (croppedFile != null) {
        setState(() {
          if (isBanner) {
            _bannerImageFile = File(croppedFile.path);
            _bannerImage = croppedFile.path;
          } else {
            _profileImageFile = File(croppedFile.path);
            _profileImage = croppedFile.path;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomLeft,
                children: [
                  // Banner Image
                  GestureDetector(
                    onTap: () => _pickImage(true),
                    child: Container(
                      height: 150, // Reduced height for banner
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _bannerImageFile != null
                              ? FileImage(_bannerImageFile!) as ImageProvider
                              : NetworkImage(_bannerImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white.withOpacity(0.8),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  // Profile Picture
                  Positioned(
                    bottom: -40,
                    left: 16, // Aligned to the left like Twitter
                    child: GestureDetector(
                      onTap: () => _pickImage(false),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 45, // Slightly smaller profile picture
                              backgroundImage: _profileImageFile != null
                                  ? FileImage(_profileImageFile!)
                                      as ImageProvider
                                  : NetworkImage(_profileImage),
                              backgroundColor: Colors.grey[200],
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 48), // Adjusted spacing for profile content
              const Text(
                'Freaky Pai',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Adventure Enthusiast',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatColumn('12', 'Trips'),
                  _buildStatColumn('48', 'Places'),
                  _buildStatColumn('2.4k', 'Photos'),
                ],
              ),
              const SizedBox(height: 12),
              _buildBadgesSection(),
              const SizedBox(height: 12),
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Badges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(6, (index) {
              return _buildBadgeCard('Badge ${index + 1}');
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(String label) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
