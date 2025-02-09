import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _bannerImage =
      'https://via.placeholder.com/600x200?text=Mountains'; // Placeholder banner image
  String _profileImage =
      'https://via.placeholder.com/150'; // Placeholder profile image

  Future<void> _pickImage(bool isBanner) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isBanner) {
          _bannerImage = pickedFile.path;
        } else {
          _profileImage = pickedFile.path;
        }
      });
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
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_bannerImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: MediaQuery.of(context).size.width / 2 - 50,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_profileImage),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
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
            Icon(Icons.star, color: Colors.amber, size: 24),
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
      color: Colors.white,
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.photo,
            title: 'Change Banner',
            onTap: () => _pickImage(true),
          ),
          _buildSettingsTile(
            icon: Icons.person,
            title: 'Change Profile Picture',
            onTap: () => _pickImage(false),
          ),
          _buildSettingsTile(
            icon: Icons.bookmark_border,
            title: 'Saved Places',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help Center',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
