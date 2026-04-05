import '../../core/network/api_base_helper.dart';
import '../../core/network/api_endpoints.dart';
import '../models/call.dart';
import '../models/response.dart';

class UsersRemoteDataSource {
  UsersRemoteDataSource({required this.apiHelper});

  final ApiBaseHelper apiHelper;

  Future<AppResponse> reportCall({
    required Call call,
    required String reason,
  }) async {
    final body = {'reason': reason};
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/${call.uuid}${ApiEndpoints.report}',
      body: body,
    );
    return AppResponse.fromMap(response);
  }
}
