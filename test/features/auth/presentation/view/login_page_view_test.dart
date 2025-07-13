import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/auth/presentation/view/login_page_view.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_state.dart';

class MockLoginViewModel extends Mock implements LoginViewModel {}

class FakeLoginState extends Fake implements LoginState {}

void main() {
  late MockLoginViewModel mockLoginViewModel;

  setUpAll(() {
    registerFallbackValue(FakeLoginState());
  });

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
  });

  testWidgets('LoginScreen shows Login button and Forgot Password text',
      (WidgetTester tester) async {
    when(() => mockLoginViewModel.state)
        .thenReturn(const LoginState.initial());
    when(() => mockLoginViewModel.stream)
        .thenAnswer((_) => const Stream<LoginState>.empty());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginViewModel>.value(
          value: mockLoginViewModel,
          child: const LoginScreen(),
        ),
      ),
    );
    
    expect(find.text('Forgot Password?'), findsOneWidget);
  });
}
