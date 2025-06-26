import 'package:flutter/material.dart';
import 'event_model.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyTicket extends StatefulWidget {
  final Event event;
  const BuyTicket({super.key, required this.event});

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(


    );
  }
}
