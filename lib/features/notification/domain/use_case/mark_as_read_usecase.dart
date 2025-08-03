import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/notification/domain/repository/notification_repository.dart';

class MarkAsReadUseCase implements UsecaseWithParams<bool, String> {
  final INotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await repository.markAsRead(params);
  }
}