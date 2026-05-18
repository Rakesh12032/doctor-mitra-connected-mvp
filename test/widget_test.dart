import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doctor_mitra/mvp_app.dart';

void main() {
  testWidgets('Doctor Mitra app shows role selection', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const DoctorMitraRoleApp());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Doctor Mitra'), findsOneWidget);
    expect(find.text('Patient Login'), findsOneWidget);
    expect(find.text('Doctor Login'), findsOneWidget);
    expect(find.text('Admin Login'), findsOneWidget);
  });
}
