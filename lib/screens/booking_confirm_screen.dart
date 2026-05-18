import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/booking_model.dart';
import '../models/doctor_model.dart';
import '../providers/language_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_ui.dart';

class BookingConfirmScreen extends StatelessWidget {
  final Booking booking;
  final Doctor doctor;

  const BookingConfirmScreen({
    super.key,
    required this.booking,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final doctorName = lang.isHindi ? doctor.nameHi : doctor.nameEn;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: AppColors.success, size: 64),
                ),
                const SizedBox(height: 24),
                Text(
                  lang.t('booking_confirmed'),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  lang.t('booking_saved'),
                  style: const TextStyle(fontSize: 15, color: AppColors.textMedium),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(lang.t('booking_id'), booking.id.substring(0, 8).toUpperCase()),
                      const Divider(color: AppColors.border, height: 24),
                      _buildDetailRow(lang.t('patient_name'), booking.patientName),
                      const Divider(color: AppColors.border, height: 24),
                      _buildDetailRow(lang.t('doctors'), doctorName),
                      const Divider(color: AppColors.border, height: 24),
                      _buildDetailRow(lang.t('select_slot'), '${booking.date}, ${booking.time}'),
                      const Divider(color: AppColors.border, height: 24),
                      _buildDetailRow(lang.t('fee'), '₹${booking.fee.toStringAsFixed(0)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: lang.t('share_whatsapp'),
                  icon: Icons.share,
                  isPrimary: false,
                  onPressed: () => _shareBooking(lang, doctorName),
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: lang.t('go_home'),
                  isPrimary: true,
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Future<void> _shareBooking(LanguageProvider lang, String doctorName) async {
    final message = '''
${lang.t('booking_confirmed')}
${lang.t('booking_id')}: ${booking.id.substring(0, 8).toUpperCase()}
${lang.t('patient_name')}: ${booking.patientName}
${lang.t('doctors')}: $doctorName
${lang.t('select_slot')}: ${booking.date}, ${booking.time}
${lang.t('fee')}: ₹${booking.fee.toStringAsFixed(0)}
''';

    final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(message)}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch WhatsApp');
    }
  }
}
