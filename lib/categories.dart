import 'package:flutter/material.dart';
import 'event_model.dart';

class Category{
  final String id;
  final String name;
  final List<Event> events;

  Category({
    required this.id,
    required this.name,
    required this.events,
});
}