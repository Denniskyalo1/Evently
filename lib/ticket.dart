import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'event_model.dart';

class Ticket extends StatefulWidget {
  final Event event;
  final int numberOfTickets;
  final String status;

  const Ticket({
    super.key,
    required this.event,
    this.numberOfTickets = 1,
    this.status = 'Confirmed',
  });

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int price = int.tryParse(widget.event.price.replaceAll(RegExp(r'\D'), '')) ?? 0;
    final int total = price * widget.numberOfTickets;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 35),
          color: colorScheme.onSurface,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Confirmation',
          style: GoogleFonts.roboto(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        width: width * 0.9,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: colorScheme.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.event.fullImageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Event Title
            Text(
              widget.event.title,
              style: GoogleFonts.roboto(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),

            // Event Date
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEE, MMM d, yyyy').format(widget.event.dateTime),
                  style: GoogleFonts.roboto(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Venue
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.event.venue,
                    style: GoogleFonts.roboto(fontSize: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Divider(color: colorScheme.outline, thickness: 1),

            const SizedBox(height: 12),

            // Ticket Info
            ticketRow('Tickets', '${widget.numberOfTickets}'),
            const SizedBox(height: 6),
            ticketRow('Price per Ticket', 'KES $price'),
            const SizedBox(height: 6),
            ticketRow('Total Price', 'KES $total'),
            const SizedBox(height: 6),
            ticketRow('Status', widget.status),

            const SizedBox(height: 20),



            const SizedBox(height: 10),

            Center(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  children: [
                    const TextSpan(text: 'You can view your ticket(s) on '),
                    TextSpan(
                      text: 'your profile',
                      style: GoogleFonts.roboto(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/profile');
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ticketRow(String title, String value) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
