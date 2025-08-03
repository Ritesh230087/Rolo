import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/notification/domain/repository/notification_repository.dart';

class MarkAllAsReadUseCase implements UsecaseWithoutParams<bool> {
  final INotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call() async {
    return await repository.markAllAsRead();
  }
}