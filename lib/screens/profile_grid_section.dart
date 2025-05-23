import 'dart:io';
import 'package:flutter/material.dart';
import 'avatar_modal.dart';

class ProfileGridSection extends StatefulWidget {
  final File? profileImage;
  final String name;

  const ProfileGridSection({
    super.key,
    required this.profileImage,
    required this.name,
  });

  @override
  State<ProfileGridSection> createState() => _ProfileGridSectionState();
}

class _ProfileGridSectionState extends State<ProfileGridSection> {
  String? customAvatarName;
  String? customAvatarUrl;

  void _showAvatarModal() async {
    await showDialog(
      context: context,
      builder: (context) => AvatarModal(
        onSave: (name, url) {
          setState(() {
            customAvatarName = name;
            customAvatarUrl = url;
          });
        },
      ),
    );
  }

  Widget _profileAvatar({
    File? image,
    String? networkImage,
    IconData? icon,
    String? emoji,
    required String label,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: highlight ? const Color(0xFFB9F227) : Colors.white24,
                width: highlight ? 3 : 2,
              ),
              boxShadow: [
                if (highlight)
                  BoxShadow(
                    color: const Color(0xFFB9F227).withOpacity(0.3),
                    blurRadius: 14,
                  ),
              ],
            ),
            child: CircleAvatar(
              radius: 38,
              backgroundColor: Colors.white.withOpacity(0.07),
              backgroundImage: image != null
                  ? FileImage(image)
                  : (networkImage != null ? NetworkImage(networkImage) : null) as ImageProvider<Object>?,
              child: image == null && networkImage == null
                  ? (emoji != null
                      ? Text(
                          emoji,
                          style: const TextStyle(fontSize: 36),
                        )
                      : Icon(icon, size: 38, color: Colors.white))
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              color: highlight ? const Color(0xFFB9F227) : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Main Profile
          _profileAvatar(
            image: widget.profileImage,
            icon: Icons.person,
            label: widget.name,
            onTap: () {},
            highlight: true,
          ),
          // Kids Profile
          _profileAvatar(
            emoji: '🧒',
            label: 'Kids',
            onTap: () {},
          ),
          // Custom Avatar (if created)
          if (customAvatarUrl != null)
            _profileAvatar(
              networkImage: customAvatarUrl,
              label: customAvatarName ?? 'Custom',
              onTap: () {},
            ),
          // Add Avatar Button
          if (customAvatarUrl == null)
            Column(
              children: [
                GestureDetector(
                  onTap: _showAvatarModal,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 38,
                      backgroundColor: Color(0xFFB9F227),
                      child: Icon(Icons.add, size: 38, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(
                  width: 90,
                  child: Text(
                    'Add Avatar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
