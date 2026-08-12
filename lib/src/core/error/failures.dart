import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Lỗi kết nối máy chủ']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Lỗi lưu trữ dữ liệu']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Lỗi xác thực người dùng']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Không có kết nối Internet']);
}
