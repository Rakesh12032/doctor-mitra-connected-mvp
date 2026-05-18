import 'package:flutter/material.dart';

class Doctor {
  final String id;
  final String nameEn;
  final String nameHi;
  final String degreeEn;
  final String degreeHi;
  final String specialtyEn;
  final String specialtyHi;
  final int experience;
  final String clinicEn;
  final String clinicHi;
  final String districtEn;
  final String districtHi;
  final double fee;
  final double rating;
  final int reviews;
  final bool isOnline;
  final List<String> slots;
  final Color specialtyColor;

  Doctor({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.degreeEn,
    required this.degreeHi,
    required this.specialtyEn,
    required this.specialtyHi,
    required this.experience,
    required this.clinicEn,
    required this.clinicHi,
    required this.districtEn,
    required this.districtHi,
    required this.fee,
    required this.rating,
    required this.reviews,
    required this.isOnline,
    required this.slots,
    required this.specialtyColor,
  });
}
