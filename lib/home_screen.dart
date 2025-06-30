import 'dart:convert';
import 'package:event_management/selected_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'authservice.dart';
import 'event_model.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key,required this.toggleTheme} );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> allEvents = [];
  List<String> categoryNames = [];
  String selectedCategory = 'All Events';
  bool isLoading = true;
  String? userName;

  @override
  void initState() {
    super.initState();
    fetchEvents();
    loadUser();
  }

  Future<void> loadUser() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'authToken');

    if (token == null) return;

    final user = await AuthService.getUser();
    setState(() {
      userName = user?['username'] ?? '';
    });
  }

  Future<void> fetchEvents() async {
    final response = await http.get(Uri.parse('https://https://56f5-102-68-79-99.ngrok-free.app/api/events'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      allEvents = jsonData.map((e) => Event.fromJson(e)).toList();

      final categoriesSet = <String>{};
      for (var event in allEvents) {
        categoriesSet.add(event.categoryName);
      }
      setState(() {
        categoryNames = ['All Events', ...categoriesSet];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Event> get filteredEvents {
    if (selectedCategory == 'All Events') {
      return allEvents;
    } else {
      return allEvents.where((e) => e.categoryName == selectedCategory).toList();
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = theme.textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            height: height * 0.225,
            width: width,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
              border: Border.all(
                 color: colorScheme.outline,
              )
            ),
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: height * 0.06,
                            width: height * 0.06,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/images/defaultpfp.png'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: GoogleFonts.roboto().copyWith(
                                color: colorScheme.onSurface,
                                fontWeight:FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              userName ?? '',
                              style:GoogleFonts.roboto().copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    PopupMenuButton(
                      iconColor: colorScheme.onSurface,
                      iconSize: 30,
                      onSelected: (value) async {
                        if (value == 'theme') {
                          widget.toggleTheme();
                        } else if (value == 'logout') {
                          showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();

            final storage = FlutterSecureStorage();
            await storage.delete(key: 'authToken');

            if (!context.mounted) return;

            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
          child: const Text('Logout'),
        ),
      ],
    ),
  );
                        } else if (value == 'profile') {
                          //go to profile
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'profile',
                          child: Row(
                            children: const [
                              Icon(Icons.person),
                              SizedBox(width: 10),
                              Text('Profile'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'theme',
                          child: Row(
                            children: const [
                              Icon(Icons.brightness_4_outlined),
                              SizedBox(width: 10),
                              Text('Theme'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: const [
                              Icon(Icons.logout_outlined),
                              SizedBox(width: 10),
                              Text('Logout'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: height * 0.05,
                      width: width * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorScheme.onSurface,),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: colorScheme.onSurface),
                          const SizedBox(width: 10),
                          Text(
                            'Search event',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.05,
                      width: height * 0.05,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorScheme.onSurface),
                      ),
                      child: Icon(Icons.calendar_month, color: colorScheme.onSurface),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: height * 0.05,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 25),
                      itemCount: categoryNames.length,
                      itemBuilder: (context, index) {
                        final name = categoryNames[index];
                        final isSelected = name == selectedCategory;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = name;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            width:width * 0.27,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? Colors.white : Colors.black)
                                  : (isDark ? colorScheme.surface : Colors.white),
                              border: Border.all(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              name,
                              style: GoogleFonts.roboto().copyWith(
                                color: isSelected
                                    ? (isDark ? Colors.black : Colors.white)
                                    : (isDark ? Colors.white : Colors.black),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Upcoming Events',
                      style: GoogleFonts.roboto().copyWith(
                        color: colorScheme.onSurface,
                        fontSize: 35,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Column(
                    children: filteredEvents
                        .map((event) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: EventCardWidget(
                        event: event,
                        height: height,
                        width: width,
                      ),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// EventCardWidget
class EventCardWidget extends StatelessWidget {
  final Event event;
  final double height;
  final double width;

  const EventCardWidget({
    super.key,
    required this.event,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;


    return Container(
      height: height * 0.45,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outline,
          width: 2,
        ),
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: height * 0.45 * 0.55,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(event.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        event.dateTime.day.toString(),
                        style: GoogleFonts.roboto().copyWith(
                            color:Colors.black,
                            fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        _monthString(event.dateTime.month),
                        style: GoogleFonts.roboto().copyWith(
                          color:Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            event.title.toUpperCase(),
            style: GoogleFonts.roboto().copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 30
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: 6),
              Text(
                event.venue,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            event.price,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectedEvent(event: event)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Read More'),
            ),
          ),
        ],
      ),
    );
  }

  String _monthString(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
