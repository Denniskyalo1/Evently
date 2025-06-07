import 'package:flutter/material.dart';
import 'constants.dart';
import 'category_data.dart';
import 'event_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> categoryNames;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    final uniqueCategoryNames =
    categories.map((category) => category.name).toSet().toList();
    categoryNames = ['All Events', ...uniqueCategoryNames];
    selectedCategory = 'All Events';
  }

  List<Event> get filteredEvents {
    if (selectedCategory == 'All Events') {
      return categories.expand((category) => category.events).toList();
    } else {
      return categories
          .firstWhere((category) => category.name == selectedCategory)
          .events;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Column(
        children: [

          Container(
            height: height * 0.22,
            width: width,
            decoration: const BoxDecoration(
              color: AppColors.lightdarkBlue,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
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
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: height * 0.06,
                          width: height * 0.06,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/images/defaultpfp.png'),
                              fit: BoxFit.contain,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Location',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cash Light',
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Nairobi, KE',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Cash Light',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.menu_sharp,
                      size: 30,
                      color: Colors.white70,
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
                        border: Border.all(color: Colors.white70, width: 2),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(width: 10),
                          Icon(Icons.search, color: Colors.white70),
                          SizedBox(width: 10),
                          Text(
                            'Search event',
                            style: TextStyle(
                              fontFamily: 'Cash Light',
                              fontSize: 22,
                              color: Colors.white,
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
                        border: Border.all(color: Colors.white70, width: 2),
                      ),
                      child: const Icon(
                        Icons.calendar_month,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Horizontal category list
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.highlight
                                  : Colors.transparent,
                              border: Border.all(color: Colors.white70, width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontFamily: 'Cash Light',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Section title
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontFamily: 'Cash Light',
                        fontSize: 27,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Event list
                  Column(
                    children: filteredEvents
                        .map(
                          (event) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: EventCardWidget(
                          event: event,
                          height: height,
                          width: width,
                        ),
                      ),
                    )
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

//EventCardWidget

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
    return Container(
      height: height * 0.45,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + date
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        event.dateTime.day.toString(),
                        style: const TextStyle(
                          fontFamily: 'Cash Light',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        _monthString(event.dateTime.month),
                        style: const TextStyle(
                          fontFamily: 'Cash Light',
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Event title (1 line)
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              event.title.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Cash Light',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 5),

          // Location
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 5),
                Text(
                  event.location,
                  style: const TextStyle(
                    fontFamily: 'Cash Light',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // Price
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Text(
              event.price,
              style: const TextStyle(
                fontFamily: 'Cash Light',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Read more button
          Container(
            width: double.infinity,
            height: height * 0.05,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Read More',
                style: TextStyle(
                  fontFamily: 'Cash Light',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
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
