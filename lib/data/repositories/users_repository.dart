import '../datasources/users_remote_data_source.dart';
import '../models/call.dart';
import '../models/response.dart';

class UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepository({required this.remoteDataSource});

  Future<AppResponse> reportCall({
    required Call call,
    required String reason,
  }) async {
    return await remoteDataSource.reportCall(call: call, reason: reason);
  }
}
