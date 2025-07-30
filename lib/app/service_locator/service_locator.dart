import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rolo/app/shared_pref/token_shared_pref.dart';
import 'package:rolo/core/network/api_service.dart';
import 'package:rolo/core/network/hive_service.dart';
import 'package:rolo/core/secure_storage/auth_secure_storage.dart';
import 'package:rolo/features/auth/data/data_source/local_datasource/user_local_data_source.dart';
import 'package:rolo/features/auth/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:rolo/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:rolo/features/auth/domain/entity/user_entity.dart';
import 'package:rolo/features/auth/domain/repository/user_repository.dart';
import 'package:rolo/features/auth/domain/use_case/forgot_password_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/login_with_google_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/register_fcm_token_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/reset_password_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:rolo/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:rolo/features/auth/presentation/view_model/forget_password/forgot_password_viewmodel.dart';
import 'package:rolo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:rolo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:rolo/features/auth/presentation/view_model/reset_password/reset_password_viewmodel.dart';
import 'package:rolo/features/cart/data/data_source/local_datasource/cart_local_data_source.dart';
import 'package:rolo/features/cart/data/repository/cart_repository_impl.dart';
import 'package:rolo/features/cart/domain/repository/cart_repository.dart';
import 'package:rolo/features/cart/domain/use_case/add_product_to_cart_usecase.dart';
import 'package:rolo/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:rolo/features/cart/domain/use_case/remove_product_from_cart_usecase.dart';
import 'package:rolo/features/cart/domain/use_case/update_item_quantity_usecase.dart';
import 'package:rolo/features/cart/presentation/view_model/cart_viewmodel.dart';
import 'package:rolo/features/category/data/data_source/remote_data_source/category_remote_data_source.dart';
import 'package:rolo/features/category/data/repository/category_repository_impl.dart';
import 'package:rolo/features/category/domain/repository/category_repository.dart';
import 'package:rolo/features/category/domain/use_case/get_all_categories_usecase.dart';
import 'package:rolo/features/explore/data/data_source/local_datasource/explore_local_data_source.dart';
import 'package:rolo/features/explore/data/data_source/remote_data_source/explore_remote_data_source.dart';
import 'package:rolo/features/explore/data/repository/explore_repository_impl.dart';
import 'package:rolo/features/explore/domain/repository/explore_repository.dart';
import 'package:rolo/features/explore/domain/use_case/get_all_products_usecase.dart';
import 'package:rolo/features/explore/presentation/view_model/explore_viewmodel.dart';
import 'package:rolo/features/home/data/data_source/local_datasource/home_local_data_source.dart';
import 'package:rolo/features/home/data/data_source/remote_data_source/home_remote_data_source.dart';
import 'package:rolo/features/home/data/repository/home_repository_impl.dart';
import 'package:rolo/features/home/domain/repository/home_repository.dart';
import 'package:rolo/features/home/domain/use_case/get_home_data_usecase.dart';
import 'package:rolo/features/home/presentation/view_model/home_viewmodel.dart';
import 'package:rolo/features/notification/data/data_source/remote_data_source/notification_remote_data_source.dart';
import 'package:rolo/features/notification/data/repository/notification_repository_impl.dart';
import 'package:rolo/features/notification/domain/repository/notification_repository.dart';
import 'package:rolo/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:rolo/features/notification/domain/use_case/mark_all_as_read_usecase.dart';
import 'package:rolo/features/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:rolo/features/notification/presentation/view_model/notification_viewmodel.dart';
import 'package:rolo/features/order/data/data_source/remote_data_source/order_remote_data_source.dart';
import 'package:rolo/features/order/data/repository/remote_repository/order_repository_impl.dart';
import 'package:rolo/features/order/domain/repository/order_repository.dart';
import 'package:rolo/features/order/domain/use_case/check_cod_availability_usecase.dart';
import 'package:rolo/features/order/domain/use_case/create_order_usecase.dart';
import 'package:rolo/features/order/domain/use_case/create_order_with_slip_usecase.dart';
import 'package:rolo/features/order/domain/use_case/get_last_shipping_address_usecase.dart';
import 'package:rolo/features/order/domain/use_case/get_order_history_usecase.dart';
import 'package:rolo/features/order/domain/use_case/get_shipping_locations_usecase.dart';
import 'package:rolo/features/order/presentation/view_model/order_form/order_form_viemodel.dart';
import 'package:rolo/features/order/presentation/view_model/order_history_view_model.dart';
import 'package:rolo/features/product/data/data_source/local_datasource/product_local_data_source.dart';
import 'package:rolo/features/product/data/data_source/remote_data_source/product_remote_datasource.dart';
import 'package:rolo/features/product/data/repository/product_repository_impl.dart';
import 'package:rolo/features/product/domain/repository/product_repository.dart';
import 'package:rolo/features/product/domain/use_case/get_product_by_id.dart';
import 'package:rolo/features/product/presentation/view_model/product_detail/product_detail_viewmodel.dart';
import 'package:rolo/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:rolo/features/profile/data/repository/profile_repository_impl.dart';
import 'package:rolo/features/profile/domain/repository/profile_repository.dart';
import 'package:rolo/features/profile/domain/use_case/change_password_usecase.dart';
import 'package:rolo/features/profile/domain/use_case/get_user_profile_usecase.dart';
import 'package:rolo/features/profile/domain/use_case/logout_usecase.dart';
import 'package:rolo/features/profile/domain/use_case/update_profile_usecase.dart';
import 'package:rolo/features/profile/presentation/view_model/change_password/change_password_viewmodel.dart';
import 'package:rolo/features/profile/presentation/view_model/edit_profile/edit_profile_viewmodel.dart';
import 'package:rolo/features/profile/presentation/view_model/profile_viewmodel.dart';
import 'package:rolo/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerLazySingleton(() => Dio());
  serviceLocator.registerLazySingleton(() => Connectivity());
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(() => TokenSharedPrefs(sharedPreferences: serviceLocator()));
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>(), serviceLocator<TokenSharedPrefs>()));
  final hiveService = HiveService();
  await hiveService.init();
  serviceLocator.registerLazySingleton(() => hiveService);

  serviceLocator.registerLazySingleton(() => AuthSecureStorage());
  serviceLocator.registerLazySingleton(() => LocalAuthentication());
  serviceLocator.registerLazySingleton(() => GoogleSignIn());

  _initAuthModule();
  _initSplashModule();
  _initHomeModule();
  _initCategoryModule();
  _initExploreModule();
  _initProductModule();
  _initCartModule();
  _initProfileModule();
  _initOrderModule();
  _initNotificationModule();
}

