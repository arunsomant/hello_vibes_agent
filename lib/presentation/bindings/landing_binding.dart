import 'package:get/get.dart';

import '../../core/network/api_base_helper.dart';
import '../../core/services/websocket_service.dart';
import '../../data/datasources/call_remote_data_source.dart';
import '../../data/datasources/transaction_remote_data_source.dart';
import '../../data/datasources/users_remote_data_source.dart';
import '../../data/repositories/call_repository.dart';
import '../../data/repositories/firebase_repository.dart';
import '../../data/repositories/transaction_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/users_repository.dart';
import '../controllers/bank_details_controller.dart';
import '../controllers/calls_controller.dart';
import '../controllers/calls_filter_controller.dart';
import '../controllers/configuration_controller.dart';
import '../controllers/landing_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/rating_controller.dart';
import '../controllers/transactions_controller.dart';
import '../controllers/transactions_filter_controller.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersRemoteDataSource>(
      () => UsersRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
      fenix: true,
    );
    Get.lazyPut<CallRemoteDataSource>(
      () => CallRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
    );
    Get.lazyPut<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
      fenix: true,
    );
    Get.lazyPut<CallRepository>(
      () => CallRepository(remoteDataSource: Get.find<CallRemoteDataSource>()),
    );

    Get.lazyPut<UsersRepository>(
      () =>
          UsersRepository(remoteDataSource: Get.find<UsersRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut<FirebaseRepository>(
      () => FirebaseRepository(apiHelper: Get.find<ApiBaseHelper>()),
    );
    Get.lazyPut<ConfigurationController>(() => ConfigurationController(),fenix: true);
    Get.lazyPut<LandingController>(
      () => LandingController(
        userRepository: Get.find<UserRepository>(),
        firebaseRepository: Get.find<FirebaseRepository>(),
        callRepository: Get.find<CallRepository>(),
      ),
    );
    Get.lazyPut<CallsController>(
      () => CallsController(callRepository: Get.find<CallRepository>()),
    );
    Get.put<CallsFilterController>(CallsFilterController(), permanent: true);

    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<RatingController>(
      () => RatingController(
        usersRepository: Get.find<UsersRepository>(),
        callRepository: Get.find<CallRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepository(
        remoteDataSource: Get.find<TransactionRemoteDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut<TransactionsController>(
      () => TransactionsController(
        transactionRepository: Get.find<TransactionRepository>(),
      ),
    );
    Get.put<TransactionsFilterController>(
      TransactionsFilterController(),
      permanent: true,
    );

    Get.lazyPut<BankDetailsController>(
      () => BankDetailsController(
        transactionRepository: Get.find<TransactionRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<WebSocketService>(
          () =>
              WebSocketService(),
      fenix: true,
    );
  }
}
