import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'subscriptions.dart'; // Your SubscriptionPage import

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Profile info variables
  String name = 'John Doe';
  String gender = 'Male';
  String country = 'USA';
  String phoneNumber = '9876543210';
  String email = 'john.doe@example.com';
  String subscriptionPlan = 'Premium plan';

  // TextEditingController for the edit fields
  final TextEditingController _nameController = TextEditingController();

  // Dropdown variables
  String? _selectedGender;
  String? _selectedCountry;

  bool isEditing = false; // To toggle between view and edit mode

  // For profile image
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = name;
    _selectedGender = gender;
    _selectedCountry = country;
  }

  // Image picker logic
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          color: const Color(0xFF232323),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFB9F227)),
                title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? picked = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (picked != null) {
                    setState(() {
                      _profileImage = File(picked.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFB9F227)),
                title: const Text('Take a Photo', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? picked = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,
                  );
                  if (picked != null) {
                    setState(() {
                      _profileImage = File(picked.path);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF191A1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
       
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF116466), Color(0xFF191A1E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 56, color: Colors.white)
                          : null,
                    ),
                  ),
                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: MediaQuery.of(context).size.width / 2 - 56,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB9F227),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.black, size: 22),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Animated Editable Info Section
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: isEditing ? _editProfileSection() : _infoSection(),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
            ),

            // Manage Subscription Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SubscriptionPage()),
                  );
                },
                icon: const Icon(Icons.subscriptions, color: Colors.black),
                label: const Text(
                  'Manage Subscription',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB9F227),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Edit Profile Button
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: Padding(
                key: ValueKey(isEditing),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (isEditing) {
                        // Save changes
                        name = _nameController.text;
                        gender = _selectedGender ?? gender;
                        country = _selectedCountry ?? country;
                      }
                      isEditing = !isEditing; // Toggle edit mode
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF232323),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isEditing ? 'Save Changes' : 'Edit Profile',
                    style: TextStyle(
                      color: isEditing ? const Color(0xFFB9F227) : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  // Profile information in view mode
  Widget _infoSection() {
    return Column(
      key: const ValueKey('view'),
      children: [
        _infoTile('Full Name', name, Icons.person_outline),
        _infoTile('Gender', gender, Icons.wc),
        _infoTile('Phone number', phoneNumber, Icons.phone),
        _infoTile('Email', email, Icons.email_outlined),
        _infoTile('Country', country, Icons.flag_outlined),
        _infoTile('Subscription Plan', subscriptionPlan, Icons.verified_user),
      ],
    );
  }

  // Editable profile section
  Widget _editProfileSection() {
    return Column(
      key: const ValueKey('edit'),
      children: [
        _editableInfoTile('Full Name', _nameController, Icons.person_outline),
        _editableGenderDropdown(),
        _editableCountryDropdown(),
        _infoTile('Phone number', phoneNumber, Icons.phone),
        _infoTile('Email', email, Icons.email_outlined),
        _infoTile('Subscription Plan', subscriptionPlan, Icons.verified_user),
      ],
    );
  }

  // Common tile for displaying profile information
  Widget _infoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFB9F227), size: 22),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Editable tile for Full Name
  Widget _editableInfoTile(String title, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFB9F227), size: 22),
          const SizedBox(width: 18),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter $title',
                hintStyle: const TextStyle(color: Colors.white54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Gender dropdown menu
  Widget _editableGenderDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          const Icon(Icons.wc, color: Color(0xFFB9F227), size: 22),
          const SizedBox(width: 18),
          const Expanded(
            child: Text('Gender',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          DropdownButton<String>(
            value: _selectedGender,
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
                gender = newValue!;
              });
            },
            items: <String>['Male', 'Female', 'Other']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            dropdownColor: const Color(0xFF232323),
            iconEnabledColor: const Color(0xFFB9F227),
          ),
        ],
      ),
    );
  }

  // Country dropdown menu
  Widget _editableCountryDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          const Icon(Icons.flag_outlined, color: Color(0xFFB9F227), size: 22),
          const SizedBox(width: 18),
          const Expanded(
            child: Text('Country',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          DropdownButton<String>(
            value: _selectedCountry,
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCountry = newValue;
                country = newValue!;
              });
            },
            items: <String>['USA', 'India', 'Canada', 'UK']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            dropdownColor: const Color(0xFF232323),
            iconEnabledColor: const Color(0xFFB9F227),
          ),
        ],
      ),
    );
  }
}
