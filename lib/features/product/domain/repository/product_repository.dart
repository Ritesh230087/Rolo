import 'package:dartz/dartz.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import '../../../../core/error/failure.dart';
abstract interface class ProductRepository {
  Future<Either<Failure, ProductEntity>> getProductById(String productId);
}