import '../../core/network/api_base_helper.dart';
import '../../core/network/api_endpoints.dart';
import '../models/call.dart';
import '../models/response.dart';

class CallRemoteDataSource {
  CallRemoteDataSource({required this.apiHelper});

  final ApiBaseHelper apiHelper;

  Future<CallsResponse> calls() async {
    final response = await apiHelper.get(ApiEndpoints.callHistory);
    return CallsResponse.fromMap(response);
  }

  Future<CallResponse> acceptCall({required String uuid}) async {
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/$uuid${ApiEndpoints.callAccept}',
    );
    return CallResponse.fromMap(response);
  }

  Future<AppResponse> endCall({required Call call}) async {
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/${call.uuid}${ApiEndpoints.callEnd}',
    );
    return AppResponse.fromMap(response);
  }
}
