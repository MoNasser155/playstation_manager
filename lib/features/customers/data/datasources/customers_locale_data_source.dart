import 'package:local_erp_system/core/errors/exceptions.dart';

import '../../../../core/objectbox/objectbox.g.dart';
import '../../../../core/objectbox/objectbox_store.dart';
import '../../../../core/shared/di.dart';
import '../models/customer_details_model.dart';
import '../models/customer_model.dart';

abstract class CustomersLocaleDatasource {
  List<CustomerModel> getAllCustomers();
  int addCustomer(CustomerModel customer);
  bool deleteCustomer(String uuid);
  int updateCustomer(CustomerModel customer);
  CustomerDetailsModel getCustomerDetails(String uuid);
}

class CustomersLocaleDatasourceImpl implements CustomersLocaleDatasource {
  ObjectBoxStore get _store => sl<ObjectBoxStore>();
  @override
  List<CustomerModel> getAllCustomers() {
    final customers = _store.customers.getAll();
    return customers;
  }

  @override
  int addCustomer(CustomerModel customer) {
    return _store.customers.put(customer);
  }

  @override
  bool deleteCustomer(String uuid) {
    final query =
        _store.customers.query(CustomerModel_.uuid.equals(uuid)).build();
    final customer = query.findFirst();
    query.close();

    if (customer != null) {
      if (customer.netAmount != 0) {
        throw CustomerHasBalanceException();
      }
      return _store.customers.remove(customer.id!);
    }
    return false;
  }

  @override
  int updateCustomer(CustomerModel customer) {
    return _store.customers.put(customer);
  }

  @override
  CustomerDetailsModel getCustomerDetails(String uuid) {
    final query =
        _store.customers.query(CustomerModel_.uuid.equals(uuid)).build();
    final customer = query.findFirst();
    query.close();
    if (customer != null) {
      return CustomerDetailsModel(customer: customer);
    }
    throw CustomerNotFoundException();
  }
}
