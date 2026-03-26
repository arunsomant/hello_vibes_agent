import '../datasources/call_remote_data_source.dart';
import '../models/call.dart';
import '../models/response.dart';

class CallRepository {
  final CallRemoteDataSource remoteDataSource;

  CallRepository({required this.remoteDataSource});

  Future<CallsResponse> getCalls() async {
    return await remoteDataSource.calls();
  }

  Future<CallResponse> acceptCall({required String uuid}) async {
    return await remoteDataSource.acceptCall(uuid: uuid);
  }

  Future<AppResponse> endCall({required Call call}) async {
    return await remoteDataSource.endCall(call: call);
  }
}
