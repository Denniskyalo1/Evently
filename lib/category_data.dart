import 'event_model.dart';
import 'categories.dart';

final List<Category> categories = [
  Category(
    id: 'c1',
    name: 'Music',
    events: [
      Event(
        title: 'Jazz Night',
        description: 'Enjoy smooth jazz under the stars.',
        location: 'Nairobi Theatre',
        dateTime: DateTime(2025, 6, 15, 19, 30),
        imageUrl: 'assets/images/jazz_night.jpeg',
        price: '3,000'
      ),
      Event(
        title: 'Afrobeats Party',
        description: 'Dance to Afrobeat vibes all night.',
        location: 'The Alchemist',
        dateTime: DateTime(2025, 7, 1, 21, 00),
        imageUrl: 'assets/images/afrobeats.jpeg',
        price: '2,500'
      ),
    ],
  ),
  Category(
    id: 'c2',
    name: 'Tech',
    events: [
      Event(
        title: 'Flutter DevFest',
        description: 'All about Flutter and Dart.',
        location: 'iHub Nairobi',
        dateTime: DateTime(2025, 8, 5, 10, 00),
        imageUrl: 'assets/images/flutter_devfest.png',
        price: 'Free'
      ),
    ],
  ),
  Category(
      id: 'c3',
      name: 'Sports',
      events: [
        Event(
            title: 'Mizizi Padathon Charity Run',
            description: 'A marathon',
            location: 'Waterfront Mall, Karen',
            dateTime: DateTime(2025, 6, 28, 00),
            imageUrl: 'assets/images/marathon.jpeg',
            price: '500'
        ),
      ],
  ),
];