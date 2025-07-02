import 'package:event_management/ticket.dart';
import 'package:flutter/material.dart';
import 'event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BuyTicket extends StatefulWidget {
  final Event event;
  const BuyTicket({super.key, required this.event});

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}
enum PaymentMethod { mpesa, card }

class _BuyTicketState extends State<BuyTicket> {
  Future<void> initiateMpesaPayment(
      String phone,
      int amount,
      ) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'authToken');

    if (token == null) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Authentication Error'),
          content: Text('No authentication token found. Please log in again.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    if (widget.event.price.toLowerCase() == 'free') {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Free Event'),
          content: Text('This event is free! No payment is required.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Ticket(
                      event: widget.event,
                      numberOfTickets: ticketCount,
                      status: 'Confirmed',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
      return;
    }

    String formattedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '254${formattedPhone.substring(1)}';
    } else if (formattedPhone.startsWith('+254')) {
      formattedPhone = formattedPhone.replaceFirst('+254', '254');
    } else if (!formattedPhone.startsWith('254')) {
      formattedPhone = '254$formattedPhone';
    }

    if (!RegExp(r'^2547\d{8}$').hasMatch(formattedPhone)) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Invalid Phone Number'),
          content: Text('Please enter a valid phone number (e.g., +254712345678 or 0712345678)'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final url = Uri.parse('$baseUrl/api/mpesa/stkpush');



    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'phone': formattedPhone,
        'amount': amount,
        'event_id': widget.event.id,
        'ticket_quantity': ticketCount
      }),
    );


    if (response.statusCode == 200) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Payment Initiated'),
          content: Text('Your payment is being processed, please await confirmation'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Ticket(
                      event: widget.event,
                      numberOfTickets: ticketCount,
                      status: 'Confirmed',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
      return;
    } else {
      final error = jsonDecode(response.body);
      debugPrint('Payment error: $error');
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Payment Failed'),
          content: Text('Your payment failed, please try again'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }
  }


  int ticketCount = 0;
  PaymentMethod? _selectedMethod;
  final TextEditingController _mpesaPhoneController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    int pricePerTicket;
    if (widget.event.price.toLowerCase() == 'free') {
      pricePerTicket = 0;
    } else {
      pricePerTicket = int.tryParse(widget.event.price.replaceAll(RegExp(r'\D'), '')) ?? 0;
    }


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            Container(
              height: height * 0.3,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget.event.fullImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Event Title
            Text(
              widget.event.title,
              style: GoogleFonts.roboto(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),

            const SizedBox(height: 10),

            // Event Location and Date
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 20,
                    color: colorScheme.onSurface),
                const SizedBox(width: 10),
                Text(
                  widget.event.venue,
                  style: GoogleFonts.roboto(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.calendar_month, size: 20,
                    color: colorScheme.onSurface),
                const SizedBox(width: 10),
                Text(
                  DateFormat('EEEE, dd MMM yyyy').format(
                      widget.event.dateTime),
                  style: GoogleFonts.roboto(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Divider(color: colorScheme.onSurface),

            const SizedBox(height: 10),

            // Ticket instructions
            Text(
              'Get your tickets to ${widget.event.title}',
              style: GoogleFonts.roboto(
                color: colorScheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kindly indicate how many tickets you would like',
              style: GoogleFonts.roboto(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),

            const SizedBox(height: 20),

            // Ticket Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Advance tickets',
                  style: GoogleFonts.roboto(
                    color: colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Column(
                  children: [
                    Text('Ksh',
                        style: GoogleFonts.roboto(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                        )),
                    Text(widget.event.price,
                        style: GoogleFonts.roboto(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                        )),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (ticketCount > 0) {
                          setState(() {
                            ticketCount--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                      color: colorScheme.onSurface,
                    ),
                    Text(
                      '$ticketCount',
                      style: GoogleFonts.roboto(
                        color: colorScheme.onSurface,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          ticketCount++;
                        });
                      },
                      icon: const Icon(Icons.add),
                      color: colorScheme.onSurface,
                    ),
                  ],
                )
              ],
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                );
              },
              child: ticketCount > 0
                  ? Container(
                key: const ValueKey('summary'),
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Summary',
                          style: GoogleFonts.roboto(
                            color: colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              ticketCount = 0;
                            });
                          },
                          icon: const Icon(Icons.delete),
                          color: colorScheme.onSurface,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$ticketCount ticket(s)',
                          style: GoogleFonts.roboto(
                            color: colorScheme.onSurface,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Total: Ksh ${pricePerTicket * ticketCount}',
                          style: GoogleFonts.roboto(
                            color: colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),

            const SizedBox(height: 20),
            Divider(color: colorScheme.onSurface),

            const SizedBox(height: 10),

            Text(
              'Please choose a payment option',
              style: GoogleFonts.roboto(
                color: colorScheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                ChoiceChip(
                  label: Text("M-PESA"),
                  selected: _selectedMethod == PaymentMethod.mpesa,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _selectedMethod = PaymentMethod.mpesa;
                      });
                    } else {
                      setState(() {
                        _selectedMethod = null;
                      });
                    }
                  },
                  selectedColor: isDark ? Colors.white : Colors.black,
                  backgroundColor: isDark ? Colors.black : Colors.white,
                  labelStyle: TextStyle(
                    color: _selectedMethod == PaymentMethod.mpesa
                        ? (isDark ? Colors.black : Colors.white)
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 30),
                ChoiceChip(
                  label: Text("Credit/Debit Card"),
                  selected: _selectedMethod == PaymentMethod.card,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _selectedMethod = PaymentMethod.card;
                      });
                    } else {
                      setState(() {
                        _selectedMethod = null;
                      });
                    }
                  },
                  selectedColor: isDark ? Colors.white : Colors.black,
                  backgroundColor: isDark ? Colors.black : Colors.white,
                  labelStyle: TextStyle(
                    color: _selectedMethod == PaymentMethod.card
                        ? (isDark ? Colors.black : Colors.white)
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) =>
                  SizeTransition(
                    sizeFactor: animation,
                    axisAlignment: -1,
                    child: child,
                  ),
              child: _selectedMethod == PaymentMethod.mpesa
                  ? _buildMpesaForm()
                  : _selectedMethod == PaymentMethod.card
                  ? _buildCardForm()
                  : const SizedBox.shrink(),
            ),
            SizedBox(height: 30,)
          ],

        ),

      ),
    );
  }
  Widget _buildMpesaForm() {
    return Container(
      key: const ValueKey('mpesa_form'),
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme
            .of(context)
            .colorScheme
            .outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'M-PESA Payment',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _mpesaPhoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixText: '+254 ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            text: 'Buy Ticket with M-PESA',
            onPressed: () async {
              final phone = _mpesaPhoneController.text.trim();
              int pricePerTicket = int.tryParse(widget.event.price.replaceAll(RegExp(r'\D'), '')) ?? 0;
              int amount = pricePerTicket * ticketCount;
              if (phone.isEmpty) {
                if (!mounted) return;
                showDialog(
                  context: context,
                  builder: (_) =>
                      AlertDialog(
                        content: Text('Please input your phone number'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                );
                return;
              }

              try {
                await initiateMpesaPayment(phone, amount
                );
              } catch (e) {
                if (!mounted) return;
                showDialog(
                  context: context,
                  builder: (_) =>
                      AlertDialog(
                        title: Text('Payment Failed'),
                        content: Text('Error initiating payment $e'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                );
              }
            },
          )

        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      key: const ValueKey('card_form'),
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme
            .of(context)
            .colorScheme
            .outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Payment',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _cardHolderController,
            decoration: const InputDecoration(
              labelText: 'Card Holder Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryDateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date (MM/YY)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomButton(
            text: 'Buy Ticket with Card',
            onPressed: () {

            },
          ),
        ],
      ),
    );
  }

}

