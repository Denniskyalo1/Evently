import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'event_model.dart';

class Ticket extends StatefulWidget {
  final Event event;
  const Ticket({super.key, required this.event});

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final int price = int.tryParse(
        widget.event.price.replaceAll(RegExp(r'\D'), '')) ?? 0;
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
          'Buy Ticket',
          style: GoogleFonts.roboto(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        elevation: 10.0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),

    );
  }
}
