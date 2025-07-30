import 'package:dartz/dartz.dart';
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/notification/domain/entity/notification_entity.dart';
import 'package:rolo/features/notification/domain/repository/notification_repository.dart';

class GetNotificationsUseCase implements UsecaseWithoutParams<List<NotificationEntity>> {
  final INotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}