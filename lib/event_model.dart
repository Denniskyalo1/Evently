import 'package:flutter/material.dart';

class Event{

  final String title;
  final String description;
  final String location;
  final DateTime dateTime;
  final String imageUrl;
  final String price;

  Event({
    required this.title,
    required this.description,
    required this.location,
    required this.dateTime,
    required this.imageUrl,
    required this.price,
  });
}


