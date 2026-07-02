import '../../../../core/errors/exceptions.dart';
import '../../../../core/objectbox/objectbox.g.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../models/supplier_details_model.dart';
import '../models/supplier_model.dart';

abstract class SuppliersLocalDataSource {
  List<SupplierModel> getAllSuppliers();
  int addSupplier(SupplierModel supplier);
  bool deleteSupplier(String uuid);
  int updateSupplier(SupplierModel supplier);
  SupplierDetailsModel getSupplierDetails(String uuid);
}

class SuppliersLocalDataSourceImpl implements SuppliersLocalDataSource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();
  SuppliersLocalDataSourceImpl();

  @override
  List<SupplierModel> getAllSuppliers() {
    return _store.suppliers.getAll();
  }

  @override
  int addSupplier(SupplierModel supplier) {
    return _store.suppliers.put(supplier);
  }

  @override
  bool deleteSupplier(String uuid) {
    final query =
        _store.suppliers.query(SupplierModel_.uuid.equals(uuid)).build();
    final supplier = query.findFirst();
    query.close();

    if (supplier != null) {
      if (supplier.netAmount != 0) {
        throw SupplierHasBalanceException();
      }
      return _store.suppliers.remove(supplier.id!);
    }
    return false;
  }

  @override
  int updateSupplier(SupplierModel supplier) {
    return _store.suppliers.put(supplier);
  }

  @override
  SupplierDetailsModel getSupplierDetails(String uuid) {
    final query =
        _store.suppliers.query(SupplierModel_.uuid.equals(uuid)).build();
    final supplier = query.findFirst();
    query.close();
    if (supplier != null) {
      return SupplierDetailsModel(supplier: supplier);
    }
    throw SupplierNotFoundException();
  }
}
