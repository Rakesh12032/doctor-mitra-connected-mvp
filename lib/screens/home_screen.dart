import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/language_toggle.dart';
import '../widgets/whatsapp_fab.dart';
import '../widgets/doctor_card.dart';
import '../widgets/specialty_chip.dart';
import '../widgets/custom_ui.dart';
import '../data/doctors_data.dart';
import 'doctors_screen.dart';
import 'teleconsult_screen.dart';
import 'health_card_screen.dart';
import 'hospitals_screen.dart';
import 'ambulance_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, lang),
              const SizedBox(height: 16),
              _buildSearchBanner(context, lang),
              const SizedBox(height: 24),
              _buildStatsRow(context, lang),
              const SizedBox(height: 24),
              _buildQuickActions(context, lang),
              const SizedBox(height: 24),
              _buildSpecialties(context, lang),
              const SizedBox(height: 24),
              _buildTopDoctors(context, lang),
              const SizedBox(height: 24),
              _buildHowItWorks(context, lang),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: const WhatsappFab(),
    );
  }

  Widget _buildHeader(BuildContext context, LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.secondary,
                child: Icon(Icons.person, color: AppColors.cardBg),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t('app_name'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    lang.isHindi ? "आपका स्वागत है" : "Welcome back",
                    style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const LanguageToggle(),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.textDark, size: 24),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSearchBanner(BuildContext context, LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lang.t('tagline'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lang.isHindi ? 'बेहतरीन डॉक्टरों से तुरंत जुड़ें' : 'Book the best doctors instantly',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorsScreen()),
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textMuted, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      lang.t('search_hint'),
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard('30+', lang.isHindi ? 'डॉक्टर' : 'Doctors', Icons.people, AppColors.primary),
            Container(width: 1, height: 40, color: AppColors.border),
            _buildStatCard('5', lang.isHindi ? 'जिले' : 'Districts', Icons.location_on, AppColors.warning),
            Container(width: 1, height: 40, color: AppColors.border),
            _buildStatCard(lang.isHindi ? 'मुफ़्त' : 'Free', lang.isHindi ? 'बुकिंग' : 'Booking', Icons.check_circle, AppColors.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, LanguageProvider lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: lang.isHindi ? 'सेवाएं' : 'Services'),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionBtn(context, Icons.medical_services_outlined, lang.t('find_doctor'), const Color(0xFF3B82F6), () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorsScreen()));
              }),
              _buildActionBtn(context, Icons.video_call_outlined, lang.t('online_consult'), const Color(0xFFF59E0B), () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TeleconsultScreen()));
              }),
              _buildActionBtn(context, Icons.credit_card_outlined, lang.t('health_card'), const Color(0xFF8B5CF6), () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthCardScreen()));
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionBtn(context, Icons.local_hospital_outlined, lang.t('hospitals'), const Color(0xFFEF4444), () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalsScreen()));
              }),
              _buildActionBtn(context, Icons.directions_car_outlined, lang.t('ambulance'), const Color(0xFFF43F5E), () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AmbulanceScreen()));
              }),
              _buildActionBtn(context, Icons.help_outline, lang.t('how_it_works'), const Color(0xFF10B981), () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 3, // Full width - padding(32) - gaps(32) / 3
        height: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialties(BuildContext context, LanguageProvider lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: lang.t('specialties')),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              SpecialtyChip(label: lang.isHindi ? 'सामान्य चिकित्सक' : 'Physician', icon: Icons.favorite, color: Colors.blue, onTap: () {}),
              const SizedBox(width: 8),
              SpecialtyChip(label: lang.isHindi ? 'हृदय रोग' : 'Cardiologist', icon: Icons.favorite_border, color: Colors.red, onTap: () {}),
              const SizedBox(width: 8),
              SpecialtyChip(label: lang.isHindi ? 'स्त्री रोग' : 'Gynecologist', icon: Icons.pregnant_woman, color: Colors.pink, onTap: () {}),
              const SizedBox(width: 8),
              SpecialtyChip(label: lang.isHindi ? 'त्वचा विशेषज्ञ' : 'Dermatologist', icon: Icons.face, color: Colors.teal, onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopDoctors(BuildContext context, LanguageProvider lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: lang.t('top_doctors'),
          actionLabel: lang.t('see_all'),
          onAction: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DoctorsScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 6,
            itemBuilder: (context, index) {
              final doctor = DoctorsData.doctors[index];
              return Container(
                width: 300,
                padding: const EdgeInsets.only(right: 12),
                child: DoctorCard(doctor: doctor),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorks(BuildContext context, LanguageProvider lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: lang.t('how_it_works')),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStepCard(context, '1', lang.t('step1')),
                const Icon(Icons.chevron_right, color: AppColors.border, size: 24),
                _buildStepCard(context, '2', lang.t('step2')),
                const Icon(Icons.chevron_right, color: AppColors.border, size: 24),
                _buildStepCard(context, '3', lang.t('step3')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(BuildContext context, String number, String text) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.lightBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.2),
          ),
        ],
      ),
    );
  }
}
