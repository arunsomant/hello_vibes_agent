import 'package:get/get.dart';

import '../../core/network/api_base_helper.dart';
import '../../data/datasources/call_remote_data_source.dart';
import '../../data/datasources/transaction_remote_data_source.dart';
import '../../data/repositories/call_repository.dart';
import '../../data/repositories/firebase_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../controllers/calls_controller.dart';
import '../controllers/calls_filter_controller.dart';
import '../controllers/landing_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/rating_controller.dart';
import 'transactions_binding.dart';

class LandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallRemoteDataSource>(
      () => CallRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
    );
    Get.lazyPut<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
    );
    Get.lazyPut<CallRepository>(
      () => CallRepository(remoteDataSource: Get.find<CallRemoteDataSource>()),
    );

    Get.lazyPut<FirebaseRepository>(
      () => FirebaseRepository(apiHelper: Get.find<ApiBaseHelper>()),
    );

    Get.lazyPut<LandingController>(
      () => LandingController(
        userRepository: Get.find<UserRepository>(),
        firebaseRepository: Get.find<FirebaseRepository>(),
      ),
    );
    Get.lazyPut<CallsController>(
      () => CallsController(callRepository: Get.find<CallRepository>()),
    );
    Get.put<CallsFilterController>(CallsFilterController(), permanent: true);

    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<RatingController>(() => RatingController(), fenix: true);
    TransactionsBinding().dependencies();
  }
}
