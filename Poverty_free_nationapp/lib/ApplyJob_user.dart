import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApplyJobUser extends StatefulWidget {
  const ApplyJobUser({super.key, required this.vac_id});
  final String vac_id;
  @override
  State<ApplyJobUser> createState() => _ApplyJobUserState();
}

class _ApplyJobUserState extends State<ApplyJobUser> {
  bool _isLoading = true;
  Map<String, dynamic>? _vacancy;
  List<dynamic> _resumes = [];
  dynamic _selectedResume;

  @override
  void initState() {
    super.initState();
    print("adsad");
    _fetchVacancyAndResumes();
  }

  Future<void> _fetchVacancyAndResumes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('uid') ?? '';
      String baseUrl = prefs.getString('url') ?? '';
      print('sdjvn');
      print("skdjnjwd");

      final response = await http.post(
        Uri.parse("$baseUrl/apply_vacancy_user_get/"),
        body: {
          "uid": uid,
          "vac_id": widget.vac_id,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          _vacancy = data['vacancy'];
          _resumes = data['resumes'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch data: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error fetching vacancy/resumes: $e");
    }
  }

  Future<void> _submitApplication() async {
    if (_selectedResume == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a resume")),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('uid') ?? '';
      String baseUrl = prefs.getString('url') ?? '';

      final response = await http.post(
        Uri.parse("$baseUrl/submit_vacancy_application/"),
        body: {
          "uid": uid,
          "vac_id": widget.vac_id,
          "resume_id": _selectedResume['id'].toString(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Application submitted successfully!")),
        );
        Navigator.pop(context, true); // go back after submission
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("Error submitting application: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Apply for Job"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _vacancy == null
            ? const Center(child: Text("Vacancy not found"))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _vacancy!['title'] ?? '',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Company: ${_vacancy!['company_name'] ?? ''}"),
              Text("Email: ${_vacancy!['company_email'] ?? ''}"),
              Text("Address: ${_vacancy!['company_address'] ?? ''}"),
              const SizedBox(height: 12),
              Text("Description: ${_vacancy!['description'] ?? ''}"),
              const SizedBox(height: 12),
              Text("Requirements: ${_vacancy!['requirements'] ?? ''}"),
              const SizedBox(height: 20),
              const Text("Select Resume to Apply:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButton<dynamic>(
                isExpanded: true,
                value: _selectedResume,
                hint: const Text("Select Resume"),
                items: _resumes.map((resume) {
                  return DropdownMenuItem(
                    value: resume,
                    child: Text(resume['title'] ?? 'Untitled'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedResume = val;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitApplication,
                  child: const Text("Submit Application"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
