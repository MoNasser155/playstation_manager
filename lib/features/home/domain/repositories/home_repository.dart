import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/home_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeModel>> getHomeData();
}
