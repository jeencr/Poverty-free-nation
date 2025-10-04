import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ResumeUpload extends StatefulWidget {
  const ResumeUpload({super.key});

  @override
  State<ResumeUpload> createState() => _ResumeUploadState();
}

class _ResumeUploadState extends State<ResumeUpload> {
  List<dynamic> _resumes = [];
  bool _isLoading = true;
  String? imgurl;

  @override
  void initState() {
    super.initState();
    _fetchResumes();
  }

  /// 📥 Fetch uploaded resumes from backend
  Future<void> _fetchResumes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String baseUrl = prefs.getString('url') ?? '';
      String uid = prefs.getString('uid') ?? '';
      imgurl = prefs.getString('img_url');

      final response = await http.post(
        Uri.parse("$baseUrl/get_resumes_user/"),
        body: {"uid": uid},
      );

      if (response.statusCode == 200) {
        setState(() {
          _resumes = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching resumes: $e");
      setState(() => _isLoading = false);
    }
  }

  /// 📤 Upload a new resume file with title
  Future<void> _uploadResume() async {
    final TextEditingController titleController = TextEditingController();

    // Show dialog to ask for title
    String? enteredTitle = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Resume Title"),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Enter a title for your resume",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a title")),
                  );
                  return;
                }
                Navigator.pop(context, titleController.text.trim());
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    if (enteredTitle == null) return; // user cancelled

    // File picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String baseUrl = prefs.getString('url') ?? '';
        String uid = prefs.getString('uid') ?? '';

        var request = http.MultipartRequest(
          "POST",
          Uri.parse("$baseUrl/upload_resume/"),
        );

        request.fields["uid"] = uid;
        request.fields["title"] = enteredTitle; // ✅ send title too
        request.files.add(
          await http.MultipartFile.fromPath("resume", file.path),
        );

        var response = await request.send();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Resume uploaded successfully")),
          );
          _fetchResumes(); // refresh list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to upload (${response.statusCode})")),
          );
        }
      } catch (e) {
        debugPrint("Upload error: $e");
      }
    }
  }

  /// 📥 Download resume (open in browser/downloader)
  Future<void> _downloadResume(String fileUrl) async {
    if (await canLaunchUrl(Uri.parse(fileUrl))) {
      await launchUrl(Uri.parse(fileUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open resume")),
      );
    }
  }

  /// 📄 Resume Card Widget
  Widget _buildResumeCard(dynamic resumeData) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text("Title: ${resumeData['title']}"),
        subtitle: Text("Uploaded at: ${resumeData['uploaded_at']}"),
        trailing: IconButton(
          icon: const Icon(Icons.download, color: Colors.blueAccent),
          onPressed: () => _downloadResume("$imgurl/media/${resumeData["resume"]}"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Resume"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _uploadResume,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _resumes.isEmpty
          ? const Center(child: Text("No resumes uploaded yet"))
          : ListView.builder(
        itemCount: _resumes.length,
        itemBuilder: (context, i) => _buildResumeCard(_resumes[i]),
      ),
    );
  }
}
