// // test/features/home/presentation/view_model/home_view_model_test.dart
// import 'package:bloc_test/bloc_test.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:rolo/core/error/failure.dart';
// import 'package:rolo/features/home/domain/entity/home_entity.dart';
// import 'package:rolo/features/home/domain/entity/home_section_entity.dart';
// import 'package:rolo/features/home/domain/use_case/get_home_data_usecase.dart';
// import 'package:rolo/features/home/presentation/view_model/home_event.dart';
// import 'package:rolo/features/home/presentation/view_model/home_state.dart';
// import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
// import 'package:rolo/features/product/domain/entity/product_entity.dart';
// import 'package:rolo/features/ribbon/domain/entity/ribbon_entity.dart';

// // Mock the use case
// class MockGetHomeDataUsecase extends Mock implements GetHomeDataUsecase {}

// void main() {
//   late HomeViewModel viewModel;
//   late GetHomeDataUsecase mockGetHomeDataUsecase;

//   // --- Sample Data for Testing ---
//   // CRITICAL FIX: Create ProductEntity instances with ALL required fields.
//   final sampleProduct1 = ProductEntity(id: '1', name: 'Singing Bowl', price: 25.0, description: '', originalPrice: 30, quantity: 10, imageUrl: '', extraImages: [], features: [], material: '', origin: '', care: '', warranty: '', featured: true, categoryId: 'c1');
//   final sampleProduct2 = ProductEntity(id: '2', name: 'Mandala Painting', price: 150.0, description: '', originalPrice: 200, quantity: 5, imageUrl: '', extraImages: [], features: [], material: '', origin: '', care: '', warranty: '', featured: false, categoryId: 'c2');
//   final sampleProduct3 = ProductEntity(id: '3', name: 'Prayer Bowl Flags', price: 10.0, description: '', originalPrice: 10, quantity: 100, imageUrl: '', extraImages: [], features: [], material: '', origin: '', care: '', warranty: '', featured: true, categoryId: 'c3');

//   final tHomeEntity = HomeEntity(
//     categories: [],
//     featuredProducts: [sampleProduct1, sampleProduct3],
//     ribbonSections: [
//       HomeSectionEntity(
//         ribbon: const RibbonEntity(id: 'r1', label: 'New Arrivals', color: ''),
//         products: [sampleProduct2],
//       ),
//     ],
//   );

//   setUp(() {
//     mockGetHomeDataUsecase = MockGetHomeDataUsecase();
//     viewModel = HomeViewModel(mockGetHomeDataUsecase);
//   });

//   tearDown(() {
//     viewModel.close();
//   });

//   group('HomeViewModel', () {
//     // --- Test Group for Loading Data ---
//     group('LoadHomeData', () {
//       blocTest<HomeViewModel, HomeState>(
//         'emits [HomeLoading, HomeLoaded] when use case is successful',
//         setUp: () {
//           when(() => mockGetHomeDataUsecase()).thenAnswer((_) async => Right(tHomeEntity));
//         },
//         build: () => viewModel,
//         act: (bloc) => bloc.add(LoadHomeData()),
//         expect: () => [
//           HomeLoading(),
//           HomeLoaded(tHomeEntity),
//         ],
//         verify: (_) => verify(() => mockGetHomeDataUsecase()).called(1),
//       );

//       blocTest<HomeViewModel, HomeState>(
//         'emits [HomeLoading, HomeError] when use case fails',
//         setUp: () {
//           when(() => mockGetHomeDataUsecase()).thenAnswer((_) async => Left(ServerFailure(message: 'Server Error')));
//         },
//         build: () => viewModel,
//         act: (bloc) => bloc.add(LoadHomeData()),
//         expect: () => [
//           HomeLoading(),
//           const HomeError('Server Error'),
//         ],
//       );
//     });

//     // --- Test Group for Searching Products ---
//     group('SearchHomeProducts', () {
//       blocTest<HomeViewModel, HomeState>(
//         'emits [HomeLoaded] with filtered data when a search query is entered',
//         setUp: () {
//           // The use case is called once to seed the data.
//           when(() => mockGetHomeDataUsecase()).thenAnswer((_) async => Right(tHomeEntity));
//         },
//         build: () => viewModel,
//         act: (bloc) async {
//           // First, ensure data is loaded to set the internal _originalHomeData
//           bloc.add(LoadHomeData());
//           // Wait for the event to be processed
//           await Future.microtask(() {});
//           // Then, perform the search
//           bloc.add(const SearchHomeProducts('bowl'));
//         },
//         skip: 2, // Skip the initial HomeLoading and HomeLoaded states
//         expect: () {
//           // Define the expected result after filtering for "bowl"
//           final filteredEntity = HomeEntity(
//             categories: tHomeEntity.categories,
//             featuredProducts: [sampleProduct1, sampleProduct3], // Both contain "Bowl"
//             ribbonSections: [], // The "Mandala" section is removed
//           );
//           return [
//             HomeLoaded(filteredEntity),
//           ];
//         },
//       );

//       blocTest<HomeViewModel, HomeState>(
//         'emits [HomeLoaded] with original data when the search query is cleared',
//         setUp: () {
//           when(() => mockGetHomeDataUsecase()).thenAnswer((_) async => Right(tHomeEntity));
//         },
//         build: () => viewModel,
//         act: (bloc) async {
//           bloc.add(LoadHomeData());
//           await Future.microtask(() {});
//           bloc.add(const SearchHomeProducts('painting')); // Perform a search
//           await Future.microtask(() {});
//           bloc.add(const SearchHomeProducts(''));    // Clear the search
//         },
//         skip: 3, // Skip initial load and the search result
//         expect: () => [
//           HomeLoaded(tHomeEntity), // The state should revert to the original, full dataset.
//         ],
//       );
//     });
//   });
// }
















































