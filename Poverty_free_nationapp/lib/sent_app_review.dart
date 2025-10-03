import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SendAppReview extends StatefulWidget {
  const SendAppReview({super.key});

  @override
  State<SendAppReview> createState() => _SendAppReviewState();
}

class _SendAppReviewState extends State<SendAppReview> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  List<dynamic> _reviews = [];
  bool _isLoading = true;



  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  // 📥 Fetch reviews from backend
  Future<void> _fetchReviews() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String baseUrl = prefs.getString('url') ?? '';
      String uid = prefs.getString('uid') ?? '';
      final response = await http.post(Uri.parse("$baseUrl/get_reviews_user/"),
          body: {
            "uid": uid,
          }
      );
      if (response.statusCode == 200) {
        setState(() {
          _reviews = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
      setState(() => _isLoading = false);
    }
  }

  // 🚀 Submit review to backend
  Future<void> _submitReview() async {
    String review = _reviewController.text;
    if (_rating == 0 || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please give a rating and review")),
      );
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String baseUrl = prefs.getString('url') ?? '';
      String uid = prefs.getString('uid') ?? '';
      final response = await http.post(
        Uri.parse("$baseUrl/add_review_user/"),
        body: {
          "rating": _rating.toString(),
          "review": review,
          "uid": uid
        },
      );

      if (response.statusCode == 200) {
        _reviewController.clear();
        setState(() => _rating = 0);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Review submitted successfully")),
        );
        _fetchReviews(); // refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      debugPrint("Error submitting review: $e");
    }
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= _rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 32,
      ),
      onPressed: () {
        setState(() {
          _rating = index;
        });
      },
    );
  }

  Widget _buildReviewCard(dynamic reviewData) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User + Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reviewData["user_name"] ?? "Anonymous",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      index < (reviewData["rating"] ?? 0)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(reviewData["review"] ?? ""),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Feedback"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // ⭐ Rating Form
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text(
                  "Rate the App",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) => _buildStar(i + 1)),
                ),
                TextField(
                  controller: _reviewController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Write your review...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text("Submit Review"),
                ),
              ],
            ),
          ),

          const Divider(),

          // 📋 Reviews Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _reviews.isEmpty
                ? const Center(child: Text("No reviews yet"))
                : ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, i) =>
                  _buildReviewCard(_reviews[i]),
            ),
          ),
        ],
      ),
    );
  }
}
