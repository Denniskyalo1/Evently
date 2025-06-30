
class Event{

  final String title;
  final String description;
  final String venue;
  final String city;
  final DateTime dateTime;
  final String imageUrl;
  final String price;
  final String categoryName;

  Event({
    required this.title,
    required this.description,
    required this.venue,
    required this.city,
    required this.dateTime,
    required this.imageUrl,
    required this.price,
    required this.categoryName,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      description: json['description'],
      venue: json['venue'],
      city: json['city'],
      dateTime: DateTime.parse(json['dateTime']),
      imageUrl: json['imageUrl'].toString(),
      price: json['price'].toString(),
      categoryName: json['category']
    );
  }
}


