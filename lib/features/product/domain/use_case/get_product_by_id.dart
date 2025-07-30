import 'package:dartz/dartz.dart'; 
import 'package:rolo/app/use_case/usecase.dart';
import 'package:rolo/core/error/failure.dart';
import 'package:rolo/features/product/domain/entity/product_entity.dart';
import 'package:rolo/features/product/domain/repository/product_repository.dart';

class GetProductById implements UsecaseWithParams<ProductEntity, String> {
  final ProductRepository productRepository;
  
  GetProductById(this.productRepository);

  @override
  Future<Either<Failure, ProductEntity>> call(String params) async {
    return await productRepository.getProductById(params);
  }
}