import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:poverty_free_nationapp/edit_user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<Map<String, dynamic>> _userProfileFuture;
  String imgUrl = '';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPwdController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final TextEditingController _reNewPwdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userProfileFuture = view_user_profile();
  }

  Future<Map<String, dynamic>> view_user_profile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? url = pref.getString('url');
    String? userId = pref.getString('uid');
    imgUrl = pref.getString('img_url') ?? '';

    if (url == null || userId == null) {
      throw Exception("URL or User ID not found in SharedPreferences.");
    }

    try {
      final res = await http.post(
        Uri.parse("$url/view_user_profile/"),
        body: {
          'uid': userId,
        },
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(res.body);
        return responseData['user_profile'];
      } else {
        throw Exception("Failed to load user profile: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
      rethrow;
    }
  }

  void _logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileEdit()));
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final profile = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage("$imgUrl/media/${profile['photo']}"),
                      onBackgroundImageError: (_, __) {
                        Fluttertoast.showToast(msg: "Failed to load image");
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile['name'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildProfileInfo(Icons.phone, 'Phone', profile['phone']),
                    _buildProfileInfo(Icons.email, 'Email', profile['email']),
                    _buildProfileInfo(Icons.school, 'Qualification', profile['qualification']),
                    _buildProfileInfo(Icons.build, 'Skills', profile['skills']),
                    _buildProfileInfo(Icons.person, 'Gender', profile['gender']),
                    _buildProfileInfo(Icons.cake, 'Date of Birth', profile['dob']),
                    _buildProfileInfo(Icons.work, 'Experience', profile['experience']),
                    _buildProfileInfo(Icons.home, 'Address', profile['address']),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _showChangePasswordDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Change Password",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text("No profile data found."));
          }
        },
      ),
    );
  }

  Widget _buildProfileInfo(IconData icon, String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  value?.toString() ?? 'N/A',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final oldPwd = _oldPwdController.text.trim();
    final newPwd = _newPwdController.text.trim();

    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = pref.getString('url') ?? '';
    String uid = pref.getString('uid') ?? '';

    try {
      final res = await http.post(
        Uri.parse("$url/change_password_user/"),
        body: {'uid': uid, 'old_password': oldPwd, 'new_password': newPwd},
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Password changed successfully.")));
        Navigator.pop(context);
        _oldPwdController.clear();
        _newPwdController.clear();
        _reNewPwdController.clear();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'] ?? "Error changing password")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }  void _showChangePasswordDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Change Password",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _oldPwdController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        prefixIcon: Icon(Icons.lock, color: theme.colorScheme.primary),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? "Enter old password" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPwdController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        prefixIcon:
                        Icon(Icons.lock_outline, color: theme.colorScheme.primary),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? "Enter new password" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _reNewPwdController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Re-enter New Password',
                        prefixIcon:
                        Icon(Icons.lock_outline, color: theme.colorScheme.primary),
                      ),
                      validator: (value) => value != _newPwdController.text
                          ? "Passwords do not match"
                          : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: _changePassword,
                          child: const Text("Change"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
