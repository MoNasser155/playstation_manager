import 'customer_model.dart';

class CustomerDetailsModel {
  final CustomerModel customer;

  CustomerDetailsModel({required this.customer});

  factory CustomerDetailsModel.initial(){
    return CustomerDetailsModel(customer: CustomerModel.initial());
  }

}