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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(lang.t('doctors')),
        actions: const [Padding(padding: EdgeInsets.only(right: 8.0), child: LanguageToggle())],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.cardBg,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
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
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: AppColors.lightBackground,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted.withOpacity(0.5)),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            lang.isHindi ? 'कोई डॉक्टर नहीं मिला' : 'No doctors found',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: DoctorCard(doctor: filteredDoctors[index]),
                        );
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
        color: isSelected ? Colors.white : AppColors.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        fontSize: 14,
      ),
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
