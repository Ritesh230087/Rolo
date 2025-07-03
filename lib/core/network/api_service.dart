import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rolo/app/constant/api_endpoints.dart';
import 'package:rolo/core/network/dio_error_interceptor.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService(this._dio) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }
}



// import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// import 'package:rolo/app/constant/api_endpoints.dart';
// import 'package:rolo/core/network/dio_error_interceptor.dart';

// class ApiService {
//   final Dio _dio;

//   Dio get dio => _dio;

//   ApiService()
//       : _dio = Dio(BaseOptions(
//           baseUrl: ApiEndpoints.baseUrl,
//           connectTimeout: ApiEndpoints.connectionTimeout,
//           receiveTimeout: ApiEndpoints.receiveTimeout,
//           headers: {
//             'Accept': 'application/json',
//             'Content-Type': 'application/json',
//           },
//           validateStatus: (status) {
//             // ✅ Accept status codes < 400 as success
//             return status != null && status < 400;
//           },
//         )) {
//     _dio.interceptors.add(DioErrorInterceptor());
//     _dio.interceptors.add(
//       PrettyDioLogger(
//         requestHeader: true,
//         requestBody: true,
//         responseHeader: true,
//       ),
//     );
//   }
// }

