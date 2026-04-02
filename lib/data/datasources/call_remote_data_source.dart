import '../../core/network/api_base_helper.dart';
import '../../core/network/api_endpoints.dart';
import '../models/call.dart';
import '../models/response.dart';

class CallRemoteDataSource {
  CallRemoteDataSource({required this.apiHelper});

  final ApiBaseHelper apiHelper;

  Future<CallsResponse> calls({required int nextPage}) async {
    final response = await apiHelper.get(
      ApiEndpoints.callHistory,
      queryParameters: {'page': '$nextPage'},
    );
    return CallsResponse.fromMap(response);
  }

  Future<CallResponse> acceptCall({required String uuid}) async {
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/$uuid${ApiEndpoints.callAccept}',
    );
    return CallResponse.fromMap(response);
  }

  Future<AppResponse> startCall({required Call call}) async {
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/${call.uuid}${ApiEndpoints.callStart}',
    );
    return AppResponse.fromMap(response);
  }

  Future<AppResponse> endCall({required Call call}) async {
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/${call.uuid}${ApiEndpoints.callEnd}',
    );
    return AppResponse.fromMap(response);
  }

  Future<AppResponse> rejectCall({required Call call}) async {
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/${call.uuid}${ApiEndpoints.callReject}',
    );
    print(response);
    return AppResponse.fromMap(response);
  }
}
