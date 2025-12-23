import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/gym_details_screen.dart';
import 'screens/payment_screen.dart';
import 'components/bottom_navigation.dart';
import 'models/booking.dart';
import 'models/gym.dart';
import 'models/credit_package.dart';

enum Screen {
  login,
  home,
  gymDetails,
  wallet,
  payment,
  bookings,
  profile
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override

  
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _storage = const FlutterSecureStorage();

  Screen _currentScreen = Screen.home;
  bool _isLoggedIn = false;
  int _credits = 72;
  int _pendingCreditPurchase = 0;
  
  // Add this variable to track selected gym
  Gym? _selectedGym;
  
  final Color _accentColor = const Color(0xFF00ff88);
  
  List<Booking> _bookings = [
    Booking(
      id: '1',
      gym: 'PowerFit Studio',
      location: 'Downtown',
      date: 'Dec 8, 2025',
      time: '06:00 AM',
      status: 'upcoming',
    ),
    Booking(
      id: '2',
      gym: 'Zenith Yoga',
      location: 'Westside',
      date: 'Dec 5, 2025',
      time: '08:00 AM',
      status: 'completed',
    ),
    Booking(
      id: '3',
      gym: 'Strike Boxing',
      location: 'Eastside',
      date: 'Dec 3, 2025',
      time: '06:00 PM',
      status: 'completed',
    ),
  ];

  List<Gym> _allGyms = [
    Gym(
      id: '1',
      name: 'Iron Temple',
      location: 'North District',
      rating: 4.5,
      credits: 12,
      categories: ['Bodybuilding', 'Powerfitting'],
      imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80',
    ),
    Gym(
      id: '2',
      name: 'Movement Lab',
      location: 'South Bay',
      rating: 4.6,
      credits: 20,
      categories: ['Functional', 'Mobility'],
      imageUrl: 'https://images.unsplash.com/photo-1576678927484-cc907957088c?w=800&q=80',
    ),
    Gym(
      id: '3',
      name: 'Pulse Fitness',
      location: 'Harbor View',
      rating: 4.8,
      credits: 16,
      categories: ['Cycling', 'Running'],
      imageUrl: 'https://images.unsplash.com/photo-1517344884509-a0c97ec11bcc?w=800&q=80',
    ),
    Gym(
      id: '4',
      name: 'PowerFit Studio',
      location: 'Downtown',
      rating: 4.7,
      credits: 15,
      categories: ['Strength', 'Cardio'],
      imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80',
    ),
    Gym(
      id: '5',
      name: 'Zenith Yoga',
      location: 'Westside',
      rating: 4.9,
      credits: 12,
      categories: ['Yoga', 'Meditation'],
      imageUrl: 'https://images.unsplash.com/photo-1594381898411-846e7d193883?w=800&q=80',
    ),
    Gym(
      id: '6',
      name: 'Strike Boxing',
      location: 'Eastside',
      rating: 4.4,
      credits: 18,
      categories: ['Boxing', 'MMA'],
      imageUrl: 'https://images.unsplash.com/photo-1549060279-7e168fce7090?w=800&q=80',
    ),
  ];

  // Simple version if you don't have all those fields in your CreditPackage model
final List<CreditPackage> _creditPackages = [
  CreditPackage(
    id: '1',
    credits: 100,
    price: 100,          // no discount
    discountPercent: 0,
  ),
  CreditPackage(
    id: '2',
    credits: 500,
    price: 487.5,        // 2.5% discount
    discountPercent: 2.5,
    isPopular: true,
  ),
  CreditPackage(
    id: '3',
    credits: 1000,
    price: 950,          // 5% discount
    discountPercent: 5,
  ),
];


  void _handleLogin() {
    setState(() {
      _isLoggedIn = true;
      _currentScreen = Screen.home;
    });
  }

  void _handleNavigate(Screen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  // Update this method to accept Gym parameter
  void _handleNavigateToGym(String gymId) {
    final gym = _allGyms.firstWhere((g) => g.id == gymId);
    setState(() {
      _selectedGym = gym;  // Store the selected gym
      _currentScreen = Screen.gymDetails;
    });
  }

  void _handleBuyCredits(CreditPackage package) {
    setState(() {
      _pendingCreditPurchase = package.credits;
      _currentScreen = Screen.payment;
    });
  }

  void _handlePaymentComplete() {
    setState(() {
      _credits += _pendingCreditPurchase;
      _pendingCreditPurchase = 0;
      _currentScreen = Screen.wallet;
    });
  }

  void _handleBookSlot(String period, String date, String slot) {
    if (_selectedGym == null) return;
    
    final newBooking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gym: _selectedGym!.name,
      location: _selectedGym!.location,
      date: _formatDate(date),
      time: slot,
      status: 'upcoming',
    );

    setState(() {
      _bookings = [newBooking, ..._bookings];
      _credits -= _selectedGym!.credits;
      _currentScreen = Screen.bookings;
    });
  }

  String _formatDate(String date) {
    // If date is in ISO format, convert it
    try {
      final dateTime = DateTime.parse(date);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    } catch (e) {
      return date; // Return as is if not parseable
    }
  }

  void _handleCancelBooking(String id) {
    setState(() {
      _bookings = _bookings.map((booking) {
        if (booking.id == id) {
          return Booking(
            id: booking.id,
            gym: booking.gym,
            location: booking.location,
            date: booking.date,
            time: booking.time,
            status: 'cancelled',
          );
        }
        return booking;
      }).toList();
    });
  }

  void _handleBack() {
    setState(() {
      _currentScreen = Screen.home;
      _selectedGym = null; // Clear selected gym when going back
    });
  }

  Widget _buildScreenContent() {
    switch (_currentScreen) {
      case Screen.home:
        return HomeScreen(
          onNavigateToGym: _handleNavigateToGym,
          credits: _credits,
          recentBookings: _bookings.where((b) => b.status == 'completed').take(2).toList(),
          allGyms: _allGyms,
          accentColor: _accentColor,
        );
      case Screen.gymDetails:
        // Check if we have a selected gym
        if (_selectedGym == null) {
          // If no gym selected, go back to home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _handleBack();
          });
          return Container(); // Return empty container while redirecting
        }
        
        return GymDetailsScreen(
          gym: _selectedGym!, // Use the selected gym
          onBack: _handleBack,
          onBookSlot: _handleBookSlot,
          accentColor: _accentColor,
        );
      case Screen.wallet:
        return WalletScreen(
          onBack: _handleBack,
          walletBalance: _credits,
          onBuyCredits: _handleBuyCredits,
          creditPackages: _creditPackages,
          accentColor: _accentColor,
        );
      case Screen.payment:
        return PaymentScreen(
          onBack: _handleBack,
          onPaymentComplete: _handlePaymentComplete,
          amount: _pendingCreditPurchase,
          accentColor: _accentColor,
        );
      case Screen.bookings:
        return BookingsScreen(
          bookings: _bookings,
          onCancelBooking: _handleCancelBooking,
          accentColor: _accentColor,
        );
      case Screen.profile:
        return ProfileScreen(accentColor: _accentColor);
      case Screen.login:
        return LoginScreen(onLogin: _handleLogin, accentColor: _accentColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn && _currentScreen == Screen.login) {
      return LoginScreen(onLogin: _handleLogin, accentColor: _accentColor);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Expanded(
                child: _buildScreenContent(),
              ),
              if (_isLoggedIn && _currentScreen != Screen.login)
                BottomNavigation(
                  activeScreen: _currentScreen,
                  onNavigate: _handleNavigate,
                  accentColor: _accentColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}