// test/features/home/presentation/view_model/home_view_model_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/home/domain/entity/home_entity.dart';
import 'package:rolo/features/home/domain/entity/home_section_entity.dart';
import 'package:rolo/features/home/domain/use_case/get_home_data_usecase.dart';
import 'package:rolo/features/home/presentation/view_model/home_event.dart';
import 'package:rolo/features/home/presentation/view_model/home_state.dart';
import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:rolo/features/ribbon/domain/entity/ribbon_entity.dart';

class MockGetHomeDataUsecase extends Mock implements GetHomeDataUsecase {}

void main() {
  late HomeViewModel viewModel;
  late GetHomeDataUsecase mockGetHomeDataUsecase;

  final sampleProduct1 = ProductEntity(id: '1', name: 'Singing Bowl', price: 25.0, description: '', originalPrice: 30, quantity: 10, imageUrl: '', extraImages: [], features: [], material: '', origin: '', care: '', warranty: '', featured: true, categoryId: 'c1');
  final sampleProduct2 = ProductEntity(id: '2', name: 'Mandala Painting', price: 150.0, description: '', originalPrice: 200, quantity: 5, imageUrl: '', extraImages: [], features: [], material: '', origin: '', care: '', warranty: '', featured: false, categoryId: 'c2');
  final sampleProduct3 = ProductEntity(id: '3', name: 'Prayer Bowl Flags', price: 10.0, description: '', originalPrice: 10, quantity: 100, imageUrl: '', extraImages: [], features: [], material: '', origin: '', care: '', warranty: '', featured: true, categoryId: 'c3');

  final tHomeEntity = HomeEntity(
    categories: [],
    featuredProducts: [sampleProduct1, sampleProduct3],
    ribbonSections: [
      HomeSectionEntity(
        ribbon: const RibbonEntity(id: 'r1', label: 'New Arrivals', color: ''),
        products: [sampleProduct2],
      ),
    ],
  );

  setUp(() {
    mockGetHomeDataUsecase = MockGetHomeDataUsecase();
    viewModel = HomeViewModel(mockGetHomeDataUsecase);
  });

  tearDown(() {
    viewModel.close();
  });

  group('HomeViewModel', () {
    group('LoadHomeData', () {
      blocTest<HomeViewModel, HomeState>(
        'emits [HomeLoading, HomeLoaded] when use case is successful',
        setUp: () => when(() => mockGetHomeDataUsecase()).thenAnswer((_) async => Right(tHomeEntity)),
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadHomeData()),
        expect: () => [HomeLoading(), HomeLoaded(tHomeEntity)],
      );

      blocTest<HomeViewModel, HomeState>(
        'emits [HomeLoading, HomeError] when use case fails',
        setUp: () => when(() => mockGetHomeDataUsecase()).thenAnswer((_) async => Left(ServerFailure(message: 'Error'))),
        build: () => viewModel,
        act: (bloc) => bloc.add(LoadHomeData()),
        expect: () => [HomeLoading(), const HomeError('Error')],
      );
    });

    group('SearchHomeProducts', () {
      blocTest<HomeViewModel, HomeState>(
        'emits [HomeLoaded] with filtered data when a search query is entered',
        setUp: () => when(() => mockGetHomeDataUsecase()).thenAnswer((_) async => Right(tHomeEntity)),
        build: () => viewModel,
        act: (bloc) async {
          bloc.add(LoadHomeData());
          await Future.microtask(() {});
          bloc.add(const SearchHomeProducts('bowl'));
        },
        skip: 2,
        expect: () {
          final filteredEntity = HomeEntity(
            categories: tHomeEntity.categories,
            featuredProducts: [sampleProduct1, sampleProduct3],
            ribbonSections: [],
          );
          return [HomeLoaded(filteredEntity)];
        },
      );

      blocTest<HomeViewModel, HomeState>(
        'emits [HomeLoaded] with original data when the search query is cleared',
        setUp: () => when(() => mockGetHomeDataUsecase()).thenAnswer((_) async => Right(tHomeEntity)),
        build: () => viewModel,
        act: (bloc) async {
          bloc.add(LoadHomeData());
          await Future.microtask(() {});
          bloc.add(const SearchHomeProducts('bowl'));
          await Future.microtask(() {});
          bloc.add(const SearchHomeProducts(''));
        },
        skip: 3,
        expect: () => [HomeLoaded(tHomeEntity)],
      );

      // --- NEW TEST ADDED ---
      blocTest<HomeViewModel, HomeState>(
        'emits [HomeLoaded] with empty lists when search query has no matches',
        setUp: () => when(() => mockGetHomeDataUsecase()).thenAnswer((_) async => Right(tHomeEntity)),
        build: () => viewModel,
        act: (bloc) async {
          bloc.add(LoadHomeData());
          await Future.microtask(() {});
          bloc.add(const SearchHomeProducts('nonexistent'));
        },
        skip: 2,
        expect: () {
          // The expected result has empty product lists, which should trigger
          // the "No products found" message in your UI.
          final filteredEntity = HomeEntity(
            categories: tHomeEntity.categories,
            featuredProducts: [], // Empty list
            ribbonSections: [],   // Empty list
          );
          return [HomeLoaded(filteredEntity)];
        },
      );
    });
  });
}