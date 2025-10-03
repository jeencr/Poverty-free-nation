import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:poverty_free_nationapp/Send_complaint_user.dart';
import 'package:poverty_free_nationapp/sent_app_review.dart';
import 'package:poverty_free_nationapp/view_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String? imgPath;

  @override
  void initState() {
    super.initState();
    user_data_get();
  }

  // Fetch user data and profile image
  Future<void> user_data_get() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String? url = sh.getString('url');
    String? uid = sh.getString('uid');
    String? img_url = sh.getString('img_url');

    if (url == null) {
      Fluttertoast.showToast(msg: "Server URL not found.");
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('$url/user_data_get/'),
        body: {'uid': uid},
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final userData = data['data']; // 👈 Nested data

        print('$userData (user data received)');

        setState(() {
          imgPath = "$img_url/media/${userData['photo']}";
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to fetch user data");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  // Reusable ElevatedButton
  Widget buildElevatedButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Home"),
        actions: [
          if (imgPath != null)
            IconButton(
              icon: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(imgPath!),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfile(),
                  ),
                );
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: user_data_get,
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (imgPath != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(imgPath!),
                ),
              ),
            const SizedBox(height: 16),

            // Each button separately
            buildElevatedButton("Sent app reviews and rating", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SendAppReview(),
                ),
              );

            }),
            buildElevatedButton("Sent complaint to admin and view reply", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SendComplaint(),
                ),
              );
            }),
            buildElevatedButton("Upload Resume (PDF Only)", () {}),
            buildElevatedButton("View job vacancies and apply", () {}),
            buildElevatedButton("View applied job vacancies and status", () {}),
            buildElevatedButton("View notifications", () {}),
            buildElevatedButton("View all companies", () {}),
            buildElevatedButton("View skill centers", () {}),
            buildElevatedButton("View current programs", () {}),
            buildElevatedButton("View Videos sessions", () {}),
            buildElevatedButton("View Google meet class links", () {}),
            buildElevatedButton("Send review about programs", () {}),
            buildElevatedButton("Create crowd funding request", () {}),
            buildElevatedButton("View created crowd funding request and status", () {}),
            buildElevatedButton("View Other crowd funding request", () {}),
            buildElevatedButton("Send money (Razorpay)", () {}),
            buildElevatedButton("View Self Transactions", () {}),
            buildElevatedButton("View Others donation to my crowd funding", () {}),
            buildElevatedButton("Send help message to other users", () {}),
            buildElevatedButton("View my help request", () {}),
            buildElevatedButton("View others response willingness", () {}),
            buildElevatedButton("View others help message", () {}),
            buildElevatedButton("Confirm willingness to help", () {}),
          ],
        ),
      ),
    );
  }
}
