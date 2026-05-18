import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_toggle.dart';
import '../theme/app_colors.dart';

class HospitalsScreen extends StatelessWidget {
  const HospitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final isHi = lang.isHindi;

    final mockHospitals = [
      {
        'nameEn': 'City General Hospital',
        'nameHi': 'सिटी जनरल अस्पताल',
        'addressEn': '123 Main St, Patna, Bihar',
        'addressHi': '123 मेन स्ट्रीट, पटना, बिहार',
        'distance': '2.5 km',
        'rating': '4.5',
      },
      {
        'nameEn': 'Sanjeevani Care',
        'nameHi': 'संजीवनी केयर',
        'addressEn': '45 Kankarbagh Road, Patna, Bihar',
        'addressHi': '45 कंकड़बाग रोड, पटना, बिहार',
        'distance': '4.1 km',
        'rating': '4.2',
      },
      {
        'nameEn': 'Apollo Clinic',
        'nameHi': 'अपोलो क्लिनिक',
        'addressEn': 'Boring Road, Patna, Bihar',
        'addressHi': 'बोरिंग रोड, पटना, बिहार',
        'distance': '5.8 km',
        'rating': '4.8',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(lang.t('hospitals')),
        actions: const [LanguageToggle()],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mockHospitals.length,
          itemBuilder: (context, index) {
            final hospital = mockHospitals[index];
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
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.local_hospital_outlined, color: AppColors.error, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isHi ? hospital['nameHi']! : hospital['nameEn']!,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      isHi ? hospital['addressHi']! : hospital['addressEn']!,
                                      style: const TextStyle(color: AppColors.textMedium, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.warning, size: 18),
                            const SizedBox(width: 4),
                            Text(hospital['rating']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            const Icon(Icons.directions_walk, color: AppColors.primary, size: 18),
                            const SizedBox(width: 4),
                            Text(hospital['distance']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                        SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(isHi ? 'दिशा निर्देश' : 'Directions', style: const TextStyle(fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
