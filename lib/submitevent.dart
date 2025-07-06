import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:event_management/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubmitEventPage extends StatefulWidget {
  const SubmitEventPage({super.key});

  @override
  State<SubmitEventPage> createState() => _SubmitEventPageState();
}

class _SubmitEventPageState extends State<SubmitEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _image;
  final storage = FlutterSecureStorage();

  String title = '';
  String description = '';
  String venue = '';
  String city = '';
  int? categoryId;
  double? price;
  DateTime? selectedDateTime;
  bool _isLoading = false;

  final List<Map<String, dynamic>> categories = [
    {'id': 1, 'name': 'Music'},
    {'id': 2, 'name': 'Tech'},
    {'id': 3, 'name': 'Sports'},
    {'id': 4, 'name': 'Business'},
  ];

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<String?> uploadImage(File image) async {
    final uri = Uri.parse('$baseUrl/api/upload-event-image');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final token = await storage.read(key: 'authToken');
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json'; // <-- crucial for Laravel Sanctum

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      return data['path'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed (${response.statusCode})')),
      );
      return null;
    }
  }


  Future<void> submitEvent() async {
    if (!_formKey.currentState!.validate() || selectedDateTime == null || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and pick image/date')),
      );
      return;
    }

    setState(() => _isLoading = true);
    _formKey.currentState!.save();

    final imagePath = await uploadImage(_image!);
    if (imagePath == null) {
      setState(() => _isLoading = false);
      return;
    }

    final uri = Uri.parse('$baseUrl/api/submit-event');
    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['venue'] = venue;
    request.fields['city'] = city;
    request.fields['category_id'] = categoryId.toString();
    request.fields['price'] = price.toString();
    request.fields['dateTime'] = selectedDateTime!.toIso8601String();
    request.fields['imageUrl'] = imagePath;

    final token = await storage.read(key: 'authToken');
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    var response = await request.send();

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text('Event submitted successfully, pending approval.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );

      setState(() {
        title = '';
        description = '';
        venue = '';
        city = '';
        categoryId = null;
        price = null;
        selectedDateTime = null;
        _image = null;
        _formKey.currentState!.reset();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit event (${response.statusCode})')),
      );
    }
  }

  Future<void> pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
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
            Navigator.of(context).pushNamed('/home');
          },
        ),
        title: Text(
          'Submit Event',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Title'),
                onSaved: (val) => title = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (val) => description = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Required' : null,
                maxLines: 3,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Venue'),
                onSaved: (val) => venue = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'City'),
                onSaved: (val) => city = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<int>(
                value: categoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories
                    .map<DropdownMenuItem<int>>((cat) => DropdownMenuItem<int>(
                  value: cat['id'] as int,
                  child: Text(cat['name']),
                ))
                    .toList(),
                onChanged: (val) => setState(() => categoryId = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (val) => price = double.tryParse(val!),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(selectedDateTime == null
                    ? 'Pick Event Date & Time'
                    : selectedDateTime.toString()),
                onPressed: pickDateTime,
              ),
              const SizedBox(height: 16),
              _image == null
                  ? const Text('No image selected')
                  : Image.file(_image!, height: 150),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
                onPressed: pickImage,
              ),
              const SizedBox(height: 24),
              CustomButton(text: 'Submit Event', onPressed: submitEvent),
            ],
          ),
        ),
      ),
    );
  }
}
