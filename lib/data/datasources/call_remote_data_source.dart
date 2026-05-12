import '../../core/network/api_base_helper.dart';
import '../../core/network/api_endpoints.dart';
import '../models/call.dart';
import '../models/response.dart';

class CallRemoteDataSource {
  CallRemoteDataSource({required this.apiHelper});

  final ApiBaseHelper apiHelper;

  Future<CallsResponse> calls({
    required int nextPage,
    String callType = '',
    String fromDate = '',
    String toDate = '',
  }) async {
    final response = await apiHelper.get(
      ApiEndpoints.callHistory,
      queryParameters: {
        'page': '$nextPage',
        'type': callType,
        'from': fromDate,
        'to': toDate,
      },
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

  Future<AppResponse> endCall({
    required Call call,
    bool isClientInitiateEndCall = false,
  }) async {
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/${call.uuid}${ApiEndpoints.callEnd}',
      body: {'client_initiated': isClientInitiateEndCall},
    );
    return AppResponse.fromMap(response);
  }

  Future<AppResponse> rejectCall({required Call call}) async {
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/${call.uuid}${ApiEndpoints.callReject}',
    );
    return AppResponse.fromMap(response);
  }

  Future<AppResponse> markCallRinging({required Call call}) async {
    final response = await apiHelper.post(
      '${ApiEndpoints.calls}/${call.uuid}${ApiEndpoints.callRinging}',
    );
    return AppResponse.fromMap(response);
  }
}
