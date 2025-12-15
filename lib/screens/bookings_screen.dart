import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingsScreen extends StatelessWidget {
  final List<Booking> bookings;
  final Function(String) onCancelBooking;
  final Color accentColor;

  const BookingsScreen({
    super.key,
    required this.bookings,
    required this.onCancelBooking,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'My Bookings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return _buildBookingCard(booking);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(Booking booking) {
    Color statusColor = accentColor;
    String statusText = booking.status;
    
    if (booking.status == 'completed') {
      statusColor = Colors.green;
    } else if (booking.status == 'cancelled') {
      statusColor = Colors.red;
    } else if (booking.status == 'upcoming') {
      statusText = 'Upcoming';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.gym,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.location,
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, color: accentColor, size: 16),
              const SizedBox(width: 8),
              Text(
                booking.date,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 20),
              Icon(Icons.access_time, color: accentColor, size: 16),
              const SizedBox(width: 8),
              Text(
                booking.time,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          if (booking.status == 'upcoming')
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => onCancelBooking(booking.id),
                child: Text(
                  'Cancel Booking',
                  style: TextStyle(color: accentColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}