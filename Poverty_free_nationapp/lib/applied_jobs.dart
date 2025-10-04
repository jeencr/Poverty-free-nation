import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppliedJobs extends StatefulWidget {
  const AppliedJobs({super.key});

  @override
  State<AppliedJobs> createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  bool _isLoading = true;
  List<dynamic> _applications = [];

  @override
  void initState() {
    super.initState();
    _fetchAppliedJobs();
  }

  Future<void> _fetchAppliedJobs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString('uid') ?? '';
      String baseUrl = prefs.getString('url') ?? '';

      final response = await http.post(
        Uri.parse("$baseUrl/view_applied_vacancies_user/"),
        body: {"uid": uid},
      );

      if (response.statusCode == 200) {
        setState(() {
          _applications = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Error fetching applied jobs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Applications"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
          ? const Center(child: Text("No applications found"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _applications.length,
        itemBuilder: (context, index) {
          final app = _applications[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app["vacancy__title"] ?? "Untitled Job",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text("Vacancy Status:${app["vacancy__status"] ?? ''}"),
                  Text("Company: ${app["vacancy__company__company_name"] ?? ''}"),
                  Text("Email: ${app["vacancy__company__email"] ?? ''}"),
                  Text("Address: ${app["vacancy__company__address"] ?? ''}"),
                  const SizedBox(height: 6),
                  Text("Description: ${app["vacancy__description"] ?? ''}"),
                  Text("Requirements: ${app["vacancy__requirements"] ?? ''}"),
                  const SizedBox(height: 6),
                  Text("Applied At: ${app["applied_at"] ?? ''}"),
                  Text("Status: ${app["status"] ?? ''}",
                      style: const TextStyle(color: Colors.blueAccent)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
