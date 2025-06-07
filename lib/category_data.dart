import 'event_model.dart';
import 'categories.dart';

final List<Category> categories = [
  Category(
    id: 'c1',
    name: 'Music',
    events: [
      Event(
        title: 'Jazz Night',
        description: "Late Night Jazz offers a tranquil retreat into the velvety embrace of poignant tunes, creating an intimate musical experience that resonates with the peace of the night. This genre flourishes in the quietude, presenting a tapestry woven with calm instrumental compositions and a few dreamy vocal tracks. The channel curates a refined ambiance with its carefully selected repertoire, inviting listeners to unwind and indulge in the seductive allure of slow jazz. Whether you're winding down after a long day or seeking a soothing backdrop for contemplation, Late Night Jazz beckons with its immortal melodies, capturing the essence of nocturnal serenity.",
        venue: 'Nairobi Theatre',
        city:'Nairobi',
        dateTime: DateTime(2025, 6, 15, 19, 30),
        imageUrl: 'assets/images/jazz_night.jpeg',
        price: '3,000'
      ),
      Event(
        title: 'Afrobeats Party',
        description: "Get ready for an electrifying night as we bring you the ultimate Afrobeat experience! From the heart of Africa to the streets of Nairobi, this is where culture, rhythm, and pure energy collide.",
        venue: 'The Alchemist',
        city: 'Nairobi',
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
        city: 'Nairobi',
        venue: 'iHub Nairobi',
        dateTime: DateTime(2025, 8, 5, 10, 00),
        imageUrl: 'assets/images/flutter_devfest.jpeg',
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
            description: "Join thousands of runners from across the globe for the Nairobi Freedom Marathon 2025 — a celebration of endurance, unity, and the unstoppable human spirit.",
            venue: 'Waterfront Mall, Karen',
            city: 'Nairobi',
            dateTime: DateTime(2025, 6, 28, 00),
            imageUrl: 'assets/images/marathon.jpeg',
            price: '500'
        ),
      ],
  ),
];