import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();
  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}
class ConnectivityOnline extends ConnectivityState {}
class ConnectivityOffline extends ConnectivityState {}
class ConnectivityRestored extends ConnectivityState {}

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _wasOffline = false;

  ConnectivityCubit({required Connectivity connectivity})
      : _connectivity = connectivity,
        super(ConnectivityInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    checkInitialConnection();
  }
  
  Future<void> checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> resultList) {
    if (resultList.contains(ConnectivityResult.none)) {
      if (state is! ConnectivityOffline) {
        _wasOffline = true;
        emit(ConnectivityOffline());
      }
    } else {
      if (_wasOffline) {
        emit(ConnectivityRestored());
        Future.delayed(const Duration(milliseconds: 100), () => emit(ConnectivityOnline()));
      } else if (state is ConnectivityInitial) {
        emit(ConnectivityOnline());
      }
      _wasOffline = false;
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}