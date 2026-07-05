import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../data/models/home_model.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final _repository = sl<HomeRepository>();

  Future<Either<Failure, HomeModel>> call() async {
    return await _repository.getHomeData();
  }
}
