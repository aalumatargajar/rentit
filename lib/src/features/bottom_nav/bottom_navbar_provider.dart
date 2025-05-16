import 'package:flutter/material.dart';
import 'package:rentit/src/features/booking/booking_screen.dart';
import 'package:rentit/src/features/history/history_screen.dart';
import 'package:rentit/src/features/home/home_screen.dart';
import 'package:rentit/src/features/profile/profile_screen.dart';

class BottomNavbarProvider extends ChangeNotifier {
  int _currentIndex = 0;
  late TabController _tabController;
  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  final PageController _pageController = PageController();

  int get currentIndex => _currentIndex;
  TabController get tabController => _tabController;
  set tabController(TabController value) {
    _tabController = value;
    notifyListeners();
  }

  PageController get pageController => _pageController;
  List<Widget> get screens => _screens;

  void changeIndex({required int index}) {
    _currentIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }
}
