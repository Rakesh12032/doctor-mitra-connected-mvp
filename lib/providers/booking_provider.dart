import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  static const String _storageKey = 'doctor_mitra_bookings';

  final List<Booking> _bookings = [];
  bool _isLoaded = false;

  BookingProvider() {
    loadBookings();
  }

  List<Booking> get bookings => List.unmodifiable(_bookings);
  bool get isLoaded => _isLoaded;

  List<Booking> get upcomingBookings =>
      _bookings.where((booking) => booking.status == 'upcoming').toList();

  List<Booking> get pastBookings =>
      _bookings.where((booking) => booking.status == 'past').toList();

  List<Booking> get cancelledBookings =>
      _bookings.where((booking) => booking.status == 'cancelled').toList();

  Future<void> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final rawBookings = prefs.getStringList(_storageKey) ?? [];

    _bookings
      ..clear()
      ..addAll(
        rawBookings.map((rawBooking) {
          final decoded = jsonDecode(rawBooking) as Map<String, dynamic>;
          return Booking.fromJson(decoded);
        }),
      );

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> addBooking(Booking booking) async {
    _bookings.insert(0, booking);
    await _saveBookings();
    notifyListeners();
  }

  Future<void> cancelBooking(String bookingId) async {
    final index = _bookings.indexWhere((booking) => booking.id == bookingId);
    if (index == -1) return;

    _bookings[index] = _bookings[index].copyWith(status: 'cancelled');
    await _saveBookings();
    notifyListeners();
  }

  Future<void> _saveBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final rawBookings = _bookings
        .map((booking) => jsonEncode(booking.toJson()))
        .toList(growable: false);
    await prefs.setStringList(_storageKey, rawBookings);
  }
}
