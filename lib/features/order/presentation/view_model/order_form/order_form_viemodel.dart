import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:rolo/features/order/domain/entity/delivery_location_entity.dart';
import 'package:rolo/features/order/domain/entity/shipping_address_entity.dart';
import 'package:rolo/features/order/domain/use_case/get_last_shipping_address_usecase.dart';
import 'package:rolo/features/order/domain/use_case/get_shipping_locations_usecase.dart';
import 'package:rolo/features/order/presentation/view_model/order_form/order_form_event.dart';
import 'package:rolo/features/order/presentation/view_model/order_form/order_form_state.dart';
import 'package:rolo/features/profile/domain/entity/profile_entity.dart';
import 'package:rolo/features/profile/domain/use_case/get_user_profile_usecase.dart';

class OrderViewModel extends Bloc<OrderEvent, OrderState> {
  final GetShippingLocationsUseCase _getShippingLocationsUseCase;
  final GetLastShippingAddressUseCase _getLastShippingAddressUseCase;
  final GetProfileUsecase _getProfileUsecase;
  final CartViewModel cartViewModel;
  final Connectivity _connectivity;

  OrderViewModel({
    required GetShippingLocationsUseCase getShippingLocationsUseCase,
    required GetLastShippingAddressUseCase getLastShippingAddressUseCase,
    required this.cartViewModel,
    required GetProfileUsecase getProfileUsecase,
    required Connectivity connectivity,
  })  : _getShippingLocationsUseCase = getShippingLocationsUseCase,
        _getLastShippingAddressUseCase = getLastShippingAddressUseCase,
        _getProfileUsecase = getProfileUsecase,
        _connectivity = connectivity,
        super(OrderState.initial()) {
    on<OrderLoadInitialData>(_onLoadInitialData);
    on<OrderFormFieldChanged>(_onFormFieldChanged);
    on<OrderDistrictSelected>(_onDistrictSelected);
    on<OrderCitySelected>(_onCitySelected);
    on<ProceedToPayment>(_onProceedToPayment);
  }

  Future<void> _onLoadInitialData(
      OrderLoadInitialData event, Emitter<OrderState> emit) async {
    emit(state.copyWith(
      status: OrderStatus.loading,
      clearActionMessage: true,
      clearError: true,
    ));

    try {
      // Check connectivity first
      final connectivityResult = await _connectivity.checkConnectivity();
      
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(state.copyWith(status: OrderStatus.noNetwork));
        return;
      }

      final results = await Future.wait([
        _getShippingLocationsUseCase(),
        _getLastShippingAddressUseCase(),
        _getProfileUsecase(),
      ]);

      final locationsResult = results[0] as Either<Failure, List<DeliveryLocationEntity>>;
      final addressResult = results[1] as Either<Failure, ShippingAddressEntity>;
      final profileResult = results[2] as Either<Failure, ProfileEntity>;

      await locationsResult.fold(
        (failure) async => emit(state.copyWith(
          status: OrderStatus.error, 
          errorMessage: () => failure.message
        )),
        (locations) async {
          final districts = locations.map((l) => l.district).toSet().toList();
          
          var newState = state.copyWith(
            status: OrderStatus.success,
            allLocations: locations,
            availableDistricts: districts
          );

          profileResult.fold(
            (failure) {
               newState = newState.copyWith(
                 status: OrderStatus.error,
                 errorMessage: () => "Could not load user profile. Please try again."
               );
            },
            (profile) {
              final user = profile.user;
              newState = newState.copyWith(
                userId: user.userId,
                shippingAddress: newState.shippingAddress.copyWith(
                  firstName: user.fName,
                  lastName: user.lName,
                  email: user.email,
                )
              );
            }
          );

          if (newState.status == OrderStatus.error) {
            emit(newState);
            return;
          }

          addressResult.fold(
            (_) {}, 
            (address) {
              final cities = locations.where((l) => l.district == address.district).map((l) => l.name).toList();
              final matchingLocation = locations.firstWhere(
                (l) => l.district == address.district && l.name == address.city,
                orElse: () => const DeliveryLocationEntity(id: '', name: '', district: '', fare: 0.0),
              );

              newState = newState.copyWith(
                shippingAddress: address.copyWith(email: newState.shippingAddress.email),
                availableCities: cities,
                shippingFee: matchingLocation.fare
              );
            }
          );
          
          emit(newState);
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: OrderStatus.error,
        errorMessage: () => 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }
  
  void _onFormFieldChanged(OrderFormFieldChanged event, Emitter<OrderState> emit) {
    final newAddress = state.shippingAddress.copyWith(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      phone: event.phone,
      address: event.address,
      postalCode: event.postalCode,
      notes: event.notes,
    );
    emit(state.copyWith(shippingAddress: newAddress));
  }

  void _onDistrictSelected(OrderDistrictSelected event, Emitter<OrderState> emit) {
    final cities = state.allLocations
        .where((l) => l.district == event.district)
        .map((l) => l.name)
        .toList();
    
    emit(state.copyWith(
      shippingAddress: state.shippingAddress.copyWith(district: event.district, city: ''),
      availableCities: cities,
      shippingFee: 0.0,
    ));
  }

  void _onCitySelected(OrderCitySelected event, Emitter<OrderState> emit) {
    final location = state.allLocations.firstWhere(
      (l) => l.district == state.shippingAddress.district && l.name == event.city,
      orElse: () => const DeliveryLocationEntity(id: '', name: '', district: '', fare: 0.0),
    );
    
    emit(state.copyWith(
      shippingAddress: state.shippingAddress.copyWith(city: event.city),
      shippingFee: location.fare,
    ));
  }
  
  Future<void> _onProceedToPayment(ProceedToPayment event, Emitter<OrderState> emit) async {
    try {
      // Check connectivity before proceeding to payment
      final connectivityResult = await _connectivity.checkConnectivity();
      
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(state.copyWith(
          actionMessage: "You are offline. Cannot proceed to payment.",
        ));
        return;
      }

      emit(state.copyWith(status: OrderStatus.proceedingToPayment));
      
      // Add a small delay to show loading state
      await Future.delayed(const Duration(milliseconds: 500));
      
      emit(state.copyWith(status: OrderStatus.readyForPayment));
    } catch (e) {
      emit(state.copyWith(
        actionMessage: "An error occurred while proceeding to payment.",
      ));
    }
  }
}