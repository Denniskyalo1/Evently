import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:event_management/constants.dart';

class EventRequestsPage extends StatefulWidget {
  const EventRequestsPage({super.key});

  @override
  State<EventRequestsPage> createState() => _EventRequestsPageState();
}

class _EventRequestsPageState extends State<EventRequestsPage> {
  final storage = FlutterSecureStorage();
  List<dynamic> submissions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubmissions();
  }

  Future<void> fetchSubmissions() async {
    final token = await storage.read(key: 'authToken');
    final response = await http.get(
      Uri.parse('$baseUrl/api/submitted-events'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        submissions = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load submissions')),
      );
    }
  }

  Future<void> handleAction(int id, String action) async {
    final token = await storage.read(key: 'authToken');
    final url = '$baseUrl/api/${action}-event/$id';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event $action successfully')),
      );
      fetchSubmissions();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to $action event')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 35),
          color: colorScheme.onSurface,
          onPressed: () {
            Navigator.of(context).pushNamed('/adminprofile');
          },
        ),
        title: Text(
          'Event Requests',
          style: GoogleFonts.roboto(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        elevation: 30.0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : submissions.isEmpty
          ? const Center(child: Text('No pending reuqests'))
          : ListView.builder(
        itemCount: submissions.length,
        itemBuilder: (context, index) {
          final event = submissions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(event['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${event['venue']} - ${event['city']}'),
                  if (event['user'] != null && event['user']['name'] != null)
                    Text('Submitted by: ${event['user']['name']}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => handleAction(event['id'], 'approve'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => handleAction(event['id'], 'reject'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
