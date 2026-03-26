import 'package:get/get.dart';

import '../../core/network/api_base_helper.dart';
import '../../data/datasources/call_remote_data_source.dart';
import '../../data/repositories/call_repository.dart';
import '../controllers/calling_controller.dart';

class CallingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallRemoteDataSource>(
      () => CallRemoteDataSource(apiHelper: Get.find<ApiBaseHelper>()),
    );
    Get.lazyPut<CallRepository>(
      () => CallRepository(remoteDataSource: Get.find<CallRemoteDataSource>()),
    );
    Get.lazyPut<CallingController>(
      () => CallingController(callRepository: Get.find<CallRepository>()),
    );
  }
}
