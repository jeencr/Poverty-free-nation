import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SendComplaint extends StatefulWidget {
  const SendComplaint({super.key});

  @override
  State<SendComplaint> createState() => _SendComplaintState();
}

class _SendComplaintState extends State<SendComplaint> {
  final TextEditingController _complaintController = TextEditingController();

  List<dynamic> _complaints = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  // 📥 Fetch complaints from backend
  Future<void> _fetchComplaints() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String baseUrl = prefs.getString('url') ?? '';
      String uid = prefs.getString('uid') ?? '';

      final response = await http.post(
        Uri.parse("$baseUrl/get_complaints_user/"),
        body: {"uid": uid},
      );

      if (response.statusCode == 200) {
        setState(() {
          _complaints = jsonDecode(response.body);
          print(_complaints);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching complaints: $e");
      setState(() => _isLoading = false);
    }
  }

  // 🚀 Submit complaint
  Future<void> _submitComplaint() async {
    String complaint = _complaintController.text;
    if (complaint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your complaint")),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String baseUrl = prefs.getString('url') ?? '';
      String uid = prefs.getString('uid') ?? '';

      final response = await http.post(
        Uri.parse("$baseUrl/add_complaint_user/"),
        body: {
          "complaint": complaint,
          "uid": uid,
        },
      );

      if (response.statusCode == 200) {
        _complaintController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Complaint submitted successfully")),
        );
        _fetchComplaints(); // refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("Error submitting complaint: $e");
    }
  }

  // 📝 Complaint + Reply card
  Widget _buildComplaintCard(dynamic complaintData) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Complaint text
            Text(
              "Complaint:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              complaintData["complaint_text"] ?? "",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              'Status: ${complaintData['status']}'
            ),

            // Reply section
            if (complaintData["reply_text"] != null &&
                complaintData["reply_text"].toString().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text(
                    "Admin Reply:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.green[700]),
                  ),
                  Text(
                    complaintData["reply_text"],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "No reply yet",
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
              ),


          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaints"),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          // ✍️ Complaint Form
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _complaintController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Enter your complaint...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitComplaint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text("Submit Complaint"),
                ),
              ],
            ),
          ),

          const Divider(),

          // 📋 Complaints Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _complaints.isEmpty
                ? const Center(child: Text("No complaints submitted yet"))
                : ListView.builder(
              itemCount: _complaints.length,
              itemBuilder: (context, i) =>
                  _buildComplaintCard(_complaints[i]),
            ),
          ),
        ],
      ),
    );
  }
}
