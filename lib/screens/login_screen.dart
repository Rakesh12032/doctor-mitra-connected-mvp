import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_toggle.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_ui.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  String _selectedRole = 'patient';
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final isHi = lang.isHindi;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [Padding(padding: EdgeInsets.only(right: 8.0), child: LanguageToggle())],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Premium Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, spreadRadius: 5),
                        ],
                      ),
                      child: const Icon(Icons.health_and_safety, size: 64, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    isHi ? 'डॉक्टर मित्रा में आपका स्वागत है' : 'Welcome to Doctor Mitra',
                    style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isHi ? 'बेहतर स्वास्थ्य देखभाल, अब आपके फोन पर' : 'Premium healthcare, now on your phone',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Role Selection
                  Text(
                    isHi ? 'आगे बढ़ने के लिए चुनें' : 'Choose your role to continue',
                    style: theme.textTheme.titleMedium?.copyWith(color: AppColors.textMedium),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  // Large Patient Card
                  _buildLargeRoleCard(
                    role: 'patient',
                    icon: Icons.person_rounded,
                    title: isHi ? 'मरीज़ (Patient)' : 'Patient',
                    subtitle: isHi ? 'डॉक्टर बुक करें और परामर्श लें' : 'Book doctors and consult online',
                    isSelected: _selectedRole == 'patient',
                  ),
                  const SizedBox(height: 16),
                  
                  // Small Secondary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallRoleCard(
                          role: 'doctor',
                          icon: Icons.medical_information,
                          title: isHi ? 'डॉक्टर' : 'Doctor',
                          isSelected: _selectedRole == 'doctor',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSmallRoleCard(
                          role: 'admin',
                          icon: Icons.admin_panel_settings,
                          title: isHi ? 'एडमिन' : 'Admin',
                          isSelected: _selectedRole == 'admin',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Login Form Card
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(_selectedRole),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: _selectedRole == 'patient' ? lang.t('enter_phone') : (isHi ? 'लॉगिन आईडी' : 'Login ID'),
                              prefixIcon: Icon(_selectedRole == 'patient' ? Icons.phone_outlined : Icons.badge_outlined),
                            ),
                            keyboardType: _selectedRole == 'patient' ? TextInputType.phone : TextInputType.text,
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            text: _selectedRole == 'patient' ? lang.t('send_otp') : (isHi ? 'लॉगिन करें' : 'Login Now'),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    lang.t('data_safe'),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLargeRoleCard({
    required String role,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: 2),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]
              : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: isSelected ? Colors.white : AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? Colors.white.withOpacity(0.9) : AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallRoleCard({
    required String role,
    required IconData icon,
    required String title,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: isSelected ? AppColors.primary : AppColors.textMedium),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textMedium,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
