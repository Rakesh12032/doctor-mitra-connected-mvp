class Booking {
  final String id;
  final String doctorId;
  final String doctorNameEn;
  final String doctorNameHi;
  final String specialtyEn;
  final String specialtyHi;
  final String patientName;
  final String phoneNumber;
  final String symptoms;
  final String date;
  final String time;
  final String status;
  final double fee;
  final String createdAt;

  Booking({
    required this.id,
    required this.doctorId,
    required this.doctorNameEn,
    required this.doctorNameHi,
    required this.specialtyEn,
    required this.specialtyHi,
    required this.patientName,
    required this.phoneNumber,
    required this.symptoms,
    required this.date,
    required this.time,
    required this.status,
    required this.fee,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'doctorNameEn': doctorNameEn,
      'doctorNameHi': doctorNameHi,
      'specialtyEn': specialtyEn,
      'specialtyHi': specialtyHi,
      'patientName': patientName,
      'phoneNumber': phoneNumber,
      'symptoms': symptoms,
      'date': date,
      'time': time,
      'status': status,
      'fee': fee,
      'createdAt': createdAt,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      doctorNameEn: json['doctorNameEn'] as String,
      doctorNameHi: json['doctorNameHi'] as String,
      specialtyEn: json['specialtyEn'] as String,
      specialtyHi: json['specialtyHi'] as String,
      patientName: json['patientName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      symptoms: json['symptoms'] as String? ?? '',
      date: json['date'] as String,
      time: json['time'] as String,
      status: json['status'] as String,
      fee: (json['fee'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
    );
  }

  Booking copyWith({String? status}) {
    return Booking(
      id: id,
      doctorId: doctorId,
      doctorNameEn: doctorNameEn,
      doctorNameHi: doctorNameHi,
      specialtyEn: specialtyEn,
      specialtyHi: specialtyHi,
      patientName: patientName,
      phoneNumber: phoneNumber,
      symptoms: symptoms,
      date: date,
      time: time,
      status: status ?? this.status,
      fee: fee,
      createdAt: createdAt,
    );
  }
}
