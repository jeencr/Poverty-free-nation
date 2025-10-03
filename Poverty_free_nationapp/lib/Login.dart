import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:poverty_free_nationapp/Signup_user.dart';
import 'package:poverty_free_nationapp/UserHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLogin extends StatefulWidget {
  const AppLogin({super.key});

  @override
  State<AppLogin> createState() => _AppLoginState();
}

class _AppLoginState extends State<AppLogin> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _uname = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final Color primaryColor = const Color(0xFF2C3E50);
  final Color accentColor = const Color(0xFF2ECC71);
  final Color errorColor = const Color(0xFFE74C3C);
  String? imgPath;

  @override
  void initState() {
    super.initState();
  }

  // Validate username
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username is required';
    return null;
  }

  // Validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  // Fetch user data and profile image


  // Login function
  Future<void> _login() async {
    if (!_formkey.currentState!.validate()) return;

    SharedPreferences sh = await SharedPreferences.getInstance();
    String uname = _uname.text.trim();
    String pwd = _pwd.text.trim();
    String url = sh.getString("url") ?? "";

    try {
      final res = await http.post(
        Uri.parse("$url/loginapp/"),
        body: {'uname': uname, 'pwd': pwd},
      );

      final data = json.decode(res.body);
      String message = data['message'].toString();
      print(message);

      if (message == 'Invalid username or password.') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
        return;
      }

      if (res.statusCode == 200 && message == 'Login Successful.') {
        sh.setString('lid', data['login_id'].toString());
        sh.setString('uid', data['user_id'].toString());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHome()),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Server error: $e");
    }
  }

  // Build input field widget
  Widget _buildInputField(
      String label,
      TextEditingController controller, {
        bool isPassword = false,
        String? Function(String?)? validator,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFECF0F1),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: accentColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: errorColor, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: errorColor, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Icon(
                    Icons.lock_open_rounded,
                    color: primaryColor,
                    size: 96,
                  ),
                ),
                const SizedBox(height: 24),

                // Show profile image if available
                if (imgPath != null)
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(imgPath!),
                    ),
                  ),

                const SizedBox(height: 24),
                Text(
                  "Welcome Back!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Sign in to your account to continue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF7F8C8D),
                  ),
                ),
                const SizedBox(height: 48),

                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInputField(
                          "Username",
                          _uname,
                          validator: _validateUsername,
                        ),
                        _buildInputField(
                          "Password",
                          _pwd,
                          isPassword: true,
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding:
                              const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()),
                            );
                          },
                          child: Text(
                            "New User? Sign Up",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Back to Home",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

