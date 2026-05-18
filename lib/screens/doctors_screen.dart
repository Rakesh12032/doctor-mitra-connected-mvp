import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/language_toggle.dart';
import '../widgets/doctor_card.dart';
import '../data/doctors_data.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  String _searchQuery = '';
  String? _selectedSpecialty;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    final filteredDoctors = DoctorsData.doctors.where((doc) {
      final query = _searchQuery.toLowerCase();
      final matchesSearch = doc.nameEn.toLowerCase().contains(query) ||
                            doc.nameHi.toLowerCase().contains(query) ||
                            doc.specialtyEn.toLowerCase().contains(query) ||
                            doc.specialtyHi.toLowerCase().contains(query);
      
      final matchesSpecialty = _selectedSpecialty == null || 
                               doc.specialtyEn == _selectedSpecialty || 
                               doc.specialtyHi == _selectedSpecialty;
      
      return matchesSearch && matchesSpecialty;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(lang.t('doctors')),
        actions: const [LanguageToggle()],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.cardBg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: lang.t('search_hint'),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip(lang.isHindi ? 'सभी' : 'All', null),
                        const SizedBox(width: 8),
                        _buildFilterChip(lang.isHindi ? 'सामान्य चिकित्सक' : 'Physician', lang.isHindi ? 'सामान्य चिकित्सक' : 'Physician'),
                        const SizedBox(width: 8),
                        _buildFilterChip(lang.isHindi ? 'हृदय रोग' : 'Cardiologist', lang.isHindi ? 'हृदय रोग' : 'Cardiologist'),
                        const SizedBox(width: 8),
                        _buildFilterChip(lang.isHindi ? 'स्त्री रोग' : 'Gynecologist', lang.isHindi ? 'स्त्री रोग' : 'Gynecologist'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredDoctors.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: AppColors.textMuted.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text(
                            lang.isHindi ? 'कोई डॉक्टर नहीं मिला' : 'No doctors found',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        return DoctorCard(doctor: filteredDoctors[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String? value) {
    final isSelected = _selectedSpecialty == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSpecialty = selected ? value : null;
        });
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textMedium,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        fontSize: 13,
      ),
      backgroundColor: AppColors.lightBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
      ),
    );
  }
}
