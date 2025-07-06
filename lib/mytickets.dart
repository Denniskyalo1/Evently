import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:event_management/authservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'package:open_file/open_file.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  late Future<List<Map<String, String>>> futureTickets;

  @override
  void initState() {
    super.initState();
    futureTickets = fetchUserTickets();
  }

  Future<List<Map<String, String>>> fetchUserTickets() async {
    final token = await AuthService.getToken();
    if (token == null) throw Exception('No auth token found');

    final url = Uri.parse('$baseUrl/api/myTickets');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map<Map<String, String>>((ticket) {
        return {
          'user_name': ticket['user_name'],
          'event_name': ticket['event_name'],
          'event_image': ticket['event_image'],
          'date': ticket['date'],
          'venue': ticket['venue'],
          'city': ticket['city'],
          'qr_code': ticket['qr_code'],
        };
      }).toList();
    } else if (response.statusCode == 401) {
      await AuthService.logout();
      if (!mounted) return[];
      Navigator.pushReplacementNamed(context, '/login');
      return [];
    } else {
      throw Exception('Failed to load tickets (${response.statusCode})');
    }
  }

  Future<void> saveTicketAsPDF(GlobalKey repaintKey, String fileName) async {
    try {
      String safeFileName = fileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      // Capture the widget as image
      await Future.delayed(const Duration(milliseconds: 100));
      RenderRepaintBoundary boundary = repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Create PDF document
      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(child: pw.Image(pdfImage)),
        ),
      );

      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission is required to save PDF')),
        );
        return;
      }

      // Get directory to save
      final baseDir = await getExternalStorageDirectory();
      final downloadsDir = Directory('/storage/emulated/0/Download');
      final path = '${downloadsDir.path}/$safeFileName.pdf';
      final file = File(path);


      // Save PDF
      await file.writeAsBytes(await pdf.save());

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Ticket downloaded"),
          content: Text('Ticket was downloaded successfully'),
          actions: [
            TextButton(
              onPressed: () async {
              Navigator.of(context).pop();
              final result = await OpenFile.open(path);
              print('OpenFile result: ${result.message}');
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error saving PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save ticket as PDF')),
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
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'My Tickets',
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
      body: RefreshIndicator(
        onRefresh: () async {
          final tickets = await fetchUserTickets();
          if (!mounted) return;
          setState(() {
            futureTickets = Future.value(tickets);
          });
        },
        child: FutureBuilder<List<Map<String, String>>>(
          future: futureTickets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
        
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
        
            final tickets = snapshot.data ?? [];
        
            if (tickets.isEmpty) {
              return const Center(child: Text('You have no tickets.'));
            }
        
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return buildTicketCard(context, tickets[index], index);
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildTicketCard(BuildContext context, Map<String, String> ticket, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final String imageUrl = '$baseUrl/storage/${ticket['event_image']}';
    final GlobalKey repaintKey = GlobalKey();

    return RepaintBoundary(
      key: repaintKey,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 180,
                    child: Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
      
              // Event Name
              Text(
                ticket['event_name'] ?? '',
                style: GoogleFonts.roboto().copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 6),
      
              // Date
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 6),
                  Text(ticket['date'] ?? '',
                      style: GoogleFonts.roboto(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 4),
      
              // Venue and City
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text('${ticket['venue']}, ${ticket['city']}',
                      style: GoogleFonts.roboto(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 4),
      
              // User Name
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 18),
                  const SizedBox(width: 6),
                  Text(ticket['user_name'] ?? '',
                      style: GoogleFonts.roboto(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
      
              // QR Code
              Center(
                child: QrImageView(
                  data: ticket['qr_code'] ?? '',
                  version: QrVersions.auto,
                  size: 120,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
      
              Center(
                child: Text(
                  ticket['qr_code'] ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),

              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_download_outlined),
                  label: const Text('Download as PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    foregroundColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,

                  ),
                  onPressed: () => saveTicketAsPDF(repaintKey, ticket['event_name'] ?? 'ticket'),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
