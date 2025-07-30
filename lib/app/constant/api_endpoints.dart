class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  
  // static const String serverAddress = "http://10.0.2.2:5050";
  static const String serverAddress = "192.168.1.77:5050";

  static const String baseUrl = "http://$serverAddress/";
  static const String imageUrl = "http://$serverAddress/";

  // ====================== Authentication & Profile ======================
  static const String login = "api/auth/login";
  static const String register = "api/auth/register";
  static const String userProfile = "api/auth/profile"; 
  static const String changePassword = "api/auth/profile/change-password";
  static const String googleLogin = "api/auth/google";
  static const String sendResetLink = "api/auth/send-reset-link";
  static String resetPassword(String token) => "api/auth/reset-password/$token";
  static const String registerFCMToken = "api/auth/register-fcm-token";

  // ====================== Order Create & Shipping ======================
  static const String shippingLocations = "api/shipping/locations";
  static const String createOrder = "api/orders/create";
  static const String createOrderWithSlip = "api/orders/create-with-slip";
  static String lastShippingAddress(String userId) => "api/orders/last-shipping/$userId";
  static const String myOrders = "api/orders/myorders";

  // ====================== E-commerce ======================
  static const String allProducts = "api/admin/product/";
  static const String featuredProducts = "api/admin/product/featured";
  static const String allCategories = "api/admin/category/";
  static const String allRibbons = "api/admin/ribbon/";
  static String getProductById(String productId) => "$baseUrl$allProducts$productId";

  // ====================== Notifications ======================
  static const String notifications = "api/notifications/";
  static String markNotificationAsRead(String id) => "api/notifications/$id/read";
  static const String markAllNotificationsAsRead = "api/notifications/mark-all-read";
}