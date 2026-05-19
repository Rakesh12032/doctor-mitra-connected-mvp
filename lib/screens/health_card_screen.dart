import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_toggle.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_ui.dart';

class HealthCardScreen extends StatelessWidget {
  const HealthCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(lang.t('health_card')),
        actions: const [Padding(padding: EdgeInsets.only(right: 8.0), child: LanguageToggle())],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDigitalCard(context),
              const SizedBox(height: 32),
              SectionHeader(title: lang.isHindi ? 'मेडिकल जानकारी' : 'Medical Information'),
              const SizedBox(height: 16),
              _buildInfoTile(
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.warning,
                title: lang.t('allergies'),
                subtitle: 'Dust, Penicillin',
              ),
              const SizedBox(height: 16),
              _buildInfoTile(
                icon: Icons.medication_outlined,
                iconColor: AppColors.primary,
                title: lang.t('medications'),
                subtitle: 'None currently',
              ),
              const SizedBox(height: 40),
              AppButton(
                text: lang.t('download_card'),
                icon: Icons.download_outlined,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDigitalCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 12)),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -20,
            top: -20,
            child: Icon(Icons.health_and_safety, size: 160, color: Colors.white.withOpacity(0.05)),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('DOCTOR MITRA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.verified_user, color: Colors.white, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Rajeev Kumar', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          const SizedBox(height: 8),
                          Text('ID: DM-HC-98765432', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, letterSpacing: 1.2, fontFamily: 'monospace')),
                        ],
                      ),
                    ),
                    // QR Code Placeholder
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.qr_code_2, size: 48, color: AppColors.textDark),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCardItem('BLOOD', 'O+'),
                      Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3)),
                      _buildCardItem('AGE', '32 Yrs'),
                      Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3)),
                      _buildCardItem('GENDER', 'Male'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildInfoTile({required IconData icon, required Color iconColor, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textMedium, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
