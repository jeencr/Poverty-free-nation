import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poverty_free_nationapp/ApplyJob_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewVacancy extends StatefulWidget {
  const ViewVacancy({super.key});

  @override
  State<ViewVacancy> createState() => _ViewVacancyState();
}

class _ViewVacancyState extends State<ViewVacancy> {
  List<dynamic> _vacancies = [];
  bool _isLoading = true;
  String? baseUrl;
  String? uid;

  @override
  void initState() {
    super.initState();
    _fetchVacancies();
  }

  Future<void> _fetchVacancies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    baseUrl = prefs.getString("url");
    uid = prefs.getString("uid");

    try {
      final response = await http.get(Uri.parse("$baseUrl/vacancy_user_get/"));
      if (response.statusCode == 200) {
        setState(() {
          _vacancies = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching vacancies: $e");
      setState(() => _isLoading = false);
    }
  }


  Widget _buildVacancyCard(dynamic vacancy) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: ${vacancy['title'] ?? 'N/A'}",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("Description: ${vacancy['description'] ?? ''}"),
            Text("Location: ${vacancy['location'] ?? ''}"),
            Text("Posted at: ${vacancy['posted_at'] ?? ''}"),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: ()  {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyJobUser(vac_id: vacancy['id'].toString()), ),);
                },
                icon: const Icon(Icons.send),
                label: const Text("Apply"),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Available Vacancies")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vacancies.isEmpty
          ? const Center(child: Text("No vacancies found"))
          : ListView.builder(
        itemCount: _vacancies.length,
        itemBuilder: (context, index) =>
            _buildVacancyCard(_vacancies[index]),
      ),
    );
  }
}