void _initAuthModule() {
  serviceLocator.registerFactory<UserLocalDataSource>(() => UserLocalDataSource(hiveService: serviceLocator()));
  serviceLocator.registerFactory<UserRemoteDataSource>(() => UserRemoteDataSource(apiService: serviceLocator()));

  serviceLocator.registerFactory<IUserRepository>(() => UserRemoteRepository(userRemoteDataSource: serviceLocator()));

  serviceLocator.registerFactory(() => UserLoginUsecase(userRepository: serviceLocator(), tokenSharedPrefs: serviceLocator()));
  serviceLocator.registerFactory(() => UserRegisterUsecase(userRepository: serviceLocator(), userLoginUsecase: serviceLocator()));
  serviceLocator.registerFactory(() => RegisterFCMTokenUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => LoginWithGoogleUseCase(serviceLocator()));

  serviceLocator.registerFactory(() => RegisterViewModel(serviceLocator()));

  serviceLocator.registerFactory(() => ForgotPasswordUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => ForgotPasswordViewModel(serviceLocator()));
  serviceLocator.registerFactory(() => ResetPasswordUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => ResetPasswordViewModel(serviceLocator()));

  // --- THIS IS THE UPDATED PART ---
  serviceLocator.registerFactory(
    () => LoginViewModel(
      userLoginUsecase: serviceLocator(),
      loginWithGoogleUseCase: serviceLocator(),
      registerFCMTokenUseCase: serviceLocator(), // Add this line
      authSecureStorage: serviceLocator(),
      localAuth: serviceLocator(),
      googleSignIn: serviceLocator(),
    ),
  );
  // -----------------------------
}

// ... Rest of your dependency injection code (no changes needed below this line)
void _initSplashModule() {
  serviceLocator.registerFactory(() => SplashViewModel());
}

void _initHomeModule() {
  serviceLocator.registerLazySingleton<IHomeRemoteDataSource>(() => HomeRemoteDataSource(serviceLocator()));
  serviceLocator.registerLazySingleton<IHomeLocalDataSource>(() => HomeLocalDataSourceImpl());
  serviceLocator.registerLazySingleton<IHomeRepository>(() => HomeRepositoryImpl(
        serviceLocator<IHomeRemoteDataSource>(),
        serviceLocator<IHomeLocalDataSource>(),
        serviceLocator<Connectivity>(),
      ));
  serviceLocator.registerFactory(() => GetHomeDataUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => HomeViewModel(serviceLocator()));
}

void _initCategoryModule() {
  serviceLocator.registerFactory<ICategoryRemoteDataSource>(() => CategoryRemoteDataSource(serviceLocator()));
  serviceLocator.registerFactory<ICategoryRepository>(() => CategoryRepositoryImpl(serviceLocator()));
  serviceLocator.registerFactory(() => GetAllCategoriesUsecase(serviceLocator()));
}

