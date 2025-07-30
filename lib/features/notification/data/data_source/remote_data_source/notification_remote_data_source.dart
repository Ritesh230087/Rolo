import 'package:dio/dio.dart';
import 'package:rolo/app/constant/api_endpoints.dart';
import 'package:rolo/core/network/api_service.dart';
import 'package:rolo/features/notification/data/model/notification_api_model.dart';

abstract interface class INotificationRemoteDataSource {
  Future<List<NotificationApiModel>> getNotifications();
  Future<bool> markAsRead(String notificationId);
  Future<bool> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements INotificationRemoteDataSource {
  final ApiService apiService;

  NotificationRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<NotificationApiModel>> getNotifications() async {
    try {
      final response = await apiService.get(ApiEndpoints.notifications);
      final List<dynamic> data = response.data['data'];
      return data.map((json) => NotificationApiModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get notifications');
    }
  }

  @override
  Future<bool> markAsRead(String notificationId) async {
    try {
      await apiService.post(ApiEndpoints.markNotificationAsRead(notificationId));
      return true;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to mark notification as read');
    }
  }

  @override
  Future<bool> markAllAsRead() async {
    try {
      await apiService.post(ApiEndpoints.markAllNotificationsAsRead);
      return true;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to mark all as read');
    }
  }
}