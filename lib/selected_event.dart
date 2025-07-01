import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'buyticket.dart';

class SelectedEvent extends StatefulWidget {
  final Event event;
  const SelectedEvent({super.key, required this.event});

  @override
  State<SelectedEvent> createState() => _SelectedEventState();
}

class _SelectedEventState extends State<SelectedEvent> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Container(
            height: height * 0.6,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.event.fullImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.surface,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.4, 1],
              ),
            ),
          ),
          const TopBar(),
          Positioned(
            top: height * 0.45,
            left: 0,
            right: 0,
            bottom: 0,
            child: EventDetailsWidget(
              event: widget.event,
              isExpanded: _isExpanded,
              toggleExpand: _toggleExpand,
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailsWidget extends StatelessWidget {
  final Event event;
  final bool isExpanded;
  final VoidCallback toggleExpand;

  const EventDetailsWidget({
    super.key,
    required this.event,
    required this.isExpanded,
    required this.toggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: GoogleFonts.roboto(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date:',
                        style: GoogleFonts.roboto(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Location:',
                        style: GoogleFonts.roboto(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('Price:',
                        style: GoogleFonts.roboto(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE').format(event.dateTime),
                          style: GoogleFonts.roboto(
                            color: colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(event.dateTime),
                          style: GoogleFonts.roboto(
                            color: colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin:EdgeInsets.only(left: 20, right: 10),
                      height: 50,
                      width: 1,
                      color: colorScheme.outline,
                    ),
                    Expanded(
                      child: Text(
                        event.venue,
                        style: GoogleFonts.roboto(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin:EdgeInsets.only(left: 10, right: 20),
                      height: 50,
                      width: 1,
                      color: colorScheme.outline,
                    ),
                    Text(
                      event.price,
                      style: GoogleFonts.roboto(
                        color: colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: GoogleFonts.roboto(
                    fontSize: 35,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 155,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.description,
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: isExpanded ? null : 3,
                          overflow: isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: toggleExpand,
                          child: Text(
                            isExpanded ? 'Read less' : 'Read more',
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            CustomButton(
              text: 'Buy Ticket',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyTicket(event: event),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
