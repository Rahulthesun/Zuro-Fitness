import 'package:flutter/material.dart';
import '../models/gym.dart';

enum BookingPeriod { session, daily, weekly, monthly }

class GymDetailsScreen extends StatefulWidget {
  final Gym gym;
  final VoidCallback onBack;
  final Function(String, String, String) onBookSlot;
  final Color accentColor;

  const GymDetailsScreen({
    super.key,
    required this.gym,
    required this.onBack,
    required this.onBookSlot,
    required this.accentColor,
  });

  @override
  State<GymDetailsScreen> createState() => _GymDetailsScreenState();
}

class _GymDetailsScreenState extends State<GymDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  BookingPeriod _selectedPeriod = BookingPeriod.session;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  bool _showAllSlots = false;

  final List<String> _timeSlots = [
    '06:00 AM',
    '07:00 AM',
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
    '08:00 PM',
    '09:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _getPriceForPeriod() {
    final basePrice = widget.gym.credits * 10;
    switch (_selectedPeriod) {
      case BookingPeriod.session:
        return basePrice;
      case BookingPeriod.daily:
        return (basePrice * 2.5).round();
      case BookingPeriod.weekly:
        return (basePrice * 15).round();
      case BookingPeriod.monthly:
        return (basePrice * 50).round();
    }
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case BookingPeriod.session:
        return 'per session';
      case BookingPeriod.daily:
        return 'per day';
      case BookingPeriod.weekly:
        return 'per week';
      case BookingPeriod.monthly:
        return 'per month';
    }
  }

  int _getCreditsForPeriod() {
    switch (_selectedPeriod) {
      case BookingPeriod.session:
        return widget.gym.credits;
      case BookingPeriod.daily:
        return (widget.gym.credits * 2.5).round();
      case BookingPeriod.weekly:
        return (widget.gym.credits * 15).round();
      case BookingPeriod.monthly:
        return (widget.gym.credits * 50).round();
    }
  }

  String _getSavingsText() {
    switch (_selectedPeriod) {
      case BookingPeriod.daily:
        return 'Save 17% vs sessions';
      case BookingPeriod.weekly:
        return 'Save 29% vs sessions';
      case BookingPeriod.monthly:
        return 'Save 40% vs sessions';
      default:
        return '';
    }
  }

  bool _isSlotAvailable(String slot) {
    // Simulate availability - some slots are full
    final unavailableSlots = ['09:00 AM', '06:00 PM', '07:00 PM'];
    return !unavailableSlots.contains(slot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.grey[900],
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: widget.onBack,
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, color: Colors.white),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.gym.imageUrl.isNotEmpty
                        ? widget.gym.imageUrl
                        : 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: _getGymColor(),
                        child: Center(
                          child: Icon(
                            _getGymIcon(),
                            color: Colors.white.withOpacity(0.8),
                            size: 64,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.gym.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: widget.accentColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.gym.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey[300],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.gym.location,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _animationController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Categories
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.gym.categories
                          .map((category) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.accentColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: widget.accentColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: widget.accentColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Period Selection
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Plan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildPeriodCard(
                                BookingPeriod.session,
                                'Single Session',
                                'Perfect for trying out',
                              ),
                              const SizedBox(width: 12),
                              _buildPeriodCard(
                                BookingPeriod.daily,
                                'Daily Pass',
                                'Unlimited sessions today',
                              ),
                              const SizedBox(width: 12),
                              _buildPeriodCard(
                                BookingPeriod.weekly,
                                'Weekly Pass',
                                '7 days unlimited access',
                              ),
                              const SizedBox(width: 12),
                              _buildPeriodCard(
                                BookingPeriod.monthly,
                                'Monthly Pass',
                                '30 days unlimited access',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Date Selection (only for session bookings)
                  if (_selectedPeriod == BookingPeriod.session) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Date',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 14,
                              itemBuilder: (context, index) {
                                final date = DateTime.now().add(Duration(days: index));
                                return _buildDateCard(date);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Time Slot Selection
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Select Time',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: widget.accentColor,
                                      size: 8,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.circle,
                                      color: Colors.grey[600],
                                      size: 8,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Full',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2,
                            ),
                            itemCount:
                                _showAllSlots ? _timeSlots.length : 8,
                            itemBuilder: (context, index) {
                              return _buildTimeSlot(_timeSlots[index]);
                            },
                          ),
                          if (!_showAllSlots && _timeSlots.length > 8) ...[
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _showAllSlots = true;
                                  });
                                },
                                icon: Icon(
                                  Icons.expand_more,
                                  color: widget.accentColor,
                                ),
                                label: Text(
                                  'Show More Times',
                                  style: TextStyle(
                                    color: widget.accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Bar with Pricing
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹${_getPriceForPeriod()}',
                          style: TextStyle(
                            color: widget.accentColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getPeriodLabel(),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if (_getSavingsText().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getSavingsText(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _canBook() ? _handleBooking : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    disabledBackgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      color: _canBook() ? Colors.black : Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodCard(
      BookingPeriod period, String title, String description) {
    final isSelected = _selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
          _selectedTimeSlot = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.accentColor.withOpacity(0.15)
              : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? widget.accentColor
                : Colors.grey[800]!,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? widget.accentColor : Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '₹${_getPriceForPeriod()}',
              style: TextStyle(
                color: isSelected ? widget.accentColor : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (_getSavingsText().isNotEmpty && isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _getSavingsText(),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(DateTime date) {
    final isSelected = _selectedDate.year == date.year &&
        _selectedDate.month == date.month &&
        _selectedDate.day == date.day;
    final isToday = DateTime.now().day == date.day &&
        DateTime.now().month == date.month;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          _selectedTimeSlot = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.accentColor
              : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? widget.accentColor
                : Colors.grey[800]!,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getWeekday(date.weekday),
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isToday)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.2)
                      : widget.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Today',
                  style: TextStyle(
                    color: isSelected ? Colors.black : widget.accentColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    final isSelected = _selectedTimeSlot == time;
    final isAvailable = _isSlotAvailable(time);

    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                _selectedTimeSlot = time;
              });
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.accentColor
              : isAvailable
                  ? Colors.grey[900]
                  : Colors.grey[850],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? widget.accentColor
                : isAvailable
                    ? Colors.grey[800]!
                    : Colors.grey[800]!,
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              color: isSelected
                  ? Colors.black
                  : isAvailable
                      ? Colors.white
                      : Colors.grey[600],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';
      case 7:
        return 'SUN';
      default:
        return '';
    }
  }

  bool _canBook() {
    if (_selectedPeriod == BookingPeriod.session) {
      return _selectedTimeSlot != null;
    }
    return true;
  }

  void _handleBooking() {
    final periodStr = _selectedPeriod.toString().split('.').last;
    widget.onBookSlot(
      periodStr,
      _selectedDate.toIso8601String(),
      _selectedTimeSlot ?? '',
    );
  }

  IconData _getGymIcon() {
    final name = widget.gym.name.toLowerCase();
    if (name.contains('yoga')) {
      return Icons.self_improvement;
    } else if (name.contains('boxing') || name.contains('strike')) {
      return Icons.sports_mma;
    } else if (name.contains('temple') || name.contains('iron')) {
      return Icons.fitness_center;
    } else if (name.contains('lab') || name.contains('movement')) {
      return Icons.directions_run;
    } else if (name.contains('pulse') || name.contains('fitness')) {
      return Icons.sports_gymnastics;
    }
    return Icons.fitness_center;
  }

  Color _getGymColor() {
    final name = widget.gym.name.toLowerCase();
    if (name.contains('yoga')) {
      return Colors.deepPurple;
    } else if (name.contains('boxing') || name.contains('strike')) {
      return Colors.red;
    } else if (name.contains('temple') || name.contains('iron')) {
      return Colors.amber;
    } else if (name.contains('lab') || name.contains('movement')) {
      return Colors.blue;
    } else if (name.contains('pulse') || name.contains('fitness')) {
      return Colors.green;
    }
    return Colors.deepOrange;
  }
}