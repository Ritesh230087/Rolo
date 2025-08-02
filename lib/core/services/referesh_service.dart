import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolo/features/home/presentation/view_model/home_event.dart';
import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_event.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_viewmodel.dart';

class RefreshService {
  final BuildContext context;
  RefreshService(this.context);

  void refreshDataOnReconnect() {
    // Refresh Home Page Data
    try {
      context.read<HomeViewModel>().add(const LoadHomeData(isRefresh: true));
    } catch (e) {
      debugPrint("Could not refresh HomeViewModel: $e");
    }

    try {
      context.read<ExploreViewModel>().add(const LoadExploreData(isRefresh: true));
      debugPrint("RefreshService: Dispatched LoadExploreData event.");
    } catch (e) {
      debugPrint("Could not refresh ExploreViewModel: $e");
    }
  }
}