import 'dart:convert';

import '../../core/config/app_config.dart';
import '../../core/network/api_base_helper.dart';
import '../../core/network/api_client.dart';
import '../datasources/call_local_data_source.dart';
import '../datasources/call_remote_data_source.dart';
import '../models/call.dart';
import '../models/response.dart';

class CallRepository {
  final CallRemoteDataSource remoteDataSource;
  final CallLocalDataSource localDataSource = CallLocalDataSource();

  CallRepository({required this.remoteDataSource});

  factory CallRepository.instance() {
    return CallRepository(
      remoteDataSource: CallRemoteDataSource(
        apiHelper: ApiBaseHelper(
          baseUrl: AppConfig.apiBaseUrl,
          http: ApiClient().http,
        ),
      ),
    );
  }

  Future<CallsResponse> getCalls({
    required int nextPage,
    String callType = '',
    String fromDate = '',
    String toDate = '',
  }) async {
    return await remoteDataSource.calls(
      nextPage: nextPage,
      callType: callType,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<CallResponse> acceptCall({required String uuid}) async {
    return await remoteDataSource.acceptCall(uuid: uuid);
  }

  Future<AppResponse> endCall({required Call call}) async {
    return await remoteDataSource.endCall(call: call);
  }

  Future<bool> saveCallDetails(Call call) async {
    return await localDataSource.saveCallDetails(json.encode(call.toMap()));
  }

  Future<Call> getCallDetails() async {
    String callData = await localDataSource.getCallDetails();
    return callData.isNotEmpty
        ? Call.fromMap(json.decode(callData))
        : const Call();
  }

  Future<AppResponse> startCall({required Call call}) async {
    return await remoteDataSource.startCall(call: call);
  }

  Future<AppResponse> rejectCall({required Call call}) async {
    return await remoteDataSource.rejectCall(call: call);
  }
}
