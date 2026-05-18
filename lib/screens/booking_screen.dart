import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/booking_model.dart';
import '../models/doctor_model.dart';
import '../providers/booking_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/language_toggle.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_ui.dart';
import 'booking_confirm_screen.dart';

class BookingScreen extends StatefulWidget {
  final Doctor doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _symptomsController = TextEditingController();
  String? _selectedSlot;
  int _currentStep = 1; // 1: Time, 2: Details

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final isHi = lang.isHindi;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(lang.t('book_appointment')),
        actions: const [LanguageToggle()],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildStepIndicator(lang),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDoctorSummary(isHi),
                    const SizedBox(height: 24),
                    if (_currentStep == 1) _buildTimeSelection(lang),
                    if (_currentStep == 2) _buildPatientDetailsForm(lang),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: AppButton(
            text: _currentStep == 1 ? (isHi ? 'अगला' : 'Next') : lang.t('confirm_booking'),
            onPressed: () {
              if (_currentStep == 1) {
                if (_selectedSlot == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isHi ? 'कृपया एक स्लॉट चुनें' : 'Please select a slot')),
                  );
                  return;
                }
                setState(() => _currentStep = 2);
              } else {
                _confirmBooking(lang);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(LanguageProvider lang) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Row(
        children: [
          _buildStepCircle('1', _currentStep >= 1),
          Expanded(child: Container(height: 2, color: _currentStep >= 2 ? AppColors.primary : AppColors.border)),
          _buildStepCircle('2', _currentStep >= 2),
        ],
      ),
    );
  }

  Widget _buildStepCircle(String step, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.lightBackground,
        shape: BoxShape.circle,
        border: Border.all(color: isActive ? AppColors.primary : AppColors.border),
      ),
      child: Center(
        child: Text(
          step,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.textMuted,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorSummary(bool isHi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: widget.doctor.specialtyColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person, color: widget.doctor.specialtyColor, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHi ? widget.doctor.nameHi : widget.doctor.nameEn,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 4),
                Text(
                  isHi ? widget.doctor.specialtyHi : widget.doctor.specialtyEn,
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.payment, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text('₹${widget.doctor.fee}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelection(LanguageProvider lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: lang.t('select_slot')),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.doctor.slots.map((slot) {
            final isSelected = _selectedSlot == slot;
            return ChoiceChip(
              label: Text(slot),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedSlot = selected ? slot : null);
              },
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.cardBg,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textMedium,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPatientDetailsForm(LanguageProvider lang) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: lang.t('patient_name')),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: lang.t('patient_name'),
              prefixIcon: const Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return lang.t('required_field');
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: lang.t('phone_number'),
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            validator: (value) {
              final phone = value?.replaceAll(RegExp(r'\D'), '') ?? '';
              if (phone.length != 10) return lang.t('invalid_phone');
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _symptomsController,
            minLines: 3,
            maxLines: 5,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: lang.t('optional_symptoms'),
              prefixIcon: const Icon(Icons.notes),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmBooking(LanguageProvider lang) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();
    final booking = Booking(
      id: const Uuid().v4(),
      doctorId: widget.doctor.id,
      doctorNameEn: widget.doctor.nameEn,
      doctorNameHi: widget.doctor.nameHi,
      specialtyEn: widget.doctor.specialtyEn,
      specialtyHi: widget.doctor.specialtyHi,
      patientName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.replaceAll(RegExp(r'\D'), ''),
      symptoms: _symptomsController.text.trim(),
      date: DateFormat('dd MMM yyyy').format(now),
      time: _selectedSlot!,
      status: 'upcoming',
      fee: widget.doctor.fee,
      createdAt: now.toIso8601String(),
    );

    final bookingProvider = context.read<BookingProvider>();
    await bookingProvider.addBooking(booking);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmScreen(
          booking: booking,
          doctor: widget.doctor,
        ),
      ),
    );
  }
}
