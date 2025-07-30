import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart'; 
import 'package:rolo/app/constant/api_endpoints.dart';
import 'package:rolo/core/network/api_service.dart';
import 'package:rolo/features/order/data/model/delivery_location_api_model.dart';
import 'package:rolo/features/order/data/model/order_api_model.dart';
import 'package:rolo/features/order/data/model/shipping_address_api_model.dart';

abstract interface class OrderRemoteDataSource {
  Future<List<DeliveryLocationApiModel>> getShippingLocations();
  Future<ShippingAddressApiModel> getLastShippingAddress();
  Future<OrderApiModel> createOrder(Map<String, dynamic> orderData);
  Future<OrderApiModel> createOrderWithSlip(Map<String, dynamic> orderData, File slipImage);
  Future<List<OrderApiModel>> getOrderHistory(String userId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiService apiService;
  OrderRemoteDataSourceImpl(this.apiService);

  @override
  Future<OrderApiModel> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.createOrder,
        data: orderData,
      );
      return OrderApiModel.fromJson(response.data['order']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to create order');
    }
  }

  @override
  Future<OrderApiModel> createOrderWithSlip(Map<String, dynamic> orderData, File slipImage) async {
    try {
      final String? mimeType = lookupMimeType(slipImage.path);
      final mediaType = MediaType.parse(mimeType ?? 'image/jpeg');

      final Map<String, dynamic> formDataMap = {
        'userId': orderData['userId'],
        'deliveryFee': orderData['deliveryFee'],
        'totalAmount': orderData['totalAmount'],
        'deliveryType': orderData['deliveryType'],
        'items': jsonEncode(orderData['items']),
        'shippingAddress': jsonEncode(orderData['shippingAddress']),
        
        'slipImage': await MultipartFile.fromFile(
          slipImage.path,
          filename: slipImage.path.split('/').last,
          contentType: mediaType,
        ),
      };

      final formData = FormData.fromMap(formDataMap);

      final response = await apiService.post(
        ApiEndpoints.createOrderWithSlip,
        data: formData,
      );
      return OrderApiModel.fromJson(response.data['order']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to create order with slip');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  
  @override
  Future<ShippingAddressApiModel> getLastShippingAddress() async {
    try {
      const userId = "get_your_logged_in_user_id_here"; 
      final endpoint = ApiEndpoints.lastShippingAddress(userId);
      final response = await apiService.get(endpoint);
      
      return ShippingAddressApiModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('No previous shipping address found.');
      }
      throw Exception(e.response?.data['error'] ?? 'Failed to fetch address');
    }
  }

  @override
  Future<List<OrderApiModel>> getOrderHistory(String userId) async {
    try {
      final endpoint = '${ApiEndpoints.myOrders}/$userId'; 
      final response = await apiService.get(endpoint);
      final List<dynamic> data = response.data['data'];
      return data.map((orderJson) => OrderApiModel.fromJson(orderJson)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to fetch order history');
    }
  }

  @override
  Future<List<DeliveryLocationApiModel>> getShippingLocations() async {
    try {
      final response = await apiService.get(ApiEndpoints.shippingLocations);
      final List<dynamic> data = response.data;
      return data.map((json) => DeliveryLocationApiModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to fetch locations');
    }
  }
}