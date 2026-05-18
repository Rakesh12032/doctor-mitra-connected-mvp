import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_toggle.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_ui.dart';

class TeleconsultScreen extends StatelessWidget {
  const TeleconsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(lang.t('teleconsult')),
        actions: const [LanguageToggle()],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.video_camera_front, size: 60, color: AppColors.primary),
                ),
                const SizedBox(height: 32),
                Text(
                  lang.t('teleconsult'),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This feature is coming soon! Consult doctors from the comfort of your home.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.textMedium),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: 'Go Back',
                  onPressed: () => Navigator.pop(context),
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
