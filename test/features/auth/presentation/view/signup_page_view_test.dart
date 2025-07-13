import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:rolo/features/auth/presentation/view/signup_page_view.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';

// Mock RegisterViewModel (Bloc)
class MockRegisterViewModel extends Mock implements RegisterViewModel {}

void main() {
  late MockRegisterViewModel mockRegisterViewModel;

  setUp(() {
    mockRegisterViewModel = MockRegisterViewModel();
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<RegisterViewModel>.value(
        value: mockRegisterViewModel,
        child: child,
      ),
    );
  }

  testWidgets('SignUpScreen renders with correct UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(SignUpScreen()));

    // Basic visible texts
    expect(find.text('Create Account'), findsOneWidget);

    // TextFormFields (First Name, Last Name, Email, Password)
    expect(find.byType(TextFormField), findsNWidgets(4));

    // Checkbox
    expect(find.byType(Checkbox), findsOneWidget);

    // Sign Up Button
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
  });
}
