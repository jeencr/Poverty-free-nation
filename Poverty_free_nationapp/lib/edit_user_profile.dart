import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileEdit extends StatefulWidget {
  const UserProfileEdit({super.key});

  @override
  State<UserProfileEdit> createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? _imageFile;
  String imgUrl = '';
  String? photoPath; // ✅ store photo path from backend
  bool isLoading = true;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController qualificationController;
  late TextEditingController skillsController;
  late TextEditingController genderController;
  late TextEditingController dobController;
  late TextEditingController experienceController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    qualificationController = TextEditingController();
    skillsController = TextEditingController();
    genderController = TextEditingController();
    dobController = TextEditingController();
    experienceController = TextEditingController();
    addressController = TextEditingController();

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? url = pref.getString('url');
    String? userId = pref.getString('uid');
    setState(() {
      imgUrl = pref.getString('img_url') ?? '';
    });

    if (url == null || userId == null) {
      Fluttertoast.showToast(msg: "Missing user info.");
      return;
    }

    try {
      var response = await http.post(
        Uri.parse("$url/edit_user_profile_get/"),
        body: {'uid': userId},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        data = data['user_profile'];

        setState(() {
          nameController.text = data['name'] ?? '';
          phoneController.text = data['phone'] ?? '';
          emailController.text = data['email'] ?? '';
          qualificationController.text = data['qualification'] ?? '';
          skillsController.text = data['skills'] ?? '';
          genderController.text = data['gender'] ?? '';
          dobController.text = data['dob'] ?? '';
          experienceController.text = data['experience'] ?? '';
          addressController.text = data['address'] ?? '';
          photoPath = data['photo']; // ✅ store photo path
          isLoading = false;
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to load profile");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? url = pref.getString('url');
    String? userId = pref.getString('uid');

    if (url == null || userId == null) {
      Fluttertoast.showToast(msg: "Missing user info.");
      return;
    }

    try {
      var request =
      http.MultipartRequest('POST', Uri.parse("$url/update_user_profile_post/"));
      request.fields['uid'] = userId;
      request.fields['name'] = nameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['email'] = emailController.text;
      request.fields['qualification'] = qualificationController.text;
      request.fields['skills'] = skillsController.text;
      request.fields['gender'] = genderController.text;
      request.fields['dob'] = dobController.text;
      request.fields['experience'] = experienceController.text;
      request.fields['address'] = addressController.text;

      if (_imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo', _imageFile!.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Profile updated successfully");
        if (mounted) Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: "Update failed: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (photoPath != null && photoPath!.isNotEmpty
                      ? NetworkImage("$imgUrl/media/$photoPath")
                      : const AssetImage(
                      'assets/default_avatar.png')
                  as ImageProvider),
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Full Name", nameController),
              _buildTextField("Phone", phoneController,
                  keyboardType: TextInputType.phone),
              _buildTextField("Email", emailController,
                  keyboardType: TextInputType.emailAddress),
              _buildTextField("Qualification", qualificationController),
              _buildTextField("Skills", skillsController),
              _buildTextField("Gender", genderController),
              _buildTextField("Date of Birth", dobController),
              _buildTextField("Experience", experienceController),
              _buildTextField("Address", addressController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Save",
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) =>
        value == null || value.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

}
