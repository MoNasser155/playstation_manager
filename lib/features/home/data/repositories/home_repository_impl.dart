import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/shared/di.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../models/home_model.dart';

class HomeRepositoryImpl with ErrorHandler implements HomeRepository {
  final _localDataSource = sl<HomeLocalDataSource>();

  HomeRepositoryImpl();

  @override
  Future<Either<Failure, HomeModel>> getHomeData() async {
    return wrapBoxOperationSync(() => _localDataSource.getHomeData());
  }
}
