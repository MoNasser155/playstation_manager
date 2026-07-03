import '../languages/local_keys.g.dart';

abstract class AppException implements Exception {
  final String messageKey;
  const AppException(this.messageKey);
}

class CustomerHasBalanceException extends AppException {
  CustomerHasBalanceException()
    : super(LocaleKeys.cannotDeleteCustomerWithBalance);
}

class CustomerNotFoundException extends AppException {
  CustomerNotFoundException() : super(LocaleKeys.errorGettingCustomerDetails);
}

class NoCustomersExeption extends AppException {
  NoCustomersExeption() : super(LocaleKeys.noCustomersFound);
}

class NoStorageItemsExeption extends AppException {
  NoStorageItemsExeption() : super(LocaleKeys.noStorageItemsFound);
}

class NoCustomersAndStorageItemsFoundException extends AppException {
  NoCustomersAndStorageItemsFoundException()
    : super(LocaleKeys.noInvoiceModelsFound);
}

class NoInvoicesFoundException extends AppException {
  NoInvoicesFoundException() : super(LocaleKeys.noInvoicesFound);
}

class BackupSourceNotFoundException extends AppException {
  BackupSourceNotFoundException() : super(LocaleKeys.backupSourceNotFound);
}

class BackupCreationFailedException extends AppException {
  BackupCreationFailedException() : super(LocaleKeys.backupCreationFailed);
}

class RestoreFailedException extends AppException {
  RestoreFailedException() : super(LocaleKeys.restoreFailed);
}

class InvoiceNotFoundException extends AppException {
  InvoiceNotFoundException() : super(LocaleKeys.errorGettingInvoiceDetails);
}

class GoogleSignInFailedException extends AppException {
  GoogleSignInFailedException() : super(LocaleKeys.googleSignInFailed);
}

class GoogleSignInCancelledException extends AppException {
  GoogleSignInCancelledException() : super(LocaleKeys.signInWasCancelled);
}

class GoogleSignInTimedOutException extends AppException {
  GoogleSignInTimedOutException() : super(LocaleKeys.googleSignInTimedOut);
}

class MachineMismatchException extends AppException {
  MachineMismatchException() : super(LocaleKeys.machineMismatch);
}

class NoMachineIdException extends AppException {
  NoMachineIdException() : super(LocaleKeys.noMachineId);
}

class NoUserFoundException extends AppException {
  NoUserFoundException() : super(LocaleKeys.noUserFound);
}

class AccountNotActiveException extends AppException {
  AccountNotActiveException() : super(LocaleKeys.accountNotActive);
}

class ServerErrorException extends AppException {
  ServerErrorException() : super(LocaleKeys.serverError);
}

class NoDevicesException extends AppException {
  NoDevicesException() : super(LocaleKeys.noDevices);
}

class DeviceNotFoundException extends AppException {
  DeviceNotFoundException() : super(LocaleKeys.cannotDeleteDevice);
}

