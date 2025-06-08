import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'category_data.dart';
import 'event_model.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkBlue,

      body: Stack(
        children: [
          Container(
            height: height * 0.6,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.event.imageUrl),
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
                  AppColors.darkBlue,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.4, 1],
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name container
            Container(
              child: Text(
                event.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  fontFamily: 'Cash Light',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 10),
            // Date, Location, and Price container
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Date:',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cash Light',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Location:',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cash Light',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Price:',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cash Light',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE').format(event.dateTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cash Light',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(event.dateTime),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cash Light',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.white70,
                      ),
                      Text(
                        event.venue,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cash Light',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.white70,
                      ),
                      Text(
                        event.price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cash Light',
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
            ),
            const SizedBox(height: 30),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontFamily: 'Cash Light',
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
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white70,
                              fontFamily: 'Cash Light',
                            ),
                            maxLines: isExpanded ? null : 3,
                            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (!isExpanded)
                            GestureDetector(
                              onTap: toggleExpand,
                              child: const Text(
                                'Read more',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.highlight,
                                  fontFamily: 'Cash Light',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (isExpanded)
                            GestureDetector(
                              onTap: toggleExpand,
                              child: const Text(
                                'Read less',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: AppColors.highlight,
                                  fontFamily: 'Cash Light',
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
            ),
            const SizedBox(height: 10),
            // Buy ticket Button
            CustomButton(
                text: 'Buy Ticket',
                onPressed:(){},
            ),
          ],
        ),
      ),
    );
  }
}