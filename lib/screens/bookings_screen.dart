import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_toggle.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_ui.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(lang.t('my_bookings')),
        actions: const [LanguageToggle()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textMuted,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: [
                    Tab(text: lang.t('upcoming')),
                    Tab(text: lang.t('past')),
                    Tab(text: lang.t('cancelled')),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildBookingList(context, lang, bookingProvider.upcomingBookings),
                      _buildBookingList(context, lang, bookingProvider.pastBookings),
                      _buildBookingList(context, lang, bookingProvider.cancelledBookings),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: AppColors.cardBg,
              child: TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: [
                  Tab(text: lang.t('upcoming')),
                  Tab(text: lang.t('past')),
                  Tab(text: lang.t('cancelled')),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBookingList(context, lang, bookingProvider.upcomingBookings),
                  _buildBookingList(context, lang, bookingProvider.pastBookings),
                  _buildBookingList(context, lang, bookingProvider.cancelledBookings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(
    BuildContext context,
    LanguageProvider lang,
    List<Booking> bookings,
  ) {
    if (bookings.isEmpty) {
      return EmptyState(
        icon: Icons.calendar_today_outlined,
        title: lang.isHindi ? 'कोई बुकिंग नहीं मिली' : 'No bookings found',
        subtitle: lang.isHindi ? 'आपकी अभी तक कोई बुकिंग नहीं है।' : 'You have no bookings at the moment.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final doctorName = lang.isHindi ? booking.doctorNameHi : booking.doctorNameEn;
        final specialty = lang.isHindi ? booking.specialtyHi : booking.specialtyEn;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person, color: AppColors.primary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  doctorName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              _buildStatusChip(context, lang, booking.status),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(specialty, style: const TextStyle(color: AppColors.textMedium, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),
                _buildInfoLine(Icons.person_outline, lang.t('patient_name'), booking.patientName),
                _buildInfoLine(Icons.schedule, lang.t('select_slot'), '${booking.date}, ${booking.time}'),
                _buildInfoLine(Icons.account_balance_wallet_outlined, lang.t('fee'), '₹${booking.fee.toStringAsFixed(0)}'),
                if (booking.status == 'upcoming') ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<BookingProvider>().cancelBooking(booking.id);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      child: Text(lang.t('cancel')),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(BuildContext context, LanguageProvider lang, String status) {
    Color color;
    Color bgColor;
    if (status == 'cancelled') {
      color = AppColors.error;
      bgColor = AppColors.error.withOpacity(0.1);
    } else if (status == 'upcoming') {
      color = AppColors.success;
      bgColor = AppColors.success.withOpacity(0.1);
    } else {
      color = AppColors.textMuted;
      bgColor = AppColors.lightBackground;
    }

    final label = lang.t(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildInfoLine(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.textMedium, fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