void _initExploreModule() {
  serviceLocator.registerLazySingleton<IExploreRemoteDataSource>(() => ExploreRemoteDataSource(serviceLocator()));
  serviceLocator.registerLazySingleton<IExploreLocalDataSource>(() => ExploreLocalDataSourceImpl());
  serviceLocator.registerLazySingleton<IExploreRepository>(() => ExploreRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        connectivity: serviceLocator(),
        categoryRemoteDataSource: serviceLocator(),
      ));
  serviceLocator.registerFactory(() => GetAllProductsUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => ExploreViewModel(
        getAllProductsUsecase: serviceLocator(),
        getAllCategoriesUsecase: serviceLocator(),
      ));
}

void _initProductModule() {
  serviceLocator.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(serviceLocator()));
  serviceLocator.registerLazySingleton<IProductLocalDataSource>(() => ProductLocalDataSourceImpl());
  serviceLocator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      connectivity: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(() => GetProductById(serviceLocator()));
  serviceLocator.registerFactoryParam<ProductDetailViewModel, CartViewModel, void>(
    (cartViewModel, _) => ProductDetailViewModel(
      getProductById: serviceLocator(),
      cartViewModel: cartViewModel,
    ),
  );
}

void _initCartModule() {
  serviceLocator.registerSingleton<ICartDataSource>(CartLocalDataSource());
  serviceLocator.registerFactory<ICartRepository>(() => CartRepositoryImpl(serviceLocator()));
  serviceLocator.registerFactory(() => GetCartUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => AddProductToCartUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => RemoveProductFromCartUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => UpdateItemQuantityUsecase(serviceLocator()));
  serviceLocator.registerLazySingleton<CartViewModel>(() => CartViewModel(
        getCartUsecase: serviceLocator(),
        addProductToCartUsecase: serviceLocator(),
        removeProductFromCartUsecase: serviceLocator(),
        updateItemQuantityUsecase: serviceLocator(),
      ));
}

void _initProfileModule() {
  serviceLocator.registerFactory<IProfileRemoteDataSource>(() => ProfileRemoteDataSource(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory<IProfileRepository>(() => ProfileRepositoryImpl(
        remoteDataSource: serviceLocator(),
        tokenSharedPrefs: serviceLocator(),
      ));
  serviceLocator.registerFactory(() => GetProfileUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => LogoutUsecase(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory(() => UpdateProfileUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => ChangePasswordUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => ProfileViewModel(
        getProfileUsecase: serviceLocator(),
        logoutUsecase: serviceLocator(),
      ));
  serviceLocator.registerFactoryParam<EditProfileViewModel, UserEntity, void>((userEntity, _) =>
      EditProfileViewModel(updateProfileUseCase: serviceLocator(), currentUser: userEntity));
  serviceLocator.registerFactory(() => ChangePasswordViewModel(serviceLocator()));
}

void _initOrderModule() {
  serviceLocator.registerFactory<OrderRemoteDataSource>(() => OrderRemoteDataSourceImpl(serviceLocator()));
  serviceLocator.registerFactory<OrderRepository>(() => OrderRepositoryImpl(serviceLocator()));
  serviceLocator.registerFactory(() => GetShippingLocationsUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => GetLastShippingAddressUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => CreateOrderUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => GetOrderHistoryUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => CheckCodAvailabilityUseCase());
  serviceLocator.registerFactory(() => CreateOrderWithSlipUseCase(serviceLocator()));
  serviceLocator.registerFactoryParam<OrderViewModel, CartViewModel, void>(
    (cartViewModel, _) => OrderViewModel(
      getShippingLocationsUseCase: serviceLocator(),
      getLastShippingAddressUseCase: serviceLocator(),
      getProfileUsecase: serviceLocator(),
      cartViewModel: cartViewModel,
    ),
  );
  serviceLocator.registerFactory(() => OrderHistoryViewModel(
        getOrderHistoryUsecase: serviceLocator(),
      ));
}

void _initNotificationModule() {
  serviceLocator.registerFactory<INotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(serviceLocator()));
  serviceLocator.registerFactory<INotificationRepository>(() => NotificationRepositoryImpl(serviceLocator()));
  serviceLocator.registerFactory(() => GetNotificationsUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => MarkAsReadUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => MarkAllAsReadUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => NotificationViewModel(
        getNotificationsUseCase: serviceLocator(),
        markAsReadUseCase: serviceLocator(),
        markAllAsReadUseCase: serviceLocator(),
      ));
}