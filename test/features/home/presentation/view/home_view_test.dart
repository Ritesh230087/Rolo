// test/features/home/presentation/view/home_view_test.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/core/widgets/product_card.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/presentation/view/home_view.dart';
import 'package:rolo/features/home/presentation/view_model/home_event.dart';
import 'package:rolo/features/home/presentation/view_model/home_state.dart';
import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';

// --- MOCK AND FAKE CLASSES ---
class MockHomeViewModel extends Mock implements HomeViewModel {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late MockHomeViewModel mockViewModel;
  late NavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    registerFallbackValue(LoadHomeData());
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockViewModel = MockHomeViewModel();
    mockNavigatorObserver = MockNavigatorObserver();

    // Stub the stream and close methods to prevent runtime errors in tests.
    when(() => mockViewModel.stream).thenAnswer((_) => StreamController<HomeState>().stream);
    when(() => mockViewModel.close()).thenAnswer((_) async {});
  });

  // Create a valid, complete ProductEntity instance for testing.
  final tProduct = ProductEntity(id: '1', name: 'Test Product', price: 10.0, description: '', originalPrice: 12.0, quantity: 5, imageUrl: '', extraImages: [], features: [], material: '', origin: '', care: '', warranty: '', featured: true, categoryId: 'c1');
  
  final tHomeEntity = HomeEntity(
    categories: [],
    featuredProducts: [tProduct, tProduct],
    ribbonSections: [],
  );

  // Helper function to build the widget tree for our tests.
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<HomeViewModel>.value(
        value: mockViewModel,
        child: const HomeView(),
      ),
      navigatorObservers: [mockNavigatorObserver],
    );
  }

  group('HomeView', () {
    testWidgets('shows loading indicator when state is HomeLoading', (tester) async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(HomeLoading());
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // CRITICAL FIX: Wrap the test in `tester.runAsync` to handle `Future.delayed`.
    testWidgets('renders product sections when state is HomeLoaded', (tester) async => await tester.runAsync(() async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(HomeLoaded(tHomeEntity));
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // `pumpAndSettle` will now work because `runAsync` gives it control over the timers.
      // It will fast-forward through the animation delays.
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('Featured Products'), findsOneWidget);
      expect(find.byType(ProductCard), findsNWidgets(2));
    }));

    testWidgets('finds the search bar at the top when state is HomeLoaded', (tester) async => await tester.runAsync(() async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(HomeLoaded(tHomeEntity));
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.widgetWithText(TextField, 'Search for authentic crafts...'), findsOneWidget);
    }));

    testWidgets('finds "Discover Authentic Nepalese Crafts" text when state is HomeLoaded', (tester) async => await tester.runAsync(() async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(HomeLoaded(tHomeEntity));
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('Discover Authentic\nNepalese Crafts', skipOffstage: false), findsOneWidget);
    }));

    testWidgets('finds "Shop Now" button when state is HomeLoaded', (tester) async => await tester.runAsync(() async {
      // Arrange
      when(() => mockViewModel.state).thenReturn(HomeLoaded(tHomeEntity));
      
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.widgetWithText(ElevatedButton, 'Shop Now'), findsOneWidget);
    }));
  });
}